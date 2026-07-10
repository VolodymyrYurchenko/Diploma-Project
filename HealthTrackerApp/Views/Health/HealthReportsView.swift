import SwiftUI

struct HealthReportsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var healthReportService: HealthReportService
    @State private var showingAddReport = false
    @State private var selectedPeriod: Period = .week
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate = Date()
    
    enum Period: String, CaseIterable {
        case week = "Тиждень"
        case month = "Місяць"
        case year = "Рік"
        case custom = "Власний період"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Период вибору
                Picker("Період", selection: $selectedPeriod) {
                    ForEach(Period.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedPeriod == .custom {
                    DatePicker("З", selection: $startDate, displayedComponents: .date)
                        .padding(.horizontal)
                    DatePicker("По", selection: $endDate, displayedComponents: .date)
                        .padding(.horizontal)
                }
                
                // Список звітів
                List {
                    ForEach(filteredReports) { report in
                        HealthReportRow(report: report)
                    }
                    .onDelete { indexSet in
                        deleteReports(at: indexSet)
                    }
                }
            }
            .navigationTitle("Звіти про здоров'я")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddReport = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReport) {
                AddHealthReportView()
            }
            .onChange(of: selectedPeriod) { _ in
                updateDates()
            }
        }
    }
    
    private var filteredReports: [HealthReport] {
        let reports = healthReportService.getReports(for: authManager.currentUser?.id ?? "")
        return reports.filter { report in
            report.date >= startDate && report.date <= endDate
        }
        .sorted { $0.date > $1.date }
    }
    
    private func updateDates() {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            endDate = now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            endDate = now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            endDate = now
        case .custom:
            break
        }
    }
    
    private func deleteReports(at offsets: IndexSet) {
        let reports = filteredReports
        for index in offsets {
            let report = reports[index]
            healthReportService.deleteReport(report)
        }
    }
}

struct HealthReportRow: View {
    let report: HealthReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(report.date.formatted(date: .long, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(report.mood.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Вага: \(String(format: "%.1f", report.weight)) кг")
                    Text("Тиск: \(report.bloodPressure.systolic)/\(report.bloodPressure.diastolic)")
                    Text("Пульс: \(report.heartRate) уд/хв")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Кроки: \(report.steps)")
                    Text("Калорії: \(report.caloriesBurned)")
                    Text("Сон: \(String(format: "%.1f", report.sleepHours)) год")
                }
            }
            .font(.caption)
            
            if !report.notes.isEmpty {
                Text(report.notes)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HealthReportsView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HealthReportService())
} 