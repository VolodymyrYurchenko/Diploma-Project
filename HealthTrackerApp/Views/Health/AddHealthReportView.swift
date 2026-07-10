import SwiftUI

struct AddHealthReportView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var healthReportService: HealthReportService
    
    @State private var weight = ""
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var heartRate = ""
    @State private var steps = ""
    @State private var caloriesBurned = ""
    @State private var sleepHours = ""
    @State private var selectedMood: HealthReport.Mood = .normal
    @State private var notes = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Форма звіту
                    VStack(spacing: 15) {
                        // Вага
                        HStack {
                            Image(systemName: "scalemass.fill")
                                .foregroundColor(.gray)
                            Text("Вага")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Вага (кг)", text: $weight)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Тиск
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.gray)
                            Text("Тиск")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Верхній тиск", text: $systolic)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                            Text("/")
                            TextField("Нижній тиск", text: $diastolic)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Пульс
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .foregroundColor(.gray)
                            Text("Пульс")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Пульс (уд/хв)", text: $heartRate)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Кроки
                        HStack {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.gray)
                            Text("Кроки")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Кількість кроків", text: $steps)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Спалені калорії
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.gray)
                            Text("Калорії")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Спалені калорії", text: $caloriesBurned)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Сон
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.gray)
                            Text("Сон")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("Тривалість сну (год)", text: $sleepHours)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Настрій
                        HStack {
                            Image(systemName: "face.smiling")
                                .foregroundColor(.gray)
                            Text("Настрій")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Picker("Настрій", selection: $selectedMood) {
                            ForEach(HealthReport.Mood.allCases, id: \.self) { mood in
                                Text(mood.rawValue).tag(mood)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Нотатки
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.gray)
                            Text("Нотатки")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        TextField("Нотатки", text: $notes, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .frame(minHeight: 100)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }
                        
                        // Кнопка збереження
                        Button(action: {
                            saveReport()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Зберегти звіт")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .disabled(isLoading)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                }
            }
            .navigationTitle("Новий звіт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveReport() {
        isLoading = true
        errorMessage = ""
        
        // Валідація ваги
        guard let weightValue = Double(weight), weightValue > 0 else {
            errorMessage = "Будь ласка, введіть коректну вагу"
            isLoading = false
            return
        }
        
        guard weightValue >= 20 && weightValue <= 300 else {
            errorMessage = "Вага повинна бути від 20 до 300 кг"
            isLoading = false
            return
        }
        
        // Валідація тиску
        guard let systolicValue = Int(systolic), systolicValue > 0,
              let diastolicValue = Int(diastolic), diastolicValue > 0 else {
            errorMessage = "Будь ласка, введіть коректний тиск"
            isLoading = false
            return
        }
        
        guard systolicValue >= 70 && systolicValue <= 250 else {
            errorMessage = "Верхній тиск повинен бути від 70 до 250 мм рт.ст."
            isLoading = false
            return
        }
        
        guard diastolicValue >= 40 && diastolicValue <= 150 else {
            errorMessage = "Нижній тиск повинен бути від 40 до 150 мм рт.ст."
            isLoading = false
            return
        }
        
        guard systolicValue > diastolicValue else {
            errorMessage = "Верхній тиск повинен бути більшим за нижній"
            isLoading = false
            return
        }
        
        // Валідація пульсу
        guard let heartRateValue = Int(heartRate), heartRateValue > 0 else {
            errorMessage = "Будь ласка, введіть коректний пульс"
            isLoading = false
            return
        }
        
        guard heartRateValue >= 30 && heartRateValue <= 220 else {
            errorMessage = "Пульс повинен бути від 30 до 220 ударів за хвилину"
            isLoading = false
            return
        }
        
        // Валідація кроків
        guard let stepsValue = Int(steps), stepsValue >= 0 else {
            errorMessage = "Будь ласка, введіть коректну кількість кроків"
            isLoading = false
            return
        }
        
        guard stepsValue <= 100000 else {
            errorMessage = "Кількість кроків не може перевищувати 100 000"
            isLoading = false
            return
        }
        
        // Валідація калорій
        guard let caloriesValue = Int(caloriesBurned), caloriesValue >= 0 else {
            errorMessage = "Будь ласка, введіть коректну кількість калорій"
            isLoading = false
            return
        }
        
        guard caloriesValue <= 10000 else {
            errorMessage = "Кількість спалених калорій не може перевищувати 10 000"
            isLoading = false
            return
        }
        
        // Валідація сну
        guard let sleepValue = Double(sleepHours), sleepValue >= 0 else {
            errorMessage = "Будь ласка, введіть коректну тривалість сну"
            isLoading = false
            return
        }
        
        guard sleepValue <= 24 else {
            errorMessage = "Тривалість сну не може перевищувати 24 години"
            isLoading = false
            return
        }
        
        let report = HealthReport(
            id: UUID().uuidString,
            userId: authManager.currentUser?.id ?? "",
            date: Date(),
            weight: weightValue,
            bloodPressure: HealthReport.BloodPressure(systolic: systolicValue, diastolic: diastolicValue),
            heartRate: heartRateValue,
            steps: stepsValue,
            caloriesBurned: caloriesValue,
            sleepHours: sleepValue,
            mood: selectedMood,
            notes: notes
        )
        
        healthReportService.addReport(report)
        isLoading = false
        dismiss()
    }
}

#Preview {
    AddHealthReportView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HealthReportService())
} 