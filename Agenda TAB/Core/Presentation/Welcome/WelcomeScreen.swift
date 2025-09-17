import SwiftUI

struct WelcomeScreen: View {
    let onGetStarted: () -> Void
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var showContent = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if showContent {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header with skip button
                            HStack {
                                Spacer()
                                Button("Pular", action: onGetStarted)
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.top, 16)
                            
                            // Step indicator
                            stepIndicatorView
                            
                            // Main content
                            Group {
                                switch viewModel.currentStep {
                                case 0: WelcomeHeaderView()
                                case 1: AppIntroductionView()
                                case 2: MoodTrackingExplanationView()
                                default: GetStartedSectionView(onGetStarted: onGetStarted)
                                }
                            }
                            .frame(minHeight: geometry.size.height * 0.6)
                            
                            Spacer()
                            
                            // Progress indicators
                            progressIndicatorsView
                            
                            // Navigation buttons
                            navigationButtonsView
                        }
                        .padding(24)
                    }
                    .transition(.opacity.combined(with: .slide))
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.1),
                    Color.clear,
                    Color.secondary.opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showContent = true
            }
        }
    }
    
    private var stepIndicatorView: some View {
        VStack(spacing: 4) {
            Text("\(viewModel.currentStep + 1) de 4")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(stepTitle)
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var stepTitle: String {
        switch viewModel.currentStep {
        case 0: return "Boas-vindas"
        case 1: return "Recursos"
        case 2: return "Como usar"
        default: return "Começar"
        }
    }
    
    private var progressIndicatorsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                StepIndicator(
                    isActive: index <= viewModel.currentStep,
                    isCompleted: index < viewModel.currentStep,
                    onClick: { viewModel.setStep(index) }
                )
            }
        }
        .padding(16)
    }
    
    private var navigationButtonsView: some View {
        HStack(spacing: 16) {
            if viewModel.currentStep > 0 {
                Button("Anterior") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.previousStep()
                    }
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            } else {
                Spacer()
            }
            
            if viewModel.currentStep < 3 {
                Button("Próximo") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.nextStep()
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            } else {
                Button("Começar") {
                    onGetStarted()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 32)
    }
}

struct WelcomeHeaderView: View {
    var body: some View {
        VStack(spacing: 24) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                        center: .center,
                        startRadius: 10,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Text("📝")
                        .font(.system(size: 48))
                )
            
            Text("Bem-vindo ao Agenda TAB")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Sua jornada de autoconhecimento emocional começa aqui")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
}

struct AppIntroductionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("💫")
                .font(.system(size: 64))
            
            Text("Conheça seu bem-estar emocional")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                FeatureItem(
                    icon: "📅",
                    title: "Calendário Visual",
                    description: "Veja seus humores em um calendário colorido e intuitivo"
                )
                
                FeatureItem(
                    icon: "📊",
                    title: "Visão Semanal",
                    description: "Acompanhe tendências e padrões em seus registros"
                )
                
                FeatureItem(
                    icon: "🔒",
                    title: "Privacidade Total",
                    description: "Seus dados ficam apenas no seu dispositivo"
                )
            }
            .padding(.top, 16)
        }
    }
}

struct MoodTrackingExplanationView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Como funciona o registro de humor")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Registre como você se sente todos os dias escolhendo entre os humores disponíveis e adicionando suas anotações pessoais.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            HStack(spacing: 16) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    MoodExample(mood: mood)
                }
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 8) {
                Text("💡 Dica: Registre seu humor sempre no mesmo horário para criar um hábito saudável!")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(16)
            }
        }
    }
}

struct GetStartedSectionView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🚀")
                .font(.system(size: 64))
            
            Text("Tudo pronto!")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Você está pronto para começar sua jornada de autoconhecimento. Vamos registrar seu primeiro humor?")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct MoodExample: View {
    let mood: Mood
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(MoodColors.color(for: mood))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(mood.emoji)
                        .font(.title2)
                )
            
            Text(mood.displayName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StepIndicator: View {
    let isActive: Bool
    let isCompleted: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
                .scaleEffect(isActive ? 1.2 : 1.0)
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 8, height: 8)
                        .opacity(isActive || isCompleted ? 1 : 0)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
    }
    
    private var color: Color {
        if isCompleted {
            return .accentColor
        } else if isActive {
            return .accentColor.opacity(0.6)
        } else {
            return Color.secondary.opacity(0.3)
        }
    }
}
