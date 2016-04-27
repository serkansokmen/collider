// Copyright © 2016 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import UIKit
import AVFoundation

public enum CameraPosition: Int {
    case Unspecified = 0
    case Back
    case Front
}

public class Camera: View {
    public var capturedImage: Image?
    public var quality: String = AVCaptureSessionPresetPhoto
    public var position: CameraPosition = .Front

    var imageOutput: AVCaptureStillImageOutput?
    var captureDevice: AVCaptureDevice?
    var previewView: CameraView?
    var input: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    var captureSession: AVCaptureSession?
    var didCaptureAction: (()->())?
    var orientationObserver: AnyObject?

    class CameraView: UIView {
        var previewLayer: PreviewLayer {
            return self.layer as! PreviewLayer // swiftlint:disable:this force_cast
        }

        override class func layerClass() -> AnyClass {
            return PreviewLayer.self
        }
    }

    var previewLayer: PreviewLayer {
        get {
            return self.cameraView.previewLayer
        }
    }

    var cameraView: CameraView {
        return self.view as! CameraView // swiftlint:disable:this force_cast
    }

    public override init(frame: Rect) {
        super.init()
        view = CameraView()
        view.frame = CGRect(frame)

        previewLayer.backgroundColor = clear.CGColor
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

        orientationObserver = on(event: UIDeviceOrientationDidChangeNotification) { [unowned self] in
            self.updateOrientation()
        }
    }

    deinit {
        if let observer = orientationObserver {
            cancel(observer)
        }
    }

    public func startCapture(position: CameraPosition = .Front) {
        self.position = position
        guard let cd = captureDevice(position) else {
            print("Could not retrieve capture device for \(position)")
            return
        }
        initializeInput(cd)

        guard input != nil else {
            print("Could not initialize input for \(cd)")
            return
        }
        initializeOutput(cd)
        captureDevice = cd

        initializeCaptureSession()

        captureSession?.startRunning()

        updateOrientation()
    }

    func captureDevice(position: CameraPosition) -> AVCaptureDevice? {
            for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
                if let d = device as? AVCaptureDevice where d.position.rawValue == position.rawValue {
                    return d
                }
            }
        return nil
    }

    func updateOrientation() {
        if let connection = previewLayer.connection where connection.supportsVideoOrientation {
            switch UIApplication.sharedApplication().statusBarOrientation {
            case .PortraitUpsideDown:
                previewLayer.connection.videoOrientation = .PortraitUpsideDown
            case .LandscapeLeft:
                previewLayer.connection.videoOrientation = .LandscapeLeft
            case .LandscapeRight:
                previewLayer.connection.videoOrientation = .LandscapeRight
            default:
                previewLayer.connection.videoOrientation = .Portrait
            }
        }
    }

    func initializeInput(device: AVCaptureDevice) {
        if input == nil {
            do {
                input = try AVCaptureDeviceInput(device: device)
            } catch {
                print("Could not create input for device: \(device)")
                return
            }
        }
    }

    func initializeOutput(device: AVCaptureDevice) {
        if stillImageOutput == nil {
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        }
    }

    func initializeCaptureSession() {
        if captureSession == nil {
            captureSession = AVCaptureSession()
            previewLayer.session = captureSession
        }

        captureSession?.sessionPreset = quality

        if let inputs = captureSession?.inputs {
            for input in inputs {
                if let i = input as? AVCaptureInput {
                    captureSession?.removeInput(i)
                }
            }
        }

        captureSession?.addInput(input)

        if let outputs = captureSession?.outputs {
            for output in outputs {
                if let o = output as? AVCaptureOutput {
                    captureSession?.removeOutput(o)
                }
            }
        }

        captureSession?.addOutput(stillImageOutput)
    }

    public func captureImage() {
        guard stillImageOutput?.capturingStillImage == false else {
            print("Still capturing, please wait until I'm done until you put me to work again")
            return
        }

        if let connection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            updateOrientation()
            connection.videoOrientation = previewLayer.connection.videoOrientation

            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(connection) { imageSampleBuffer, error in
                guard imageSampleBuffer != nil else {
                    print("Couldn't capture image from still image output")
                    return
                }

                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer as CMSampleBufferRef)

                if let img = UIImage(data: data) {
                    self.capturedImage = Image(uiimage: self.orientRawImage(img))
                    self.didCaptureAction?()
                }
            }
        }
    }

    func orientRawImage(image: UIImage) -> UIImage {
        if let cgimg = image.CGImage {
            var orientation: UIImageOrientation!
            let shouldFlip = self.position == .Front

            switch previewLayer.connection.videoOrientation {
            case .LandscapeLeft:
                orientation = shouldFlip ? .UpMirrored : .Down
            case .LandscapeRight:
                orientation = shouldFlip ? .DownMirrored : .Up
            case .Portrait:
                orientation = shouldFlip ? .LeftMirrored : .Right
            case .PortraitUpsideDown:
                orientation = shouldFlip ? .RightMirrored : .Left
            }
            return UIImage(CGImage: cgimg, scale: image.scale, orientation: orientation)
        }
        return image
    }

    public func didCaptureImage(action: ()->()) {
        didCaptureAction = action
    }
}

class PreviewLayer: AVCaptureVideoPreviewLayer {

}
