//
//  Card.swift
//  clueApp
//
//  Created by Reema Alsaleh  on 08/04/1447 AH.
//


import SwiftUI

// MARK: - Main ContentView
struct Card: View {
    var body: some View {
        DecisionPage()
    }
}

#Preview {
    Card()
}

// MARK: - Decision Page Layout
struct DecisionPage: View {
    @State private var expandedCard: String? = nil
    var body: some View {
        ZStack {
            // خلفية الصفحة
            Color(red: 1.0, green: 0.925, blue: 0.655)
                .ignoresSafeArea()
            
            VStack {
                // الجزء العلوي الثابت (Option 1 + زر Next)
                HStack {
                    Text("Option 1")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 30)
                        .background(Color(red: 1.0, green: 0.831, blue: 0.541))
                        .cornerRadius(28)
                        .padding(.leading, -35)
                        .offset(x: 4, y: -100)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Next button tapped")
                    }) {
                        Text("Next")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color("red"))
                    }
                    .padding(.top, -105)
                }
                .padding()
                
                Spacer() // يضمن البطاقات تكون في الأسفل
                
                // البطاقات هنا فقط
                VStack(spacing: -40) {
                    CurvedCard(text: "Pros", color: Color(red: 254/255, green: 93/255, blue: 91/255),
                               isExpanded: expandedCard == "Pros") {
                        expandedCard = (expandedCard == "Pros") ? nil : "Pros"
                    }
                    CurvedCard(text: "Cons", color: Color(red: 253/255, green: 157/255, blue: 132/255),
                               isExpanded: expandedCard == "Cons") {
                        expandedCard = (expandedCard == "Cons") ? nil : "Cons"
                    }
                    CurvedCard(text: "Offer and demand", color: Color(red: 249/255, green: 205/255, blue: 189/255),
                               isExpanded: expandedCard == "Offer and demand") {
                        expandedCard = (expandedCard == "Offer and demand") ? nil : "Offer and demand"
                    }
                    CurvedCard(text: "In 5 Months", color: Color(red: 255/255, green: 212/255, blue: 138/255),
                               isExpanded: expandedCard == "In 5 Months") {
                        expandedCard = (expandedCard == "In 5 Months") ? nil : "In 5 Months"
                    }
                    CurvedCard(text: "In 5 Years", color:Color(red: 252/255, green: 231/255, blue: 145/255),
                               isExpanded: expandedCard == "In 5 Years") {
                        expandedCard = (expandedCard == "In 5 Years") ? nil : "In 5 Years"
                    }
                }
                .padding(.bottom, -30)
            }
            .padding(.top, 10)
        }.navigationBarBackButtonHidden(true) // hides default back button
    }
}
// MARK: - CurvedCard View (زاوية واحدة دائرية)
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
struct OpenedCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: rect.height))
        // Line up left edge to 60 pts from top
        path.addLine(to: CGPoint(x: 0, y: 60))
        // Top-left rounded corner (80 radius)
        path.addQuadCurve(to: CGPoint(x: 80, y: 0), control: CGPoint(x: 0, y: 0))

        // Line horizontal to -100 pts from right
        path.addLine(to: CGPoint(x: rect.width - 100, y: 0))

        // Top-right outward curve (opening shape)
        path.addQuadCurve(to: CGPoint(x: rect.width, y: -100), control: CGPoint(x: rect.width, y: 0))

        // Line down right edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))

        // Close path
        path.closeSubpath()

        return path
    }
}
// MARK: - Extension لتحديد زوايا معينة فقط
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
    
