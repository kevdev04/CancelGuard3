import SwiftUI

struct AddStoryCard: View {
    @State private var isShowingCameraView = false
    
    var body: some View {
        Button(action: {
            isShowingCameraView = true
        }) {
            VStack {
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .padding(.leading, 8)
                
                Text("Add Story")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .fullScreenCover(isPresented: $isShowingCameraView) {
            CameraView()
        }
    }
}

struct AddStoryCard_Previews: PreviewProvider {
    static var previews: some View {
        AddStoryCard()
    }
}
