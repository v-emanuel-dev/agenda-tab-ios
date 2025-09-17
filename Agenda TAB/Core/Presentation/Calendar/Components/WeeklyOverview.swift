import SwiftUI

struct WeeklyOverview: View {
    let dailyEntries: [Date: DailyEntry]
    let onDayClick: (Date) -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Esta Semana")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            LazyVStack(spacing: 8) {
                ForEach(currentWeekDays, id: \.self) { date in
                    WeekDayCard(
                        date: date,
                        entry: dailyEntries[calendar.startOfDay(for: date)],
                        isToday: calendar.isDateInToday(date),
                        onClick: { onDayClick(date) }
                    )
                }
            }
        }
    }
    
    private var currentWeekDays: [Date] {
        let today = Date()
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today)
        guard let startOfWeek = weekInterval?.start else { return [] }
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
}

struct WeekDayCard: View {
    let date: Date
    let entry: DailyEntry?
    let isToday: Bool
    let onClick: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 16) {
                // Date info
                VStack(alignment: .leading, spacing: 2) {
                    Text(date.formatted(.dateTime.weekday(.abbreviated)))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(textColor)
                    
                    Text(date.formatted(.dateTime.day().month(.abbreviated)))
                        .font(.caption2)
                        .foregroundColor(subtextColor)
                    
                    if isToday {
                        Text("Hoje")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 60, alignment: .leading)
                
                // Mood and note info
                VStack(alignment: .leading, spacing: 4) {
                    if let entry = entry {
                        Text(entry.mood.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(isToday ? .white : MoodColors.color(for: entry.mood))
                        
                        if !entry.note.isEmpty {
                            Text(entry.note)
                                .font(.caption2)
                                .foregroundColor(isToday ? .white : .secondary)
                                .lineLimit(2)
                        }
                    } else {
                        Text("Nenhum humor registrado")
                            .font(.caption2)
                            .italic()
                            .foregroundColor(subtextColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Mood indicator
                Circle()
                    .fill(moodColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(entry?.mood.emoji ?? "❓")
                            .font(.title3)
                    )
            }
            .padding(16)
            .background(cardBackgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isToday ? Color.gray : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var cardBackgroundColor: Color {
        if isToday {
            return Color(red: 26/255, green: 21/255, blue: 18/255) // Dark brown for today
        } else if let entry = entry {
            return MoodColors.color(for: entry.mood).opacity(0.1)
        } else {
            return Color(.systemBackground)
        }
    }
    
    private var textColor: Color {
        isToday ? .white : .primary
    }
    
    private var subtextColor: Color {
        isToday ? .white : .secondary
    }
    
    private var moodColor: Color {
        if let entry = entry {
            return MoodColors.color(for: entry.mood)
        } else {
            return Color.secondary
        }
    }
}
