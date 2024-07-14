//
//  CapsuleAPIClient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import Foundation

struct createCapsuleResponse: Codable {
    let capsuleId: UInt
}

struct CapsuleData: Codable {
    var id: UInt
    var code: String
    var createdAt: Date
    var isPublic: Bool
    var capsuleOwnerId: UInt
    
    var capsuleMember1Id: UInt
    var capsuleMember2Id: UInt
    var capsuleMember3Id: UInt
    var capsuleMember4Id: UInt
    var capsuleMember5Id: UInt
    
    var capsuleMember1Sealed: Bool
    var capsuleMember2Sealed: Bool
    var capsuleMember3Sealed: Bool
    var capsuleMember4Sealed: Bool
    var capsuleMember5Sealed: Bool
    
    var vessel: String
    var name: String
    var dateToOpen: Date?
    var emailSent: Bool
    var sealed: String
}

struct Song: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var spotifyId: String
    var name: String
    var artistName: String
    var albumArtURL: String
    var createdAt: Date
}

struct QuestionAnswer: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var prompt: String
    var answer: String
    var createdAt: Date
}

struct Writing: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var writing: String
    var createdAt: Date
}

struct Photo: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: Date
}

struct Audio: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: Date
}

struct Doodle: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: Date
}

struct MiscFile: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: Date
}

struct APICapsule: Codable {
    var Capsule: CapsuleData
    var Songs: [Song]
    var QuestionAnswers: [QuestionAnswer]
    var Writings: [Writing]
    var Photos: [Photo]
    var Audios: [Audio]
    var Doodles: [Doodle]
    var MiscFiles: [MiscFile]
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
    
    func createCapsule(authorization: String, vessel: String, public: Bool, completion: @escaping (Result<createCapsuleResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/capsules/create") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["vessel": vessel, "public": `public`]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request) { (result: Result<createCapsuleResponse, APIError>) in
            switch result {
            case .success(let capsule):
                completion(.success(capsule))
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
    
    struct ErrorResponse: Decodable {
        let message: String
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error)
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
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
}
