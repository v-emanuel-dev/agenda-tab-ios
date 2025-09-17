import SwiftUI

struct DayDetailsCard: View {
    let date: Date
    let entry: DailyEntry?
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if Calendar.current.isDateInToday(date) {
                        Text("Hoje")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            if let entry = entry {
                DayWithMoodContent(entry: entry, onEdit: onEdit, onDelete: onDelete)
            } else {
                DayWithoutMoodContent(onEdit: onEdit)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(radius: 8)
        )
        .padding(8)
    }
    
    private var backgroundColor: Color {
        if let entry = entry {
            return MoodColors.color(for: entry.mood).opacity(0.03)
        } else {
            return Color(.systemBackground)
        }
    }
}

struct DayWithMoodContent: View {
    let entry: DailyEntry
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Mood display
            VStack(spacing: 16) {
                Circle()
                    .fill(MoodColors.color(for: entry.mood))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(entry.mood.emoji)
                            .font(.system(size: 40))
                    )
                
                Text(entry.mood.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(MoodColors.color(for: entry.mood))
            }
            
            // Note display
            if !entry.note.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Anotação:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(entry.note)
                        .font(.body)
                        .padding(16)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(12)
                        .frame(maxHeight: 200)
                }
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: onEdit) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Editar Entrada")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(MoodColors.color(for: entry.mood))
                
                Button(action: onDelete) {
                    Text("Excluir")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
    }
}

struct DayWithoutMoodContent: View {
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            // Empty state
            VStack(spacing: 24) {
                Button(action: onEdit) {
                    Circle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Text("📝")
                                .font(.system(size: 48))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(spacing: 12) {
                    Text("Nenhum humor registrado")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Registre como você se sentiu neste dia")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Add entry button
            Button(action: onEdit) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Registrar Humor")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
