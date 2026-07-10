import SwiftUI

struct HealthDashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    WelcomeHeader()
                    
                    VStack(spacing: 15) {
                        HealthSummaryCard(
                            title: "Today's Steps",
                            value: "8,542",
                            icon: "figure.walk",
                            color: .blue,
                            progress: 0.85
                        )
                        
                        HealthSummaryCard(
                            title: "Heart Rate",
                            value: "72 BPM",
                            icon: "heart.fill",
                            color: .red,
                            progress: 0.72
                        )
                        
                        HealthSummaryCard(
                            title: "Sleep",
                            value: "7.5 hrs",
                            icon: "moon.fill",
                            color: .purple,
                            progress: 0.94
                        )
                    }
                    .padding(.horizontal)
                    
                    QuickActionsView()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Health Dashboard")
        }
    }
}

struct WelcomeHeader: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Вітаємо,")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(authManager.currentUser?.name ?? "Користувач")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }
}

struct HealthSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let progress: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 60, height: 60)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct QuickActionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 20) {
                QuickActionButton(
                    title: "Add Meal",
                    icon: "plus.circle.fill",
                    color: .green
                )
                
                QuickActionButton(
                    title: "Log Workout",
                    icon: "figure.run",
                    color: .orange
                )
                
                QuickActionButton(
                    title: "Add Metric",
                    icon: "plus.circle.fill",
                    color: .blue
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .padding(15)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HealthDashboardView()
} 