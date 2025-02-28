import SwiftUI

struct SearchResultsView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            Text("Search results for \"\(searchText)\"")
                .font(.title)
                .foregroundColor(.white)
                .padding()

           
            Text("No results found")
                .foregroundColor(.white.opacity(0.7))

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    SearchResultsView(searchText: .constant(""))
}
