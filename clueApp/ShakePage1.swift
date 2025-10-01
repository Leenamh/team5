import SwiftUI

struct ShakePage1: View {
    @State private var options: [String] = ["", ""]  // قلبين ثابتة
    @State private var currentPair: Int = 0          // يحدد أي جروب ظاهر الآن (pair)

    @State private var goToHome = false
    @State private var goToNext = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { geo in
                ZStack {
                    // القلب الأول (يسار)
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        TextField("Option \(currentPair * 2 + 1)", text: Binding(
                            get: { options.indices.contains(currentPair * 2) ? options[currentPair * 2] : "" },
                            set: { newValue in
                                if options.indices.contains(currentPair * 2) {
                                    options[currentPair * 2] = newValue
                                } else {
                                    options.append(newValue)
                                }
                            }
                        ))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .foregroundColor(Color("red"))                        .font(.system(size: 16, weight: .bold))
                        .background(Color.clear)
                        .disableAutocorrection(true)
                    }
                    .position(x: geo.size.width * 0.3, y:90)

                    // القلب الثاني (يمين)
                    ZStack {
                        Image("HeartOption")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        TextField("Option \(currentPair * 2 + 2)", text: Binding(
                            get: { options.indices.contains(currentPair * 2 + 1) ? options[currentPair * 2 + 1] : "" },
                            set: { newValue in
                                if options.indices.contains(currentPair * 2 + 1) {
                                    options[currentPair * 2 + 1] = newValue
                                } else {
                                    options.append(newValue)
                                }
                            }
                        ))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .foregroundColor(Color("red"))
                        .font(.system(size: 16, weight: .bold))
                        .background(Color.clear)
                        .disableAutocorrection(true)
                    }
                    .position(x: geo.size.width * 0.7, y:90)

                    // زر +
                    Button(action: {
                        currentPair += 1
                        if options.count < (currentPair + 1) * 2 {
                            options.append(contentsOf: ["", ""]) // يضيف فيلديـن جدد
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("pink"))
                    }
                    .position(x: geo.size.width / 2, y: 190)

                    // صورة الجار
                    Image("EmptyJarOpen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 430, height: 430)
                        .position(x: geo.size.width / 2, y: geo.size.height - 290)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { goToHome = true }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { goToNext = true }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("red"))
            }
        }
        .navigationDestination(isPresented: $goToHome) { Home() }
        .navigationDestination(isPresented: $goToNext) {
            Shaking(options: options) // ✅ نرسل الخيارات كلها للصفحة الثانية
        }
    }
}

#Preview {
    NavigationStack {
        ShakePage1()
    }
}
