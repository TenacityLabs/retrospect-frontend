//
//  OpenTextPrompt.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import SwiftUI

struct OpenTextData: View {
    @State private var questionAnswers: [QuestionAnswer] = [
        QuestionAnswer(id: 1, prompt: "What is the capital of France?", answer: "The capital of France is Paris."),
        QuestionAnswer(id: 2, prompt: "How does photosynthesis work?", answer: "Photosynthesis is the process by which plants use sunlight to synthesize foods from carbon dioxide and water. It involves the green pigment chlorophyll and generates oxygen as a by-product."),
        QuestionAnswer(id: 3, prompt: "What is the meaning of life?", answer: "The meaning of life is a philosophical question that has been explored by many thinkers. Some believe it's about finding purpose and happiness, while others look for deeper, existential meanings."),
        QuestionAnswer(id: 4, prompt: "What are the benefits of regular exercise?", answer: "Regular exercise improves cardiovascular health, strengthens muscles and bones, boosts mood and mental health, and can help manage weight."),
        QuestionAnswer(id: 5, prompt: "Can you explain the concept of artificial intelligence?", answer: "Artificial intelligence (AI) refers to the simulation of human intelligence in machines that are programmed to think and learn like humans. AI can be used in a variety of applications, from voice assistants to self-driving cars."),
        QuestionAnswer(id: 6, prompt: "What is the significance of the theory of relativity?", answer: "The theory of relativity, proposed by Albert Einstein, revolutionized our understanding of space, time, and gravity. It explains how objects move through space and how gravity affects the fabric of space-time."),
        QuestionAnswer(id: 7, prompt: "What are the main causes of climate change?", answer: "The main causes of climate change are human activities such as deforestation, burning fossil fuels for energy, and industrial processes, all of which increase the concentration of greenhouse gases in the atmosphere.")
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("We asked & you answered")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                Spacer()
                ZStack {
                    ForEach(0..<min(3, questionAnswers.count - currentIndex), id: \.self) { index in
                        let reversedIndex = currentIndex + min(3, questionAnswers.count - currentIndex) - index - 1
                        if reversedIndex < questionAnswers.count {
                            CardView(questionAnswer: questionAnswers[reversedIndex],
                                     index: reversedIndex,
                                     currentIndex: $currentIndex,
                                     lastIndex: questionAnswers.count)
                                .frame(width: geometry.size.width - 40)
                                .offset(x: 0, y: 0)
                                .animation(.spring(), value: currentIndex)
                        }
                    }
                }
                Spacer()
                Text("Swipe for the next card, tap to flip!")
                    .foregroundColor(.white)
                    .font(.custom("Syne-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .frame(width: geometry.size.width * 0.7)
                Spacer()
                Button(action: {}) {
                    Text("Thank You, Next!")
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 30)
                .padding(.bottom, 5)
                Spacer() 
            }
        }
        .padding()
    }
}

struct CardView: View {
    var questionAnswer: QuestionAnswer
    var index: Int
    @Binding var currentIndex: Int
    var lastIndex: Int
    @State private var offset = CGSize.zero
    @State private var flipped = false
    @State private var angle = 0.0
    
    var body: some View {
        ZStack {
            FrontView(questionAnswer: questionAnswer, flipAction: flipCard)
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            
            BackView(questionAnswer: questionAnswer, flipAction: flipCard)
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(angle + 180), axis: (x: 0, y: 1, z: 0))
        }
        .offset(x: offset.width, y: offset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if (index == currentIndex){
                        offset = value.translation
                    }
                    else {
                        offset = .zero
                    }
                }
                .onEnded { value in
                    if abs(value.translation.width) > 100 {
                        if value.translation.width > 0 {
                            swipeRight()
                        } else {
                            swipeLeft()
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            flipCard()
        }
    }
    
    private func swipeRight() {
        if (index == currentIndex){
            withAnimation {
                if(currentIndex > 0){
                    currentIndex -= 1
                }
                offset = .zero
            }
        }
        if(flipped){
            angle += 180
            flipped.toggle()
        }
    }
    
    private func swipeLeft() {
        if (index == currentIndex){
            withAnimation {
                if(currentIndex + 1 < lastIndex){
                    currentIndex += 1
                }
                offset = .zero
            }
        }
        if(flipped){
            angle += 180
            flipped.toggle()
        }
    }
    
    private func flipCard() {
        if (index == currentIndex){
            withAnimation(.easeInOut(duration: 0.8)) {
                angle += 180
                flipped.toggle()
            }
        }
    }
}

struct FrontView: View {
    var questionAnswer: QuestionAnswer
    var flipAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack (alignment: .top) {
                Text("We asked you")
                    .font(.custom("Syne-Regular", size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .bold()
                Spacer()
                Button(action: {
                    flipAction()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.custom("Syne-Regular", size: 16))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            Spacer().frame(height: 30)
            VStack {
                Text(questionAnswer.prompt)
                    .font(.custom("Syne-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 15)
            Spacer().frame(height: 60)
        }
        .frame(width: 325)
        .background(Color(UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1)))
        .border(Color.black, width: 2)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }
}

struct BackView: View {
    var questionAnswer: QuestionAnswer
    var flipAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack (alignment: .top) {
                Text("You answered")
                    .font(.custom("Syne-Regular", size: 20))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .bold()
                Spacer()
                Button(action: {
                    flipAction()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.custom("Syne-Regular", size: 16))
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            Spacer().frame(height: 30)
            VStack {
                Text(questionAnswer.answer)
                    .font(.custom("Syne-Regular", size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 15)
            Spacer().frame(height: 60)
        }
        .frame(width: 325)
        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
        .border(Color.black, width: 2)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ZStack {
        ColorImageView()
        OpenTextData()
    }
}
