//
//  CapsuleAPIClient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import Foundation

extension URLRequest {
    mutating func addMultipartFormData(parameters: [String: String], fileURL: URL, fileType: String) {
        let boundary = "Boundary-\(UUID().uuidString)"
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(fileType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        httpBody = body
    }
}

class CapsuleAPIClient {
    static let shared = CapsuleAPIClient()
    
    private let baseURL = "http://34.130.149.129/api/v1"
    
    private init() {}
    
    func getCapsules(authorization: String, completion: @escaping (Result<[APICapsule], APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        performRequest(request, completion: completion)
    }
    
    func getCapsuleById(authorization: String, id: UInt, completion: @escaping (Result<APICapsule, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/get-by-id/\(id)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        performRequest(request, completion: completion)
    }
    
    func createCapsule(authorization: String, vessel: String, public: Bool, completion: @escaping (Result<CreateResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/create") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["vessel": vessel, "public": `public`]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request, completion: completion)
    }
    
    func joinCapsule(authorization: String, code: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/join") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["code": code]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteCapsule(authorization: String, capsuleId: UInt, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/delete") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["capsuleId": capsuleId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func nameCapsule(authorization: String, capsuleId: UInt, name: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/name") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["capsuleId": capsuleId, "name": name]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sealCapsule(authorization: String, capsuleId: UInt, dateToOpen: Date, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/seal") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["capsuleId": capsuleId, "dateToOpen": dateToOpen]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func openCapsule(authorization: String, capsuleId: UInt, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/open") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["capsuleId": capsuleId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadFile(authorization: String, fileURL: URL, fileType: String, completion: @escaping (Result<UploadResponse, APIError>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/files/upload") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        request.addMultipartFormData(parameters: [:], fileURL: fileURL, fileType: fileType)
        
        performRequest(request, completion: completion)
    }
    
    func createMedia(authorization: String, mediaType: MediaType, capsuleId: UInt, objectName: String, fileURL: String, completion: @escaping (Result<CreateResponse, APIError>) -> Void) {
        
        let endpoint: String
        switch mediaType {
            case .audio:
                endpoint = "/audios/create"
            case .photo:
                endpoint = "/photos/create"
            case .doodle:
                    endpoint = "/doodles/create"
            case .miscFile:
                    endpoint = "/misc-files/create"
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["capsuleId": capsuleId, "objectName": objectName, "fileURL": fileURL]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        performRequest(request) { (result: Result<CreateResponse, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            } else {
                print("Unable to convert data to JSON string.")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding failed with error: \(error.localizedDescription)")
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("Error response from server: \(errorResponse.message)")
                }
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
