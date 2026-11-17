import Foundation

/// Builds the greeting shown on the main screen.
nonisolated enum Greeting {
    /// Returns "Hello, world!" when `name` is nil or blank, otherwise "Hello, <name>!"
    /// with surrounding whitespace trimmed.
    static func message(for name: String?) -> String {
        let trimmed = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Hello, world!" : "Hello, \(trimmed)!"
    }
}
