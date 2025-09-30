//
//  NumOtionsView.swift
//  clueApp
//
//  Created by Hissah Alohali on 08/04/1447 AH.
//


//
//  SwiftUIView.swift
//  page1
//
//  Created by Hissah Alohali on 08/04/1447 AH.
//

import SwiftUI

struct NumOtionsView: View {
    @State private var selectedOption: Int? = nil
    let clueRed = UIColor(named: "red")!
    let cluePeach = UIColor(named: "peach")!
    let cluePink = UIColor(named: "pink")!
    let clueYellow = UIColor(named: "yellow")!
    let clueLightYellow = UIColor(named: "lightYellow")!

    var body: some View {
        ZStack{
            Color(clueLightYellow).ignoresSafeArea()
            VStack(spacing: 40){
                
                
                HStack{
                    Button("Back") {
                        // Handle back action
                    }
                    .foregroundColor(Color(clueRed))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    
                    Spacer()
                    
                    Button("Next") {
                        // Handle next action
                    }
                    .foregroundColor(Color(clueRed))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                //.padding(.horizontal)
                .padding(.top, 5)
                .frame(maxWidth:.infinity, maxHeight: 1, alignment: .top)
                
                //Spacer()
                .padding(.bottom, 50)
                Text("How many options\ndo you have?")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color(clueRed))
                    .multilineTextAlignment(.center)
                
                
                HStack(spacing: 24) {
                    ForEach(1...4, id: \.self) { number in
                        Button(action: {
                            selectedOption = number
                        }) {
                            Text("\(number)")
                                .font(.system(size: 36, weight: .regular, design: .rounded))
                                .fontWeight(.bold)
                                .frame(width: 60, height: 60)
                                .background(circleColor(for: number))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedOption == number ? Color.white : Color.clear, lineWidth: 5)
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
        }
        
    }
    private func circleColor(for number: Int) -> Color {
            switch number {
            case 1: return Color(clueRed)
            case 2: return Color(cluePeach)
            case 3: return Color(cluePink)
            case 4: return Color(clueYellow)
            default: return Color.gray
            }
        }
    
}
#Preview {
    NumOtionsView()
}
