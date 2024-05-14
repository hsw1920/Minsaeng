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
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let vehicleNumberlabel: UILabel = {
        let label = UILabel()
        label.text = "01가1234"
        label.textColor = .MSWhite
        return label
    }()
    
    private let vehicleNumberView: UIView = {
        let view = UIView()
        view.backgroundColor = .MSBlack
        return view
    }()
    
    private let cameraView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .MSBlack
        return view
    }()
    
    private let captureButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.MSWhite.cgColor
        return view
    }()
    
    private let captureButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .MSWhite
        button.layer.cornerRadius = 32
        return button
    }()
    
    private let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.MSWhite, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "취소",
                                                     attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .medium)]),
                                  for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermission()
        setupAndStartCaputeSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // MARK: 세션 정지
        captureSession.stopRunning()
    }
    
    override func setupUI() {
        view.backgroundColor = .MSBlack
        
        view.addSubview(vehicleNumberView)
        view.addSubview(cameraView)
        view.addSubview(cancelButton)
        view.addSubview(captureButtonView)
        
        vehicleNumberView.snp.makeConstraints {
            $0.top.leading.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        vehicleNumberView.addSubview(vehicleNumberlabel)
        vehicleNumberlabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        cameraView.snp.makeConstraints {
            $0.top.equalTo(vehicleNumberView.snp.bottom)
            $0.leading.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.width * 4/3)
        }
        
        captureButtonView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        captureButtonView.addSubview(captureButton)
        captureButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.center.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(captureButtonView)
            $0.leading.equalToSuperview().inset(36)
        }
    }
    
    private func bind() {
        captureButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                // 호출될 때 마다 다른 세팅을 주어야 하기 때문에 메서드 안에서 생성
                let settings = AVCapturePhotoSettings(
                    format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                
                // 아래에 AVCapturePhotoCaptureDelegate를 채택
                owner.cameraOutput.capturePhoto(with: settings, delegate: owner)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
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
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.cameraView.bounds
        self.cameraView.layer.addSublayer(previewLayer)
    }
    
    private func setupInputs() {
        AVCaptureDevice.default(for: AVMediaType.video)
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video, position: .unspecified),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
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
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // TODO: 여기서 buffer를 AI 모델 전달하여 차량번호 반환받기
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.processPixelBuffer(pixelBuffer)
        }
    }
    
    private func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        // TODO: pixelBuffer를 UIImage 또는 CIImage로 변환하여 AI 모델에 전달하여 위반유형 반환받기
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let uiImage = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        
        // TODO: AI 모델에 이미지 전달 등의 작업 수행
        // 예:
        // yourAIModel.processImage(uiImage)
        
        // TODO: 여기서 UI 로직 처리
//        DispatchQueue.main.async { [weak self] in
//
//        }
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
                self?.cameraView.image = image
                
                if let vc = self?.presentingViewController as? CreateFormViewController {
                    vc.captureImage.accept(imageData)
                }
                
                self?.dismiss(animated: true)
            }
        }
    }
}
