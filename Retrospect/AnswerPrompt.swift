//
//  AnswerPrompt.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-14.
//

import SwiftUI

// FIXME: Fix styling, delete text kind of buggy, plus button wrong shape, prompt generation, prompt changing
struct AnswerPrompt: View {
    @EnvironmentObject var localCapsule: Capsule
    @State private var selectedIndex: Int = 0
    @Binding var state: String
    
    var body: some View {
         VStack {
             Text("Let's get personal!")
                 .font(.custom("IvyOra Display", size: 48))
                 .foregroundColor(.white)
                 .padding(.top, 80)
             
             
             TabView(selection: $selectedIndex) {
                 ForEach(localCapsule.prompts.indices, id: \.self) { index in
                     GeometryReader { geometry in
                         VStack {
                             VStack {
                                 Text(localCapsule.prompts[index].prompt)
                                     .font(.custom("Syne-Regular", size: 18))
                                     .fontWeight(.bold)
                                     .foregroundColor(.white)
                                     .padding(.horizontal, 20)
                                 
                                 Spacer()
                                     .frame(height: 30)
                                 
                                 HStack {
                                     TextField("", text: $localCapsule.prompts[index].response)
                                         .frame(height: 45)
                                         .padding(.horizontal, 20)
                                         .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                                         .cornerRadius(50)
                                         .foregroundColor(.white)
                                         .overlay(
                                             RoundedRectangle(cornerRadius: 50)
                                                 .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                         )
                                 }
                                 .padding(.horizontal, 20)
                             }
                             .frame(width: geometry.size.width - 60, height: 160)
                             .padding()
                             .background(Color(red: 30/255, green: 30/255, blue: 30/255).opacity(0.9))
                             .cornerRadius(20)
                             .overlay(
                             RoundedRectangle(cornerRadius: 20)
                             .inset(by: 0.5)
                             .stroke(Color.white.opacity(0.2), lineWidth: 1)
                             )
                         }
                         .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                     }
                 }
                 
                 if localCapsule.prompts.count < 3 {
                     VStack {
                         Button(action: {
                             let newPrompt = Prompt(prompt: "What item would you bring to a deserted island?", response: "")
                             localCapsule.prompts.append(newPrompt)
                             selectedIndex = localCapsule.prompts.count - 1
                         }) {
                             VStack {
                                 Image(systemName: "plus")
                                     .resizable()
                                     .foregroundColor(.white)
                                     .frame(width: 30, height: 30)
                             }
                             .frame(width: 200, height: 200)
                             .background(Color(red: 30/255, green: 30/255, blue: 30/255).opacity(0.9))
                             .cornerRadius(15)
                             .overlay(
                             RoundedRectangle(cornerRadius: 20)
                             .inset(by: 0.5)
                             .stroke(Color.white.opacity(0.2), lineWidth: 1)
                             )
                             .padding(.horizontal, 20)
                         }
                     }
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .tag(localCapsule.prompts.count)
                 }
             }
             .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
             .frame(height: 400)
             
             HStack {
                 ForEach(0..<localCapsule.prompts.count + (localCapsule.prompts.count < 3 ? 1 : 0), id: \.self) { index in
                     Circle()
                         .fill(index == selectedIndex ? Color.white : Color.gray)
                         .frame(width: 8, height: 8)
                         .animation(.easeInOut, value: selectedIndex)
                 }
             }
             .padding(.top, 10)
             
             Button(action: {
                 if localCapsule.prompts.count > 1 && selectedIndex < localCapsule.prompts.count {
                     localCapsule.prompts.remove(at: selectedIndex)
                     if selectedIndex != 0 {
                         selectedIndex -= 1
                     }
                 }
             }) {
                 Text("Delete Text")
                     .foregroundColor(.black)
                     .padding()
                     .frame(width: 300)
                     .background(Color.white)
                     .cornerRadius(25)
                     .overlay(
                         RoundedRectangle(cornerRadius: 25)
                             .stroke(Color.black, lineWidth: 1)
                     )
             }
             .padding(.horizontal, 20)
             .padding(.top, 10)
             .opacity(localCapsule.prompts.count <= 1 || selectedIndex == localCapsule.prompts.count ? 0.5 : 1.0)
             .disabled(localCapsule.prompts.count <= 1 || selectedIndex == localCapsule.prompts.count)
             
             Button(action: {
                 state = "AdditionalGoodies"
             }) {
                 Text("I'm Done!")
                     .foregroundColor(.black)
                     .padding()
                     .frame(width: 300)
                     .background(Color.white)
                     .cornerRadius(25)
                     .overlay(
                         RoundedRectangle(cornerRadius: 25)
                             .stroke(Color.black, lineWidth: 1)
                     )
             }
         }
         .onAppear {
             if localCapsule.prompts.isEmpty {
                 let newPrompt = Prompt(prompt: "What item would you bring to a deserted island?", response: "")
                 localCapsule.prompts.append(newPrompt)
             }
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
     }
}

#Preview {
    ZStack {
        BackgroundImageView()
        AnswerPrompt(state: .constant(""))
            .environmentObject(Capsule())
    }
}
