import SwiftUI

struct TabbarView: View {
    @State private var selectedTab = 0
    @State private var isNewPostPresented = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem { }
                        .tag(0)
                    
                    Text("Search View")
                        .tabItem { }
                        .tag(1)
                    
                    Text("Profile View")
                        .tabItem { }
                        .tag(3)
                }
                
                HStack {
                    ForEach(0..<4) { index in
                        Spacer()
                        if index == 2 {
                            NavigationLink(destination: NewPost(), isActive: $isNewPostPresented) {
                                Image(systemName: "plus.app.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(Color(UIColor.systemBackground))
                            }
                        } else {
                            TabbarItem(
                                imageName: getImageName(for: index),
                                isSelected: selectedTab == index,
                                action: { selectedTab = index }
                            )
                        }
                        Spacer()
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
                .background(Color(UIColor.systemBackground))
            }
            .navigationBarHidden(true)
        }
    }
    
    func getImageName(for index: Int) -> String {
        switch index {
        case 0: return selectedTab == 0 ? "house.fill" : "house"
        case 1: return "magnifyingglass"
        case 3: return selectedTab == 3 ? "person.fill" : "person"
        default: return ""
        }
    }
}

struct TabbarItem: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? .primary : .secondary)
        }
    }
}



struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
