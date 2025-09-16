import Foundation

class SaveDailyEntryUseCase {
    private let repository: MoodRepository
    
    init(repository: MoodRepository) {
        self.repository = repository
    }
    
    func execute(_ entry: DailyEntry) async throws {
        try await repository.saveDailyEntry(entry)
    }
}
