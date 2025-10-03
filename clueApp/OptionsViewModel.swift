import SwiftUI

struct OptionDetail: Identifiable, Equatable {
    let id = UUID()
    var label: String = ""
    var pros: String = ""
    var cons: String = ""
    var offer: String = ""
    var demand: String = ""
    var in5Months: String = ""
    var in5Years: String = ""
    // ✅ scoring counter
       var score: Int = 0
//        var prosScore: Int = 0
//    
    var prosScore: Int?
        var consScore: Int?
        var offerScore: Int?
        var demandScore: Int?
        var in5MonthsScore: Int?
        var in5YearsScore: Int?
    
    
}

let questions: [(title: String, keyPath: KeyPath<OptionDetail, String>)] = [
    ("What do you prefer?", \.pros),
    ("What can you tolerate?", \.cons),
    ("Which will you take?", \.offer),
    ("What demand can you meet?", \.demand),
    ("In 5 months?", \.in5Months),
    ("In 5 years?", \.in5Years)
]

/// Shared state for all option pages
final class OptionsViewModel: ObservableObject {
    
    @Published var currentScoreIndex: Int = 0 //wed 

    /// Still used by Shaking pages – do NOT remove
    @Published var options: [String] = ["", ""]

    /// Your per-option fields for the Cards page
    @Published var details: [OptionDetail] = [OptionDetail(), OptionDetail()]

    /// Which option index is being edited/viewed
    @Published var currentIndex: Int = 0

    // MARK: - Helpers

    var currentOptionNumber: Int { currentIndex + 1 }

    func titleForCurrent() -> String {
        guard options.indices.contains(currentIndex) else { return "" }
        return options[currentIndex]
        
        
        
    }

    /// Keep `details` length and labels matched to `options`
    func syncDetailsToOptions() {
        if details.count < options.count {
            details.append(contentsOf: Array(repeating: OptionDetail(), count: options.count - details.count))
        } else if details.count > options.count {
            details = Array(details.prefix(options.count))
        }
        for i in 0..<options.count {
            details[i].label = options[i]
        }
    }

    /// Update current option title and mirror it to details.label
    func updateCurrentTitle(_ title: String) {
        if options.indices.contains(currentIndex) {
            options[currentIndex] = title
            if details.indices.contains(currentIndex) {
                details[currentIndex].label = title
            }
        }
    }

    /// Move to the next option if possible
    func goToNextOption() -> Bool {
        if currentIndex < options.count - 1 {
            currentIndex += 1
            return true
        }
        return false
    }

    func goToPreviousOption() -> Bool {
        if currentIndex > 0 {
            currentIndex -= 1
            return true
        }
        return false
    }

    func reset() {
        options = ["", ""]
        details = [OptionDetail(), OptionDetail()]
        currentIndex = 0
    }
    
    // MARK: - ✅ New Scoring System
    
    /// Increment score for a given option index
    func incrementScore(for index: Int) {
        guard details.indices.contains(index) else { return }
        details[index].score += 1
    }
    
    /// Return option with highest score (if needed for results page)
    func winningOption() -> OptionDetail? {
        details.max(by: { $0.score < $1.score })
    }
}


