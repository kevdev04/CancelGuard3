import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    @State private var showingSettings = false // Estado para mostrar la configuración
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    HStack {
                        Image("kev")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        VStack {
                            Text("371")
                                .font(.headline)
                            Text("Posts")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("15.1 M")
                                .font(.headline)
                            Text("Followers")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("609")
                                .font(.headline)
                            Text("Following")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aaron Rincon")
                            .font(.headline)
                        Text("Meta")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Edit Profile Button
                    Button(action: {
                        // Acción para editar perfil
                    }) {
                        Text("Edit Profile")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(5)
                    }
                    .padding(.horizontal)
                    
                    // Tab View for Posts, Reels, etc.
                    VStack {
                        HStack {
                            ForEach(0..<3) { index in
                                Button(action: {
                                    selectedTab = index
                                }) {
                                    Image(systemName: index == 0 ? "square.grid.3x3" : (index == 1 ? "play.rectangle" : "person.crop.square"))
                                        .foregroundColor(selectedTab == index ? .primary : .secondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 2) {
                            ForEach(1..<10) { index in // Cambia 0..<9 a 1..<10 para que empiece desde 1
                                Image("img-\(index)") // Referenciando las imágenes en la carpeta Grids
                                    .resizable()
                                    .aspectRatio(contentMode: .fill) // O .fit según tu preferencia
                                    .frame(height: UIScreen.main.bounds.width / 3) // Ajusta el alto para que se mantenga un formato adecuado
                                    .clipped() // Recortar la imagen si es necesario
                            }
                        }
                        .padding(.bottom, 50) // Ajustar el padding inferior si es necesario para no solapar el tab bar
                    }
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text("aaronrincon")
                        .font(.title2)
                        .fontWeight(.bold)
                    Image(systemName: "checkmark.seal") // Usando un ícono de verificación de SF Symbols
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                },
                trailing: HStack {
                    Button(action: {
                        showingSettings = true // Mostrar configuración cuando se presiona
                    }) {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            )
            .sheet(isPresented: $showingSettings) {
                SettingsView() // Presentar la vista de configuración
            }
        }
    }
}

struct SettingsView: View {
    @State private var antifunaActivated = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // Opción Antifuna
                    Toggle(isOn: $antifunaActivated) {
                        HStack {
                            Image(systemName: "shield.lefthalf.fill") // Icono de antifuna
                                .foregroundColor(.blue)
                            Text("Antifuna")
                        }
                    }
                }
                
                // Sección de Configuración General
                Section(header: Text("Configuración y Privacidad")) {
                    NavigationLink(destination: Text("Tu Actividad")) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("Tu actividad")
                        }
                    }
                    
                    NavigationLink(destination: Text("Archivo")) {
                        HStack {
                            Image(systemName: "archivebox.fill")
                                .foregroundColor(.blue)
                            Text("Archivo")
                        }
                    }
                    
                    NavigationLink(destination: Text("Código QR")) {
                        HStack {
                            Image(systemName: "qrcode")
                                .foregroundColor(.blue)
                            Text("Código QR")
                        }
                    }
                    
                    NavigationLink(destination: Text("Guardado")) {
                        HStack {
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(.blue)
                            Text("Guardado")
                        }
                    }
                    
                    NavigationLink(destination: Text("Supervisión")) {
                        HStack {
                            Image(systemName: "eye.fill")
                                .foregroundColor(.blue)
                            Text("Supervisión")
                        }
                    }
                    
                    NavigationLink(destination: Text("Pedidos y pagos")) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.blue)
                            Text("Pedidos y pagos")
                        }
                    }
                    
                    NavigationLink(destination: Text("Meta Verified")) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                            Text("Meta Verified")
                                .badge("Nuevo")
                        }
                    }
                    
                    NavigationLink(destination: Text("Mejores amigos")) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                            Text("Mejores amigos")
                        }
                    }
                    
                    NavigationLink(destination: Text("Favoritos")) {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.blue)
                            Text("Favoritos")
                        }
                    }
                }
            }
            .navigationBarTitle("Configuración", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                // Acción para cerrar la configuración
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
