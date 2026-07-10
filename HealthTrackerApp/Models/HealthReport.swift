import Foundation

struct HealthReport: Identifiable, Codable {
    let id: String
    let userId: String
    let date: Date
    let weight: Double
    let bloodPressure: BloodPressure
    let heartRate: Int
    let steps: Int
    let caloriesBurned: Int
    let sleepHours: Double
    let mood: Mood
    let notes: String
    
    struct BloodPressure: Codable {
        let systolic: Int
        let diastolic: Int
    }
    
    enum Mood: String, Codable, CaseIterable {
        case excellent = "Відмінно"
        case good = "Добре"
        case normal = "Нормально"
        case bad = "Погано"
        case terrible = "Жахливо"
    }
}

class HealthReportService: ObservableObject {
    @Published var reports: [HealthReport] = []
    private let userDefaults = UserDefaults.standard
    private let reportsKey = "healthReports"
    
    init() {
        loadReports()
    }
    
    func addReport(_ report: HealthReport) {
        reports.append(report)
        saveReports()
    }
    
    func deleteReport(_ report: HealthReport) {
        reports.removeAll { $0.id == report.id }
        saveReports()
    }
    
    func getReports(for userId: String) -> [HealthReport] {
        return reports.filter { $0.userId == userId }
    }
    
    func generateReport(for userId: String, from startDate: Date, to endDate: Date) -> [HealthReport] {
        return reports.filter { 
            $0.userId == userId && 
            $0.date >= startDate && 
            $0.date <= endDate 
        }
    }
    
    private func loadReports() {
        if let data = userDefaults.data(forKey: reportsKey),
           let decodedReports = try? JSONDecoder().decode([HealthReport].self, from: data) {
            reports = decodedReports
        }
    }
    
    private func saveReports() {
        if let encodedData = try? JSONEncoder().encode(reports) {
            userDefaults.set(encodedData, forKey: reportsKey)
        }
    }
} 