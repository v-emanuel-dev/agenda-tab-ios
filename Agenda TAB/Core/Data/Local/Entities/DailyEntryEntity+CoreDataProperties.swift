import Foundation
import CoreData

extension DailyEntryEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyEntryEntity> {
        return NSFetchRequest<DailyEntryEntity>(entityName: "DailyEntryEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var mood: String?
    @NSManaged public var note: String?
}

extension DailyEntryEntity: Identifiable {}
