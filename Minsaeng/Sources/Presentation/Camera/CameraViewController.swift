//
//  CameraViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/02.
//

import AVFoundation
import UIKit
import RxCocoa
import RxSwift

final class CameraViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    var shootCamera: (() -> (UIImage))?
    
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "<#차량번호>"
        return label
    }()
    
    let vehicleNumberView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    let cameraView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemMint
        return view
    }()
    
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 40
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicleNumberView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.backgroundColor = .black
        captureImageButton.rx.tap
            .bind(onNext: { [weak self] in
                print("tap")
                // 호출될 때 마다 다른 세팅을 주어야 하기 때문에 메서드 안에서 생성
                guard let self else { return }
                let settings = AVCapturePhotoSettings(
                    format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                
                // 아래에 AVCapturePhotoCaptureDelegate를 채택
                cameraOutput.capturePhoto(with: settings, delegate: self)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermission()
        setupAndStartCaputeSession()
    }
    
    
    override func setupUI() {
        view.addSubview(vehicleNumberView)
        view.addSubview(cameraView)
        view.addSubview(captureImageButton)
        
        vehicleNumberView.snp.makeConstraints {
            $0.top.leading.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        cameraView.snp.makeConstraints {
            $0.top.equalTo(vehicleNumberView.snp.bottom)
            $0.leading.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.width * 4/3)
        }
        
        captureImageButton.snp.makeConstraints {
            //            $0.top.equalTo(cameraView.snp.bottom).offset(16)
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func checkPermission() {
        
    }
    
    private func setupAndStartCaputeSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            // captureSession에 대한 세션 초기화
            self?.captureSession = AVCaptureSession()
            // 구성 시작
            self?.captureSession.beginConfiguration()
            
            guard let isConfigured = self?.captureSession.canSetSessionPreset(.photo) else {
                return
            }
            
            if isConfigured {
                self?.captureSession.sessionPreset = AVCaptureSession.Preset.photo
            }
            
            // Setup Inputs
            self?.setupInputs()
            
            
            // UI 관련 부분은 메인 스레드에서 실행되어야 합니다.
            DispatchQueue.main.async { [weak self] in
                // 미리보기 레이어 셋업
                self?.setupPreviewLayer()
            }
            
            // Setup Outputs
            self?.setupOutput()
            self?.setupVideoOutput()
            
            // commit configuration: 단일 atomic 업데이트에서 실행중인 캡처 세션의 구성에 대한 하나 이상의 변경 사항을 커밋합니다.
            self?.captureSession.commitConfiguration()
            
            // 캡처 세션을 실행
            self?.captureSession.startRunning()
        }
    }
    
    func setupPreviewLayer() {
        print(self.cameraView.frame)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.cameraView.bounds
        self.cameraView.layer.addSublayer(previewLayer)
    }
    
    private func setupInputs() {
        AVCaptureDevice.default(for: AVMediaType.video)
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              captureSession.canAddInput(videoDeviceInput) else {
            return
        }
        captureSession.addInput(videoDeviceInput)
    }
    
    private func setupOutput() {
        cameraOutput = AVCapturePhotoOutput()
        
        guard captureSession.canAddOutput(cameraOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(cameraOutput)
    }
    
    
    
    private func setupVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        let videoOutputQueue = DispatchQueue(label: "VideoOutputQueue")
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)

        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, 
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        print(">>> video")
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self?.processPixelBuffer(pixelBuffer)
//        }
    }
    
    private func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        // pixelBuffer를 UIImage 또는 CIImage로 변환하여 AI 모델에 전달할 수 있습니다.
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        // 또는 UIImage로 변환
        let uiImage = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        
        DispatchQueue.main.async { [weak self] in
            self?.vehicleNumberView.image = uiImage
        }
        
        
        // AI 모델에 이미지 전달 등의 작업 수행
        // 예:
        // yourAIModel.processImage(image)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, 
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
         
            DispatchQueue.main.async { [weak self] in
                self?.vehicleNumberView.image = nil
                self?.cameraView.image = image
                
                if let vc = self?.presentingViewController as? CreateFormViewController {
                    vc.captureImage.accept(imageData)
                }
                
                self?.dismiss(animated: true)
            }
        }
    }
}
