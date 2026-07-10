import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var healthReportService = HealthReportService()
    
    var body: some View {
        TabView {
            HealthDashboardView()
                .environmentObject(authManager)
                .tabItem {
                    Label("Активність", systemImage: "figure.walk")
                }
            
            HealthReportsView()
                .environmentObject(authManager)
                .environmentObject(healthReportService)
                .tabItem {
                    Label("Звіти", systemImage: "chart.bar.doc.horizontal")
                }
            
            ProfileView()
                .environmentObject(authManager)
                .tabItem {
                    Label("Профіль", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationManager())
}