import SwiftUI

struct SavedLocationsView: View {
    @State private var searchText: String = ""
    @State private var savedLocations: [WeatherData] = []
    private let weatherService = WeatherService()

    // Sample saved cities (User can add more in the future)
    private let cityList = ["Toronto", "Montreal", "Vancouver", "Calgary", "Ottawa"]

    var filteredLocations: [WeatherData] {
        if searchText.isEmpty {
            return savedLocations
        } else {
            return savedLocations.filter { $0.city.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Search Bar
                    searchBarView()

                    // Saved Locations List
                    locationsListView()
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
        }
        .onAppear {
            fetchWeatherForSavedLocations()
        }
    }

    // MARK: - Search Bar UI
    private func searchBarView() -> some View {
        HStack {
            TextField("Search City ...", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .foregroundColor(.black)
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
        .padding(.horizontal)
    }

    // MARK: - Locations List UI
    private func locationsListView() -> some View {
        VStack(spacing: 15) {
            if filteredLocations.isEmpty {
                Text("No results found")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                ForEach(filteredLocations, id: \.city) { location in
                    locationCardView(for: location)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Single Location Card UI
    private func locationCardView(for location: WeatherData) -> some View {
        NavigationLink(destination: CurrentWeatherView(city: location.city))
 {
            VStack(alignment: .leading) {
                HStack {
                    Text(location.city)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(location.temperature)°C")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }

                Text("Weather: \(location.condition)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                HStack {
                    Image(systemName: location.icon)
                        .foregroundColor(.white.opacity(0.8))
                    Text(location.condition)
                        .foregroundColor(.white)

                    Spacer()
                    Text("H:\(location.high) L:\(location.low)")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
        }
    }

    // MARK: - Fetch Weather Data for Saved Locations
    private func fetchWeatherForSavedLocations() {
        var updatedLocations: [WeatherData] = []
        let group = DispatchGroup()

        for city in cityList {
            group.enter()
            weatherService.fetchCurrentWeather(city: city) { weather in
                if let weather = weather {
                    let weatherData = WeatherData(
                        city: weather.name,
                        temperature: String(format: "%.0f", weather.main.temp),
                        condition: weather.weather.first?.description.capitalized ?? "Unknown",
                        high: String(format: "%.0f", weather.main.temp + 3),
                        low: String(format: "%.0f", weather.main.temp - 3),
                        icon: self.getWeatherIcon(for: weather.weather.first?.description ?? "")
                    )
                    updatedLocations.append(weatherData)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.savedLocations = updatedLocations
        }
    }

    // MARK: - Convert Weather Description to SF Symbols
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

// MARK: - Weather Data Model for UI
struct WeatherData {
    let city: String
    let temperature: String
    let condition: String
    let high: String
    let low: String
    let icon: String
}

#Preview {
    SavedLocationsView()
}
