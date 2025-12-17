//
//  CaptureView.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//

import SwiftUI
import MobaiBiometric

struct CaptureView: UIViewControllerRepresentable {
    var onFinished: (Result<VideoDecodingResponse, Error>) -> Void
    
    func makeUIViewController(context: Context) -> MBCaptureSessionViewController {
        let vc = MBCaptureSessionViewController( with: AppData.mbCaptureSessionOptions, style: AppData.mbUIOptions)
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MBCaptureSessionViewController, context: Context) {
    
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFinished: onFinished)
    }
    
    class Coordinator: NSObject, MBBiometricDelegate {
        func biometricSucceeded(result: VideoDecodingResponse) {
            onFinished(.success(result))
        }
        
        func biometricFailed(error: any Error) {
            onFinished(.failure(error))
        }
        
        let onFinished: (Result<VideoDecodingResponse, Error>) -> Void
        
        init(onFinished: @escaping (Result<VideoDecodingResponse, Error>) -> Void) {
            self.onFinished = onFinished
        }
    }
}

