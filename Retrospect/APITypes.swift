//
//  Types.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-14.
//

import Foundation
import UIKit

enum MediaType {
    case capsule
    case song
    case prompt
    case writing
    case audio
    case photo
    case doodle
    case miscFile
}

enum UpdateType {
    case QuestionAnswer
    case Writing
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

import Foundation

public struct CapsuleData: Codable {
    public var id: UInt
    public var code: String
    public var createdAt: Date
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
        case id, code, createdAt, isPublic = "public", capsuleOwnerId,
             capsuleMember1Id, capsuleMember2Id, capsuleMember3Id,
             capsuleMember4Id, capsuleMember5Id, capsuleMember1Sealed,
             capsuleMember2Sealed, capsuleMember3Sealed, capsuleMember4Sealed,
             capsuleMember5Sealed, vessel, name, dateToOpen, emailSent, sealed
    }
}

public struct Song: Codable, Equatable, Hashable {
    public var uploaded: Bool = true
    public var id: UInt?
    public var userId: UInt?
    public var capsuleId: UInt?
    public var spotifyId: String
    public var name: String
    public var artistName: String
    public var albumArtURL: String
    public var createdAt: String?

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
    
    public static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.spotifyId == rhs.spotifyId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(spotifyId)
    }
}

public struct QuestionAnswer: Codable {
    public var uploaded: Bool = true
    public var edited: Bool = false
    public var id: UInt?
    public var userId: UInt?
    public var capsuleId: UInt?
    public var prompt: String
    public var answer: String
    public var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case prompt
        case answer
        case createdAt
    }
}

public struct Writing: Codable, Equatable {
    public var uploaded: Bool = true
    public var edited: Bool = false
    public var id: UInt?
    public var userId: UInt?
    public var capsuleId: UInt?
    public var writing: String
    public var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case writing
        case createdAt
    }
    
    public static func == (lhs: Writing, rhs: Writing) -> Bool {
        return lhs.writing == rhs.writing
    }
}

public struct File: Codable, Hashable {
    public var uploaded: Bool = true
    public var id: UInt?
    public var userId: UInt?
    public var capsuleId: UInt?
    public var objectName: String?
    public var fileURL: String
    public var photo: UIImage?
    public var fileType: String = ""
    public var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
    
    public static func == (lhs: File, rhs: File) -> Bool {
        return lhs.fileURL == rhs.fileURL
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fileURL)
    }
}

