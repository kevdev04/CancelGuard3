import SwiftUI

struct ScanningAnimationView: View {
    @State private var yOffset: CGFloat = -120
    @State private var animationCompleted = false
    @Binding var isAnimating: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: 375, height: 300)
                
                Rectangle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 259, height: 4)
                    .offset(y: yOffset)
                    .animation(
                        Animation.easeInOut(duration: 5)
                            .repeatCount(2, autoreverses: true)
                            .delay(1),
                        value: yOffset
                    )
            }
            .onAppear {
                yOffset = 147
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
                    animationCompleted = true
                    isAnimating = false
                }
            }
        }
        .frame(width: 380, height: 300)
    }
}

struct CargarApi: View {
    @State private var isAnimating = true
    
    var body: some View {
        if isAnimating {
            VStack {
                ScanningAnimationView(isAnimating: $isAnimating)
                Text("Validando imagen...")
                    .padding(.top)
            }
        } else {
            LlamaAnalysis()
        }
    }
}

struct NewPost: View {
    let galleryImages = ["imagen-1", "imagen-2", "imagen-3"]
    
    // Categorías asociadas a las imágenes
    let imageCategories = ["tarjeta", "gimnasio", "ebrio"]
    
    @State private var postTitle: String = ""
    @State private var postContent: String = ""
    @State private var isLoading: Bool = false
    @State private var selectedImage: String = "imagen-1"
    @State private var selectedCategory: String = "tarjeta" // Categoría de la imagen seleccionada
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
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
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 5)
            
            ZStack {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        .cornerRadius(15)
                        .padding(.top, 20)
                        .opacity(isLoading ? 0.5 : 1.0)
                } else {
                    Image(selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        .cornerRadius(15)
                        .padding(.top, 20)
                        .opacity(isLoading ? 0.5 : 1.0)
                }
                
                if isLoading {
                    CargarApi()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        .cornerRadius(15)
                }
            }
            
            HStack(spacing: 15) {
                Button(action: {
                    showCamera = true
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                ForEach(0..<galleryImages.count, id: \.self) { index in
                    Button(action: {
                        selectedImage = galleryImages[index]
                        selectedCategory = imageCategories[index] // Actualiza la categoría
                        capturedImage = nil
                    }) {
                        Image(galleryImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                            .clipped()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            TextField("Escribe un texto o agrega una encuesta...", text: $postContent)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)
           
            Button(action: {
                isLoading = true
                postContent = ""
                
                // Simula la llamada de la API y realiza la validación
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                    
                    if selectedCategory == "gimnasio" {
                        // Fomentar el ejercicio
                        print("¡Buen trabajo! Fomentas el ejercicio en cualquier espacio.")
                    } else if selectedCategory == "tarjeta" || selectedCategory == "ebrio" {
                        // Caso de imagen no apta para redes sociales
                        print("Esta imagen no es adecuada para redes sociales.")
                    } else {
                        print("Publicación realizada correctamente.")
                    }
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
        .navigationBarHidden(true)
        .sheet(isPresented: $showCamera) {
            CameraView(capturedImage: $capturedImage)
        }
    }
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}

// Placeholder for LlamaAnalysis view
