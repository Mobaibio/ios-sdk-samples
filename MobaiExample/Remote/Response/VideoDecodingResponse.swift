//
//  VideoDecodingResponse.swift
//  MobaiExample
//
//  Created by Şerif Kazan on 10.10.2025.
//

public struct VideoDecodingResponse: Codable {
    public var message: String?
    public var filename: String?
    public var video_info: VideoInfo?
    public var status: String?
    
    public init(message: String? = nil, filename: String? = nil, video_info: VideoInfo? = nil, status: String? = nil) {
        self.message = message
        self.filename = filename
        self.video_info = video_info
        self.status = status
    }
}

public struct VideoInfo: Codable {
  public var fps: Int?
  public var width: Int?
  public var height: Int?
  public var frame_count: Int?
  
  public init(fps: Int? = nil, width: Int? = nil, height: Int? = nil, frame_count: Int? = nil) {
      self.fps = fps
      self.width = width
      self.height = height
      self.frame_count = frame_count
  }
}
