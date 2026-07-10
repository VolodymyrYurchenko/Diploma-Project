import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
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
                
                VStack(spacing: 30) {
                    // Логотип та заголовок
                    VStack(spacing: 15) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Здоров'я")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .padding(.top, 50)
                    
                    // Форма входу
                    VStack(spacing: 20) {
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
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }
                        
                        // Кнопка входу
                        Button(action: {
                            isLoading = true
                            errorMessage = ""
                            
                            // Валідація полів
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
                            
                            authManager.signIn(email: email, password: password) { error in
                                isLoading = false
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Увійти")
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
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 30)
                    
                    // Кнопка реєстрації
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Немає облікового запису? Зареєструватися")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
} 