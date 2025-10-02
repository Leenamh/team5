
import SwiftUI

struct OptionTitleView: View {
    @ObservedObject var viewModel: OptionsViewModel

    @State private var optionTitle: String = ""
    @State private var goToDecisionPage = false


    let clueLightYellow = UIColor(named: "lightYellow") ?? UIColor(red: 1, green: 0.925, blue: 0.655, alpha: 1)

    var body: some View {
        ZStack {
            Color(clueLightYellow).ignoresSafeArea()

            VStack(spacing: 40) {
                // top bar: only Next (NO Back)
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

                // Option number
                Text("Option \(viewModel.currentOptionNumber)")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)

                // Title field
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

                // NavigationLink -> Card() (NO viewModel passed)
                NavigationLink(destination: Card(), isActive: $goToDecisionPage) {
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
                // populate the field with any existing value for the current option
                optionTitle = viewModel.titleForCurrent()
            }
        }
        .navigationBarBackButtonHidden(true) // hide nav back button
    }

    private func saveAndAdvance() {
        let trimmed = optionTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updateCurrentTitle(trimmed)

        if viewModel.goToNextOption() {
            // advanced to next option -> update textfield
            optionTitle = viewModel.titleForCurrent()
        } else {
            // last option completed -> go straight to your existing Card()
            goToDecisionPage = true
        }
    }
}

#Preview {
    NavigationStack {
        OptionTitleView(viewModel: OptionsViewModel())
    }
}

