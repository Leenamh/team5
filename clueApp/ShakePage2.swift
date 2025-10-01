import SwiftUI
import UIKit

// MARK: - Model
struct HeartShape: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var imageName: String
    var rotation: Double = 0
}

// MARK: - UIKit Shake Detector
final class ShakeVC: UIViewController {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { onShake?() }
    }
}

struct ShakeDetector: UIViewControllerRepresentable {
    let onShake: () -> Void
    
    func makeUIViewController(context: Context) -> ShakeVC {
        let vc = ShakeVC()
        vc.view.backgroundColor = .clear
        vc.view.isUserInteractionEnabled = false
        vc.onShake = onShake
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ShakeVC, context: Context) {}
}

// MARK: - View
struct Shaking: View {
    var options: [String]   // ✅ يجي من ShakePage1
    @State private var hearts: [HeartShape] = []
    @State private var isShaking = false
    @State private var goToNext = false
    @State private var chosenResult: String = ""   // ✅ النتيجة المختارة

    private let heartImages = ["heart1", "heart2", "heart3", "heart4", "heart5"]

    private let jarSize = CGSize(width: 280, height: 320)
    private let xRange: ClosedRange<CGFloat> = -70...80
    private let yRange: ClosedRange<CGFloat> = 20...170
    private let xClamp: ClosedRange<CGFloat> = -50...90
    private let yClamp: ClosedRange<CGFloat> = -50...190

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                Image("shake")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                
                ZStack {
                    Image("jar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 430, height: 430)

                    ForEach(hearts) { heart in
                        Image(heart.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .offset(x: heart.x, y: heart.y)
                            .rotationEffect(.degrees(heart.rotation))
                    }
                }
                .padding(.bottom, 40)
            }

            ShakeDetector {
                startShaking()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { generateHearts() }
        .navigationDestination(isPresented: $goToNext) {
            ShakePage3(result: chosenResult) // ✅ نرسل النتيجة
        }
    }

    // MARK: - Helpers
    private func clamp(_ value: CGFloat, in range: ClosedRange<CGFloat>) -> CGFloat {
        min(max(value, range.lowerBound), range.upperBound)
    }
    
    private func generateHearts() {
        hearts = (0..<45).map { _ in
            HeartShape(
                x: clamp(CGFloat.random(in: xRange), in: xClamp),
                y: clamp(CGFloat.random(in: yRange), in: yClamp),
                imageName: heartImages.randomElement()!,
                rotation: .random(in: -15...15)
            )
        }
    }

    private func reshuffleHearts() {
        for i in hearts.indices {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
                let newX = CGFloat.random(in: xRange)
                let newY = CGFloat.random(in: yRange)
                hearts[i].x = clamp(newX, in: xClamp)
                hearts[i].y = clamp(newY, in: yClamp)
                hearts[i].rotation = .random(in: -30...30)
            }
        }
    }
    
    private func startShaking() {
        guard !isShaking else { return }
        isShaking = true
        
        var elapsed: TimeInterval = 0
        let interval: TimeInterval = 0.3
        let duration: TimeInterval = 2.0
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            reshuffleHearts()
            elapsed += interval
            if elapsed >= duration {
                timer.invalidate()
                isShaking = false
                chosenResult = options.randomElement() ?? "No Option" // ✅ اختيار عشوائي
                goToNext = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        Shaking(options: ["One", "Two", "Three"])
    }
}
