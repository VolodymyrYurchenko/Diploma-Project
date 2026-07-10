import SwiftUI

struct AppStyle {
    static let gradient = LinearGradient(
        colors: [Color.blue, Color.purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color.green, Color.blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(.systemBackground)
        .opacity(0.8)
        .blur(radius: 3)
    
    static let shadow = Color.black.opacity(0.2)
    
    struct Button {
        static let primary = AnyView(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppStyle.gradient)
        )
        
        static let secondary = AnyView(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppStyle.secondaryGradient)
        )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(color: AppStyle.shadow, radius: 2, x: 0, y: 1)
    }
}

struct HealthCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppStyle.cardBackground)
            .cornerRadius(20)
            .shadow(color: AppStyle.shadow, radius: 10, x: 0, y: 5)
    }
}

extension View {
    func healthCard() -> some View {
        modifier(HealthCard())
    }
} 