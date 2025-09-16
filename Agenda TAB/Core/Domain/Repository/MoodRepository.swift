import Foundation
import Combine

protocol MoodRepository {
    func getDailyEntry(for date: Date) async -> DailyEntry?
    func getDailyEntries(from startDate: Date, to endDate: Date) -> AnyPublisher<[DailyEntry], Error>
    func saveDailyEntry(_ entry: DailyEntry) async throws
    func deleteDailyEntry(for date: Date) async throws
}
