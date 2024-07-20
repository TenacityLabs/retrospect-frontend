//
//  Preparing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import SwiftUI

struct Preparing: View {
    @Binding var state: String
    @EnvironmentObject var localCapsule: Capsule
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
            let body: [String: Any] = ["vessel": vessel, "public": collab]
            CapsuleAPIClient.shared.create(
                authorization: jwt,
                mediaType: .capsule,
                body: body)
            { result in
                switch result {
                case .success(let result):
                    capsuleID = result.id
                    CapsuleAPIClient.shared.getCapsuleById(
                        authorization: jwt,
                        id: result.id)
                    { result in
                        switch result {
                        case .success(let capsule):
                            backendCapsule = capsule
                            state = "PhotoSelect"
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        
        
    }
}

#Preview {
    ZStack {
        ColorImageView()
        Preparing(state: .constant(""))
    }
}
