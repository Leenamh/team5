//
//  DecisionPageView.swift
//  clueApp
//
//  Created by Wed Ahmed Alasiri on 10/04/1447 AH.
//


//
// // perfer.swift
// // perfer1
//
//  //Created by Wed Ahmed Alasiri on 09/04/1447 AH.
//
//



import SwiftUI

struct DecisionPageView: View {
    @State private var selectedOption: String? = nil
    @State private var selectedOptionUser: String? = nil
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255/255, green: 236/255, blue:167/255),//Color(red: 1.0, green: 0.95, blue: 0.75)
                    Color(red: 1.0, green: 0.97, blue: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // Title
                Spacer()
                Spacer()
                HStack(spacing: 0) {
                   
                    Text("What")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.45)) // pink
                    Text(" Do you prefer?")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.45))
                }
                
                ZStack {
                    //  OR text
                    Text("OR")
                    
                        .font(.system(size: 100, weight: .bold)) // حجم أكبر و Bold
                        .foregroundColor(Color(red: 254/255, green: 93/255, blue: 91/255)) // FE5D5B
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2) // ظل خفيف
                        .opacity(0.9) // شفافية بسيطة
                    
                
                        .offset(x: -140, y: 20)
                    
                    
                    
                    
                    VStack(spacing: 30) {
                        Spacer()
                        
                        //  Pink Option
                        OptionBox(
                            text: "pink pink pink pink  \n  pink pink pink ",
                            color: Color(red: 1.0, green: 0.45, blue: 0.45),
                            isSelected: selectedOption ==  "pink"  // selectedOptionUser
                        )
                        .onTapGesture {
                            selectedOption =  "pink" // selectedOptionUser
                        }
                        
                        // Blue Option
                        OptionBox(
                            text: "blue blue blue blue\nblue blue blue blue blue",
                            color: Color(red: 1.0, green: 0.45, blue: 0.45),//
                            isSelected: selectedOption == "blue"
                        )
                        .onTapGesture {
                            selectedOption = "blue"
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                
                
                
                
                
                
                
                
                
                //  Next button
                Button(action: {
                    print("Selected:", selectedOption ?? "None")
                }) {
                    Text("Next")
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.45))
                        .font(.system(size: 20, weight: .medium))
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

// MARK: - Option Box
struct OptionBox: View {
    let text: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .multilineTextAlignment(.center)
            .foregroundColor(color)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color(red: 254/255, green: 93/255, blue: 91/255) : Color.clear, lineWidth: 3)
            )
            .padding(.horizontal, 40)
    }
}

#Preview {
    DecisionPageView()
}

