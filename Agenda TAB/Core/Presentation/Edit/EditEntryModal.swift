import SwiftUI

struct EditEntryModal: View {
    let date: Date
    let existingEntry: DailyEntry?
    let onSave: (DailyEntry) -> Void
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    @State private var selectedMood: Mood?
    @State private var noteText: String = ""
    
    init(date: Date, existingEntry: DailyEntry?, onSave: @escaping (DailyEntry) -> Void, onDelete: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.date = date
        self.existingEntry = existingEntry
        self.onSave = onSave
        self.onDelete = onDelete
        self.onDismiss = onDismiss
        
        self._selectedMood = State(initialValue: existingEntry?.mood)
        self._noteText = State(initialValue: existingEntry?.note ?? "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Date display
                    Text(date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // Mood selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Selecione o humor:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: 12) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                MoodButton(
                                    mood: mood,
                                    isSelected: selectedMood == mood,
                                    onClick: { selectedMood = mood }
                                )
                            }
                        }
                    }
                    
                    // Note input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Anotação:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("Como foi seu dia?", text: $noteText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(5...10)
                        
                        Text("\(noteText.count)/280 caracteres")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            guard let mood = selectedMood else { return }
                            let entry = DailyEntry(date: date, mood: mood, note: noteText)
                            onSave(entry)
                        }) {
                            Text(existingEntry != nil ? "Atualizar Entrada" : "Salvar Entrada")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedMood == nil)
                        
                        HStack(spacing: 12) {
                            Button("Cancelar", action: onDismiss)
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                            
                            if existingEntry != nil {
                                Button("Excluir", action: onDelete)
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(24)
            }
            .navigationTitle("Editar Entrada")
            .navigationBarItems(trailing: Button("Fechar", action: onDismiss))
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(MoodColors.color(for: mood))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Text(mood.emoji)
                            .font(.largeTitle)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.accentColor, lineWidth: isSelected ? 3 : 0)
                    )
                    .shadow(radius: isSelected ? 6 : 2)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
