import Foundation
import Combine

class GetDailyEntriesUseCase {
    private let repository: MoodRepository
    
    init(repository: MoodRepository) {
        self.repository = repository
    }
    
    func execute(from startDate: Date, to endDate: Date) -> AnyPublisher<[DailyEntry], Error> {
        repository.getDailyEntries(from: startDate, to: endDate)
    }
}
