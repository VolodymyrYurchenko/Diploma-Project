import SwiftUI

struct NutritionView: View {
    @State private var selectedDate = Date()
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Date picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                // Daily nutrition summary
                DailyNutritionSummary()
                
                // Meal list
                MealListView()
            }
            .navigationTitle("Nutrition")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMeal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
            }
        }
    }
}

struct DailyNutritionSummary: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Daily Summary")
                .font(.headline)
            
            HStack(spacing: 20) {
                NutritionMetricView(title: "Calories", value: "1,850", target: "2,000")
                NutritionMetricView(title: "Protein", value: "75g", target: "100g")
                NutritionMetricView(title: "Carbs", value: "200g", target: "250g")
                NutritionMetricView(title: "Fat", value: "65g", target: "70g")
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding()
    }
}

struct NutritionMetricView: View {
    let title: String
    let value: String
    let target: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
            Text("of \(target)")
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct MealListView: View {
    var body: some View {
        List {
            MealRow(mealType: "Breakfast", time: "8:00 AM", calories: "450")
            MealRow(mealType: "Lunch", time: "12:30 PM", calories: "650")
            MealRow(mealType: "Dinner", time: "7:00 PM", calories: "750")
        }
    }
}

struct MealRow: View {
    let mealType: String
    let time: String
    let calories: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mealType)
                    .font(.headline)
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(calories) kcal")
                .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @State private var mealType = ""
    @State private var foodItems = ""
    @State private var calories = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Meal Type", text: $mealType)
                        .foregroundColor(.black)
                    TextField("Food Items", text: $foodItems)
                        .foregroundColor(.black)
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    // Save meal
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    NutritionView()
} 