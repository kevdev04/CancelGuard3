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
    @Environment(\.presentationMode) var presentationMode // To handle navigation

    var body: some View {
        VStack(spacing: 10) {
            // Custom back button
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    TextField("Nueva Publicación", text: $postTitle)
                        .padding(.vertical)
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
            
            // Línea divisoria
            Divider()
                .padding(.horizontal)
                .padding(.top, 5)
            
            // Imagen principal (de la publicación actual)
            ZStack {
                Image(selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                    .cornerRadius(15)
                    .padding(.top, 20)
                    .opacity(isLoading ? 0.5 : 1.0)
                
                if isLoading {
                    CargarApi()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        .cornerRadius(15)
                }
            }
            
            // Gallery image buttons
            HStack(spacing: 15) {
                ForEach(galleryImages, id: \.self) { imageName in
                    Button(action: {
                        selectedImage = imageName
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
                isLoading = true
                postContent = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
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
        .padding()
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}
