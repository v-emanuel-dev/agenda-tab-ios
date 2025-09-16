import SwiftUI

struct MoodLegend: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cores dos Humores")
                .font(.headline)
                .fontWeight(.medium)
                .padding(.bottom, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MoodColors.allMoodColors, id: \.0) { mood, color in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(color)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(mood.emoji)
                                        .font(.caption)
                                )
                            
                            Text(mood.localizedName)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}
