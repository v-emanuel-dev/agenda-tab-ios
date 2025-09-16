import SwiftUI

struct CalendarScreen: View {
    @StateObject private var viewModel: CalendarViewModel
    @State private var showThemeSelector = false
    @State private var showDatePicker = false
    @State private var showHintCard = false
    
    init(viewModel: CalendarViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                headerView
                
                // Tutorial hint card
                if showHintCard {
                    TutorialHintCard(
                        onShowTutorial: {
                            showHintCard = false
                            // Show welcome
                        },
                        onDismiss: { showHintCard = false }
                    )
                }
                
                // Day Details Card
                if viewModel.showDayDetailsCard, let selectedDate = viewModel.selectedDate {
                    DayDetailsCard(
                        date: selectedDate,
                        entry: viewModel.dailyEntries[Calendar.current.startOfDay(for: selectedDate)],
                        onEdit: { viewModel.onEditFromDetailsCard() },
                        onDelete: { viewModel.onEntryDeleted(selectedDate) },
                        onDismiss: { viewModel.onDayDetailsCardDismissed() }
                    )
                }
                
                // Calendar Grid
                CalendarGrid(
                    currentMonth: viewModel.currentMonth,
                    dailyEntries: viewModel.dailyEntries,
                    onDayClick: viewModel.onDaySelected
                )
                
                // Weekly Overview
                WeeklyOverview(
                    dailyEntries: viewModel.dailyEntries,
                    onDayClick: viewModel.onDaySelected
                )
                
                // Mood Legend
                MoodLegend()
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showEditModal) {
            if let selectedDate = viewModel.selectedDate {
                EditEntryModal(
                    date: selectedDate,
                    existingEntry: viewModel.dailyEntries[Calendar.current.startOfDay(for: selectedDate)],
                    onSave: viewModel.onEntryUpdated,
                    onDelete: { viewModel.onEntryDeleted(selectedDate) },
                    onDismiss: viewModel.onEditModalDismissed
                )
            }
        }
        .sheet(isPresented: $showThemeSelector) {
            ThemeSelector()
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerDialog(
                initialDate: viewModel.currentMonth,
                onDateSelected: viewModel.onMonthChanged
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                let calendar = Calendar.current
                let newMonth = calendar.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                viewModel.onMonthChanged(newMonth)
            }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Button(action: { showDatePicker = true }) {
                Text(viewModel.currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            HStack {
                Button(action: { showThemeSelector = true }) {
                    Image(systemName: "gearshape")
                }
                
                Button(action: {
                    let calendar = Calendar.current
                    let newMonth = calendar.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                    viewModel.onMonthChanged(newMonth)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}
