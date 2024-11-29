//
//  Dashboard.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-26.
//

import SwiftUI

struct Dashboard: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var containers = ["box", "suitcase", "guitar", "jar", "shoe"]
    
    var body: some View {
        let capsules = globalState.userCapsules 
        if capsules.count <= 0 {
            EmptyDashboard(globalState: globalState)
        } else {
            let capsules: [APIBaseCapsule] = generateSampleCapsules()
            let columns: [GridItem] = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
            
            GeometryReader { geometry in
                VStack {
                    Text("Capsule Cabinet")
                        .font(.custom("IvyOraDisplay-Regular", size: 48))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    Spacer()
                        .frame(height: 60)
                    
                    HStack {
                        Text("Capsules you own")
                            .font(.custom("Syne-Bold", size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("3/5 spaces filled")
                            .font(.custom("Syne-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                    .frame(width: (geometry.size.width - 60))
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            HStack {
                                Button(action: {
                                    globalState.localCapsule = LocalCapsule(vessel: "box", name: "", collab: false, openDate: Date())
                                    globalState.route = "/capsule/icon-select"
                                }) {
                                    VStack {
                                        Spacer()
                                        
                                        Image("emptybox")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 80)
                                            .shadow(color: .white, radius: 60, x: 0, y: 0)
                                        
                                        Text("Create a capsule")
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center
                                            )
                                            .font(.custom("Syne-Bold", size: 18))
                                        
                                        Spacer()
                                    }
                                    .frame(width: 120, height: 160)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            
                            ForEach(capsules, id: \.id) { capsule in
                                CapsuleView(capsule: capsule)
                            }
                        }
                        .padding()
                    }
                    .frame(width: (geometry.size.width - 50), height: 340)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .shadow(color: .white.opacity(0.5), radius: 30, x: 0, y: 0)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .navigationTitle("Capsule Grid")
                    
                    
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        Text("Capsules you've contributed to")
                            .font(.custom("Syne-Bold", size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .frame(width: (geometry.size.width - 60))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 40) {
                            ForEach(capsules, id: \.id) { capsule in
                                CapsuleView(capsule: capsule)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: (geometry.size.width - 50), height: 180)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .shadow(color: .white.opacity(0.5), radius: 30, x: 0, y: 0)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct EmptyDashboard: View {
    var globalState: GlobalState
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Capsule Cabinet")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                
                Spacer()
                    .frame(height: 100)

                Button(action: {
                    globalState.localCapsule = LocalCapsule(vessel: "box", name: "", collab: false, openDate: Date())
                    globalState.route = "/capsule/icon-select"
                }) {
                    HStack {
                        Spacer()
                        
                        Image("emptybox")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .shadow(color: .white, radius: 60, x: 0, y: 0)
                        
                        Spacer()
                        
                        Text("Create a capsule")
                            .foregroundColor(.black)
                            .font(.custom("Syne-Bold", size: 22))
                        
                        Spacer()
                    }
                    .frame(width: (geometry.size.width - 50), height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                    .frame(height: 20)
                
                VStack {
                    Spacer()
                    
                    Text("It’s empty in here!")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("IvyOraDisplay-RegularItalic", size: 48))
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("Create a capsule to get started")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("IvyOra Display", size: 32))
                        .frame(maxWidth: .infinity)
                        .lineLimit(nil)
                    
                    Spacer()
                }
                .frame(width: (geometry.size.width - 50), height: 200)
                .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                .shadow(color: .white.opacity(0.5), radius: 30, x: 0, y: 0)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CapsuleView: View {
    let capsule: APIBaseCapsule

    var body: some View {
        VStack {
            Spacer()
            
            // Image based on the vessel type
            Image(capsule.vessel)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .shadow(color: .white, radius: 30, x: 0, y: 0)
            
            // Capsule name
            Text(capsule.name)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.custom("Syne-Bold", size: 18))
            
            Spacer()
        }
        .frame(width: 120, height: 160)
    }
}

func generateSampleCapsules() -> [APIBaseCapsule] {
    @State var containers = ["box", "Suitcase", "Guitar", "Jar", "Shoe"]
    return (1...5).map { i in
        APIBaseCapsule(
            id: UInt(i),
            code: "Code\(i)",
            createdAt: "2023-10-27",
            isPublic: true,
            capsuleOwnerId: 1,
            capsuleMember1Id: 2,
            capsuleMember2Id: 3,
            capsuleMember3Id: 4,
            capsuleMember4Id: 5,
            capsuleMember5Id: 6,
            capsuleMember1Sealed: true,
            capsuleMember2Sealed: false,
            capsuleMember3Sealed: true,
            capsuleMember4Sealed: false,
            capsuleMember5Sealed: true,
            vessel: containers[i % 4], // Cycle through vessel0 to vessel4
            name: "Capsule \(i)",
            dateToOpen: nil,
            emailSent: false,
            sealed: "No"
        )
    }
}


#Preview {
    ZStack {
        BackgroundImageView()
        Dashboard().environmentObject(GlobalState())
    }
}
