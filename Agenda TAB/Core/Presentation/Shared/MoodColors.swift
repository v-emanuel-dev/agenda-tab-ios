import SwiftUI

struct MoodColors {
    static func color(for mood: Mood) -> Color {
        switch mood {
        case .happy: return Color.green
        case .calm: return Color.blue
        case .anxious: return Color.orange
        case .depressed: return Color.red
        }
    }
    
    // Adicione este método que está faltando:
    static var allMoodColors: [(Mood, Color)] {
        return [
            (.happy, color(for: .happy)),
            (.calm, color(for: .calm)),
            (.anxious, color(for: .anxious)),
            (.depressed, color(for: .depressed))
        ]
    }
}
