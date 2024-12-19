//
//  MBCameraPermissions.swift
//  MobaiExample


import AVFoundation

struct MBCameraPermissions {
    func authorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
}
