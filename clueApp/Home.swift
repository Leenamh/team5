import SwiftUI

struct Home: View {
    @State private var offsetX: CGFloat = 0.0 // track circle movement
    @State private var goToNumOptions = false // navigate Wisely
    @State private var goToRandom = false     // navigate Randomly

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("BG") // from Assets
                    .ignoresSafeArea()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding(.top, -180)
                    
                    // Toggle
                    ZStack {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.4, blue: 0.5),
                                        Color(red: 1.0, green: 0.7, blue: 0.4)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 280, height: 100)
                            .shadow(
                                color: Color(red: 1.0, green: 0.6, blue: 0.4).opacity(0.9),
                                radius: 25, x: 0, y: 18
                            )
                        
                        HStack {
                            Text("Wisely")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.5))
                                .shadow(color: .white.opacity(0.8), radius: 2)
                                .shadow(color: .pink.opacity(0.3), radius: 4, x: 1, y: 1)
                                .frame(maxWidth: .infinity)
                            
                            Text(" Randomly")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.4))
                                .shadow(color: .white.opacity(0.8), radius: 2)
                                .shadow(color: .pink.opacity(0.3), radius: 4, x: 1, y: 1)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 40)
                        
                        // Draggable circle
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.5, blue: 0.5).opacity(0.6))
                                    .frame(width: 75, height: 75)
                            )
                            .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                            .offset(x: offsetX)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let dragRange: CGFloat = 100
                                        offsetX = min(max(value.translation.width, -dragRange), dragRange)
                                    }
                                    .onEnded { _ in
                                        if offsetX < -80 {
                                            // go left → Wisely
                                            goToNumOptions = true
                                        } else if offsetX > 80 {
                                            // go right → Randomly
                                            goToRandom = true
                                        }
                                        withAnimation {
                                            offsetX = 0
                                        }
                                    }
                            )
                    }
                    .padding(.top, -10)
                }
            }
            // ✅ navigation destinations
            .navigationDestination(isPresented: $goToNumOptions) {
                NumOtionsView()
            }
            .navigationDestination(isPresented: $goToRandom) {
                ShakePage1()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    Home()
}
