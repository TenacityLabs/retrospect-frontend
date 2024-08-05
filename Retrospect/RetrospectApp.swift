import SwiftUI
import Foundation
import Combine

struct APIUser: Codable {
    var id: UInt
    var name: String
    var email: String
    var phone: String
    var referralCount: UInt
    var createdAt: String
}

public struct APIBaseCapsule: Codable {
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

struct APISong: Codable, Equatable, Hashable {
    var uploaded: Bool = true
    var id: UInt?
    var userId: UInt?
    var capsuleId: UInt?
    var spotifyId: String
    var name: String
    var artistName: String
    var albumArtURL: String
    var createdAt: String?
    
    public static func == (lhs: APISong, rhs: APISong) -> Bool {
        return lhs.spotifyId == rhs.spotifyId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(spotifyId)
    }
}

struct APIQuestionAnswer: Codable {
    var uploaded: Bool = true
    var edited: Bool = false
    var id: UInt?
    var userId: UInt?
    var capsuleId: UInt?
    var prompt: String
    var answer: String
    var createdAt: String?
}

struct APIWriting: Codable {
    var uploaded: Bool = true
    var edited: Bool = false
    var id: UInt?
    var userId: UInt?
    var capsuleId: UInt?
    var writing: String
    var createdAt: String?
}

struct APIPhoto: Codable, Hashable {
    var id: UInt?
    var userId: UInt?
    var capsuleId: UInt?
    var objectName: String?
    var fileURL: String
    var createdAt: String?
    var uploaded: Bool = true
    var fileType: String = ""
}

struct APIAudio: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: String
}

struct APIDoodle: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: String
}

struct APIMiscFile: Codable, Hashable {
    var uploaded: Bool = true
    var id: UInt?
    var userId: UInt?
    var capsuleId: UInt?
    var objectName: String?
    var fileURL: String
    var photo: UIImage?
    var fileType: String = ""
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case capsuleId
        case objectName
        case fileURL
        case createdAt
    }
        
    public static func == (lhs: APIMiscFile, rhs: APIMiscFile) -> Bool {
        return lhs.fileURL == rhs.fileURL
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fileURL)
    }
}

struct APICapsule: Codable {
    var capsule: APIBaseCapsule 
    var songs: [APISong]
    var questionAnswers: [APIQuestionAnswer]
    var writings: [APIWriting]
    var photos: [APIPhoto]
    var audios: [APIAudio]
    var doodles: [APIDoodle]
    var miscFiles: [APIMiscFile]
    
    public init() {
        self.capsule = APIBaseCapsule()
        self.songs = []
        self.questionAnswers = []
        self.writings = []
        self.photos = []
        self.audios = []
        self.doodles = []
        self.miscFiles = []
    }
}

struct LocalCapsule {
    var vessel: String
    var name: String
    var collab: Bool
    var openDate: Date
}

class GlobalState: ObservableObject {
    @Published var jwt: String {
        didSet {
            UserDefaults.standard.set(jwt, forKey: "retrospect-space-client-jwt")
        }
    }
    
    @Published var user: APIUser? {
        didSet {
            do {
                let userData = try JSONEncoder().encode(user)
                UserDefaults.standard.set(userData, forKey: "retrospect-space-client-user")
            } catch {
                print(user)
                print("Failed to encode JSON: \(error.localizedDescription)")
            }
        }
    }
    
    @Published var focusCapsule: APICapsule? {
        didSet {
            do {
                let focusCapsuleData = try JSONEncoder().encode(focusCapsule)
                UserDefaults.standard.set(focusCapsuleData, forKey: "retrospect-space-client-focusCapsule")
            } catch {
                print(focusCapsule)
                print("Failed to encode JSON: \(error.localizedDescription)")
            }
        }
    }
    
    @Published var userCapsules: [APIBaseCapsule] {
        didSet {
            do {
                let capsuleData = try JSONEncoder().encode(userCapsules)
                UserDefaults.standard.set(capsuleData, forKey: "retrospect-space-client-userCapsules")
            } catch {
                print(userCapsules)
                print("Failed to encode JSON: \(error.localizedDescription)")
            }
        }
    }
    
    @Published var route: String = "/landing"
    @Published var localCapsule: LocalCapsule = LocalCapsule(vessel: "box", name: "Jessica's Capsule", collab: false, openDate: Date())
    
    init() {
        self.jwt = UserDefaults.standard.string(forKey: "retrospect-space-client-jwt") ?? ""
        self.userCapsules = []
        self.reload()
    }
    
    func reload() {
        self.jwt = UserDefaults.standard.string(forKey: "retrospect-space-client-jwt") ?? ""
        print(self.jwt)
        
        if let userData = UserDefaults.standard.data(forKey: "retrospect-space-client-user") {
            do {
                let user = try JSONDecoder().decode(APIUser.self, from: userData)
                self.user = user
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                self.user = nil
            }
        } else {
            self.user = nil
        }
        
        if let focusCapsuleData = UserDefaults.standard.data(forKey: "retrospect-space-client-focusCapsule") {
            do {
                let focusCapsule = try JSONDecoder().decode(APICapsule.self, from: focusCapsuleData)
                self.focusCapsule = focusCapsule
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                self.focusCapsule = nil
            }
        } else {
            self.focusCapsule = nil
        }
        
        if let capsuleData = UserDefaults.standard.data(forKey: "retrospect-space-client-userCapsules") {
            do {
                let userCapsules = try JSONDecoder().decode([APIBaseCapsule].self, from: capsuleData)
                self.userCapsules = userCapsules
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                self.userCapsules = []
            }
        } else {
            self.userCapsules = []
        }
        
        //TODO: HANDLE LOGIC FOR FOCUS CAPSULE SAVING
        print("BEGIN PRINTING>>>")
        print(self.user)
        print(self.jwt)
        print(self.focusCapsule)
        print(self.userCapsules)
        if self.user != nil {
            if(!self.isJWTExpired()){
                UserAPIClient.shared.getUser(authorization: self.jwt){ userResult in
                       DispatchQueue.main.async {
                           switch(userResult) {
                           case .success (let user):
                               CapsuleAPIClient.shared.getCapsules(authorization: self.jwt)
                               { capsuleResult in
                                   DispatchQueue.main.async {
                                       switch(capsuleResult) {
                                       case .success (let capsuleArray):
                                           self.user = user.user
                                           self.userCapsules = capsuleArray
                                           self.route = "/dashboard"
                                       case .failure(_):
                                           print("Capsule fetch failed, please try again!")
                                           self.route = "/landing"
                                       }
                                   }
                               }
                           case .failure(_):
                               print("User fetch failed, please try again!")
                               self.route = "/landing"
                           }
                       }
                   }
               }
               else {
                   //sessino expired logic?
                   self.route = "/landing"
               }
           }
        
        self.reveal()
    }

    func reveal() {
        print("<========= Global State Print =========>")
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        for (key, value) in dictionary {
            print("\(key): \(value)")
        }
        
        print("JWT: \(dictionary["retrospect-space-client-jwt"] ?? "[None]")")
        print("USER: \(dictionary["retrospect-space-client-user"] ?? "[None]")")
        print("FOCUS: \(dictionary["retrospect-space-client-focusCapsule"] ?? "[None]")")
        print("CAPSULES: \(dictionary["retrospect-space-client-userCapsules"] ?? "[None]")")
        
        print("<======================================>")
    }
    
    func isJWTExpired() -> Bool {
        let segments = self.jwt.split(separator: ".")
        guard segments.count == 3 else { return true }
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value.replacingOccurrences(of: "-", with: "+")
                              .replacingOccurrences(of: "_", with: "/")
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 += padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        guard let payloadData = base64UrlDecode(String(segments[1])),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else {
            return true // If there's no exp claim or decoding fails, consider it expired
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate <= Date()
    }
}

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var globalState = GlobalState()
    @State private var drawIndex = 0

    var body: some Scene {
        WindowGroup {
            ZStack {
                ColorImageView()
                if globalState.route == "/landing" {
                    Landing().environmentObject(globalState)
                } else if globalState.route == "/login" {
                    Login().environmentObject(globalState)
                } else if globalState.route == "/signup" {
                    SignUp().environmentObject(globalState)
                } else if globalState.route == "/tutorial" {
                    Tutorial().environmentObject(globalState)
                } else if globalState.route == "/dashboard" {
                    Dashboard().environmentObject(globalState)
                } else if globalState.route == "/referrals" {
                    ShareWithFriends().environmentObject(globalState)
                } else if globalState.route == "/capsule/icon-select" {
                    IconSelect().environmentObject(globalState)
                } else if globalState.route == "/capsule/choose-name" {
                    ChooseName().environmentObject(globalState)
                } else if globalState.route == "/capsule/collab" {
                    Collab().environmentObject(globalState)
                } else if globalState.route == "/capsule/preparing" {
                    Preparing().environmentObject(globalState)
                } else if globalState.route == "/capsule/photo-select" {
                    PhotoSelect().environmentObject(globalState)
                } else if globalState.route == "/capsule/song-select" {
                    SongSelect().environmentObject(globalState).environmentObject(SpotifyManager())
                } else if globalState.route == "/capsule/answer-prompt" {
                    AnswerPrompt().environmentObject(globalState)
                } else if globalState.route == "/ag" {
                    AdditionalGoodies().environmentObject(globalState)
                } else if globalState.route == "/ag/add-text" {
                    AddText().environmentObject(globalState)
                } else if globalState.route == "/ag/add-file" {
                    AddFile().environmentObject(globalState)
                } else if globalState.route == "/capsule/set-date" {
                    SetDate().environmentObject(globalState)
                } else if globalState.route == "/capsule/seal" {
                    SealCapsuleView().environmentObject(globalState)
                }
            }
            .onAppear {
                globalState.reload()
            }
        }
    }
}

struct BackgroundImageView: View {
    var body: some View {
        Image("Grains")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct ColorImageView: View {
    var body: some View {
        Image("grains-color")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct BackButton: View {
    var action: () -> Void;
    
    var body: some View {
        Button (action: action){
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
        }.position(x: 25, y: 50)
    }
}
