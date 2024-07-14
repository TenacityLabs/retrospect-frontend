//
//  CapsuleAPIClient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import Foundation

public struct CreateCapsuleResponse: Codable {
    let capsuleId: UInt
}

public struct CapsuleData: Codable {
    public var id: UInt
    public var code: String
    public var createdAt: String
    public var isPublic: Bool
    public var capsuleOwnerId: UInt
    
    public var capsuleMember1Id: UInt
    public var capsuleMember2Id: UInt
    public var capsuleMember3Id: UInt
    public var capsuleMember4Id: UInt
    public var capsuleMember5Id: UInt
    
    public var capsuleMember1Sealed: Bool
    public var capsuleMember2Sealed: Bool
    public var capsuleMember3Sealed: Bool
    public var capsuleMember4Sealed: Bool
    public var capsuleMember5Sealed: Bool
    
    public var vessel: String
    public var name: String
    public var dateToOpen: Date?
    public var emailSent: Bool
    public var sealed: String

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case createdAt
        case isPublic = "public"
        case capsuleOwnerId = "capsuleOwnerId"
        case capsuleMember1Id = "capsuleMember1Id"
        case capsuleMember2Id = "capsuleMember2Id"
        case capsuleMember3Id = "capsuleMember3Id"
        case capsuleMember4Id = "capsuleMember4Id"
        case capsuleMember5Id = "capsuleMember5Id"
        case capsuleMember1Sealed = "capsuleMember1Sealed"
        case capsuleMember2Sealed = "capsuleMember2Sealed"
        case capsuleMember3Sealed = "capsuleMember3Sealed"
        case capsuleMember4Sealed = "capsuleMember4Sealed"
        case capsuleMember5Sealed = "capsuleMember5Sealed"
        case vessel
        case name
        case dateToOpen
        case emailSent
        case sealed
    }
}

public struct Song: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var spotifyId: String
    public var name: String
    public var artistName: String
    public var albumArtURL: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case spotifyId
        case name
        case artistName
        case albumArtURL
        case createdAt
    }
}

public struct QuestionAnswer: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var prompt: String
    public var answer: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case prompt
        case answer
        case createdAt
    }
}

public struct Writing: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var writing: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case writing
        case createdAt
    }
}

public struct Photo: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var objectName: String
    public var fileURL: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
}

public struct Audio: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var objectName: String
    public var fileURL: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
}

public struct Doodle: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var objectName: String
    public var fileURL: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
}

public struct MiscFile: Codable {
    public var id: UInt
    public var userId: UInt
    public var capsuleId: UInt
    public var objectName: String
    public var fileURL: String
    public var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
}

public struct APICapsule: Codable {
    public var capsule: CapsuleData
    public var songs: [Song]
    public var questionAnswers: [QuestionAnswer]
    public var writings: [Writing]
    public var photos: [Photo]
    public var audios: [Audio]
    public var doodles: [Doodle]
    public var miscFiles: [MiscFile]

    enum CodingKeys: String, CodingKey {
        case capsule = "capsule"
        case songs = "songs"
        case questionAnswers = "questionAnswers"
        case writings = "writings"
        case photos = "photos"
        case audios = "audios"
        case doodles = "doodles"
        case miscFiles = "miscFiles"
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
    
    func createCapsule(authorization: String, vessel: String, public: Bool, completion: @escaping (Result<CreateCapsuleResponse, APIError>) -> Void) {
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
    
    struct ErrorResponse: Decodable {
        let message: String
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
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
                print("Decoding failed with error: \(error.localizedDescription)")
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("Error response from server: \(errorResponse.message)")
                }
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
