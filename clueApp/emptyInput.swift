//
//  emptyInput.swift
//  clueApp
//
//  Created by Wed Ahmed Alasiri on 11/04/1447 AH.
//

import SwiftUI

struct emptyInput: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var goHome = false   // ✅ navigation trigger

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255/255, green: 236/255, blue: 167/255),
                    Color(red: 1.0, green: 0.97, blue: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("No data entered")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)

                // ✅ Show winning option label
                if let winner = viewModel.winningOption() {
                    Text(winner.label)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }

            // ✅ Hidden NavigationLink back to Home
            NavigationLink(destination: Home().environmentObject(viewModel),
                           isActive: $goHome) {
                EmptyView()
            }
            .hidden()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.reset()   // clear all option data
                    goHome = true       // trigger navigation back to Home
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        emptyInput()
            .environmentObject(OptionsViewModel())
    }
}
