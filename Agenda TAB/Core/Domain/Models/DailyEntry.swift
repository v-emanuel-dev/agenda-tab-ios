import Foundation

struct DailyEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mood: Mood
    let note: String
    
    init(date: Date, mood: Mood, note: String) {
        self.id = UUID()
        self.date = date
        self.mood = mood
        self.note = note
    }
}
