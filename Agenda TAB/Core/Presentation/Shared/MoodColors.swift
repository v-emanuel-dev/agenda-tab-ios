import SwiftUI

struct MoodColors {
    static let happy = Color(red: 76/255, green: 175/255, blue: 80/255)
    static let calm = Color(red: 33/255, green: 150/255, blue: 243/255)
    static let anxious = Color(red: 255/255, green: 152/255, blue: 0/255)
    static let depressed = Color(red: 244/255, green: 67/255, blue: 54/255)
    static let defaultColor = Color(red: 189/255, green: 189/255, blue: 189/255)
    
    static func color(for mood: Mood) -> Color {
        switch mood {
        case .happy: return happy
        case .calm: return calm
        case .anxious: return anxious
        case .depressed: return depressed
        }
    }
    
    static var allMoodColors: [(Mood, Color)] {
        [
            (.happy, happy),
            (.calm, calm),
            (.anxious, anxious),
            (.depressed, depressed)
        ]
    }
}
