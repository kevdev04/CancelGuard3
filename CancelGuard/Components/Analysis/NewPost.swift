import SwiftUI

// Loading view
struct CargarApi: View {
    var body: some View {
        VStack {
            ProgressView("Cargando...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .padding()
        }
    }
}

struct NewPost: View {
    let galleryImages = ["imagen-1", "imagen-2", "imagen-3"] // Array of image names
    
    // State properties for the new post, loading state, and selected image
    @State private var postTitle: String = ""
    @State private var postContent: String = ""
    @State private var isLoading: Bool = false // Loading state
    @State private var selectedImage: String = "imagen-1" // Default selected image

    var body: some View {
        VStack(spacing: 10) { // Set spacing for the VStack
            // Botón de regreso
            Button(action: {
                // Acción del botón de regreso
            }) {
                HStack {
                    Image(systemName: "chevron.left") // Use a back arrow icon
                        .foregroundColor(.black)
                    // Nueva publicación (sin fondo y texto negro)
                    TextField("Nueva Publicación", text: $postTitle)
                        .padding(.vertical) // Vertical padding for the text field
                        .foregroundColor(.black) // Set text color to black
                        .font(.headline) // Set font to make it more prominent
                        .padding(.horizontal) // Horizontal padding
                }
            }
            // Línea divisoria
            Divider()
                .padding(.horizontal)
                .padding(.top, 5) // Padding for the line separator
            
            // Imagen principal (de la publicación actual)
            ZStack {
                Image(selectedImage) // Use the selected image
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                    .cornerRadius(15)
                    .padding(.top, 20)
                    .opacity(isLoading ? 0.5 : 1.0) // Apply fade effect during loading
                
                if isLoading {
                    CargarApi() // Show loading view when loading
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400) // Same size as the image
                        .cornerRadius(15)
                }
            }
            
            // Gallery image buttons
            HStack(spacing: 15) {
                ForEach(galleryImages, id: \.self) { imageName in
                    Button(action: {
                        selectedImage = imageName // Set selected image when button is pressed
                    }) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                            .clipped()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // TextField for optional survey or additional text
            TextField("Escribe un texto o agrega una encuesta...", text: $postContent)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)
           
            // Botón de compartir
            Button(action: {
                // Start loading process
                isLoading = true
                
                // Reset post content after starting the loading
                postContent = ""
                
                // Simulate an API call or image loading
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulating a 2-second loading
                    isLoading = false // End loading
                }
            }) {
                Text("Compartir")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding() // Add overall padding to the VStack
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}
