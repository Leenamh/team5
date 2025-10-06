//
//  ShakePage1.swift
//  clueApp
//

import SwiftUI

struct ShakePage1: View {
    @EnvironmentObject var viewModel: OptionsViewModel   // ✅ shared state
    @State private var currentPair: Int = 0              // track which pair of hearts is visible

    @State private var goToHome = false
    @State private var goToNext = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { geo in
                ZStack {
                    // left heart
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        TextField("Option", text: Binding(
                            get: { viewModel.options.indices.contains(currentPair * 2) ? viewModel.options[currentPair * 2] : "" },
                            set: { newValue in
                                if viewModel.options.indices.contains(currentPair * 2) {
                                    viewModel.options[currentPair * 2] = newValue
                                } else {
                                    viewModel.options.append(newValue)
                                }
                            }
                        ))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .foregroundColor(.red)
                        .font(.custom("AvenirNextRounded-Bold", size: 16))
                        .background(Color.clear)
                        .disableAutocorrection(true)
                        .tint(Color("red")) // 👈 لون المؤشر (cursor)
                    }
                    .position(x: geo.size.width * 0.3, y:90)

                    // right heart
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        TextField("Option", text: Binding(
                            get: { viewModel.options.indices.contains(currentPair * 2 + 1) ? viewModel.options[currentPair * 2 + 1] : "" },
                            set: { newValue in
                                if viewModel.options.indices.contains(currentPair * 2 + 1) {
                                    viewModel.options[currentPair * 2 + 1] = newValue
                                } else {
                                    viewModel.options.append(newValue)
                                }
                            }
                        ))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .foregroundColor(.red)
                        .font(.custom("AvenirNextRounded-Bold", size: 16))
                        .background(Color.clear)
                        .disableAutocorrection(true)
                        .tint(Color("red")) // 👈 لون المؤشر (cursor)
                    }
                    .position(x: geo.size.width * 0.7, y:90)

                    // add more button
                    Button(action: {
                        currentPair += 1
                        if viewModel.options.count < (currentPair + 1) * 2 {
                            viewModel.options.append(contentsOf: ["", ""]) // add 2 new slots
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("pink"))
                    }
                    .position(x: geo.size.width / 2, y: 190)

                    // jar image
                    Image("EmptyJarOpen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 430, height: 430)
                        .position(x: geo.size.width / 2, y: geo.size.height - 250)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { goToHome = true }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { goToNext = true }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
            }
        }
        .navigationDestination(isPresented: $goToHome) { Home() }
        .navigationDestination(isPresented: $goToNext) {
            Shaking(options: viewModel.options.filter { !$0.isEmpty }) // send non-empty options
                .environmentObject(viewModel) // ✅ keep sharing
        }
        .onAppear {
            // ✅ make sure at least 2 slots exist
            if viewModel.options.count < 2 {
                viewModel.options = ["", ""]
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShakePage1()
            .environmentObject(OptionsViewModel()) // ✅ preview with shared model
    }
}
