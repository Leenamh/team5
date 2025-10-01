import SwiftUI

struct ShakePage3: View {
    @State private var option1: String

    init(result: String) {
        _option1 = State(initialValue: result)
    }

    @State private var goToHome = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                Image("YourDecion")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                
                 
                HStack(spacing: 40) {
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)

                        Text(option1) // ✅ نعرض النتيجة كنص
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                            .foregroundColor(Color("red"))
                            .font(.system(size: 16, weight: .bold, design: .rounded))

                    }.offset(y: -100)
                }

                Image("fullJarOpen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 430, height: 430)
                    .offset(y: -90)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { goToHome = true }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
            }
        }
        .navigationDestination(isPresented: $goToHome) { Home() }
    }
}

#Preview {
    NavigationStack {
        ShakePage3(result: "Test Result")
    }
}
