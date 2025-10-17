//
//  VideoDecodingRequest.swift
//  MobaiExample
//
//  Created by Şerif Kazan on 10.10.2025.
//

public struct VideoDecodingRequest: Codable {
  public var video_base64: String
  public var session_meta_data: String?
  public var face_image_base64: String
  
  public init(video_base64: String, session_meta_data: String? = nil, face_image_base64: String) {
    self.video_base64 = video_base64
    self.face_image_base64 = face_image_base64
    self.session_meta_data = session_meta_data
  }
}
