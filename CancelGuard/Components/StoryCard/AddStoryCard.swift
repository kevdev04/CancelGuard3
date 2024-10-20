import SwiftUI

struct AddStoryCard: View {
    @State private var isShowingCameraView = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        Button(action: {
            isShowingCameraView = true
        }) {
            VStack {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                } else {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(
                            Image("kev")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.8)
                        )
                        .clipShape(Circle())
                        .padding(.leading, 8)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingCameraView) {
            CameraView(capturedImage: $capturedImage)
        }
    }
}

struct AddStoryCard_Previews: PreviewProvider {
    static var previews: some View {
        AddStoryCard()
    }
}
