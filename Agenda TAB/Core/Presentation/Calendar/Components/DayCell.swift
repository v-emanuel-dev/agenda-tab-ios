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
            return MoodColors.defaultColor
        }
    }
    
    private var textColor: Color {
        if isToday {
            return Color(red: 139/255, green: 0, blue: 0) // Dark red for today
        } else if isCurrentMonth {
            return .black
        } else {
            return .gray
        }
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
}
