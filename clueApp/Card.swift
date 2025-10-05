import SwiftUI

// MARK: - Main ContentView
struct Card: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    var body: some View {
        NavigationStack {
            DecisionPage().environmentObject(viewModel)
        }
    }
}

#Preview {
    Card().environmentObject(OptionsViewModel())
}

// MARK: - Decision Page Layout
struct DecisionPage: View {
    @EnvironmentObject var viewModel: OptionsViewModel
    @State private var expandedCard: String? = nil
    @State private var goToDecisionPageView = false
    @State private var goToHeart = false   // ✅ new flag

    var body: some View {
        ZStack {
            Color("BG").ignoresSafeArea()

            // fixed header + label
            VStack {
                HStack {
                    Text("Option \(viewModel.currentIndex + 1)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 30)
                        .background(Color(red: 1.0, green: 0.831, blue: 0.541))
                        .cornerRadius(28)
                        .padding(.leading, -35)
                        .offset(x: 4, y: -100)
                    Spacer()
                }
                .padding(.horizontal)

                // label from the selected option
                if viewModel.details.indices.contains(viewModel.currentIndex) {
                    Text(viewModel.details[viewModel.currentIndex].label)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, -10)
                }

                Spacer()
            }

            // cards stack
            VStack {
                Spacer()
                VStack(spacing: -40) {
                    ForEach(["Pros", "Cons", "Offer and demand", "In 5 Months", "In 5 Years"], id: \.self) { title in
                        CurvedCard(
                            text: title,
                            color: getColor(for: title),
                            isExpanded: expandedCard == title
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expandedCard = (expandedCard == title) ? nil : title
                            }
                        }
                        .overlay(
                            Group {
                                if expandedCard == title,
                                   viewModel.details.indices.contains(viewModel.currentIndex) {

                                    let idx = viewModel.currentIndex

                                    switch title {
                                    case "Pros":
                                        CardTextFieldView(
                                            title: title,
                                            text: Binding(
                                                get: { viewModel.details[idx].pros },
                                                set: { viewModel.details[idx].pros = $0 }
                                            )
                                        )

                                    case "Cons":
                                        CardTextFieldView(
                                            title: title,
                                            text: Binding(
                                                get: { viewModel.details[idx].cons },
                                                set: { viewModel.details[idx].cons = $0 }
                                            )
                                        )

                                    case "Offer and demand":
                                        CardTextFieldView(
                                            title: title,
                                            text: Binding(
                                                get: { viewModel.details[idx].offer },
                                                set: { viewModel.details[idx].offer = $0 }
                                            ),
                                            secondText: Binding(
                                                get: { viewModel.details[idx].demand },
                                                set: { viewModel.details[idx].demand = $0 }
                                            )
                                        )

                                    case "In 5 Months":
                                        CardTextFieldView(
                                            title: title,
                                            text: Binding(
                                                get: { viewModel.details[idx].in5Months },
                                                set: { viewModel.details[idx].in5Months = $0 }
                                            )
                                        )

                                    case "In 5 Years":
                                        CardTextFieldView(
                                            title: title,
                                            text: Binding(
                                                get: { viewModel.details[idx].in5Years },
                                                set: { viewModel.details[idx].in5Years = $0 }
                                            )
                                        )

                                    default:
                                        EmptyView()
                                    }
                                }
                            },
                            alignment: .center
                        )
                    }
                }
                .padding(.bottom, -30)
            }

            // ✅ NavigationLink to DecisionPageView
            NavigationLink(destination: DecisionPageView().environmentObject(viewModel),
                           isActive: $goToDecisionPageView) {
                EmptyView()
            }
            .hidden()

            // ✅ NavigationLink to Heart page
            NavigationLink(destination: heart().environmentObject(viewModel),
                           isActive: $goToHeart) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    if !viewModel.goToNextOption() {
                        // ✅ last option finished → decide where to go
                        if viewModel.options.count == 1 {
                            goToHeart = true   // go heart if only 1 option
                        } else {
                            goToDecisionPageView = true
                        }
                    }
                    withAnimation { expandedCard = nil }
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }
        }
    }

    func getColor(for title: String) -> Color {
        switch title {
        case "Pros": return Color(red: 254/255, green: 93/255, blue: 91/255)
        case "Cons": return Color(red: 253/255, green: 157/255, blue: 132/255)
        case "Offer and demand": return Color(red: 249/255, green: 205/255, blue: 189/255)
        case "In 5 Months": return Color(red: 255/255, green: 212/255, blue: 138/255)
        case "In 5 Years": return Color(red: 252/255, green: 231/255, blue: 145/255)
        default: return .gray
        }
    }
}


// MARK: - CardTextFieldView (new binding-based)
struct CardTextFieldView: View {
    var title: String
    @Binding var text: String
    @Binding var secondText: String

    init(title: String, text: Binding<String>, secondText: Binding<String> = .constant("")) {
        self.title = title
        self._text = text
        self._secondText = secondText
    }

    var body: some View {
        switch title {
        case "Pros":
            editorBinding($text, placeholder: "List all the pros that you can think of", bold: true)

        case "Cons":
            editorBinding($text, placeholder: "List all the cons that you can think of", bold: true)

        case "Offer and demand":
            HStack(alignment: .top, spacing: 20) {
                editorBinding($text,       placeholder: "What does it\noffer you", width: 153, height: 113, bold: true)
                editorBinding($secondText, placeholder: "What does\ndemand from\nyou", width: 153, height: 113, bold: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case "In 5 Months":
            editorBinding($text, placeholder: "With this choice\nWhat do you see in 5 months ", bold: true)

        case "In 5 Years":
            editorBinding($text, placeholder: "With this choice\nWhat do you see in 5 years ", bold: true)

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func editorBinding(_ value: Binding<String>,
                               placeholder: String,
                               width: CGFloat = 282,
                               height: CGFloat = 152,
                               bold: Bool = false) -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: value)
                .scrollContentBackground(.hidden)
                .autocorrectionDisabled()
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .frame(width: width, height: height)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16, weight: bold ? .bold : .regular))

            if value.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: width - 22, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - CurvedCard View
struct CurvedCard: View {
    var text: String
    var color: Color

    var isExpanded: Bool
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                OpenedCardShape()
                    .fill(color)
                    .frame(height: isExpanded ? 300 : 120)
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 4)

                Text(text)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.leading, 30)
            }
        }
        .padding(.horizontal, -3)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                onTap()
            }
        }
    }
}

// MARK: - Card Shape with curved top corners
struct OpenedCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 60))
        path.addQuadCurve(to: CGPoint(x: 80, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width - 100, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: -100), control: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path;
    }
}
