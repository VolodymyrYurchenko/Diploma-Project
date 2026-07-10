import SwiftUI

struct ActivityView: View {
    @State private var selectedDate = Date()
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Activity summary
                ActivitySummaryView()
                
                // Workout history
                WorkoutHistoryView()
            }
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddWorkout = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
            }
        }
    }
}

struct ActivitySummaryView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                ActivityMetricView(title: "Steps", value: "8,542", icon: "figure.walk")
                ActivityMetricView(title: "Distance", value: "5.2 km", icon: "map")
                ActivityMetricView(title: "Calories", value: "420", icon: "flame.fill")
            }
            .padding()
            
            // Activity rings
            ActivityRingsView()
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding()
    }
}

struct ActivityMetricView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ActivityRingsView: View {
    var body: some View {
        VStack {
            Text("Today's Activity")
                .font(.headline)
            
            HStack(spacing: 20) {
                ActivityRing(progress: 0.7, color: .red, title: "Move")
                ActivityRing(progress: 0.5, color: .green, title: "Exercise")
                ActivityRing(progress: 0.8, color: .blue, title: "Stand")
            }
        }
        .padding()
    }
}

struct ActivityRing: View {
    let progress: Double
    let color: Color
    let title: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 60, height: 60)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct WorkoutHistoryView: View {
    var body: some View {
        List {
            WorkoutRow(type: "Running", duration: "30 min", calories: "320", date: "Today")
            WorkoutRow(type: "Cycling", duration: "45 min", calories: "450", date: "Yesterday")
            WorkoutRow(type: "Walking", duration: "60 min", calories: "280", date: "2 days ago")
        }
    }
}

struct WorkoutRow: View {
    let type: String
    let duration: String
    let calories: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(type)
                    .font(.headline)
                Spacer()
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text(duration)
                    .font(.subheadline)
                Spacer()
                Text("\(calories) kcal")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var workoutType = ""
    @State private var duration = ""
    @State private var calories = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Type", text: $workoutType)
                        .foregroundColor(.black)
                    TextField("Duration (minutes)", text: $duration)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                    TextField("Calories Burned", text: $calories)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                    TextField("Notes", text: $notes)
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    // Save workout
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    ActivityView()
} 