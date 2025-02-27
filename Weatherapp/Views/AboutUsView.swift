//
//  AboutUsView.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🌤️ Weather App")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This app provides real-time weather updates, a 7-day forecast, and saved locations for easy access.")
                .padding(.bottom, 20)

            Text("✅ Features:")
                .font(.title2)
                .bold()

            VStack(alignment: .leading) {
                Text("• Real-time weather updates")
                Text("• 7-day forecast")
                Text("• Saved locations")
                Text("• Minimalist UI")
            }
            .padding(.leading)

            Text("👩‍💻 Developed by:")
                .font(.title2)
                .bold()

            Text("📌 Yasaman Mirvahabi Sabet – 101217770")
            Text("📌 Dorsa Mohammadi – 101397591")
            Text("📌 Darya Mansouri – 101394900")

            Spacer()
        }
        .padding()
        .navigationTitle("About Us")
    }
}

#Preview {
    AboutUsView()
}
