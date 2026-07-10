import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile header
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(authManager.currentUser?.name ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(authManager.currentUser?.email ?? "email@example.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.vertical, 10)
                }
                
                // Health goals
                Section(header: Text("Health Goals")) {
                    GoalRow(title: "Daily Steps", target: "10,000", current: "8,542")
                    GoalRow(title: "Water Intake", target: "2.5L", current: "1.8L")
                    GoalRow(title: "Sleep", target: "8h", current: "7.5h")
                }
                
                // Account settings
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Personal Information")) {
                        Label("Personal Information", systemImage: "person.fill")
                    }
                    NavigationLink(destination: Text("Health Data")) {
                        Label("Health Data", systemImage: "heart.fill")
                    }
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                }
                
                // App settings
                Section(header: Text("App")) {
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock.fill")
                    }
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle.fill")
                    }
                    NavigationLink(destination: Text("About")) {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }
                
                // Sign out button
                Section {
                    Button(action: {
                        authManager.signOut()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Text("Вийти з акаунту")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Профіль")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Text("Редагувати")
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
} 