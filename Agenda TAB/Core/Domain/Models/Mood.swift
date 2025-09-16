import Foundation

enum Mood: String, CaseIterable, Codable {
    case happy = "HAPPY"
    case calm = "CALM"
    case anxious = "ANXIOUS"
    case depressed = "DEPRESSED"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .anxious: return "😰"
        case .depressed: return "😔"
        }
    }
    
    var localizedName: String {
        switch self {
        case .happy: return NSLocalizedString("mood_happy", comment: "")
        case .calm: return NSLocalizedString("mood_calm", comment: "")
        case .anxious: return NSLocalizedString("mood_anxious", comment: "")
        case .depressed: return NSLocalizedString("mood_depressed", comment: "")
        }
    }
}
