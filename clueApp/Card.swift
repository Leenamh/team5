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

    // Shared focus state
    @FocusState private var focusedField: FocusField?

    enum FocusField: Hashable {
        case pros, cons, offer, demand, months, years
    }

    @State private var expandedCard: String? = nil
    @State private var goToDecisionPageView = false
    @State private var goToHeart = false

    var body: some View {
        ZStack {
            Color("BG").ignoresSafeArea()

            // Header + label
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

                if viewModel.details.indices.contains(viewModel.currentIndex) {
                    Text(viewModel.details[viewModel.currentIndex].label)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, -10)
                }

                Spacer()
            }

            // Cards list
            VStack {
                Spacer()
                VStack(spacing: -40) {

                    // Pros
                    CurvedCard(
                        text: "Pros",
                        color: getColor(for: "Pros"),
                        isExpanded: expandedCard == "Pros"
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedCard = (expandedCard == "Pros") ? nil : "Pros"
                        }
                    }
                    .overlay(
                        Group {
                            if expandedCard == "Pros", viewModel.details.indices.contains(viewModel.currentIndex) {
                                let idx = viewModel.currentIndex
                                CardTextFieldView(
                                    title: "Pros",
                                    text: Binding(
                                        get: { viewModel.details[idx].pros },
                                        set: { viewModel.details[idx].pros = $0 }
                                    ),
                                    focusedField: $focusedField,
                                    currentField: .pros,
                                    nextField: .cons,
                                    onFocusChange: expandForFocus
                                )
                            }
                        },
                        alignment: .center
                    )

                    // Cons
                    CurvedCard(
                        text: "Cons",
                        color: getColor(for: "Cons"),
                        isExpanded: expandedCard == "Cons"
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedCard = (expandedCard == "Cons") ? nil : "Cons"
                        }
                    }
                    .overlay(
                        Group {
                            if expandedCard == "Cons", viewModel.details.indices.contains(viewModel.currentIndex) {
                                let idx = viewModel.currentIndex
                                CardTextFieldView(
                                    title: "Cons",
                                    text: Binding(
                                        get: { viewModel.details[idx].cons },
                                        set: { viewModel.details[idx].cons = $0 }
                                    ),
                                    focusedField: $focusedField,
                                    currentField: .cons,
                                    nextField: .offer,
                                    onFocusChange: expandForFocus
                                )
                            }
                        },
                        alignment: .center
                    )

                    // Offer and demand
                    CurvedCard(
                        text: "Offer and demand",
                        color: getColor(for: "Offer and demand"),
                        isExpanded: expandedCard == "Offer and demand"
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedCard = (expandedCard == "Offer and demand") ? nil : "Offer and demand"
                        }
                    }
                    .overlay(
                        Group {
                            if expandedCard == "Offer and demand", viewModel.details.indices.contains(viewModel.currentIndex) {
                                let idx = viewModel.currentIndex
                                CardTextFieldView(
                                    title: "Offer and demand",
                                    text: Binding(
                                        get: { viewModel.details[idx].offer },
                                        set: { viewModel.details[idx].offer = $0 }
                                    ),
                                    secondText: Binding(
                                        get: { viewModel.details[idx].demand },
                                        set: { viewModel.details[idx].demand = $0 }
                                    ),
                                    focusedField: $focusedField,
                                    currentField: .offer,
                                    nextField: .months,
                                    onFocusChange: expandForFocus
                                )
                            }
                        },
                        alignment: .center
                    )

                    // In 5 Months
                    CurvedCard(
                        text: "In 5 Months",
                        color: getColor(for: "In 5 Months"),
                        isExpanded: expandedCard == "In 5 Months"
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedCard = (expandedCard == "In 5 Months") ? nil : "In 5 Months"
                        }
                    }
                    .overlay(
                        Group {
                            if expandedCard == "In 5 Months", viewModel.details.indices.contains(viewModel.currentIndex) {
                                let idx = viewModel.currentIndex
                                CardTextFieldView(
                                    title: "In 5 Months",
                                    text: Binding(
                                        get: { viewModel.details[idx].in5Months },
                                        set: { viewModel.details[idx].in5Months = $0 }
                                    ),
                                    focusedField: $focusedField,
                                    currentField: .months,
                                    nextField: .years,
                                    onFocusChange: expandForFocus
                                )
                            }
                        },
                        alignment: .center
                    )

                    // In 5 Years
                    CurvedCard(
                        text: "In 5 Years",
                        color: getColor(for: "In 5 Years"),
                        isExpanded: expandedCard == "In 5 Years"
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedCard = (expandedCard == "In 5 Years") ? nil : "In 5 Years"
                        }
                    }
                    .overlay(
                        Group {
                            if expandedCard == "In 5 Years", viewModel.details.indices.contains(viewModel.currentIndex) {
                                let idx = viewModel.currentIndex
                                CardTextFieldView(
                                    title: "In 5 Years",
                                    text: Binding(
                                        get: { viewModel.details[idx].in5Years },
                                        set: { viewModel.details[idx].in5Years = $0 }
                                    ),
                                    focusedField: $focusedField,
                                    currentField: .years,
                                    nextField: nil,
                                    onFocusChange: expandForFocus
                                )
                            }
                        },
                        alignment: .center
                    )
                }
                .padding(.bottom, -30)
            }

            // Navigation Links
            NavigationLink(destination: DecisionPageView().environmentObject(viewModel), isActive: $goToDecisionPageView) { EmptyView() }.hidden()
            NavigationLink(destination: heart().environmentObject(viewModel), isActive: $goToHeart) { EmptyView() }.hidden()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    guard viewModel.details.indices.contains(viewModel.currentIndex) else { return }

                    let current = viewModel.details[viewModel.currentIndex]
                    let hasPros = !current.pros.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let hasCons = !current.cons.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let hasOffer = !current.offer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let hasDemand = !current.demand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

                    guard hasPros, hasCons, hasOffer, hasDemand else {
                        print("🚨 يجب تعبئة جميع الخانات (ما عدا 5 Months يمكن تركها فارغة)")
                        return
                    }

                    if !viewModel.goToNextOption() {
                        if viewModel.options.count == 1 {
                            goToHeart = true
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

    // Expand appropriate card for a focus field
    private func expandForFocus(_ field: FocusField?) {
        guard let f = field else { return }
        withAnimation {
            switch f {
            case .pros: expandedCard = "Pros"
            case .cons: expandedCard = "Cons"
            case .offer, .demand: expandedCard = "Offer and demand"
            case .months: expandedCard = "In 5 Months"
            case .years: expandedCard = "In 5 Years"
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

// MARK: - CardTextFieldView (Fixed single Next button)
struct CardTextFieldView: View {
    var title: String
    @Binding var text: String
    @Binding var secondText: String
    let focusedField: FocusState<DecisionPage.FocusField?>.Binding
    let currentField: DecisionPage.FocusField
    let nextField: DecisionPage.FocusField?
    let onFocusChange: (DecisionPage.FocusField?) -> Void

    init(
        title: String,
        text: Binding<String>,
        secondText: Binding<String> = .constant(""),
        focusedField: FocusState<DecisionPage.FocusField?>.Binding,
        currentField: DecisionPage.FocusField,
        nextField: DecisionPage.FocusField?,
        onFocusChange: @escaping (DecisionPage.FocusField?) -> Void
    ) {
        self.title = title
        self._text = text
        self._secondText = secondText
        self.focusedField = focusedField
        self.currentField = currentField
        self.nextField = nextField
        self.onFocusChange = onFocusChange
    }

    var body: some View {
        VStack {
            if title == "Offer and demand" {
                HStack(alignment: .top, spacing: 20) {
                    // Offer (بدون زر Next)
                    singleEditor(
                        text: $text,
                        placeholder: "What does it\noffer you",
                        field: .offer,
                        nextTarget: nil, // ← ما له زر
                        width: 153
                    )

                    // Demand (مع زر Next)
                    singleEditor(
                        text: $secondText,
                        placeholder: "What does it\ndemand from\nyou",
                        field: .demand,
                        nextTarget: nextField,
                        width: 153
                    )
                }
            } else {
                singleEditor(
                    text: $text,
                    placeholder: getPlaceholder(for: title),
                    field: currentField,
                    nextTarget: nextField
                )
            }
        }
    }

    // MARK: - Single Editor
    private func singleEditor(
        text: Binding<String>,
        placeholder: String,
        field: DecisionPage.FocusField,
        nextTarget: DecisionPage.FocusField?,
        width: CGFloat = 282,
        height: CGFloat = 152
    ) -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: text)
                .focused(focusedField, equals: field)
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
                .font(.system(size: 16, weight: .bold))
                // Detect newline (Return key)
                .onChange(of: text.wrappedValue) { newValue in
                    if newValue.contains("\n") {
                        text.wrappedValue = newValue.replacingOccurrences(of: "\n", with: "")
                        DispatchQueue.main.async {
                            if let next = nextTarget {
                                focusedField.wrappedValue = next
                                onFocusChange(next)
                            } else {
                                focusedField.wrappedValue = nil
                                onFocusChange(nil)
                            }
                        }
                    }
                }
                // ✅ Only show toolbar for fields that need it
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        if field != .offer { // ← اخفِ الزر في Offer فقط
                            if let next = nextTarget {
                                Button("Next") {
                                    focusedField.wrappedValue = next
                                    onFocusChange(next)
                                }
                            } else {
                                Button("Done") {
                                    focusedField.wrappedValue = nil
                                    onFocusChange(nil)
                                }
                            }
                        }
                    }
                }

            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top, 18)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
        }
    }

    private func getPlaceholder(for title: String) -> String {
        switch title {
        case "Pros": return "List all the pros that you can think of"
        case "Cons": return "List all the cons that you can think of"
        case "In 5 Months": return "With this choice,\nwhat do you see in 5 months?"
        case "In 5 Years": return "With this choice,\nwhat do you see in 5 years?"
        default: return ""
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
        return path
    }
}
