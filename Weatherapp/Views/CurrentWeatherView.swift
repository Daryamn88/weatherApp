import SwiftUI

struct CurrentWeatherView: View {
    @State private var searchText: String = ""
    @State private var cityName: String = "Toronto"
    @State private var temperature: String = "-6"
    @State private var weatherCondition: String = "Cloudy"
    @State private var forecast: [(day: String, high: String, low: String)] = [
        ("Sat", "-9°", "-1°"), ("Sun", "-10°", "-4°"), ("Mon", "-13°", "-7°"),
        ("Tue", "-15°", "-10°"), ("Wed", "-17°", "-8°"), ("Thu", "-15°", "-9°"), ("Fri", "-11°", "-4°")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Search Bar
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


                // Weather Information
                HStack {
                    VStack(alignment: .leading) {
                        Text(cityName)
                            .font(.title)
                            .bold()
                        
                        Text("Fri, Feb 14, 1:45 PM")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Image(systemName: "cloud.fill") // Weather Icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
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
                Image(systemName: "building.2.fill") // Replace with actual skyline image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .foregroundColor(.white.opacity(0.9)) // Darker placeholder image
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    CurrentWeatherView()
}
