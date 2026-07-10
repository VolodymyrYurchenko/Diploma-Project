import Foundation
import CoreData
import SwiftUI

class HealthViewModel: ObservableObject {
    @Published var steps: Int = 0
    @Published var waterIntake: Int = 0
    @Published var sleepHours: Double = 0.0
    @Published var currentUser: User?
    
    private let context = CoreDataManager.shared.context
    
    func createHealthRecord() {
        guard let user = currentUser else { return }
        
        let record = HealthRecord(context: context)
        record.id = UUID()
        record.date = Date()
        record.steps = Int32(steps)
        record.waterIntake = Int32(waterIntake)
        record.sleepHours = sleepHours
        record.user = user
        
        saveContext()
    }
    
    func fetchTodayRecord() {
        guard let user = currentUser else { return }
        
        let request: NSFetchRequest<HealthRecord> = HealthRecord.fetchRequest()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        request.predicate = NSPredicate(format: "user == %@ AND date >= %@ AND date < %@",
                                      user, today as NSDate, tomorrow as NSDate)
        
        do {
            let records = try context.fetch(request)
            if let record = records.first {
                steps = Int(record.steps)
                waterIntake = Int(record.waterIntake)
                sleepHours = record.sleepHours
            }
        } catch {
            print("Failed to fetch health record: \(error)")
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
} 