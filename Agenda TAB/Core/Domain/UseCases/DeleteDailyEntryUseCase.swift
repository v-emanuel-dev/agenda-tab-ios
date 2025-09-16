import Foundation

class DeleteDailyEntryUseCase {
    private let repository: MoodRepository
    
    init(repository: MoodRepository) {
        self.repository = repository
    }
    
    func execute(for date: Date) async throws {
        try await repository.deleteDailyEntry(for: date)
    }
}
