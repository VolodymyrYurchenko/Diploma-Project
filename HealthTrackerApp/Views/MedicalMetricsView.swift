import SwiftUI

struct MedicalMetricsView: View {
    @State private var showingAddMetric = false
    @State private var selectedMetricType = "Blood Pressure"
    
    let metricTypes = ["Blood Pressure", "Heart Rate", "Blood Sugar", "Weight", "Sleep"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Metric type picker
                Picker("Metric Type", selection: $selectedMetricType) {
                    ForEach(metricTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Metric history
                MetricHistoryView(metricType: selectedMetricType)
                
                // Recommendations
                RecommendationsView()
            }
            .navigationTitle("Health Metrics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMetric = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMetric) {
                AddMetricView(metricType: selectedMetricType)
            }
        }
    }
}

struct MetricHistoryView: View {
    let metricType: String
    
    var body: some View {
        VStack {
            // Metric chart
            MetricChartView()
            
            // Recent readings
            List {
                MetricReadingRow(value: "120/80", date: "Today", time: "8:00 AM")
                MetricReadingRow(value: "118/78", date: "Yesterday", time: "8:00 AM")
                MetricReadingRow(value: "122/82", date: "2 days ago", time: "8:00 AM")
            }
        }
    }
}

struct MetricChartView: View {
    var body: some View {
        VStack {
            Text("Last 7 Days")
                .font(.headline)
            
            // Placeholder for chart
            Rectangle()
                .fill(Color.blue.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    Text("Chart View")
                        .foregroundColor(.gray)
                )
                .cornerRadius(10)
                .padding()
        }
    }
}

struct MetricReadingRow: View {
    let value: String
    let date: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(value)
                    .font(.headline)
                Text("\(date) at \(time)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct RecommendationsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    RecommendationCard(
                        title: "Blood Pressure",
                        message: "Your blood pressure is within normal range. Keep up the good work!",
                        icon: "heart.fill",
                        color: .green
                    )
                    
                    RecommendationCard(
                        title: "Activity",
                        message: "Try to increase your daily steps by 2000 for better cardiovascular health.",
                        icon: "figure.walk",
                        color: .blue
                    )
                    
                    RecommendationCard(
                        title: "Sleep",
                        message: "Aim for 7-8 hours of sleep each night for optimal health.",
                        icon: "moon.fill",
                        color: .purple
                    )
                }
                .padding()
            }
        }
    }
}

struct RecommendationCard: View {
    let title: String
    let message: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 250)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct AddMetricView: View {
    @Environment(\.dismiss) var dismiss
    let metricType: String
    @State private var value = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Metric Details")) {
                    TextField("Value", text: $value)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.black)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Notes", text: $notes)
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Add \(metricType)")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    // Save metric
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    MedicalMetricsView()
} 