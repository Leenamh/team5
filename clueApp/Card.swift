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
        NavigationStack {
                    DecisionPage()
                }
    }
}

#Preview {
    Card()
}

// MARK: - Decision Page Layout
struct DecisionPage: View {
    @State private var expandedCard: String? = nil
    @State private var cardTexts: [String: String] = [:] // store user input for each card
    @State private var goToNextOption = false
    var optionNumber = 1;
    var body: some View {
        ZStack {
            // Background
            Color("BG").ignoresSafeArea()
            
            VStack {
                // Top fixed section (Option 1 + Next button)
                HStack {
                    Text("Option \(optionNumber)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 30)
                        .background(Color(red: 1.0, green: 0.831, blue: 0.541))
                        .cornerRadius(28)
                        .padding(.leading, -35)
                        .offset(x: 4, y: -130)
                    
                    Spacer()
                    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    goToNextOption
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("red"))
            }
        } .navigationDestination(isPresented: $goToNextOption) {
            Card()
        }
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
            TextEditor( text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .scrollContentBackground(.hidden)
            .autocorrectionDisabled()
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.4)) // Solid white background
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners instead of capsule
            .foregroundColor(.gray) // gray text color
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // Light gray border
            )
            .frame(width: 282, height: 152)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.leading) // Left-aligned text
            .lineLimit(nil) // Allow multiple lines
            .font(.system(size: 16, weight: .bold)) // Regular font weight
            
            if (cardTexts[title] ?? "").isEmpty {
                Text("List all the pros that you can think of")
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: 260, alignment: .leading)
                    .padding(.top, -55)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
            
        case "Cons":
            TextEditor( text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .scrollContentBackground(.hidden)
            .autocorrectionDisabled()
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.4)) // Solid white background
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners instead of capsule
            .foregroundColor(.gray) // gray text color
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // Light gray border
            )
            .frame(width: 282, height: 152)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.leading) // Left-aligned text
            .lineLimit(nil) // Allow multiple lines
            .font(.system(size: 16, weight: .regular)) // Regular font weight
            
            if (cardTexts[title] ?? "").isEmpty {
                Text("List all the cons that you can think of")
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: 260, alignment: .leading)
                    .padding(.top, -55)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
            
        case "Offer and demand":

                // Centered content
                HStack(alignment: .top, spacing: 20) {
                    
                    // Left TextEditor
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { cardTexts["offer"] ?? "" },
                            set: { cardTexts["offer"] = $0 }
                        ))
                        .scrollContentBackground(.hidden)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 153, height: 113)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16, weight: .regular))
                        
                        if (cardTexts["offer"] ?? "").isEmpty {
                            Text("What does it\noffer you")
                                .foregroundColor(Color.gray.opacity(0.7))
                                .padding(.leading, 24)
                                .padding(.top, 20)
                        }
                    }
                    
                    // Right TextEditor
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { cardTexts["demand"] ?? "" },
                            set: { cardTexts["demand"] = $0 }
                        ))
                        .scrollContentBackground(.hidden)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 153, height: 113)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16, weight: .regular))
                        
                        if (cardTexts["demand"] ?? "").isEmpty {
                            Text("What does\ndemand from\nyou")
                                .foregroundColor(Color.gray.opacity(0.7))
                                .padding(.leading, 24)
                                .padding(.top, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // center inside card


            
        case "In 5 Months":
            TextEditor( text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .scrollContentBackground(.hidden)
            .autocorrectionDisabled()
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.4)) // Solid white background
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners instead of capsule
            .foregroundColor(.gray) // gray text color
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // Light gray border
            )
            .frame(width: 282, height: 152)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.leading) // Left-aligned text
            .lineLimit(nil) // Allow multiple lines
            .font(.system(size: 16, weight: .regular)) // Regular font weight
            
            if (cardTexts[title] ?? "").isEmpty {
                Text("With this choice\nWhat do you see in 5 months ")
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: 260, alignment: .leading)
                    .padding(.top, -55)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
            
        case "In 5 Years":
            TextEditor( text: Binding(
                get: { cardTexts[title] ?? "" },
                set: { cardTexts[title] = $0 }
            ))
            .scrollContentBackground(.hidden)
            .autocorrectionDisabled()
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.4)) // Solid white background
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners instead of capsule
            .foregroundColor(.gray) // gray text color
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // Light gray border
            )
            .frame(width: 282, height: 152)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.leading) // Left-aligned text
            .lineLimit(nil) // Allow multiple lines
            .font(.system(size: 16, weight: .bold)) // Regular font weight
            
            if (cardTexts[title] ?? "").isEmpty {
                Text("With this choice\nWhat do you see in 5 months ")
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: 260, alignment: .leading)
                    .padding(.top, -55)
                    .padding(.leading, 24)
                    .allowsHitTesting(false)
            }
            
        default:
            EmptyView()
        }
    }
}
