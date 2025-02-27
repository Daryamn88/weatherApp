//
//  SavedLocationsView.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import SwiftUI

struct SavedLocationsView: View {
    @State private var savedCities: [String] = ["Toronto", "New York", "Los Angeles"] // Example data

    var body: some View {
        VStack {
            Text("Saved Locations 📍")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            List(savedCities, id: \.self) { city in
                NavigationLink(destination: CurrentWeatherView()) {
                    HStack {
                        Text(city)
                            .font(.title2)
                        Spacer()
                        Text("🌡️ 20°C") // Placeholder temperature
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Saved Locations")
    }
}

#Preview {
    SavedLocationsView()
}
