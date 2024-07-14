//
//  Preparing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-13.
//

import SwiftUI

struct Preparing: View {
    @Binding var state: String
    @EnvironmentObject var dataStore: Capsule
    @State private var pulsate = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                Text("You're all set!")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                
                Spacer()
                
                Image("Box")
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
            CapsuleAPIClient.shared.createCapsule(
                authorization: jwt,
                vessel: dataStore.container ?? "Box",
                public: dataStore.collab ?? false)
            { result in
                switch result {
                case .success(let capsule):
                    CapsuleAPIClient.shared.getCapsuleById(
                        authorization: jwt,
                        id: capsule.capsuleId)
                    { result in
                        switch result {
                        case .success(let capsule):
                            currentCapsule = capsule
                            print("Success")
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
