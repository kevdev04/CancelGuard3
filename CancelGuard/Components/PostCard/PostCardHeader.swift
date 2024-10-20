import SwiftUI

struct PostCardHeader: View {
    
    let profile_img: String
    let profile_name: String
    let profile_id: String
    
    var body: some View {
        HStack {
            // Profile image
            Image(profile_img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            
            // Profile name and ID
            VStack(alignment: .leading, spacing: 4) {
                Text(profile_name).bold()
                Text(profile_id)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Options button (ellipsis)
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
        }
        .padding(.horizontal, 8) // Add padding to align with the body content
        .padding(.vertical, 4) // Optional padding for vertical spacing
    }
}
