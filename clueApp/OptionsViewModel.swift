import SwiftUI

/// Shared state for all option pages
final class OptionsViewModel: ObservableObject {
    /// All the option titles (dynamic list)
    @Published var options: [String] = ["", ""]   // start with 2 slots

    /// Which option index is currently being edited (used in OptionTitleView)
    @Published var currentIndex: Int = 0

    // MARK: - Helpers

    /// Returns the current option number (1-based, for UI display)
    var currentOptionNumber: Int { currentIndex + 1 }

    /// Current option text safely
    func titleForCurrent() -> String {
        guard options.indices.contains(currentIndex) else { return "" }
        return options[currentIndex]
    }

    /// Update the current option
    func updateCurrentTitle(_ title: String) {
        if options.indices.contains(currentIndex) {
            options[currentIndex] = title
        } else {
            options.append(title)
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

    /// Move back if possible
    func goToPreviousOption() -> Bool {
        if currentIndex > 0 {
            currentIndex -= 1
            return true
        }
        return false
    }

    /// Is this the last option?
    var isLastOption: Bool {
        currentIndex == options.count - 1
    }

    /// Reset everything
    func reset() {
        options = ["", ""]   // always reset to 2 empty slots
        currentIndex = 0
    }
}
