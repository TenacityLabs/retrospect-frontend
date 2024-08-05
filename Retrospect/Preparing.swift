//
//  Preparing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import SwiftUI

struct Preparing: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var pulsate = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                Text("You're all set!")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                
                Spacer()
                
                Image("box")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .white, radius: 60, x: 0, y: 0)
                    .padding()
                    .scaleEffect(pulsate ? 1.05 : 0.95)
                    .shadow(color: .black, radius: pulsate ? 20 : 10, x: 0, y: 0)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true)
                        ) {
                            pulsate.toggle()
                        }
                    }
                    .frame(width: geometry.size.width - 120)
                    .frame(maxWidth: .infinity, alignment: .center)
            
                Spacer()
            
                Text("Preparing your vessel...")
                    .font(.custom("Syne-Regular", size: 24))
                    .foregroundColor(.white)
                    .padding(.bottom, 80)
            
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            let body: [String: Any] = ["vessel": globalState.localCapsule.vessel, "public": globalState.localCapsule.collab]
                CapsuleAPIClient.shared.create(
                    authorization: globalState.jwt,
                mediaType: .capsule,
                body: body)
                { result in
                    switch result {
                        case .success(let result):
                            CapsuleAPIClient.shared.getCapsuleById(
                                authorization: globalState.jwt,
                            id: result.id)
                            { result in
                                switch result {
                                    case .success(let capsule):
                                    globalState.focusCapsule = capsule
                                    let capsuleName = globalState.localCapsule.name
                                        CapsuleAPIClient.shared.nameCapsule(
                                            authorization: globalState.jwt,
                                        capsuleId: capsule.capsule.id,
                                        name: capsuleName)
                                        { nameResult in
                                            switch nameResult {
                                                case .success(_):
                                                    DispatchQueue.main.async {
                                                        globalState.focusCapsule?.capsule.name = capsuleName
                                                        globalState.route = "/capsule/photo-select"
                                                    }
                                                    break
                                                case .failure(_):
                                                    break
                                            }
                                        }
                                    case .failure(let error):
                                        print("ERR AT POINT B")
                                        print(error)
                                }
                            }
                        case .failure(let error):
                            print("ERR AT POINT A")
                            print(error)
                    }
                }
        }
    }
}

#Preview {
    ZStack {
        ColorImageView()
        Preparing()
    }
}
