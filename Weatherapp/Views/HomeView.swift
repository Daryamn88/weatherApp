//
//  HomeView.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import SwiftUI

struct HomeView: View {
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
                    Text("About Us 👩🏻‍💻")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.title2)
                        .cornerRadius(12)
                        .padding(.horizontal, 50)
                }

                NavigationLink(destination: SavedLocationsView()) {
                    Text("Saved Location 📍")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.title2)
                        .cornerRadius(12)
                        .padding(.horizontal, 50)
                }

                NavigationLink(destination: CurrentWeatherView()) {
                    Text("Current Weather 🌞")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.title2)
                        .cornerRadius(12)
                        .padding(.horizontal, 50)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all)) // Light purple background
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
