//
//  Types.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-14.
//

import Foundation

enum MediaType {
    case audio
    case photo
    case doodle
    case miscFile
}

struct CreateResponse: Decodable {
    let id: UInt
}

struct ErrorResponse: Decodable {
    let message: String
}

struct UploadResponse: Decodable {
    let objectName: String
    let fileURL: String
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

public struct File: Codable {
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
    public var photos: [File]
    public var audios: [File]
    public var doodles: [File]
    public var miscFiles: [File]

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
