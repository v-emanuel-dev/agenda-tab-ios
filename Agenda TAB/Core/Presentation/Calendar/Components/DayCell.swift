import SwiftUI

struct DayCell: View {
    let date: Date
    let entry: DailyEntry?
    let isCurrentMonth: Bool
    let onClick: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(width: 48, height: 48)
                
                if let entry = entry {
                    VStack(spacing: 2) {
                        Text(entry.mood.emoji)
                            .font(.title3)
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.caption)
                            .fontWeight(isToday ? .bold : .regular)
                            .foregroundColor(textColor)
                    }
                } else {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.body)
                        .fontWeight(isToday ? .bold : .regular)
                        .foregroundColor(textColor)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if let entry = entry {
            return MoodColors.color(for: entry.mood)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if isToday {
            return Color.red
        } else if isCurrentMonth {
            return Color.black
        } else {
            return Color.gray
        }
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
}
