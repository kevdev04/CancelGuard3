import SwiftUI

struct PostCardBody: View {
    let image: String
    @State private var like_count: Int
    @State private var comment_count: Int
    let view_count: Int
    let description: String
    @State private var isLiked: Bool = false
    @State private var isBookmarked: Bool = false
    
    init(image: String, like_count: Int, comment_count: Int, view_count: Int, description: String) {
        self.image = image
        self._like_count = State(initialValue: like_count)
        self._comment_count = State(initialValue: comment_count)
        self.view_count = view_count
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Post image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .clipped()

            // Action buttons
            HStack(spacing: 12) {
                // Like button
                Button(action: {
                    isLiked.toggle()
                    like_count += isLiked ? 1 : -1
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .primary)
                            .font(.system(size: 20, weight: .bold))
                        Text("\(like_count.formattedString())")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                }
                
                // Comment button
                Button(action: {
                    // Add comment functionality here
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        Text("\(comment_count.formattedString())")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                }
                
                // Share button
                Button(action: {
                    // Add share functionality here
                }) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                // Bookmark button
                Button(action: {
                    isBookmarked.toggle()
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .blue : .primary)
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .padding(.horizontal, 8)
            
            // Description
            Text(description)
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, 8)
            
            // Time stamp
            Text("2 hours ago")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
                .padding(.horizontal, 8)
        }
        .background(Color(UIColor.systemBackground))
    }
}

// Preview
struct PostCardBody_Previews: PreviewProvider {
    static var previews: some View {
        PostCardBody(
            image: "sampleImage",
            like_count: 1234,
            comment_count: 56,
            view_count: 7890,
            description: "This is a sample post description that might span multiple lines."
        )
        .previewLayout(.sizeThatFits)
    }
}


