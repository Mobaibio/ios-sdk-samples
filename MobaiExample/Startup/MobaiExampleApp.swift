//
//  MobaiExampleApp.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//

import SwiftUI
import MobaiBiometric

@main
struct MobaiExampleApp: App {
    @AppStorage("serviceUrlAddress") private var serviceUrlAddress = "http://192.168.0.113:8010"
    @AppStorage("isDebuggingEnabled") private var debuggingSelectedIndex = 0
    @AppStorage("isNetworkEnabled") private var networkSelectedIndex = 0
    @AppStorage("isFaceStatusTextEnabled") private var faceStatusSelectedIndex = 0
    @AppStorage("isFacePlacementTextEnabled") private var facePlacementSelectedIndex = 0
    @AppStorage("isFaceAngleTextEnabled") private var faceAngleSelectedIndex = 0
    @AppStorage("isTimerTextEnabled") private var timerTextSelectedIndex = 0
    @AppStorage("isProgressbarEnabled") private var progressbarSelectedIndex = 0
    @AppStorage("isShowFaceOverlayEnabled") private var shouldShowOverlaySelectedIndex = 0
    @AppStorage("isNewConstraintsEnabled") private var newConstraintsSelectedIndex = 1
    @AppStorage("cameraPosition") private var cameraPositionSelectedIndex = 0
    @AppStorage("targetResolution") private var targetResolutionSelectedIndex = 0
    @AppStorage("payloadOptimization") private var payloadOptimizationSelectedIndex = 0
    @AppStorage("captureType") private var captureTypeSelectedIndex = 0
    @AppStorage("constraintLevel") private var constraintLevelSelectedIndex = 0
    @AppStorage("numberOfFrames") private var numberOfFramesSelected = "3"
    @AppStorage("timeBeforeAutomaticCapture") private var timeBeforeAutomaticCaptureSelected = "1"
    @AppStorage("videoCaptureDuration") private var videoCaptureDurationSelected = "1000"
    
    init () {
        AppData.serviceUrlAddress = self.serviceUrlAddress
        AppData.mbUIOptions = .init(
            showProgressBar: progressbarSelectedIndex == 1,
            showFaceStatusLabel: faceStatusSelectedIndex == 1,
            showCountdownTimerLabel: timerTextSelectedIndex == 1,
            shouldShowOverlayFaceView: shouldShowOverlaySelectedIndex == 1,
            shouldShowFaceAngleText: faceAngleSelectedIndex == 1,
            shouldShowFacePlacementLabel: facePlacementSelectedIndex == 1
        )
        
        let targetResolution = switch  targetResolutionSelectedIndex{
        case 0: MBTargetResolution.qHD960x540
        case 1: MBTargetResolution.hd1280x720
        case 2: MBTargetResolution.hd1920x1080
        case 3: MBTargetResolution.hd4K3840x2160
        default: MBTargetResolution.qHD960x540
        }
        
        let cameraPosition = switch cameraPositionSelectedIndex{
        case 0: MBCameraPosition.front
        case 1: MBCameraPosition.rear
        default : MBCameraPosition.front
        }
        
        let cameraQuality = MBCameraOptions(
            targetResolution: targetResolution,
            previewScaleType: .fill,
            cameraPosition: cameraPosition
        )

        AppData.mbCaptureSessionOptions = .init(
            autoCaptureEnabled: captureTypeSelectedIndex == 0,
            numberOfFrameToCollect: numberOfFramesSelected.isEmpty ? 3 : Int(numberOfFramesSelected)!,
            videoCaptureDuration: videoCaptureDurationSelected.isEmpty ? 1000 : Int(videoCaptureDurationSelected)!,
            timeBeforeAutomaticCapture: timeBeforeAutomaticCaptureSelected.isEmpty ? 1 : Int(timeBeforeAutomaticCaptureSelected)!,
            isDebugging: debuggingSelectedIndex == 1,
            payloadOptimization: payloadOptimizationSelectedIndex == 1,
            cameraQuality: cameraQuality,
            captureConstraints: newConstraintsSelectedIndex == 1 ? .v2 : .v1
        )
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
