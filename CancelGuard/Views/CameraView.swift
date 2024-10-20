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
            if self.cameraPosition == .front {
                settings.isAutoStillImageStabilizationEnabled = false
            }
            self.output.capturePhoto(with: settings, delegate: self)
            DispatchQueue.main.async {
                withAnimation { self.isTaken = true }
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
    @Binding var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                if camera.isTaken {
                    if let imageData = camera.picData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: camera.cameraPosition == .front ? uiImage.withHorizontallyFlippedOrientation() : uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                    }
                } else {
                    CameraPreview(camera: camera)
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack(spacing: 20) {
                    if camera.isTaken {
                        Button(action: {
                            if let imageData = camera.picData, let uiImage = UIImage(data: imageData) {
                                capturedImage = camera.cameraPosition == .front ? uiImage.withHorizontallyFlippedOrientation() : uiImage
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Use Photo")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                    } else {
                        Button(action: camera.toggleFlash) {
                            Image(systemName: camera.flashMode == .on ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        
                        Button(action: camera.takePic) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                        
                        Button(action: camera.switchCamera) {
                            Image(systemName: "camera.rotate")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                }
                .padding(.bottom, 30)
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
