//
//  MBCaptureSessionViewController.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//

import UIKit
import AVFoundation
import MobaiBiometric

public protocol MBBiometricDelegate: AnyObject {
    func biometricSucceeded(result: VideoDecodingResponse)
    func biometricFailed(error: Error)
}
public class MBCaptureSessionViewController: UIViewController {
    weak var delegate: MBBiometricDelegate?
    
    var captureSessionOptions: MBCaptureSessionOptions
    var style: MBUIOptions
    private var cameraPermissions: MBCameraPermissions = MBCameraPermissions()
    private let mbCaptureSessionView: MBCaptureSessionView
    private var currentOrientation: UIInterfaceOrientation?
    private let videoDecodingService: VideoDecodingService
    var loadingOverlay: UIView?
    
    private lazy var dissmisButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close", in: Bundle(for: MBCaptureSessionViewController.self), with: nil), for: .normal)
        button.isHidden = !style.presentedDismissButtonEnabled
        return button
    }()
    
    private lazy var overlayFaceView: MBOvalOverlayView = {
        let overlayFaceView = MBOvalOverlayView()
        overlayFaceView.translatesAutoresizingMaskIntoConstraints = false
        overlayFaceView.isHidden = !style.shouldShowOverlayFaceView
        return overlayFaceView
    }()
    
    lazy var faceStatusView: CustomLabelView = {
        let label = CustomLabelView(text: "")
        label.isHidden = faceStatusTextViewIsHidden()
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0, animated: true)
        progressView.trackTintColor = UIColor.primaryColor
        progressView.tintColor = UIColor.secondaryColor
        progressView.isHidden = progressViewIsHidden()
        return progressView
    }()
    
    lazy var textByTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Hold Still"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.isHidden = false
        
        return label
    }()
    
    lazy var debugTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        
        label.isHidden = captureSessionOptions.isDebugging ? false : !style.showCountdownTimerLabel
        return label
    }()
    
    lazy var progressViewHorizontalConstraints: [NSLayoutConstraint] = {
        return progressView.anchorToConstraints(
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 100, bottom: 0, right: 0),
            size: CGSize(width: 300, height: 10),
            centerY: view.centerYAnchor
        )
    }()
    
    lazy var progressViewVerticalConstraints: [NSLayoutConstraint] = {
        progressView.anchorToConstraints(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 0, left: 0, bottom: 100, right: 0),
            size: CGSize(width: 300, height: 10),
            centerX: view.centerXAnchor
        )
    }()
    
    private func faceStatusTextViewIsHidden() -> Bool {
        captureSessionOptions.isDebugging ? false : !style.showFaceStatusLabel
    }
    
    private func progressViewIsHidden() -> Bool {
        captureSessionOptions.isDebugging ? false : !style.showProgressBar
    }
    
    public init(with captureSessionOptions: MBCaptureSessionOptions = MBCaptureSessionOptions(), style: MBUIOptions = MBUIOptions()) {
        var endPoint: String = Bundle.main.infoDictionary?["END_POINT"] as! String
        if(!endPoint.starts(with: "/")){
            endPoint = "/\(endPoint)"
        }
        
        self.style = style
        self.captureSessionOptions = captureSessionOptions
        self.mbCaptureSessionView = MBCaptureSessionView(options: captureSessionOptions)
        self.mbCaptureSessionView.translatesAutoresizingMaskIntoConstraints = false
        self.videoDecodingService = VideoDecodingService(baseURL: "\(AppData.serviceUrlAddress)", endPoint: endPoint)
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setObservers()
        
        setupConstraints()
    }
    
    public func setBindings() {
        self.setUpdateProgressViewConstraints()
        self.overlayFaceView.updateView(regionOfIntereseSize: mbCaptureSessionView.calculateScalePreview())
    }
    
    public func onUpdate(with captureSessionOptions: MBCaptureSessionOptions, style: MBUIOptions) {
        self.style = style
        self.captureSessionOptions = captureSessionOptions
        
        faceStatusView.isHidden = faceStatusTextViewIsHidden()
        progressView.isHidden = progressViewIsHidden()
        debugTimerLabel.isHidden = !captureSessionOptions.isDebugging
        overlayFaceView.isHidden = !style.shouldShowOverlayFaceView
        
        self.mbCaptureSessionView.onUpdate(options: captureSessionOptions)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraSession(isAuthorized: granted)
                self?.setBindings()
            }
        }
    }
    
    func cameraSession(isAuthorized: Bool) {
        if !isAuthorized {
            presentAlertWithTitle(
                title: "To continue the app need access for settings!",
                message: "Go to Settings?",
                options: "Settings", "Cancel"
            ) { option in
                switch option {
                case 0:
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                    break
                case 1:
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func setObservers() {
        mbCaptureSessionView.captureSessionDelegate = self
        mbCaptureSessionView.countDownDelegate = self
        mbCaptureSessionView.validatingDelegate = self
        mbCaptureSessionView.progressDelegate = self
        mbCaptureSessionView.boundingBoxFaceValidatorDelegate = self
    }
    
    func setupConstraints() {
        [mbCaptureSessionView, dissmisButton].forEach {
            view.addSubview($0)
        }
        
        [overlayFaceView, progressView].forEach {
            mbCaptureSessionView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mbCaptureSessionView.topAnchor.constraint(equalTo: view.topAnchor),
            mbCaptureSessionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mbCaptureSessionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mbCaptureSessionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayFaceView.topAnchor.constraint(equalTo: mbCaptureSessionView.topAnchor),
            overlayFaceView.trailingAnchor.constraint(equalTo: mbCaptureSessionView.trailingAnchor),
            overlayFaceView.leadingAnchor.constraint(equalTo: mbCaptureSessionView.leadingAnchor),
            overlayFaceView.bottomAnchor.constraint(equalTo: mbCaptureSessionView.bottomAnchor)
        ])
        
        dissmisButton.anchorTo(
            top: view.topAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: .init(top: 55, left: 0, bottom: 0, right: 16),
            size: .init(width: 45, height: 45)
        )
        
        setUpdateProgressViewConstraints()
        
        mbCaptureSessionView.bringSubviewToFront(overlayFaceView)
    }
    
    func setUpdateProgressViewConstraints() {
        view.removeConstraints(progressViewHorizontalConstraints)
        view.addConstraints(progressViewVerticalConstraints)
        
        self.view.layoutIfNeeded()
        progressView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(0) * .pi/180))
    }
    
    @objc
    func takePictureAction() {
        mbCaptureSessionView.takePicture()
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        mbCaptureSessionView.onStopCapturing()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        let sessionID: String? = (Bundle.main.object(forInfoDictionaryKey: "SessionId") as? String).flatMap { s in
            return s.isEmpty ? nil : s
        }
        mbCaptureSessionView.onStartCapturing(sessionId: sessionID)
        progressView.setProgress(0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MBCaptureSessionViewController: MBCaptureSessionDelegate, MBOnValidatingDelegate, MBCountDownDelegate, MBCaptureProgressDelegate {
    public func onPresentedDismissTapped() { }
    
    public func onInitializing() { }
    
    public func onValidating(_ faceStatus: MBFaceStatus) {
        switch faceStatus {
        case .valid:
            overlayFaceView.updateOvalStrokeColor(.green)
            self.faceStatusView.updateLabelColor(.green)
        default:
            overlayFaceView.updateOvalStrokeColor(.yellow)
            self.faceStatusView.updateLabelColor(.black)
        }
        
        if !faceStatusTextViewIsHidden() {
            faceStatusViewUpdate(faceStatus)
        }
    }
    
    public func onCountDown(timeCounter: Int) {
        if captureSessionOptions.isDebugging ? true : style.showCountdownTimerLabel {
            textByTimerLabel.isHidden = timeCounter == 0
        } else {
            textByTimerLabel.isHidden = true
        }
        
        debugTimerLabel.isHidden = timeCounter == 0
        debugTimerLabel.text = String(timeCounter)
    }
    
    public func onCaptureStarted() {
        print("MBCaptureSessionViewController: -------------Started Capturing-------------")
    }
    
    public func onSuccess(result: MBCaptureSessionResult) {
        Task{
            showLoading()
            let request = VideoDecodingRequest(video_base64: result.capturedVideoData.base64EncodedString(), session_meta_data: result.sessionVideoMetaData, face_image_base64: result.faceImage.base64EncodedString())
            
            do{
                var headers: [String: String] = [:]
                let response = try await videoDecodingService.post(httpHeader: headers, request: request)
                delegate?.biometricSucceeded(result: response)
                hideLoading()
            }catch{
                hideLoading()
                delegate?.biometricFailed(error: error)
            }
        }
    }
    
    public func onFailure(error: MBCaptureSessionError) {
        delegate?.biometricFailed(error: error)
    }
    
    public func onStateChanged(captureState: MBCaptureState) { }
    
    public func onCaptureProgress(captureProgressCounter: Float) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressView.setProgress(captureProgressCounter, animated: true)
        }
        print("MBCaptureSessionView: onCaptureProgress", captureProgressCounter)
    }
    
    public func faceStatusViewUpdate(_ action: MBFaceStatus) {
        switch action {
        case .tooFarAway:
            faceStatusView.label.text = "Face Too Far Away"
        case .tooClose:
            faceStatusView.label.text = "Face Too Close"
        case .tooFarUp:
            faceStatusView.label.text = "Face Too Far Up"
        case .tooFarDown:
            faceStatusView.label.text = "Face Too Far Down"
        case .tooFarLeft:
            faceStatusView.label.text = "Face Too Far Left"
        case .tooFarRight:
            faceStatusView.label.text = "Face Too Far Right"
        case .notFound:
            faceStatusView.label.text = "Face Not Found"
        case .tooMany:
            faceStatusView.label.text = "Too Many Faces"
        case .valid:
            faceStatusView.label.text = "Valid Face"
        @unknown default:
            break
        }
    }
}

extension MBCaptureSessionViewController: MBBoundingBoxFaceValidatorDelegate {
    public func onValidating(_ faceStatus: Result<MBFaceGeometryModel, MBFaceBoundingBoxStatus>) {
        if case .failure = faceStatus {
            overlayFaceView.updateOvalStrokeColor(.yellow)
            self.faceStatusView.updateLabelColor(.black)
        } else {
            overlayFaceView.updateOvalStrokeColor(.green)
            self.faceStatusView.updateLabelColor(.green)
        }
    }
}

extension MBCaptureSessionViewController {
    func showLoading() {
        self.loadingOverlay = UIView(frame: view.bounds)
        self.loadingOverlay!.backgroundColor = UIColor(white: 0, alpha: 0.4)
        self.loadingOverlay!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        self.loadingOverlay!.addSubview(indicator)
        view.addSubview(self.loadingOverlay!)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.loadingOverlay!.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.loadingOverlay!.centerYAnchor)
        ])

        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        if let loadingOverlay = self.loadingOverlay{
            loadingOverlay.removeFromSuperview()
        }
        view.isUserInteractionEnabled = true
    }
}
