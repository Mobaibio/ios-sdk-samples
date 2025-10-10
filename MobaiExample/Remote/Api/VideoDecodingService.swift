//
//  VideoDecodingService.swift
//  MobaiExample
//
//  Created by Şerif Kazan on 10.10.2025.
//

public protocol VideoDecodingDelegate {
    func post(httpHeader: [String: String]?, request: VideoDecodingRequest) async throws -> VideoDecodingResponse
}

public class VideoDecodingService: VideoDecodingDelegate {
    var baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func post(httpHeader: [String: String]?, request: VideoDecodingRequest) async throws -> VideoDecodingResponse {
        return try await ApiClient().sendRequest(
            requestData: request,
            httpClient: .init(
                httpMethod: .POST,
                httpHeader: httpHeader ?? [:],
                endpoint: .videoToDecode,
                baseURL: self.baseURL
            )
        )
    }
}
