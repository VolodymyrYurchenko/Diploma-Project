import SwiftUI
import HealthKit

struct OnboardingView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showHealthKitAlert = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppStyle.gradient
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                            
                            Text("Health Tracker")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Track your health journey")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 50)
                        
                        // Registration Form
                        VStack(spacing: 20) {
                            TextField("Name", text: $viewModel.name)
                                .textFieldStyle(CustomTextFieldStyle())
                            
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .padding()
                        .healthCard()
                        
                        // Buttons
                        VStack(spacing: 15) {
                            Button(action: {
                                withAnimation {
                                    viewModel.createUser()
                                }
                            }) {
                                Text("Create Account")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppStyle.Button.primary)
                            }
                            
                            Button(action: {
                                viewModel.requestHealthKitAuthorization()
                            }) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                    Text("Connect with Apple Health")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppStyle.Button.secondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                isAnimating = true
            }
            .alert(isPresented: $showHealthKitAlert) {
                Alert(
                    title: Text("HealthKit Access"),
                    message: Text("Please grant access to HealthKit to track your health data."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    OnboardingView()
} 