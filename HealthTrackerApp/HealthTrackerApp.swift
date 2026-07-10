import SwiftUI

// Константи для повідомлень про помилки
private enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case wrongPassword
    case userExists
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Неправильний формат електронної пошти"
        case .invalidPassword:
            return "Пароль повинен містити щонайменше 6 символів"
        case .userNotFound:
            return "Користувача з такою поштою не знайдено"
        case .wrongPassword:
            return "Неправильний пароль"
        case .userExists:
            return "Користувач з такою поштою вже існує"
        case .emptyName:
            return "Будь ласка, введіть ім'я"
        }
    }
}

@main
struct HealthTrackerApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    // Тимчасове зберігання користувачів (в реальному додатку використовуйте базу даних)
    private var users: [String: (password: String, user: User)] = [:]
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard isValidEmail(email) else {
            completion(AuthError.invalidEmail)
            return
        }
        
        guard password.count >= 6 else {
            completion(AuthError.invalidPassword)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let userData = self.users[email] else {
                completion(AuthError.userNotFound)
                return
            }
            
            guard userData.password == password else {
                completion(AuthError.wrongPassword)
                return
            }
            
            self.currentUser = userData.user
            self.isAuthenticated = true
            completion(nil)
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard !name.isEmpty else {
            completion(AuthError.emptyName)
            return
        }
        
        guard isValidEmail(email) else {
            completion(AuthError.invalidEmail)
            return
        }
        
        guard password.count >= 6 else {
            completion(AuthError.invalidPassword)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard self.users[email] == nil else {
                completion(AuthError.userExists)
                return
            }
            
            let newUser = User(id: UUID().uuidString, email: email, name: name)
            self.users[email] = (password: password, user: newUser)
            self.currentUser = newUser
            self.isAuthenticated = true
            completion(nil)
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
} 