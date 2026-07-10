import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var age = "30"
    @State private var height = "175"
    @State private var weight = "70"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                        .foregroundColor(.black)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.black)
                }
                
                Section(header: Text("Health Information")) {
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    // Save profile changes
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    EditProfileView()
} 