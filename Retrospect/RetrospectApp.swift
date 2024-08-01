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

struct APIBaseCapsule: Codable {
    var id: UInt
    var code: String
    var createdAt: String
    var `public`: Bool
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
    var dateToOpen: String?
    var emailSent: Bool
    var sealed: String
}

struct APISong: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var spotifyId: String
    var name: String
    var artistName: String
    var albumArtURL: String
    var createdAt: String
}

struct APIQuestionAnswer: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var prompt: String
    var answer: String
    var createdAt: String
}

struct APIWriting: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var writing: String
    var createdAt: String
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

struct APIMiscFile: Codable {
    var id: UInt
    var userId: UInt
    var capsuleId: UInt
    var objectName: String
    var fileURL: String
    var createdAt: String
}

struct APICapsule: Codable {
    var capsule: APIBaseCapsule
    var song: [APISong]
    var questionAnswers: [APIQuestionAnswer]
    var writings: [APIWriting]
    var photos: [APIPhoto]
    var audios: [APIAudio]
    var doodles: [APIDoodle]
    var miscFiles: [APIMiscFile]
}

struct LocalCapsule {
    var vessel: String
    var name: String
    var collab: Bool
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
    @Published var localCapsule: LocalCapsule = LocalCapsule(vessel: "box", name: "Jessica's Capsule", collab: false)
    
    init() {
        self.jwt = UserDefaults.standard.string(forKey: "jwt") ?? ""
        self.userCapsules = []
        self.reload()
    }
    
    func reload() {
        self.jwt = UserDefaults.standard.string(forKey: "jwt") ?? ""
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
        if self.user != nil {
            if(!self.isJWTExpired()){
                UserAPIClient.shared.getUser(authorization: self.jwt){ userResult in
                       DispatchQueue.main.async {
                           switch(userResult) {
                           case .success (let user):
                               print("c")
                               CapsuleAPIClient.shared.getCapsules(authorization: self.jwt)
                               { capsuleResult in
                                   DispatchQueue.main.async {
                                       switch(capsuleResult) {
                                       case .success (let capsuleArray):
                                           print("d")
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
