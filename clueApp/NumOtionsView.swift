import SwiftUI

struct NumOtionsView: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var selectedOption: Int? = nil
    @State private var goToOptionTitles = false
    @State private var goToHome = false

    var body: some View {
        NavigationStack {
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
                                // ensure correct number of slots
                                if viewModel.options.count < number {
                                    while viewModel.options.count < number {
                                        viewModel.options.append("")
                                    }
                                } else if viewModel.options.count > number {
                                    viewModel.options = Array(viewModel.options.prefix(number))
                                }
                                viewModel.currentIndex = 0
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
                    condensedCards()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
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
                        goToOptionTitles = true
                    }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
                    .disabled(selectedOption == nil)
                }
            }
            .navigationDestination(isPresented: $goToOptionTitles) {
                OptionTitleView()
                    .environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $goToHome) {
                Home()
            }
        }
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

// cards (unchanged visuals)
struct oneCard: View {
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OpenedCardShape()
                .fill(color)
                .frame(height: 100)
                .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .padding(.horizontal, -35)
    }
}

struct CardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 60))
        path.addQuadCurve(to: CGPoint(x: 80, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width - 100, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: -100), control: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct condensedCards: View {
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: -35) {
                oneCard(color: Color("red"))
                oneCard(color: Color("peach"))
                oneCard(color: Color("pink"))
                oneCard(color: Color("yellow"))
                oneCard(color: Color("lightYellow"))
            }
        }
    }
}

#Preview {
    NavigationStack {
        NumOtionsView()
            .environmentObject(OptionsViewModel())
    }
}
