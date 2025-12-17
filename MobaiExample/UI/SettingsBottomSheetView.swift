//
//  SettingsBottomSheetView.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//
import SwiftUI
import MobaiBiometric

struct SettingsBottomSheetView: View {
    @AppStorage("$serviceUrlAddress") private var serviceUrlAddress = AppData.serviceUrlAddress
    @AppStorage("isDebuggingEnabled") private var debuggingSelectedIndex = 0
    @AppStorage("isNetworkEnabled") private var networkSelectedIndex = 1
    @AppStorage("isInjectionAttackEnabled") private var isInjectionAttackEnabled = 0
    @AppStorage("$logLevelSelectedIndex") private var logLevelSelectedIndex = 0
    @AppStorage("isFaceStatusTextEnabled") private var faceStatusSelectedIndex = 0
    @AppStorage("isFacePlacementTextEnabled") private var facePlacementSelectedIndex = 0
    @AppStorage("isFaceAngleTextEnabled") private var faceAngleSelectedIndex = 0
    @AppStorage("isTimerTextEnabled") private var timerTextSelectedIndex = 0
    @AppStorage("isProgressbarEnabled") private var progressbarSelectedIndex = 0
    @AppStorage("isShowFaceOverlayEnabled") private var shouldShowOverlaySelectedIndex = 0
    @AppStorage("isNewConstraintsEnabled") private var newConstraintsSelectedIndex = 1
    @AppStorage("cameraPosition") private var cameraPositionSelectedIndex = 0
    @AppStorage("targetResolution") private var targetResolutionSelectedIndex = 0
    @AppStorage("payloadOptimization") private var payloadOptimizationSelectedIndex = 1
    @AppStorage("captureType") private var captureTypeSelectedIndex = 0
    @AppStorage("constraintLevel") private var constraintLevelSelectedIndex = 1
    @AppStorage("numberOfFrames") private var numberOfFramesSelected = "3"
    @AppStorage("timeBeforeAutomaticCapture") private var timeBeforeAutomaticCaptureSelected = "1"
    @AppStorage("videoCaptureDuration") private var videoCaptureDurationSelected = "1000"
    
    var body: some View {
        VStack{
            List{
                Section(
                    footer: Divider().padding(.horizontal, 16)
                ){
                    Text("Capture Backend Address")
                    TextField("", text:$serviceUrlAddress)
                }
                Section(
                    header: Text("Debugging"),
                    footer: Divider().padding(.horizontal, 16)){
                        Text("Debugging")
                        Picker("Debugging", selection: $debuggingSelectedIndex){
                            Text("Off").tag(0)
                            Text("On").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        Text("Network Call")
                        Picker("Network Call", selection: $networkSelectedIndex){
                            Text("Off").tag(0)
                            Text("On").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        Text("Injection Attack")
                        Picker("Injection Attack", selection: $isInjectionAttackEnabled){
                            Text("Off").tag(0)
                            Text("On").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        Text("Log Level")
                        Picker("Log Level", selection: $logLevelSelectedIndex){
                            Text("None").tag(0)
                            Text("Error").tag(1)
                            Text("Warning").tag(2)
                            Text("Info").tag(3)
                            Text("Debug").tag(4)
                        }
                        .pickerStyle(.segmented)
                        
                    }
                Section(header: Text("UIOptions")){
                    Text("Face Status Text Enabled")
                    Picker("Face Status Text Enabled", selection: $faceStatusSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Face Placement Text Enabled")
                    Picker("Face Placement Text Enabled", selection: $facePlacementSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Face Angle Text Enabled")
                    Picker("Face Angle Text Enabled", selection: $faceAngleSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Timer Text Enabled")
                    Picker("Timer Text Enabled", selection: $timerTextSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Progressbar Enabled")
                    Picker("Progressbar Enabled", selection: $progressbarSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Should Show Overlay Face View")
                    Picker("Should Show Overlay Face View", selection: $shouldShowOverlaySelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Capture Options")){
                    Text("New Constraints Enabled")
                    Picker("New Constraints Enabled", selection: $newConstraintsSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Camera Position")
                    Picker("Camera Position", selection: $cameraPositionSelectedIndex){
                        Text("Front").tag(0)
                        Text("Back").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Target Resolution")
                    Picker("Target Resolution", selection: $targetResolutionSelectedIndex){
                        Text("QHD").tag(0)
                        Text("720p").tag(1)
                        Text("1080p").tag(2)
                        Text("4K").tag(3)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Payload Optimization")
                    Picker("Payload Optimization", selection: $payloadOptimizationSelectedIndex){
                        Text("Off").tag(0)
                        Text("On").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Capture Type")
                    Picker("Capture Type", selection: $captureTypeSelectedIndex){
                        Text("Automatic").tag(0)
                        Text("Manual").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Constraint Level")
                    Picker("Constraint Level", selection: $constraintLevelSelectedIndex){
                        Text("Easy").tag(0)
                        Text("Medium").tag(1)
                        Text("Strict").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Number of Frames to Collect")
                    TextField("", text:$numberOfFramesSelected)
                    
                    Text("Time Before Automatic Capture Interval")
                    TextField("", text:$timeBeforeAutomaticCaptureSelected)
                    
                    Text("Video Capture Duration")
                    TextField("", text:$videoCaptureDurationSelected)
                }
            }
        }
        .onDisappear{
            AppData.serviceUrlAddress = self.serviceUrlAddress.isEmpty ? "" : self.serviceUrlAddress
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
                autoCaptureEnabled: captureTypeSelectedIndex == 1,
                numberOfFrameToCollect: numberOfFramesSelected.isEmpty ? 3 : Int(numberOfFramesSelected)!,
                videoCaptureDuration: videoCaptureDurationSelected.isEmpty ? 1000 : Int(videoCaptureDurationSelected)!,
                timeBeforeAutomaticCapture: timeBeforeAutomaticCaptureSelected.isEmpty ? 1 : Int(timeBeforeAutomaticCaptureSelected)!,
                isDebugging: debuggingSelectedIndex == 1,
                payloadOptimization: payloadOptimizationSelectedIndex == 1,
                cameraQuality: cameraQuality,
                captureConstraints: newConstraintsSelectedIndex == 1 ? .v2 : .v1
            )
        }
    }
}



#Preview {
    SettingsBottomSheetView()
}
