//
//  WeatherService.swift
//  Weatherapp
//
//  Created by Darya Mansouri on 2025-02-27.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

struct ForecastResponse: Codable {
    let daily: [DailyForecast]
}

struct DailyForecast: Codable {
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable, Equatable { // Added Equatable Fix
    let min: Double
    let max: Double
}

class WeatherService {
    private let apiKey = "38d8ae3e7ed94ddc951182629252702" // API Key

    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            DispatchQueue.main.async {
                completion(weatherResponse)
            }
        }.resume()
    }

    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly,alerts&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let forecastResponse = try? JSONDecoder().decode(ForecastResponse.self, from: data)
            DispatchQueue.main.async {
                completion(forecastResponse)
            }
        }.resume()
    }
}
