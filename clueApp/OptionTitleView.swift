//
//  ContentView.swift
//  page1
//
//  Created by Hissah Alohali on 06/04/1447 AH.
//

import SwiftUI

struct OptionTitleView: View {
    @State private var selectedOption: Int? = nil
    @State private var optionTitle: String = ""
    let clueRed = UIColor(named: "red")!
    let cluePeach = UIColor(named: "peach")!
    let cluePink = UIColor(named: "pink")!
    let clueYellow = UIColor(named: "yellow")!
    let clueLightYellow = UIColor(named: "lightYellow")!
    var optionNumber = 1
    var body: some View {
        ZStack{
            Color(clueLightYellow).ignoresSafeArea()
            VStack(spacing: 40){
                
                
                HStack{
                    Button("Back") {
                        // Handle back action
                    }
                    .foregroundColor(Color("red"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    
                    Spacer()
                    
                    Button("Next") {
                        // Handle next action
                    }
                    .foregroundColor(Color("red"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                //.padding(.horizontal)
                .padding(.top, 5)
                .frame(maxWidth:.infinity, maxHeight: 1, alignment: .top)
                
                //Spacer()
                .padding(.bottom, 30)
                Text("Option \(optionNumber)")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)
                
                TextField("Option title", text: $optionTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.6)) // very transparent
                    .clipShape(Capsule()) // makes it elliptical
                    .foregroundColor(Color("red")) // text color
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1))
                    .frame(width:282, height:36)
                
                
                Spacer()
                condensedCards()
            }
            .padding()
        }
    }
    
}
#Preview {
    OptionTitleView()
}
