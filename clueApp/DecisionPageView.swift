import SwiftUI

struct DecisionPageView: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var selectedOption: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var goToCompletion = false   // ✅ new navigation flag

    let questions = [
        "What do you prefer?",
        "What can you tolerate?",
        "Which will you take?",
        "What demand can you meet?",
        "In 5 months?",
        "In 5 years?"
    ]

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

            VStack(spacing: 40) {
                Spacer().frame(height: 30)

                // Question title
                Text(questions[currentQuestionIndex])
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color("red"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)

                ZStack {
                    // OR text in background
                    Text("OR")
                        .font(.system(size: 90, weight: .bold))
                        .foregroundColor(Color("red"))
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
                        .opacity(0.15)
                        .offset(x: -140, y: 20)

                    VStack(spacing: 25) {
                        ForEach(0..<viewModel.options.count, id: \.self) { idx in
                            OptionBox(
                                text: viewModel.details.indices.contains(idx) ?
                                      viewModel.details[idx].label :
                                      "Option \(idx+1)",
                                color: Color("red"),
                                isSelected: selectedOption == idx
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedOption = idx
                                }
                                // ✅ count this choice
                                viewModel.incrementScore(for: idx)
                                autoAdvance()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()

            // ✅ NavigationLink to CompletionView
            NavigationLink(destination: CompletionView()
                .environmentObject(viewModel),
                isActive: $goToCompletion) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func autoAdvance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut) {
                if currentQuestionIndex < questions.count - 1 {
                    currentQuestionIndex += 1
                    selectedOption = nil
                } else {
                    print("✅ Finished all questions")
                    if let winner = viewModel.winningOption() {
                        print("🎉 Winning option: \(winner.label) with score \(winner.score)")
                    }
                    goToCompletion = true   // ✅ navigate to CompletionView
                }
            }
        }
    }
}

// MARK: - Styled OptionBox
struct OptionBox: View {
    let text: String
    let color: Color
    let isSelected: Bool

    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .medium, design: .rounded))
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
                    .stroke(isSelected ? color : Color.clear, lineWidth: 3)
            )
            .padding(.horizontal, 40)
    }
}

#Preview {
    NavigationStack {
        DecisionPageView()
            .environmentObject(OptionsViewModel())
    }
}

