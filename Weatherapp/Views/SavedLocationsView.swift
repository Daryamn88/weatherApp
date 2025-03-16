import SwiftUI

struct SavedLocationsView: View {
    @State private var searchText: String = ""
    
    // FIX: Encode/Decode Array in @AppStorage
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

    @State private var savedLocations: [WeatherData] = []
    private let weatherService = WeatherService()

    var filteredLocations: [WeatherData] {
        if searchText.isEmpty {
            return savedLocations
        } else {
            return savedLocations.filter { $0.city.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Set background color same as CurrentWeatherView
                Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all)
                VStack {
                    searchBarView()
                    
                    if savedCities.isEmpty {
                        Text("No saved locations yet.")
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    } else {
                        locationsListView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
                .navigationTitle("Saved Locations")
            }
            .onAppear {
                fetchWeatherForSavedLocations()
            }
        }
    }

    // MARK: - Search Bar UI
    private func searchBarView() -> some View {
        HStack {
            TextField("Search City ...", text: $searchText)
                .padding(10)
                .background(Color.gray.opacity(0.8))
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
        List {
            ForEach(filteredLocations, id: \.city) { location in
                locationCardView(for: location)
            }
            .onDelete(perform: deleteCity) // Enable swipe to delete
        }
        .scrollContentBackground(.hidden)
    }

    // MARK: - Single Location Card UI
    private func locationCardView(for location: WeatherData) -> some View {
        NavigationLink(destination: CurrentWeatherView(city: location.city)) {
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
            .background(Color.purple.opacity(0.3))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }

    // MARK: - Swipe to Delete Function
    private func deleteCity(at offsets: IndexSet) {
        var cities = savedCities.map { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }

        for index in offsets {
            let cityToDelete = savedLocations[index].city.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

            // 🔹 Ensure case-insensitive deletion
            cities.removeAll { $0.caseInsensitiveCompare(cityToDelete) == .orderedSame }
        }

        // 🔹 Remove duplicates before saving
        let uniqueCities = Array(Set(cities))

        // 🔹 Save updated list back to AppStorage
        if let encoded = try? JSONEncoder().encode(uniqueCities),
           let jsonString = String(data: encoded, encoding: .utf8) {
            savedCitiesData = jsonString
        }

        // 🔹 Remove locations that no longer exist in savedCities
        savedLocations.removeAll { !uniqueCities.contains($0.city.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) }

        fetchWeatherForSavedLocations() // Refresh list
    }




        // MARK: - Convert Weather Description to SF Symbols
         func getWeatherIcon(for condition: String) -> String {
            switch condition.lowercased() {
                case let str where str.contains("cloud"): return "cloud.fill"
                case let str where str.contains("rain"): return "cloud.rain.fill"
                case let str where str.contains("clear"): return "sun.max.fill"
                case let str where str.contains("snow"): return "snowflake"
                default: return "cloud.fill"
            }
        }
        
    // MARK: - Fetch Weather Data for Saved Locations
     func fetchWeatherForSavedLocations() {
        var updatedLocations: [WeatherData] = []
        let group = DispatchGroup()
         
        let currentCities = savedCities
         
        for city in savedCities {
            if !savedCities.contains(city) { continue }
            
            group.enter()
            weatherService.fetchCurrentWeather(city: city) { weather in
                if let weather = weather {
                    let weatherData = WeatherData(
                        city: weather.name,
                        temperature: String(format: "%.0f", weather.main.temp),
                        condition: weather.weather.first?.description.capitalized ?? "Unknown",
                        high: String(format: "%.0f", weather.main.temp + 3),
                        low: String(format: "%.0f", weather.main.temp - 3),
                        icon: getWeatherIcon(for: weather.weather.first?.description ?? "")
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
