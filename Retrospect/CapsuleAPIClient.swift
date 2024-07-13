//
//  CapsuleAPIClient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import Foundation

struct APICapsule: Codable {
    let id: UInt
    let code: String
    let createdAt: Date
    let isPublic: Bool
    let capsuleOwnerId: UInt
    let capsuleMember1Id: UInt
    let capsuleMember2Id: UInt
    let capsuleMember3Id: UInt
    let vessel: String
    let name: String
    let dateToOpen: Date?
    let emailSent: Bool
    let sealed: String

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case createdAt
        case isPublic = "public"
        case capsuleOwnerId
        case capsuleMember1Id
        case capsuleMember2Id
        case capsuleMember3Id
        case vessel
        case name
        case dateToOpen
        case emailSent
        case sealed
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
    
    func createCapsule(authorization: String, vessel: String, public: Bool, completion: @escaping (Result<UInt, APIError>) -> Void) {
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
        
        performRequest(request) { (result: Result<UInt, APIError>) in
            switch result {
            case .success(let capsuleId):
                completion(.success(capsuleId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    
    func sealCapsule(authorization: String, capsuleId: UInt, dateToOpen: String, completion: @escaping (Result<Void, APIError>) -> Void) {
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
    
    private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
