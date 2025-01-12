import SwiftUI

struct Dashboard: View {
    @EnvironmentObject var globalState: GlobalState

    // Generate capsules once and store them locally.
    private var capsules: [APIBaseCapsule] {
        globalState.userCapsules
    }

    private var ownedCapsules: [APIBaseCapsule] {
//        guard let user = globalState.user else { return [] }
        return capsules.filter { $0.capsuleOwnerId == 1 }
    }

    private var contributedCapsules: [APIBaseCapsule] {
        guard let user = globalState.user else { return [] }
        return capsules.filter { $0.capsuleOwnerId != user.id }
    }

    var body: some View {
        if ownedCapsules.isEmpty {
            // If no capsules are owned, show the empty dashboard
            EmptyDashboard(globalState: globalState)
        } else {
            GeometryReader { geometry in
                VStack {
                    Text("Capsule Cabinet")
                        .font(.custom("IvyOraDisplay-Regular", size: 48))
                        .foregroundColor(.white)
                        .padding(.top, 80)

                    Spacer().frame(height: 60)

                    HStack {
                        Text("Capsules you own")
                            .font(.custom("Syne-Bold", size: 16))
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(ownedCapsules.count)/5 spaces filled")
                            .font(.custom("Syne-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                    .frame(width: geometry.size.width - 60)

                    ScrollView {
                        // Two columns for owned capsules
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            if (ownedCapsules.count < 5) {
                                HStack {
                                    Button {
                                        globalState.localCapsule = LocalCapsule(vessel: "box", name: "", collab: false, openDate: Date())
                                        globalState.route = "/capsule/icon-select"
                                    } label: {
                                        VStack {
                                            Spacer()
                                            Image("emptybox")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 80)
                                                .shadow(color: .white, radius: 60)
                                            Text("Create a capsule")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .font(.custom("Syne-Bold", size: 18))
                                            Spacer()
                                        }
                                        .frame(width: 120, height: 160)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }

                            ForEach(ownedCapsules, id: \.id) { capsule in
                                CapsuleView(capsule: capsule)
                            }
                        }
                        .padding()
                    }
                    .frame(width: geometry.size.width - 50, height: 340)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .shadow(color: .white.opacity(0.5), radius: 30)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .navigationTitle("Capsule Grid")

                    Spacer().frame(height: 20)

                    HStack {
                        Text("Capsules you've contributed to")
                            .font(.custom("Syne-Bold", size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                    .frame(width: geometry.size.width - 60)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 40) {
                            ForEach(contributedCapsules, id: \.id) { capsule in
                                CapsuleView(capsule: capsule)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: geometry.size.width - 50, height: 180)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .shadow(color: .white.opacity(0.5), radius: 30)
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
                
                Spacer().frame(height: 100)

                Button {
                    globalState.localCapsule = LocalCapsule(vessel: "box", name: "", collab: false, openDate: Date())
                    globalState.route = "/capsule/icon-select"
                } label: {
                    HStack {
                        Spacer()
                        Image("emptybox")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .shadow(color: .white, radius: 60)
                        Spacer()
                        Text("Create a capsule")
                            .foregroundColor(.black)
                            .font(.custom("Syne-Bold", size: 22))
                        Spacer()
                    }
                    .frame(width: geometry.size.width - 50, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer().frame(height: 20)
                
                VStack {
                    Spacer()
                    Text("It’s empty in here!")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("IvyOraDisplay-RegularItalic", size: 48))
                    Spacer().frame(height: 10)
                    Text("Create a capsule to get started")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("IvyOra Display", size: 32))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .frame(width: geometry.size.width - 50, height: 200)
                .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                .shadow(color: .white.opacity(0.5), radius: 30)
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
            Image(capsule.vessel)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .shadow(color: .white, radius: 30)
            Text(capsule.name)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.custom("Syne-Bold", size: 18))
            Spacer()
        }
        .frame(width: 120, height: 160)
    }
}

//func generateSampleCapsules() -> [APIBaseCapsule] {
//    let containers = ["box", "Suitcase", "Guitar", "Jar", "Shoe"]
//    return (1...5).map { i in
//        APIBaseCapsule(
//            id: UInt(i),
//            code: "Code\(i)",
//            createdAt: "2023-10-27",
//            isPublic: true,
//            capsuleOwnerId: 1,
//            capsuleMember1Id: 2,
//            capsuleMember2Id: 3,
//            capsuleMember3Id: 4,
//            capsuleMember4Id: 5,
//            capsuleMember5Id: 6,
//            capsuleMember1Sealed: true,
//            capsuleMember2Sealed: false,
//            capsuleMember3Sealed: true,
//            capsuleMember4Sealed: false,
//            capsuleMember5Sealed: true,
//            vessel: containers[i % 4],
//            name: "Capsule \(i)",
//            dateToOpen: nil,
//            emailSent: false,
//            sealed: "No"
//        )
//    }
//}

#Preview {
    ZStack {
        BackgroundImageView()
        Dashboard().environmentObject(GlobalState())
    }
}
