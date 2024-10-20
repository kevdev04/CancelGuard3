import SwiftUI
import AVFoundation
import Photos

class CameraViewModel: NSObject, ObservableObject {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData: Data?
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var cameraPosition: AVCaptureDevice.Position = .back
    @Published var isPosting = false

    override init() {
        super.init()
        check()
    }
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    DispatchQueue.main.async {
                        self.setUp()
                    }
                }
            }
        case .denied:
            self.alert = true
            return
        default:
            return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = self.flashMode
            self.output.capturePhoto(with: settings, delegate: self)
            DispatchQueue.main.async {
                withAnimation { self.isTaken = true }
            }
        }
    }
    
    func retakePic() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken = false
                    self.picData = nil
                }
                self.isSaved = false
            }
        }
    }
    
    func savePic() {
        guard let imageData = self.picData, let image = UIImage(data: imageData) else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("Saved Successfully...")
    }
    
    func switchCamera() {
        cameraPosition = cameraPosition == .back ? .front : .back
        session.inputs.forEach { session.removeInput($0) }
        setUp()
    }
    
    func toggleFlash() {
        flashMode = flashMode == .on ? .off : .on
    }
    
    func postPic() {
        // Simulating a post action
        isPosting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isPosting = false
            print("Photo posted successfully...")
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        print("Picture taken...")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.picData = imageData
    }
}

struct CameraView: View {
    @StateObject var camera = CameraViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                if camera.isTaken {
                    if let imageData = camera.picData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                    }
                } else {
                    CameraPreview(camera: camera)
                        .edgesIgnoringSafeArea(.all)
                }
                
                if camera.isTaken {
                    HStack(spacing: 20) {
                        Button(action: camera.retakePic) {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            camera.savePic()
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            camera.postPic()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 30)
                } else {
                    HStack {
                        Button(action: camera.toggleFlash) {
                            Image(systemName: camera.flashMode == .on ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 50, height: 50)
                        }
                        
                        Spacer()
                        
                        Button(action: camera.takePic) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                        .frame(width: 65, height: 65)
                                )
                        }
                        
                        Spacer()
                        
                        Button(action: camera.switchCamera) {
                            Image(systemName: "camera.rotate")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            if camera.isPosting {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
