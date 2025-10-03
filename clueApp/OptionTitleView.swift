import SwiftUI

struct OptionTitleView: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var optionTitle: String = ""
    @State private var goToDecisionPage = false
    @State private var goToNumOptions = false

    let clueLightYellow = UIColor(named: "lightYellow") ?? UIColor(red: 1, green: 0.925, blue: 0.655, alpha: 1)

    var body: some View {
        ZStack {
            Color(clueLightYellow).ignoresSafeArea()

            VStack(spacing: 40) {
                // Title
                Text("Option")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)

                // Input Field
                TextField("Option title", text: $optionTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.6))
                    .clipShape(Capsule())
                    .foregroundColor(Color("red"))
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(width: 282, height: 36)

                Spacer()

                // Decorative stacked cards (like your old style)
                condensedCards()
            }
            .padding()
            .onAppear {
                optionTitle = viewModel.titleForCurrent()
            }

            // ✅ Navigate to Card
            NavigationLink(destination: Card().environmentObject(viewModel), isActive: $goToDecisionPage) {
                EmptyView()
            }
            .hidden()

            // ✅ Navigate back to NumOtionsView
            NavigationLink(destination: NumOtionsView().environmentObject(viewModel), isActive: $goToNumOptions) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    goToNumOptions = true
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }

            // Next button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    saveAndAdvance()
                }
                .disabled(optionTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .foregroundColor(Color("red"))
                .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
    }

    // ✅ Save logic + navigation
    private func saveAndAdvance() {
        let trimmed = optionTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updateCurrentTitle(trimmed)

        if viewModel.goToNextOption() {
            optionTitle = viewModel.titleForCurrent()
        } else {
            viewModel.currentIndex = 0
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
