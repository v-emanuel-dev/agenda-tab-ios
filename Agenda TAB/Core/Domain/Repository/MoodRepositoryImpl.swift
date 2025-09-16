import CoreData
import Foundation
import Combine

class MoodRepositoryImpl: MoodRepository {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func getDailyEntry(for date: Date) async -> DailyEntry? {
        let request: NSFetchRequest<DailyEntryEntity> = DailyEntryEntity.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        
        do {
            let entities = try coreDataStack.context.fetch(request)
            return entities.first?.toDomainModel()
        } catch {
            return nil
        }
    }
    
    func getDailyEntries(from startDate: Date, to endDate: Date) -> AnyPublisher<[DailyEntry], Error> {
        let request: NSFetchRequest<DailyEntryEntity> = DailyEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DailyEntryEntity.date, ascending: true)]
        
        return Future { promise in
            do {
                let entities = try self.coreDataStack.context.fetch(request)
                let entries = entities.compactMap { $0.toDomainModel() }
                promise(.success(entries))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveDailyEntry(_ entry: DailyEntry) async throws {
        let context = coreDataStack.context
        
        // Check if entry already exists
        let request: NSFetchRequest<DailyEntryEntity> = DailyEntryEntity.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: entry.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        let existingEntities = try context.fetch(request)
        let entity = existingEntities.first ?? DailyEntryEntity(context: context)
        
        entity.fromDomainModel(entry)
        coreDataStack.save()
    }
    
    func deleteDailyEntry(for date: Date) async throws {
        let context = coreDataStack.context
        let request: NSFetchRequest<DailyEntryEntity> = DailyEntryEntity.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        let entities = try context.fetch(request)
        entities.forEach { context.delete($0) }
        coreDataStack.save()
    }
}
