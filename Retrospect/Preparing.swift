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
    @State private var expandBox = false
    
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

//func setupCapsule() async {
//    
//    let body: [String: Any] = ["vessel": vessel, "public": collab]
//    
//    CapsuleAPIClient.shared.create(
//    authorization: jwt,
//    mediaType: .capsule,
//    body: body)
//    { result in
//        
//        switch result {
//            
//            case .success(let result):
//            
//                capsuleID = result.id
//                CapsuleAPIClient.shared.getCapsuleById(
//                authorization: jwt,
//                id: result.id)
//                { result in
//                    
//                    switch result {
//                        
//                        case .success(let capsule):
//                            
//                            backendCapsule = capsule
//                            backendCapsule.capsule.name = capsuleName
//                            CapsuleAPIClient.shared.nameCapsule(
//                            authorization: jwt,
//                            capsuleId: capsule.capsule.id,
//                            name: capsuleName)
//                            { result in
//                                
//                                switch result {
//                                    
//                                    case .success(_):
////                                    state = "PhotoSelect"
//                                        break
//                                    case .failure(_):
//                                        break
//                                }
//                            }
//                        
//                        case .failure(let error):
//                        
//                            print(error)
//                    }
//                }
//            
//            case .failure(let error):
//            
//                print(error)
//            
//        }
//=======
//>>>>>>> 22de1d82dfe6592b88708228d9a72d02a2456695
//    }
//}

#Preview {
    ZStack {
        ColorImageView()
        Preparing()
    }
}
