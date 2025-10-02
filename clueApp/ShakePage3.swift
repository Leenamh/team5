//
//  ShakePage3.swift
//  clueApp
//

import SwiftUI

struct ShakePage3: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var option1: String
    @State private var goToHome = false

    init(result: String) {
        _option1 = State(initialValue: result)
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)

                        Text(option1)
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                            .foregroundColor(Color("red"))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .offset(y: -40)
                }
                Image("fullJarOpen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 430, height: 430)
                    .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.reset()   // ✅ clear all options globally
                    goToHome = true
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }
        }
        .navigationDestination(isPresented: $goToHome) {
            Home()
        }
    }
}

#Preview {
    NavigationStack {
        ShakePage3(result: "Test Result")
            .environmentObject(OptionsViewModel())  // ✅ preview with shared model
    }
}
