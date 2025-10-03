////
////  heart.swift
////  clueApp
////
////  Created by Wed Ahmed Alasiri on 08/04/1447 AH.

////
//
//
import SwiftUI

struct heart: View {
    
    @State private var selectedOption: Int = 3 // Default selection
    @State private var dragValue: Double = 3
    @EnvironmentObject var viewModel: OptionsViewModel
    @Environment(\.dismiss) var dismiss // زر العودة
    
    @State private var finalDecision: String = ""
    @State private var averageScore: Double = 0.0
    @State private var showResult: Bool = false
    @State private var goToCompletion = false // ✅ للتنقل إذا القرار مناسب
    @State private var goToNotCompletion = false // ✅ للتنقل إذا القرار غير مناسب
    @State private var goToNoDataEntred = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.0),
                        .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.6),
                        .init(color: .white, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 50)
                    
                    // النص الثابت + النص الذي كتبه المستخدم
                    Text(getCurrentText())
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer().frame(height: 50).padding(.bottom, 60)
                    
                    HStack(spacing: 20) {
                        // Numbers
                        VStack(spacing: 40) {
                            ForEach((1...5).reversed(), id: \.self) { num in
                                Text("\(num)")
                                    .font(.title2)
                                    .foregroundColor(num == selectedOption ? .red : Color(red: 1.0, green: 116/255, blue: 114/255))
                                    .fontWeight(num == selectedOption ? .bold : .regular)
                            }
                        }
                        .padding(.bottom, 30)
                        
                        // Heart slider
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(red: 252/255, green: 241/255, blue: 177/255), location: 0.0),
                                            .init(color: Color(red: 242/255, green: 163/255, blue: 139/255), location: 1.0)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 60, height: 370)
                            
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 75, height: 65)
                                .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255))
                                .offset(y: CGFloat((5 - dragValue) * 60 - 120))
                                .animation(.spring(), value: dragValue)
                        }
                        .padding(.bottom, 60)
                        .gesture(
                            DragGesture(minimumDistance: 9)
                                .onChanged { gesture in
                                    let height: CGFloat = 300
                                    let stepHeight = height / 5
                                    let pos = max(0, min(height, height - gesture.location.y))
                                    let step = Int((pos / stepHeight).rounded(.toNearestOrAwayFromZero))
                                    
                                    dragValue = Double(step)
                                    selectedOption = max(1, min(5, step))
                                }
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        saveScoreAndAdvance()
                    }) {
                        Text("Next")
                            .foregroundColor(Color(red: 1.0, green: 0.455, blue: 0.447))
                            .font(.title3)
                            .padding(.bottom, 40)
                            .padding(.leading, 290)
                    }
                    
                    // ✅ NavigationLink للصفحة النهائية
                    NavigationLink(
                        destination: CompletionView().environmentObject(viewModel),
                        isActive: $goToCompletion
                    ) { EmptyView() }.hidden()
                    
                    NavigationLink(
                        destination: NotCompletionView().environmentObject(viewModel),
                        isActive: $goToNotCompletion
                    ) { EmptyView() }.hidden()
//                    
//                    NavigationLink(
//                                destination: emptyInput().environmentObject(viewModel),
//                                isActive: $goToNoDataEntred
//                            ) { EmptyView() }.hidden()
//                    
                    
                }
            }
            
            .onAppear {
                       // 🔄 إعادة التعيين عند فتح الشاشة
                       viewModel.currentScoreIndex = 0
                       viewModel.currentIndex = 0
                       selectedOption = 3
                       dragValue = 3
                   }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        // زر الرجوع (اختياري)
                    }
                }
            }
        }
    }

    // MARK: - النص الثابت + نص المستخدم
    func getCurrentText() -> String {
        guard viewModel.details.indices.contains(viewModel.currentIndex) else { return "" }
        let detail = viewModel.details[viewModel.currentIndex]
        switch viewModel.currentScoreIndex {
        case 0: return "How satisfied are you with: \(detail.pros)?" //+ " 1"
        case 1: return "How satisfied are you with: \(detail.cons)" + " 2"
        case 2: return "How satisfied are you with: \(detail.offer)" + " 3"
        case 3: return "How satisfied are you with: \(detail.demand)" + " 4"
        case 4: return "How satisfied are you with: \(detail.in5Months)" + " 5"
        case 5: return "How satisfied are you with: \(detail.in5Years)" + " 6"
        default: return ""
        }
    }

    // MARK: - حفظ الدرجة والتقدم
    func saveScoreAndAdvance() {
        guard viewModel.details.indices.contains(viewModel.currentIndex) else { return }
        var detail = viewModel.details[viewModel.currentIndex]

        switch viewModel.currentScoreIndex {
        case 0: detail.prosScore = selectedOption
        case 1: detail.consScore = selectedOption
        case 2: detail.offerScore = selectedOption
        case 3: detail.demandScore = selectedOption
        case 4: detail.in5MonthsScore = selectedOption
        case 5: detail.in5YearsScore = selectedOption
        default: break
        }

        viewModel.details[viewModel.currentIndex] = detail

        print("✅ User rated: \(selectedOption) for score index \(viewModel.currentScoreIndex)")

        if viewModel.currentScoreIndex == 5 {
            let scores = [detail.prosScore, detail.consScore, detail.offerScore,
                          detail.demandScore, detail.in5MonthsScore, detail.in5YearsScore].compactMap { $0 }
            averageScore = Double(scores.reduce(0, +)) / Double(scores.count)
            print("📊 Average = \(averageScore)")

            if averageScore > 3 {
                print("🎉 القرار مناسب ✅")
                goToCompletion = true
            } else if averageScore <= 3 {
                print("⚠️ القرار غير مناسب ❌")
                goToNotCompletion = true
            }else{
                print("empty data  ")
                goToNoDataEntred = true
            }
            
            
            
        }else{
            viewModel.currentScoreIndex += 1
            selectedOption = 3
            dragValue = 3
           
           
        }
    }
}

#Preview {
    heart().environmentObject(OptionsViewModel())
}






         

// code for text if its so long
//import SwiftUI
//
//struct heart: View {
//    
//    @State private var selectedOption: Int = 3 // Default selection
//    @State private var dragValue: Double = 3
//    @EnvironmentObject var viewModel: OptionsViewModel
//    @Environment(\.dismiss) var dismiss // زر العودة
//    
//    @State private var finalDecision: String = ""
//    @State private var averageScore: Double = 0.0
//    @State private var showResult: Bool = false
//    @State private var goToCompletion = false // للتنقل التلقائي
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Background gradient
//                LinearGradient(
//                    gradient: Gradient(stops: [
//                        .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.0),
//                        .init(color: Color(red: 1.0, green: 0.925, blue: 0.608), location: 0.6),
//                        .init(color: .white, location: 1.0)
//                    ]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//                
//                VStack {
//                    Spacer().frame(height: 50)
//                    
//                    // ✅ ScrollView للنص الطويل
//                    ScrollView {
//                        Text(getCurrentText())
//                            .font(.title2)
//                            .fontWeight(.medium)
//                            .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255))
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    .frame(height: 150) // حجم مخصص للسطر مع تمرير
//                    .padding(.horizontal)
//                    
//                    Spacer().frame(height: 50).padding(.bottom, 60)
//                    
//                    HStack(spacing: 20) {
//                        // Numbers
//                        VStack(spacing: 40) {
//                            ForEach((1...5).reversed(), id: \.self) { num in
//                                Text("\(num)")
//                                    .font(.title2)
//                                    .foregroundColor(num == selectedOption ? .red : Color(red: 1.0, green: 116/255, blue: 114/255))
//                                    .fontWeight(num == selectedOption ? .bold : .regular)
//                            }
//                        }
//                        .padding(.bottom, 30)
//                        
//                        // Heart slider
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 25)
//                                .fill(
//                                    LinearGradient(
//                                        gradient: Gradient(stops: [
//                                            .init(color: Color(red: 252/255, green: 241/255, blue: 177/255), location: 0.0),
//                                            .init(color: Color(red: 242/255, green: 163/255, blue: 139/255), location: 1.0)
//                                        ]),
//                                        startPoint: .top,
//                                        endPoint: .bottom
//                                    )
//                                )
//                                .frame(width: 60, height: 370)
//                            
//                            Image(systemName: "heart.fill")
//                                .resizable()
//                                .frame(width: 75, height: 65)
//                                .foregroundColor(Color(red: 1.0, green: 116/255, blue: 114/255))
//                                .offset(y: CGFloat((5 - dragValue) * 60 - 120))
//                                .animation(.spring(), value: dragValue)
//                        }
//                        .padding(.bottom, 60)
//                        .gesture(
//                            DragGesture(minimumDistance: 9)
//                                .onChanged { gesture in
//                                    let height: CGFloat = 300
//                                    let stepHeight = height / 5
//                                    let pos = max(0, min(height, height - gesture.location.y))
//                                    let step = Int((pos / stepHeight).rounded(.toNearestOrAwayFromZero))
//                                    
//                                    dragValue = Double(step)
//                                    selectedOption = max(1, min(5, step))
//                                }
//                        )
//                    }
//                    
//                    Spacer()
//                    
//                    // عرض النتيجة إذا القرار غير مناسب
//                    if showResult {
//                        Text(finalDecision)
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(averageScore >= 3 ? .green : .red)
//                            .padding()
//                    }
//                    
//                    Button(action: {
//                        saveScoreAndAdvance()
//                    }) {
//                        Text("Next")
//                            .foregroundColor(Color(red: 1.0, green: 0.455, blue: 0.447))
//                            .font(.title3)
//                            .padding(.bottom, 40)
//                            .padding(.leading, 290)
//                    }
//                    
//                    // NavigationLink مخفي للتنقل
//                    NavigationLink(
//                        destination: CompletionView().environmentObject(viewModel),
//                        isActive: $goToCompletion
//                    ) {
//                        EmptyView()
//                    }
//                    .hidden()
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Back")
//                                .foregroundColor(Color(red: 1.0, green: 0.455, blue: 0.447))
//                                .font(.title3)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - النص الثابت + نص المستخدم
//    func getCurrentText() -> String {
//        guard viewModel.details.indices.contains(viewModel.currentIndex) else { return "" }
//        let detail = viewModel.details[viewModel.currentIndex]
//        switch viewModel.currentScoreIndex {
//        case 0: return "How satisfied are you with: \(detail.pros)"
//        case 1: return "How satisfied are you with: \(detail.cons)"
//        case 2: return "How satisfied are you with: \(detail.offer)"
//        case 3: return "How satisfied are you with: \(detail.demand)"
//        case 4: return "How satisfied are you with: \(detail.in5Months)"
//        case 5: return "How satisfied are you with: \(detail.in5Years)"
//        default: return ""
//        }
//    }
//
//    // MARK: - حفظ الدرجة والتقدم
//    func saveScoreAndAdvance() {
//        guard viewModel.details.indices.contains(viewModel.currentIndex) else { return }
//        var detail = viewModel.details[viewModel.currentIndex]
//
//        switch viewModel.currentScoreIndex {
//        case 0: detail.prosScore = selectedOption
//        case 1: detail.consScore = selectedOption
//        case 2: detail.offerScore = selectedOption
//        case 3: detail.demandScore = selectedOption
//        case 4: detail.in5MonthsScore = selectedOption
//        case 5: detail.in5YearsScore = selectedOption
//        default: break
//        }
//
//        viewModel.details[viewModel.currentIndex] = detail
//
//        if viewModel.currentScoreIndex == 5 {
//            let scores = [detail.prosScore, detail.consScore, detail.offerScore,
//                          detail.demandScore, detail.in5MonthsScore, detail.in5YearsScore].compactMap { $0 }
//            averageScore = Double(scores.reduce(0, +)) / Double(scores.count)
//
//            if averageScore > 3 {
//                goToCompletion = true
//            } else {
//                finalDecision = "⚠️ القرار غير مناسب ❌"
//                showResult = true
//            }
//        } else {
//            viewModel.currentScoreIndex += 1
//            selectedOption = 3
//            dragValue = 3
//        }
//    }
//}
//
//#Preview {
//    heart().environmentObject(OptionsViewModel())
//}
//
//
