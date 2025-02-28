import SwiftUI

struct SavedLocationsView: View {
    @State private var searchText: String = ""
    
    // Sample saved locations data
    let allLocations: [(city: String, temperature: String, condition: String, high: String, low: String, icon: String, destination: AnyView)] = [
        ("Toronto", "-5°", "Partly Cloudy ☁️", "-4°", "-9°", "cloud.fill", AnyView(CurrentWeatherView())),
        ("Montreal", "-10°", "Mostly Sunny ☀️", "-8°", "-15°", "sun.max.fill", AnyView(MontrealWeatherView())),
        ("Vancouver", "7°", "Rain 🌧️", "9°", "3°", "cloud.rain.fill", AnyView(VancouverWeatherView())),
        ("Calgary", "-2°", "Snowy ❄️", "-6°", "-12°", "snowflake", AnyView(VancouverWeatherView()))
    ]
    
    // Computed property for filtered locations
    var filteredLocations: [(city: String, temperature: String, condition: String, high: String, low: String, icon: String, destination: AnyView)] {
        if searchText.isEmpty {
            return allLocations
        } else {
            return allLocations.filter { $0.city.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Search Bar (Now Fully Functional)
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

                        Button(action: {
                            // Add functionality if voice search is implemented
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Saved Locations List (Filtered)
                    VStack(spacing: 15) {
                        if filteredLocations.isEmpty {
                            Text("No results found")
                                .foregroundColor(.white.opacity(0.7))
                                .padding()
                        } else {
                            ForEach(filteredLocations, id: \.city) { location in
                                NavigationLink(destination: location.destination) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(location.city)
                                                .font(.headline)
                                                .bold()
                                                .foregroundColor(.white)

                                            Spacer()

                                            Text(location.temperature)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                        }

                                        Text("My location")
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
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    SavedLocationsView()
}
