import SwiftUI

struct TutorialHintCard: View {
    let onShowTutorial: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .foregroundColor(.accentColor)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Primeira vez usando o app?")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Veja nosso tutorial para aprender a usar todos os recursos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                Button("Ver Tutorial", action: onShowTutorial)
                    .font(.caption)
                    .buttonStyle(.bordered)
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(12)
    }
}
