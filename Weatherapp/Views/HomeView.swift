//
//  HomeView.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedCity: String = "Toronto" // Default City
    @State private var searchText: String = "" // Search bar input

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // Title
                Text("❄️ Weather App ❄️")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Spacer()
                
                

                // Buttons
                NavigationLink(destination: AboutUsView()) {
                    buttonView(text: "About Us 👩🏻‍💻")
                }

                NavigationLink(destination: SavedLocationsView()) {
                    buttonView(text: "Saved Location 📍")
                }

                NavigationLink(destination: CurrentWeatherView(city: selectedCity)) {
                    buttonView(text: "Current Weather 🌞")
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all)) // Light purple background
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    // MARK: - Reusable Button UI
    private func buttonView(text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.title2)
            .cornerRadius(12)
            .padding(.horizontal, 50)
    }
}

#Preview {
    HomeView()
}
