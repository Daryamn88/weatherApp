import SwiftUI

struct CurrentWeatherView: View {
    @State private var searchText: String = "" // Search input
    @State var city: String // Accepts city name as a parameter
    @State private var temperature: String = "--"
    @State private var weatherCondition: String = "Loading..."
    @State private var forecast: [(day: String, high: String, low: String)] = []
    @State private var showSaveButton: Bool = false // Control visibility of "Save" button
    @AppStorage("savedCities") private var savedCitiesData: String = "[]"
    private var savedCities: [String] {
        get {
            if let data = savedCitiesData.data(using: .utf8),
               let decoded = try? JSONDecoder().decode([String].self, from: data) {
                return decoded
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue),
               let jsonString = String(data: encoded, encoding: .utf8) {
                savedCitiesData = jsonString
            }
        }
    }


    private let weatherService = WeatherService()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Search Bar
                HStack {
                    TextField("Search City ...", text: $searchText, onCommit: {
                        if !searchText.isEmpty {
                            city = searchText
                            fetchWeather(for: city) // Update weather after search
                            searchText = ""
                        }
                    })
                    .padding(10)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    
                    Button(action: {
                        if !searchText.isEmpty {
                            city = searchText
                            fetchWeather(for: city)
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                // Weather Information
                HStack {
                    VStack(alignment: .leading) {
                        Text(city)
                            .font(.title)
                            .bold()
                        
                        Text(weatherCondition)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Image(systemName: getWeatherIcon(for: weatherCondition))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(temperature)°C")
                        .font(.system(size: 50, weight: .bold))
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal)

                // Check if city is already saved
                var isCitySaved: Bool {
                    savedCities.contains(city)
                }

                if !isCitySaved {
                    Button(action: {
                        addCityToSavedLocations(city)
                    }) {
                        Text("Save to Favorites ❤️")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(12)
                            .padding(.horizontal, 50)
                    }
                }


                // 7-Day Forecast
                VStack {
                    Text("Next 7 days...")
                        .font(.headline)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(forecast, id: \.day) { day in
                                VStack {
                                    Text(day.day)
                                        .font(.caption)
                                        .bold()
                                    Text(day.high)
                                    Text(day.low)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(width: 60)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchWeather(for: city)
        }
    }

    // Fetch Weather
    private func fetchWeather(for city: String) {
        weatherService.fetchCurrentWeather(city: city) { weather in
            if let weather = weather {
                DispatchQueue.main.async {
                    self.temperature = String(format: "%.0f", weather.main.temp)
                    self.weatherCondition = weather.weather.first?.description.capitalized ?? "Unknown"
                    self.showSaveButton = true // Show save button after successful fetch
                }
            }
        }
        
        weatherService.fetchWeatherForecast(city: city) { forecastResponse in
            if let forecastResponse = forecastResponse {
                DispatchQueue.main.async {
                    self.forecast = self.processForecastData(forecastResponse)
                }
            }
        }
    }

    // Add City to Saved Locations
    private func addCityToSavedLocations(_ city: String) {
        var cities = savedCities // Get a mutable copy

        if !cities.contains(city) {
            cities.append(city) // Add new city to list
            
            // Encode and update storage
            if let encoded = try? JSONEncoder().encode(cities),
               let jsonString = String(data: encoded, encoding: .utf8) {
                savedCitiesData = jsonString // Store in persistent storage
            }
        }
    }


    // Process and Group Forecast Data
    private func processForecastData(_ forecastResponse: ForecastResponse) -> [(day: String, high: String, low: String)] {
        var dailyForecast: [String: (high: Double, low: Double)] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E" // Extracts weekday name

        for item in forecastResponse.list {
            if let date = dateFormatter.date(from: item.dt_txt) {
                let dayKey = dayFormatter.string(from: date) // Convert to weekday name

                if dailyForecast[dayKey] == nil {
                    dailyForecast[dayKey] = (high: item.main.temp, low: item.main.temp)
                } else {
                    dailyForecast[dayKey]!.high = max(dailyForecast[dayKey]!.high, item.main.temp)
                    dailyForecast[dayKey]!.low = min(dailyForecast[dayKey]!.low, item.main.temp)
                }
            }
        }

        // Sort forecast by weekday and limit to 7 days
        return dailyForecast.sorted(by: { $0.key < $1.key }).prefix(7).map { (day, temps) in
            return (day, String(format: "%.0f°C", temps.high), String(format: "%.0f°C", temps.low))
        }
    }

    // Get SF Symbol for Weather Condition
    private func getWeatherIcon(for condition: String) -> String {
        switch condition.lowercased() {
            case let str where str.contains("cloud"): return "cloud.fill"
            case let str where str.contains("rain"): return "cloud.rain.fill"
            case let str where str.contains("clear"): return "sun.max.fill"
            case let str where str.contains("snow"): return "snowflake"
            default: return "cloud.fill"
        }
    }
}

#Preview {
    CurrentWeatherView(city: "Toronto")
}
