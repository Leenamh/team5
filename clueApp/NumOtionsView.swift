
import SwiftUI

final class OptionsViewModel: ObservableObject {
    @Published var numberOfOptions: Int = 1 {
        didSet { ensureTitlesSize() }
    }
    @Published var titles: [String] = []
    @Published var currentIndex: Int = 0

    private let userDefaultsKey = "com.example.optionsPayload"

    init() {
        load()
    }

    private func ensureTitlesSize() {
        if titles.count < numberOfOptions {
            titles += Array(repeating: "", count: numberOfOptions - titles.count)
        } else if titles.count > numberOfOptions {
            titles = Array(titles.prefix(numberOfOptions))
        }
        if currentIndex >= numberOfOptions {
            currentIndex = max(0, numberOfOptions - 1)
        }
    }
    


    func setNumberOfOptions(_ n: Int) {
        numberOfOptions = max(1, min(n, 10))
        ensureTitlesSize()
        save()
    }

    var currentOptionNumber: Int { currentIndex + 1 }

    func titleForCurrent() -> String {
        guard currentIndex < titles.count else { return "" }
        return titles[currentIndex]
    }

    func updateCurrentTitle(_ title: String) {
        ensureTitlesSize()
        titles[currentIndex] = title
        save()
    }

    func goToNextOption() -> Bool {
        if currentIndex < numberOfOptions - 1 {
            currentIndex += 1
            save()
            return true
        }
        return false
    }

    func goToPreviousOption() -> Bool {
        if currentIndex > 0 {
            currentIndex -= 1
            save()
            return true
        }
        return false
    }

    var isLastOption: Bool {
        currentIndex == numberOfOptions - 1
    }

    struct Persisted: Codable {
        var numberOfOptions: Int
        var titles: [String]
    }

    private func save() {
        let p = Persisted(numberOfOptions: numberOfOptions, titles: titles)
        if let data = try? JSONEncoder().encode(p) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let p = try? JSONDecoder().decode(Persisted.self, from: data) else {
            numberOfOptions = 1
            titles = [""]
            currentIndex = 0
            return
        }
        numberOfOptions = max(1, p.numberOfOptions)
        titles = p.titles
        ensureTitlesSize()
        currentIndex = 0
    }

    func reset() {
        numberOfOptions = 1
        titles = [""]
        currentIndex = 0
        save()
    }
}

struct NumOtionsView: View {
    @StateObject private var viewModel = OptionsViewModel()
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
                        viewModel.setNumberOfOptions(selectedOption ?? 1)


                        goToOptionTitles = true
                    }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
                    .disabled(selectedOption == nil) // optional: require selection
                }
            }
            .navigationDestination(isPresented: $goToOptionTitles) {
                OptionTitleView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $goToHome) {
                Home()
            }
        } // NavigationStack
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
            Spacer() // pushes cards down
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
    }
}

