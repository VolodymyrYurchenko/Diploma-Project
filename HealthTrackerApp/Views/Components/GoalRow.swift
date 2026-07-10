import SwiftUI

struct GoalRow: View {
    let title: String
    let target: String
    let current: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(current) / \(target)")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    GoalRow(title: "Daily Steps", target: "10,000", current: "8,542")
} 