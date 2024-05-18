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

enum CaptureOption {
    case required, optional
}

enum CaptureState {
    case none, waiting, correct
    var color: CGColor {
        switch self {
        case .none: return UIColor.clear.cgColor
        case .waiting: return UIColor.MSBorderGray.cgColor
        case .correct: return UIColor.MSMain.cgColor
        }
    }
}

final class CircleView: UIView {
    var state: CaptureState = .none
    
    let borderLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBorderLayer()
        addGradientLayer()
    }
    
    func removeBorderGradientLayer() {
        borderLayer.removeFromSuperlayer()
        gradientLayer.removeFromSuperlayer()
    }
    
    func addBorderLayer() {
        switch state {
        case .waiting, .none:
            borderLayer.strokeColor = UIColor.MSLightGray.cgColor
        case .correct:
            borderLayer.strokeColor = UIColor.MSMain.cgColor
        }
        
        let halfWidth = frame.width / 2
        let center = CGPoint(x: halfWidth, y: halfWidth)
        let strokeRadius = halfWidth - 2
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: strokeRadius,
                                        startAngle: 0,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        borderLayer.path = circularPath.cgPath
        borderLayer.lineWidth = 4
        borderLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(borderLayer)
    }
    
    func addGradientLayer() {
        switch state {
        case .waiting: 
            break
        default: 
            return
        }

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.mask = borderLayer
        
        gradientLayer.colors = [UIColor.MSLightGray,
                                UIColor.MSWhite.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    private func addAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "transform.rotation.z \(arc4random())")
    }
}

final class CameraViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let captureState: BehaviorRelay<CaptureState> = .init(value: .none)
    private var captureSession: AVCaptureSession!
    private var cameraOutput: AVCapturePhotoOutput!
    private var videoOutput: AVCaptureVideoDataOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let vehicleNumberlabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .MSWhite
        return label
    }()
    
    private let vehicleNumberView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let cameraView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    private var captureButtonView: CircleView = {
        let view = CircleView()
        return view
    }()
    
    private let captureButton : UIButton = {
        let button = UIButton()
        button.isEnabled = false
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
    
    private let coordinator: CameraCoordinatorInterface
    private let captureOption: CaptureOption
    
    init(coordinator: CameraCoordinatorInterface, captureOption: CaptureOption) {
        self.coordinator = coordinator
        self.captureOption = captureOption
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnimation()
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
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(62)
        }
        
        vehicleNumberView.addSubview(vehicleNumberlabel)
        vehicleNumberlabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        cameraView.snp.makeConstraints {
            $0.top.equalTo(vehicleNumberView.snp.bottom).offset(38)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        captureButton.rx.controlEvent(.touchDown)
            .bind(with: self) { owner, _ in
                owner.captureButtonTransitioningDown()
            }
            .disposed(by: disposeBag)
        
        captureButton.rx.controlEvent(.touchUpOutside)
            .bind(with: self) { owner, _ in
                owner.captureButtonTransitioningUp()
            }
            .disposed(by: disposeBag)
        
        captureButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.captureButton.isEnabled = false
                owner.captureButtonTransitioningUp()
                
                // 호출될 때 마다 다른 세팅을 주어야 하기 때문에 메서드 안에서 생성
                let settings = AVCapturePhotoSettings(
                    format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                
                // 아래에 AVCapturePhotoCaptureDelegate를 채택
                owner.cameraOutput.capturePhoto(with: settings, delegate: owner)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.cancelCamera(owner)
            })
            .disposed(by: disposeBag)
        
        if captureOption == .required {
            captureState
                .distinctUntilChanged()
                .bind(with: self) { owner, state in
                    owner.cameraView.layer.borderColor = state.color
                    owner.captureButtonView.removeBorderGradientLayer()
                    owner.captureButtonView.state = state
                    owner.captureButtonView.layoutSubviews()

                    switch state {
                    case .none:
                        owner.vehicleNumberlabel.text = nil
                        owner.vehicleNumberView.backgroundColor = .clear
                        owner.captureButton.backgroundColor = .MSWhite
                        owner.captureButton.isEnabled = false
                    case .waiting:
                        owner.vehicleNumberlabel.text = "차량번호를 인식시켜 주세요."
                        owner.vehicleNumberView.backgroundColor = .MSDarkGray
                        owner.captureButton.backgroundColor = .MSDarkGray
                        owner.captureButton.isEnabled = false
                    case .correct:
                        owner.vehicleNumberlabel.text = "01가1234"
                        owner.vehicleNumberView.backgroundColor = .MSMain
                        owner.captureButton.backgroundColor = .MSWhite
                        owner.captureButton.isEnabled = true
                    }
                }
                .disposed(by: disposeBag)
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
            if self?.captureOption == .required {
                self?.setupVideoOutput()
            }
            
            // commit configuration: 단일 atomic 업데이트에서 실행중인 캡처 세션의 구성에 대한 하나 이상의 변경 사항을 커밋합니다.
            self?.captureSession.commitConfiguration()
            
            // 캡처 세션을 실행
            self?.captureSession.startRunning()
            
            // 세션 실행 전까지는 상호작용 불가능
            // * optional의 경우
            // 세션이 실행되면 captureButton의 상호작용이 가능하도록 변경
            // * required의 경우
            // videoOutput에서의 state에 따라서만 상호작용이 제어됨
            DispatchQueue.main.async { [weak self] in
                if self?.captureOption == .optional {
                    self?.captureButton.isEnabled = true
                }
            }
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
    
    private func captureButtonTransitioningDown() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    private func captureButtonTransitioningUp() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.transform = .identity
        }
    }
    
    private func addAnimation() { // 애니메이션 레이어 추가
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1
        animation.repeatCount = .infinity
        captureButtonView.layer.add(animation, forKey: "transform.rotation.z \(arc4random())")
    }

    private func removeAnimation() {
        captureButtonView.layer.removeAllAnimations() // 애니메이션 레이어 제거
        captureButtonView.removeBorderGradientLayer() // Border, Gradient 레이어 제거
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
    
    // MARK: 테스팅용 임시 메서드
    func getStateForCurrentTime() -> Int {
        let currentTime = Int(Date().timeIntervalSince1970) % 60  // 현재 시간의 초
        
        if currentTime >= 0 && currentTime < 10 || currentTime >= 30 && currentTime <= 40 {
            return 1
        } else if currentTime >= 10 && currentTime < 20 || currentTime >= 40 && currentTime <= 50 {
            return 2
        } else {
            return 2
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
        
        // MARK: 테스팅용 임시 메서드
        captureButtonView.state = [CaptureState.none, CaptureState.waiting, CaptureState.correct][getStateForCurrentTime()]
        
        // MARK: AI 모델 리턴값 + 차량번호까지 같이?
        let state = captureButtonView.state
        DispatchQueue.main.async { [weak self] in
            self?.captureState.accept(state)
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, 
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            self.captureSession.stopRunning()
         
            //MARK: 다시찍기 구현하면 사용할 수도?
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) { [weak self] in
//                self?.setupAndStartCaputeSession()
//            }
            
            DispatchQueue.main.async {
                self.cameraView.image = image
                self.coordinator.finishCamera(self, option: self.captureOption, imageData: imageData)
            }
        }
    }
}
