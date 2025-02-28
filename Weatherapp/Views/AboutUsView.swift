import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 15) {
                Text("About Our Weather App")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("Welcome to Weather App, your simple and reliable weather companion! ☀️")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(.green)
                        Text("Check real-time weather updates for any city.")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(.green)
                        Text("View temperature, humidity, and wind speed at a glance.")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(.green)
                        Text("Save your favorite locations for quick access.")
                            .foregroundColor(.white)
                    }
                }
                .padding()

                Text("Designed with a clean and intuitive interface, Weather App ensures you stay informed about the weather wherever you go! 🌟")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Text("Would you like to add developer credits or a version number? 😊")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .center, spacing: 5) {
                    Text("This App is created by:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Dorsa Mohammadi\n101397591")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Darya Mansouri\n101394900")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Yasaman Mirvahabi Sabet\n101217770")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.6).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    AboutUsView()
}
