//
//  SendOff.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-10-06.
//

import SwiftUI

struct SendOff: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var members: [(username: String, userSealed: Bool)] = []
    @State private var containers = ["box", "Suitcase", "Guitar", "Jar", "Shoe"]
    @State private var collaboratorsAdded: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Image(globalState.focusCapsule?.capsule.vessel ?? "box")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Spacer()
                    .frame(width: 30)
                
                Text(globalState.focusCapsule?.capsule.name ?? "Your Capsule")
                    .font(.custom("IvyOraDisplay-RegularItalic", size: 56))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(height: 80)
            
            Text("Capsule Status")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Syne", size: 24))
                .foregroundColor(.white)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom, 15)
            
            
            ForEach(members, id: \.username) { member in
                HStack {
                    Image("Vinyl")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(1000)

                    Spacer().frame(width: 20)
                    
                    Text(member.username)
                        .foregroundColor(.white)
                        .font(.custom("Public Sans", size: 16))
                    
                    Spacer()
                    
                    Text(member.userSealed ? "Sent" : "Not Sent")
                        .foregroundColor(member.userSealed ? Color(red: 0.09, green: 0.75, blue: 0.47) : Color(red: 0.8, green: 0.64, blue: 0.05))
                        .padding(12)
                        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                        .cornerRadius(1000)
                    
                    Spacer().frame(width: 20)
                    
                    Image("VDots")
                }
            }
            
            if (collaboratorsAdded == 0) {
                Text("You have no collaborators on your capsule :(")
                    .foregroundStyle(.white)
                    .font(.custom("Public Sans", size: 20))
                    .multilineTextAlignment(.center)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.top, 15)
            
            HStack {
                Text("\(collaboratorsAdded)/5 Collaborators Added")
                    .foregroundColor(.white)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 20, weight: .regular))
                }
            }
            .padding(.top, 20)
            
            Text("All collaborators must be ready to seal the capsule.")
                .font(.custom("Public Sans", size: 12))
                .foregroundColor(.white)
                .padding(.vertical, 20)
            
            HStack {
                Text("Seal my capsule")
                    .font(Font.custom("Syne", size: 18).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 62, maxHeight: 62, alignment: .center)
            .background(Color(red: 0.25, green: 0.25, blue: 0.25))
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .inset(by: 0.5)
                    .stroke(.white.opacity(0.4), lineWidth: 1)
            )
        }
        .padding(20)
        .onAppear {
            fetchCapsuleMembers()
        }
    }
    
    // Fetch capsule members and count collaborators
    func fetchCapsuleMembers() {
        guard let capsule = globalState.focusCapsule?.capsule else { return }
        
        // Count the number of non-zero member IDs
        let collaborators = [
            capsule.capsuleMember1Id,
            capsule.capsuleMember2Id,
            capsule.capsuleMember3Id,
            capsule.capsuleMember4Id,
            capsule.capsuleMember5Id
        ].filter { $0 != 0 }
        collaboratorsAdded = collaborators.count
        
        
        for (index, collaborator) in collaborators.enumerated() {
            let userSealed: Bool
            switch index {
            case 0:
                userSealed = capsule.capsuleMember1Id != 0
            case 1:
                userSealed = capsule.capsuleMember2Id != 0
            case 2:
                userSealed = capsule.capsuleMember3Id != 0
            case 3:
                userSealed = capsule.capsuleMember4Id != 0
            case 4:
                userSealed = capsule.capsuleMember5Id != 0
            default:
                userSealed = false
            }
            UserAPIClient.shared.getUserName(authorization: globalState.jwt, id: collaborator) { result in
                switch result {
                case .success(let userResponse):
                    let username = userResponse.name
                    self.members.append((username: username, userSealed: userSealed))
                case .failure(let error):
                    print("Error fetching user info for collaborator \(collaborator): \(error)")
                }
            }
        }
    }
}


#Preview {
    ZStack {
        BackgroundImageView()
        SendOff().environmentObject(GlobalState())
    }
}
