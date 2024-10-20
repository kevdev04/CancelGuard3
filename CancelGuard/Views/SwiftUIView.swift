import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                HStack {
                    Image("profile_picture")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    VStack {
                        Text("54")
                            .font(.headline)
                        Text("Posts")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("834")
                            .font(.headline)
                        Text("Followers")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("162")
                            .font(.headline)
                        Text("Following")
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                
                // Bio
                VStack(alignment: .leading, spacing: 4) {
                    Text("Kevin Garcia")
                        .font(.headline)
                    Text("SWE Intern @Meta | 20")
                        .font(.subheadline)
                    Text("www.kevingael.com")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Edit Profile Button
                Button(action: {
                    // Action for edit profile
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
                    
                    // Grid of Posts
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 2) {
                        ForEach(0..<9) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .navigationBarItems(
            leading: Text("kevinggael")
                .font(.title2)
                .fontWeight(.bold),
            trailing: HStack {
                Button(action: {
                    // Action for new post
                }) {
                    Image(systemName: "plus.app")
                }
                Button(action: {
                    // Action for menu
                }) {
                    Image(systemName: "line.horizontal.3")
                }
            }
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
