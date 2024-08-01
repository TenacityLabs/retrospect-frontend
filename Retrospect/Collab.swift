import SwiftUI

struct Collab: View {
    @EnvironmentObject var globalState: GlobalState

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("How do you \n want to create \n this capsule?")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                
                Spacer()
                
                Button(action: {
                    globalState.localCapsule.collab = false
                }) {
                    VStack {
                        if (globalState.localCapsule.collab == false) {
                            Image("Union")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                        } else {
                            Image("Union")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .opacity(0.5)
                        }
                        
                        Text("I'm Creating Solo")
                            .font(.custom("Syne-Regular", size: 24))
                            .padding(.top, 10)
                            .foregroundColor(.white)
                            .opacity(globalState.focusCapsule?.capsule.public == true ? 0.5 : 1)
                    }
                    .padding()
                    .frame(width: (geometry.size.width - 60),  height: 210)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .cornerRadius(10)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.bottom, 10)

                Button(action: {
                    globalState.localCapsule.collab = true
                }) {
                    VStack {
                        if (globalState.localCapsule.collab == true) {
                            Image("Group")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                        } else {
                            Image("Group")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.5)
                                .frame(height: 100)
                        }
                        
                        Text("I'm Creating \n Collaboratively")
                            .font(.custom("Syne-Regular", size: 24))
                            .padding(.top, 10)
                            .foregroundColor(.white)
                            .opacity(globalState.focusCapsule?.capsule.public == true ? 1 : 0.5)
                    }
                    .padding()
                    .frame(width: (geometry.size.width - 60), height: 210)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .cornerRadius(10)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    globalState.route = "/capsule/preparing"
                }) {
                    Text("I'm Ready to Go!")
                        .font(.custom("Syne-Regular", size: 18))
                        .foregroundColor(Color.black)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 30)
                .padding(.bottom, 60)
            }
        }
    }
    
}

#Preview {
        ZStack {
            BackgroundImageView()
            Collab()
        }
    
}
