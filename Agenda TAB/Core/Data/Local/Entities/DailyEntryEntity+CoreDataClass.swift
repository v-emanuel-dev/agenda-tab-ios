import CoreData
import Foundation

@objc(DailyEntryEntity)
public class DailyEntryEntity: NSManagedObject {
    
    func toDomainModel() -> DailyEntry? {
        guard let dateValue = date,
              let moodString = mood,
              let mood = Mood(rawValue: moodString),
              let noteValue = note else {
            return nil
        }
        
        return DailyEntry(
            date: dateValue,
            mood: mood,
            note: noteValue
        )
    }
    
    func fromDomainModel(_ entry: DailyEntry) {
        self.date = entry.date
        self.mood = entry.mood.rawValue
        self.note = entry.note
    }
}
