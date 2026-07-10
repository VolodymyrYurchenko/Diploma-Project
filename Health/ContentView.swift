//
//  ContentView.swift
//  Health
//
//  Created by Вова Юрченко on 12.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        HealthDashboardView()
    }
}

#Preview {
    ContentView()
}
