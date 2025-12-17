//
//  VideoDecodingResponse.swift
//  MobaiExample
//
//  Created by Şerif Kazan on 10.10.2025.
//

public struct VideoDecodingResponse: Codable {
    let id: String
    let recognition: RecognitionObject?
    let pad: PadObject?
    let authenticity: AuthenticityObject?
    let integrity: IntegrityObject?
    let deepFake: DeepFakeObject?
    let faceQualityProbe: FaceQualityProbeObject?
    let error: ErrorObject?
    
    enum CodingKeys: String, CodingKey {
        case id
        case recognition
        case pad
        case authenticity
        case integrity
        case deepFake = "deepfake"
        case faceQualityProbe = "face_quality_probe"
        case error
    }
}

struct RecognitionObject: Codable {
    let passed: Bool
    let score: Double
}

struct PadObject: Codable {
    let passed: Bool
    let score: Double
}

struct AuthenticityObject: Codable {
    let passed: Bool
}

struct IntegrityObject: Codable {
    let passed: Bool
}

struct DeepFakeObject: Codable {
    let passed: Bool
    let score: Double
}

struct FaceQualityProbeObject: Codable {
    let metrics: FaceQualityMetrics
}

struct FaceQualityMetrics: Codable {
    let illuminationUniformity: String
    let luminanceMean: String
    let luminanceVariance: String
    let underExposurePrevention: String
    let overExposurePrevention: String
    let dynamicRange: String
    let sharpness: String
    let naturalColor: String

    enum CodingKeys: String, CodingKey {
        case illuminationUniformity = "illumination_uniformity"
        case luminanceMean = "luminance_mean"
        case luminanceVariance = "luminance_variance"
        case underExposurePrevention = "under_exposure_prevention"
        case overExposurePrevention = "over_exposure_prevention"
        case dynamicRange = "dynamic_range"
        case sharpness
        case naturalColor = "natural_color"
    }
}

struct ErrorObject: Codable {
    let code: Int
    let message: String
}
