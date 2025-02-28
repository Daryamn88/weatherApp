import SwiftUI

struct VancouverWeatherView: View {
    @State private var searchText: String = ""
    @State private var cityName: String = "Vancouver"
    @State private var temperature: String = "7"
    @State private var weatherCondition: String = "Rain 🌧️"
    @State private var forecast: [(day: String, high: String, low: String)] = [
        ("Sat", "9°", "3°"), ("Sun", "10°", "5°"), ("Mon", "11°", "6°"),
        ("Tue", "12°", "7°"), ("Wed", "13°", "8°"), ("Thu", "14°", "9°"), ("Fri", "15°", "10°")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Search Bar
                HStack {
                    TextField("", text: $searchText)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(
                            ZStack(alignment: .leading) {
                                if searchText.isEmpty {
                                    Text("Search City ...")
                                        .foregroundColor(.black.opacity(0.7))
                                        .padding(.leading, 10)
                                }
                            }
                        )

                    Button(action: {
                        // Add functionality for search
                    }) {
                        Image(systemName: "mic.fill")
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
                        Text(cityName)
                            .font(.title)
                            .bold()
                        
                        Text("Sat, Mar 2, 12:00 PM")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Image(systemName: "cloud.rain.fill") // Rain Icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("\(temperature)°")
                        .font(.system(size: 50, weight: .bold))
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding(.horizontal)

                // 7-Day Forecast
                VStack {
                    Text("Next 7 days...")
                        .font(.headline)
                        .padding(.top)

                    HStack {
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
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)

                // City Illustration
                Image(systemName: "building.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    VancouverWeatherView()
}
