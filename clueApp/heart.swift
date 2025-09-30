//
//  heart.swift
//  clueApp
//
//  Created by Wed Ahmed Alasiri on 08/04/1447 AH.
//  Created by Wed Ahmed Alasiri on 08/04/1447 AH.
//

import SwiftUI

struct heart: View {
    @State private var selectedOption: Int = 3//when the view first loads, the default selected number is 3   AND SAVE IT IN THE VAR
    @State private var dragValue: Double = 3  // Internal drag control ( posision  of hear when the page start)
    
    var body: some View {
        ZStack {
            //  Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.0),
                    .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.6),
                    .init(color: .white, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            
            
            
            
            VStack {
                Spacer().frame(height: 50)
                
                //  Question
                Text("Is this decision important for your future?")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255)) // 🎨 FF7472
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer().frame(height: 50)
                    .padding(.bottom, 60)
               
                HStack(spacing: 20) {
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    // Numbers on the left
                    VStack(spacing: 40) {
                        ForEach((1...5).reversed(), id: \.self) { num in
                            Text("\(num)")
                                .font(.title2)
                                .foregroundColor(num == selectedOption ? .red : Color(red: 1.0, green: 116/255, blue: 114/255))
                                .fontWeight(num == selectedOption ? .bold : .regular)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    
                    
                    
                    
                    
                    
                    
                    // Track + Heart
                    ZStack {
                        // Track background
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(red: 252/255, green: 241/255, blue: 177/255), location: 0.0), // FBEEAD
                                        .init(color: Color(red: 242/255, green: 163/255, blue: 139/255), location: 1.0)  // F2A38B
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 60, height: 370)
                        
                        //  Heart that moves
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 75, height: 65)
                            .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255)) // FF7472
                            .offset(y: CGFloat((5 - dragValue) * 60 - 120))
                            .animation(.spring(), value: dragValue)
                    }
                    .padding(.bottom, 60)
                    
                    .gesture(
                        DragGesture(minimumDistance: 9)
                            .onChanged { gesture in
                                let height: CGFloat = 300
                                let stepHeight = height / 5
                                let pos = max(0, min(height, height - gesture.location.y))
                                let step = Int((pos / stepHeight).rounded(.toNearestOrAwayFromZero))
                                
                                dragValue = Double(step)
                                selectedOption = max(1, min(5, step)) // clamp between 1–5
                            }
                    )
                }
                
                Spacer()
                
                
                
                
                
                // Next button
                
                Button(action: {
                    print("Selected value: \(selectedOption)")
                }) {
                    Text("Next")
                        .foregroundColor(Color(red: 1.0, green: 0.455, blue: 0.447)) // FF7472
                        .font(.title3)
                        .padding(.bottom, 40)   // distance from bottom
                        .padding(.leading, 290) // distance from right
                }
            }
        }
    }
}

#Preview {
    heart()
}

