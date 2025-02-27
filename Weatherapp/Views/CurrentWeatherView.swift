//
//  CurrentWeatherView.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    private let weatherService = WeatherService()

    @State private var cityName: String = "Loading..."
    @State private var temperature: String = "..."
    @State private var weatherCondition: String = "..."
    @State private var forecast: [(day: String, high: String, low: String)] = []

    var body: some View {
        VStack {
            // Weather Info
            VStack {
                Text(cityName)
                    .font(.title)
                    .bold()
                
                Text("Current Weather")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Text(weatherCondition)
                        .font(.title)
                    Spacer()
                    Text("\(temperature)°C")
                        .font(.largeTitle)
                        .bold()
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal)
            }

            // 7-Day Forecast
            VStack {
                Text("Next 7 days...")
                    .font(.headline)
                    .padding(.top)

                ForEach(forecast, id: \.day) { day in
                    HStack {
                        Text(day.day)
                        Spacer()
                        Text("H: \(day.high)°  L: \(day.low)°")
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
        .onAppear {
            locationManager.requestLocation()
            fetchWeatherData()
        }
        .navigationTitle("Current Weather")
    }

    func fetchWeatherData() {
        guard let location = locationManager.location else { return }
        
        weatherService.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude) { response in
            if let response = response {
                self.cityName = response.name
                self.temperature = String(format: "%.0f", response.main.temp)
                self.weatherCondition = response.weather.first?.description.capitalized ?? "Unknown"
            }
        }
        
        weatherService.fetchWeatherForecast(latitude: location.latitude, longitude: location.longitude) { response in
            if let response = response {
                self.forecast = response.daily.prefix(7).enumerated().map { (index, day) in
                    (day: "Day \(index + 1)",
                     high: String(format: "%.0f", day.temp.max),
                     low: String(format: "%.0f", day.temp.min))
                }
            }
        }
    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(LocationManager())
}
