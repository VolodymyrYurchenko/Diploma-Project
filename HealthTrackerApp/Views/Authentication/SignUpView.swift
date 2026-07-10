import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фоновий градієнт
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Форма реєстрації
                        VStack(spacing: 15) {
                            // Поле імені
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("Ім'я", text: $name)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            // Поле email
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                TextField("Електронна пошта", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            // Поле паролю
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Пароль", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            // Поле підтвердження паролю
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Підтвердіть пароль", text: $confirmPassword)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top, 5)
                            }
                            
                            // Кнопка реєстрації
                            Button(action: {
                                isLoading = true
                                errorMessage = ""
                                
                                // Валідація полів
                                guard !name.isEmpty else {
                                    errorMessage = "Будь ласка, введіть ім'я"
                                    isLoading = false
                                    return
                                }
                                
                                guard !email.isEmpty else {
                                    errorMessage = "Будь ласка, введіть електронну пошту"
                                    isLoading = false
                                    return
                                }
                                
                                guard !password.isEmpty else {
                                    errorMessage = "Будь ласка, введіть пароль"
                                    isLoading = false
                                    return
                                }
                                
                                guard password == confirmPassword else {
                                    errorMessage = "Паролі не співпадають"
                                    isLoading = false
                                    return
                                }
                                
                                authManager.signUp(name: name, email: email, password: password) { error in
                                    isLoading = false
                                    if let error = error {
                                        errorMessage = error.localizedDescription
                                    } else {
                                        dismiss()
                                    }
                                }
                            }) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Зареєструватися")
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
            }
            .navigationTitle("Реєстрація")
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
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationManager())
} 