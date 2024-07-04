//
//  APIclient.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-04.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

struct User: Decodable {
    let firstName: String
    let lastName: String
    let email: String
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "http://34.130.149.129/api/v1"
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        performRequest(request, completion: completion)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/register") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["firstName": firstName, "lastName": lastName, "email": email, "password": password]
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
    
    func getUser(authorization: String, completion: @escaping (Result<User, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        performRequest(request, completion: completion)
    }
    
    func deleteUser(authorization: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/delete") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        performRequest(request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUser(authorization: String, firstName: String?, lastName: String?, email: String?, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/update") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        var body: [String: Any] = [:]
        if let firstName = firstName { body["firstName"] = firstName }
        if let lastName = lastName { body["lastName"] = lastName }
        if let email = email { body["email"] = email }
        
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
    
    func updatePassword(authorization: String, password: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/update-password") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["password": password]
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

struct EmptyResponse: Decodable {}
