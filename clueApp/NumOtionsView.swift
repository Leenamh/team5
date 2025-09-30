//
//  NumOtionsView.swift
//  clueApp
//
//  Created by Hissah Alohali on 08/04/1447 AH.
//

import SwiftUI

struct NumOtionsView: View {
    @State private var selectedOption: Int? = nil
    @State private var goToCard = false   // trigger for Next navigation
    @State private var goToHome = false   // trigger for Back navigation


    var body: some View {
        ZStack {
            Color("BG").ignoresSafeArea()

            VStack(spacing: 40) {
                Text("How many options\ndo you have?")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("red"))
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
        .navigationBarBackButtonHidden(true) // hides default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    goToHome = true
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    goToCard = true
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }
        }
        // Hidden NavigationLink to Card
        .background(
            NavigationLink(destination: Card(), isActive: $goToCard) { EmptyView() }
                .hidden()
        )
        .background(
            NavigationLink(destination: Home(), isActive: $goToHome) { EmptyView() }
                .hidden()
        )
    }

    private func circleColor(for number: Int) -> Color {
        switch number {
        case 1: return Color("red")
        case 2: return Color("peach")
        case 3: return Color("pink")
        case 4: return Color("yellow")
        default: return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        NumOtionsView()
    }
}
