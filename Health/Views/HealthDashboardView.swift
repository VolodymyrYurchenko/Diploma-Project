import SwiftUI

struct HealthDashboardView: View {
    @StateObject private var viewModel = HealthViewModel()
    @State private var showingAddRecord = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppStyle.gradient
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 10) {
                            Text("Today's Progress")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text(Date().formatted(date: .long, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top)
                        
                        // Health Cards
                        VStack(spacing: 15) {
                            // Steps Card
                            HealthMetricCard(
                                title: "Steps",
                                value: "\(viewModel.steps)",
                                icon: "figure.walk",
                                color: .blue,
                                action: {
                                    viewModel.steps += 100
                                    viewModel.createHealthRecord()
                                }
                            )
                            
                            // Water Intake Card
                            HealthMetricCard(
                                title: "Water Intake",
                                value: "\(viewModel.waterIntake) ml",
                                icon: "drop.fill",
                                color: .blue,
                                action: {
                                    viewModel.waterIntake += 250
                                    viewModel.createHealthRecord()
                                }
                            )
                            
                            // Sleep Card
                            HealthMetricCard(
                                title: "Sleep",
                                value: String(format: "%.1f hours", viewModel.sleepHours),
                                icon: "moon.fill",
                                color: .purple,
                                action: {
                                    viewModel.sleepHours += 0.5
                                    viewModel.createHealthRecord()
                                }
                            )
                        }
                        .padding()
                        
                        // Add Record Button
                        Button(action: {
                            showingAddRecord = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Record")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppStyle.Button.primary)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchTodayRecord()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecord) {
                AddRecordView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchTodayRecord()
            }
        }
    }
}

struct HealthMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(value)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
        }
    }
}

struct AddRecordView: View {
    @ObservedObject var viewModel: HealthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Steps")) {
                    Stepper("\(viewModel.steps) steps", value: $viewModel.steps, in: 0...100000)
                }
                
                Section(header: Text("Water Intake")) {
                    Stepper("\(viewModel.waterIntake) ml", value: $viewModel.waterIntake, in: 0...5000, step: 250)
                }
                
                Section(header: Text("Sleep")) {
                    Stepper(String(format: "%.1f hours", viewModel.sleepHours),
                           value: $viewModel.sleepHours,
                           in: 0...24,
                           step: 0.5)
                }
            }
            .navigationTitle("Add Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.createHealthRecord()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HealthDashboardView()
} 