import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 20) // Adjust this value to increase/decrease the space below the navbar
                    StoryListView() // Display the list of stories
                    PostListView() // Display the list of posts
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("AntiFuna")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MessagesView()) {
                        Image(systemName: "paperplane")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)

                    }

                }
            }
            
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
        }
    }
}

struct MessagesView: View {
    var body: some View {
        Text("Messages View")
            .navigationTitle("Messages")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
