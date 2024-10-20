import SwiftUI

struct StoryCard: View {
    let image: String // Image name or URL
    
    var body: some View {
        VStack {
            Image(image) // Display the image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80) // Set the size of the image
                .clipShape(Circle()) // Clip the image into a circle shape
                .overlay(
                    Circle()
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 253 / 255, green: 29 / 255, blue: 29 / 255), // Red
                                Color(red: 253 / 255, green: 45 / 255, blue: 50 / 255), // Pink
                                Color(red: 253 / 255, green: 151 / 255, blue: 31 / 255) // Orange
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                                lineWidth: 3
                                )
                )
                .padding(1.5) // Add padding to prevent the stroke from being clipped
        }
    }
}
