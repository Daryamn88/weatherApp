import Foundation
import CoreLocation

// MARK: - Weather Data Models
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinates
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Forecast Data Model
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt_txt: String
    let main: Main
    let weather: [Weather]
}

// MARK: - Weather Service Class
class WeatherService {
    private let apiKey = "59f1067215928a77b96e1be0e61a0dba"

    // MARK: - Fetch Current Weather by City Name
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching current weather: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherResponse)
                }
            } catch {
                print("❌ Error decoding current weather: \(error)")
                completion(nil)
            }
        }.resume()
    }

    // MARK: - Fetch 7-Day Forecast by City Name
    func fetchWeatherForecast(city: String, completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching forecast: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(forecastResponse)
                }
            } catch {
                print("❌ Error decoding forecast: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Fetch Current Weather by Coordinates (GPS)
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching weather by location: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherResponse)
                }
            } catch {
                print("❌ Error decoding weather data: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Fetch Forecast by Coordinates (GPS)
    func fetchForecastByCoordinates(latitude: Double, longitude: Double, completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching forecast by location: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(forecastResponse)
                }
            } catch {
                print("❌ Error decoding forecast data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
