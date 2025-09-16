import Foundation

struct DailyEntry: Identifiable, Codable, Equatable {
    let id = UUID()
    let date: Date
    let mood: Mood
    let note: String
    
    init(date: Date, mood: Mood, note: String) {
        self.date = date
        self.mood = mood
        self.note = note
    }
}
