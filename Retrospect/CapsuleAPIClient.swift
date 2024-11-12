//
//  CapsuleAPIClient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

//FIXME: Consolidate functions with same return type

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
    
    private let baseURL = "http://34.130.7.105/api/v1/"
    
    private init() {}
    
    func getCapsules(authorization: String, completion: @escaping (Result<[CapsuleData], APIError>) -> Void) {
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
    
    func create(authorization: String, mediaType: MediaType, body: [String: Any],  completion: @escaping (Result<CreateResponse, APIError>) -> Void) {
        
        let endpoint: String
        switch mediaType {
        case .capsule:
            endpoint = "/capsules/create"
        case .audio:
            endpoint = "/audios/create"
        case .photo:
            endpoint = "/photos/create"
        case .doodle:
            endpoint = "/doodles/create"
        case .miscFile:
            endpoint = "/misc-files/create"
        case .song:
            endpoint = "/songs/create"
        case .prompt:
            endpoint = "/question-answers/create"
        case .writing:
            endpoint = "/writings/create"
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request, completion: completion)
    }
    
    func delete(authorization: String, mediaType: MediaType, body: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void) {
        
        let endpoint: String
        switch mediaType {
        case .capsule:
            endpoint = "/capsules/delete"
        case .audio:
            endpoint = "/audios/delete"
        case .photo:
            endpoint = "/photos/delete"
        case .doodle:
            endpoint = "/doodles/delete"
        case .miscFile:
            endpoint = "/misc-files/delete"
        case .song:
            endpoint = "/songs/delete"
        case .prompt:
            endpoint = "/question-answers/delete"
        case .writing:
            endpoint = "/writings/delete"
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
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
    
    func update(authorization: String, updateType: UpdateType, body: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void) {
        
        let endpoint: String
        switch updateType {
        case .QuestionAnswer:
            endpoint = "/question-answers/update"
        case .Writing:
            endpoint = "/writings/update"
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
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
    
    func upload(authorization: String, fileURL: URL, fileType: String, completion: @escaping (Result<UploadResponse, APIError>) -> Void) {
        
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
}

public func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
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
            completion(.failure(.decodingFailed(error)))
        }
    }.resume()
}
