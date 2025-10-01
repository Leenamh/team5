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
    @State private var cardTexts: [String: String] = [:] // store user input for each card

    var body: some View {
        ZStack {
            // Background
            Color(red: 1.0, green: 0.925, blue: 0.655)
                .ignoresSafeArea()
            
            VStack {
                // Top fixed section (Option 1 + Next button)
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
                    
                    Button(action: { print("Next button tapped") }) {
                        Text("Next")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color("red"))
                    }
                    .padding(.top, -105)
                }
                .padding()
                
                Spacer() // ensures cards are at the bottom
                
                // Cards stack
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
                            expandedCard == title ? CardTextFieldView(title: title, cardTexts: $cardTexts) : nil,
                            alignment: .bottomLeading
                        )
                    }
                }
                .padding(.bottom, -30)
            }
            .padding(.top, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Function to get card color
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

// MARK: - Extension for corner radius on specific corners
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

// MARK: - Helper View for Card TextFields
struct CardTextFieldView: View {
    var title: String
    @Binding var cardTexts: [String: String]

    var body: some View {
        switch title {
        case "Pros":
            TextField("Write pros here...", text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))

            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            .background(Color.white.opacity(0.6)) // Solid white background
            .clipShape(RoundedRectangle(cornerRadius: 12)) // Rounded corners instead of capsule
            .foregroundColor(.white) // Black text color
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // Light gray border
            )
            .frame(width: 282, height: 336)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.leading) // Left-aligned text
            .lineLimit(nil) // Allow multiple lines
            .font(.system(size: 16, weight: .regular)) // Regular font weight
//            .padding(.horizontal, 30)
//            .padding(.bottom, 150)
//            .background(Color.white.opacity(0.6)) // very transparent
//            .clipShape(Capsule()) // makes it elliptical
//            .foregroundColor(Color("red")) // text color
//            .frame(width:282, height:153)
////            .overlay(
////                Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1))
//            .textFieldStyle(.roundedBorder)
//            //.padding(.vertical, 12)
            
        case "Cons":
            TextField("Write cons here...", text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 150)
            
        case "Offer and demand":
            TextField("Write offer/demand details...", text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 150)
            
        case "In 5 Months":
            TextField("Write 5 months plan...", text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 150)
            
        case "In 5 Years":
            TextField("Write 5 years plan...", text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 150)
            
        default:
            EmptyView()
        }
    }
}
