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
    
    var displayName: String {
        switch self {
        case .happy: return "Feliz"
        case .calm: return "Calmo"
        case .anxious: return "Ansioso"
        case .depressed: return "Triste"
        }
    }
}
