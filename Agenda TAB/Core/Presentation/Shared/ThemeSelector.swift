import SwiftUI

struct ThemeSelector: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Configurações de Tema")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 16)
                
                VStack(spacing: 16) {
                    ThemeOption(
                        title: "Tema Claro",
                        emoji: "☀️",
                        selected: themeManager.themeMode == .light,
                        onClick: { themeManager.setTheme(.light) }
                    )
                    
                    ThemeOption(
                        title: "Tema Escuro",
                        emoji: "🌙",
                        selected: themeManager.themeMode == .dark,
                        onClick: { themeManager.setTheme(.dark) }
                    )
                    
                    ThemeOption(
                        title: "Seguir Sistema",
                        emoji: "⚙️",
                        selected: themeManager.themeMode == .system,
                        onClick: { themeManager.setTheme(.system) }
                    )
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    Button("Salvar") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 32)
            }
            .padding(24)
            .navigationBarHidden(true)
        }
    }
}

struct ThemeOption: View {
    let title: String
    let emoji: String
    let selected: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.title2)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(selected ? .accentColor : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selected ? .accentColor : .secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
