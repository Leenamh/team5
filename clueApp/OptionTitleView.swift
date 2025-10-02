import SwiftUI

struct OptionTitleView: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var optionTitle: String = ""
    @State private var goToDecisionPage = false

    let clueLightYellow = UIColor(named: "lightYellow") ?? UIColor(red: 1, green: 0.925, blue: 0.655, alpha: 1)

    var body: some View {
        ZStack {
            Color(clueLightYellow).ignoresSafeArea()

            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Button("Next") {
                        saveAndAdvance()
                    }
                    .disabled(optionTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(Color("red"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                .padding(.top, 5)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, maxHeight: 1, alignment: .top)

                Text("Option \(viewModel.currentOptionNumber)")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)

                TextField("Option title", text: $optionTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.6))
                    .clipShape(Capsule())
                    .foregroundColor(Color("red"))
                    .overlay(Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1))
                    .frame(width: 282, height: 36)

                Spacer()
                condensedCards()

                NavigationLink(destination: Card(), isActive: $goToDecisionPage) {
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
                optionTitle = viewModel.titleForCurrent()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func saveAndAdvance() {
        let trimmed = optionTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updateCurrentTitle(trimmed)

        if viewModel.goToNextOption() {
            optionTitle = viewModel.titleForCurrent()
        } else {
            goToDecisionPage = true
        }
    }
}

#Preview {
    NavigationStack {
        OptionTitleView()
            .environmentObject(OptionsViewModel())
    }
}
