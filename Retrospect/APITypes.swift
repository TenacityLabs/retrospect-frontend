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

    public init(id: UInt = 0,
                code: String = "",
                createdAt: String = "",
                isPublic: Bool = false,
                capsuleOwnerId: UInt = 0,
                capsuleMember1Id: UInt = 0,
                capsuleMember2Id: UInt = 0,
                capsuleMember3Id: UInt = 0,
                capsuleMember4Id: UInt = 0,
                capsuleMember5Id: UInt = 0,
                capsuleMember1Sealed: Bool = false,
                capsuleMember2Sealed: Bool = false,
                capsuleMember3Sealed: Bool = false,
                capsuleMember4Sealed: Bool = false,
                capsuleMember5Sealed: Bool = false,
                vessel: String = "",
                name: String = "",
                dateToOpen: Date? = nil,
                emailSent: Bool = false,
                sealed: String = "") {
        self.id = id
        self.code = code
        self.createdAt = createdAt
        self.isPublic = isPublic
        self.capsuleOwnerId = capsuleOwnerId
        self.capsuleMember1Id = capsuleMember1Id
        self.capsuleMember2Id = capsuleMember2Id
        self.capsuleMember3Id = capsuleMember3Id
        self.capsuleMember4Id = capsuleMember4Id
        self.capsuleMember5Id = capsuleMember5Id
        self.capsuleMember1Sealed = capsuleMember1Sealed
        self.capsuleMember2Sealed = capsuleMember2Sealed
        self.capsuleMember3Sealed = capsuleMember3Sealed
        self.capsuleMember4Sealed = capsuleMember4Sealed
        self.capsuleMember5Sealed = capsuleMember5Sealed
        self.vessel = vessel
        self.name = name
        self.dateToOpen = dateToOpen
        self.emailSent = emailSent
        self.sealed = sealed
    }
    
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

public class APICapsule: ObservableObject, Codable {
    public var capsule: CapsuleData
    public var songs: [Song] = []
    public var questionAnswers: [QuestionAnswer] = []
    public var writings: [Writing] = []
    public var photos: [File] = []
    public var audios: [File] = []
    public var doodles: [File] = []
    public var miscFiles: [File] = []

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
    
    public init() {
        self.capsule = CapsuleData()
        self.songs = []
        self.questionAnswers = []
        self.writings = []
        self.photos = []
        self.audios = []
        self.doodles = []
        self.miscFiles = []
    }
}
