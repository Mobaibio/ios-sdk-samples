//
//  AppData.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//
import MobaiBiometric

struct AppData {
    static var serviceUrlAddress: String = "http://192.168.0.113:8010"
    static var mbCaptureSessionOptions: MBCaptureSessionOptions = .init(captureConstraints: .v2)
    static var mbUIOptions: MBUIOptions = .init()
}
