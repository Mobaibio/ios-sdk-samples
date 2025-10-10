//
//  ApiClient.swift
//  MobaiExample
//
//  Created by Şerif Kazan on 10.10.2025.
//
import Foundation

enum HttpMethod: String, CaseIterable {
    case GET
    case POST
}

enum Endpoints: String, CaseIterable {
    case videoToDecode = "/videoToDecodeDemo"
}

struct HttpClient {
    var httpMethod: HttpMethod = .GET
    var httpHeader: [String: String] = [:]
    var endpoint: Endpoints
    var baseURL: String
    
    func withURL() -> URL {
        guard let url = URL(string: self.baseURL + self.endpoint.rawValue) else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    mutating func setHeader(key: String, value: String) {
        httpHeader[key] = value
    }
}

class ApiClient{
  func sendRequest<T: Encodable, Y: Decodable>(requestData: T?, httpClient: HttpClient) async throws -> Y {
      let url: URL = httpClient.withURL()
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = httpClient.httpMethod.rawValue
      
      if let requestData = requestData {
          let jsonData = try JSONEncoder().encode(requestData)
          urlRequest.httpBody = jsonData
      }
      
      urlRequest.allHTTPHeaderFields = httpClient.httpHeader
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
          throw NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
      }
      
      return try JSONDecoder().decode(Y.self, from: data)
  }
}
