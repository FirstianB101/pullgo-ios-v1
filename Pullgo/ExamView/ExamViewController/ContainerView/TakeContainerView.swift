//
//  HistoryContainerView.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit
import SnapKit

class TakeContainerView: UIView, ContainerView {
    
    // MARK: - UI
    lazy var fontSlider = { () -> UISlider in
        let slider = UISlider()
        
        slider.maximumValue = 30
        slider.minimumValue = 10
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let smallConfig = UIImage.SymbolConfiguration(scale: .small)
        
        slider.maximumValueImage = UIImage(systemName: "a", withConfiguration: largeConfig)
        slider.minimumValueImage = UIImage(systemName: "a", withConfiguration: smallConfig)
        slider.setThumbImage(UIImage(named: "FontSliderThumb"), for: .normal)
        slider.addTarget(self, action: #selector(self.controlFont(_:)), for: .allTouchEvents)
        
        return slider
    }()
    
    lazy var content = { () -> UITextView in
        let textView = UITextView()
        
        textView.isEditable = false
        textView.layer.borderWidth = 0.2
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 15
        textView.text = question?.content ?? "문제가 입력되지 않았습니다."
        textView.textColor = .black
        textView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        textView.font = UIFont.systemFont(ofSize: 18)
        
        return textView
    }()
    
    lazy var imageView = { () -> UIButton in
        let imageView = UIButton()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageView?.contentMode = .scaleAspectFit
        if let picture = question?.picture {
            imageView.setImage(picture, for: .normal)
            imageView.backgroundColor = .quaternarySystemFill
            imageView.setViewCornerRadius(radius: 15)
            imageView.adjustsImageWhenHighlighted = false
        }
        imageView.addTarget(self, action: #selector(self.loadFullImage(_:)), for: .touchUpInside)
        
        return imageView
    }()
    
    lazy var choiceButton = { () -> UIButton in
        
        guard let target = self.target as? TakeExamViewController else {
            fatalError("Target is not a TakeExamViewController.")
        }
        
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .lightAccent
        button.setTitle("보기 선택", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(target, action: #selector(target.selectChoice(_:)), for: .touchUpInside)
        button.setViewCornerRadiusAndShadow(radius: 25)
        
        return button
    }()
    
    // MARK: - Initializer + Property
    var question: Question?
    var target: UIViewController
    var originImageViewFrame: CGRect = CGRect()
    
    required init(question: Question?, target: UIViewController) {
        self.question = question
        self.target = target
        
        super.init(frame: .zero)
        
        self.setBackgroundColor()
        self.buildConstraints()
        originImageViewFrame = imageView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setBackgroundColor() {
        self.backgroundColor = .white
    }
    
    private func buildConstraints() {
        self.addSubview(fontSlider)
        self.addSubview(content)
        self.addSubview(imageView)
        self.addSubview(choiceButton)
        
        let imageViewHeight = self.question?.picture != nil ? 200 : 0
        
        fontSlider.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(140)
            make.top.equalToSuperview().offset(10)
        }
        content.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.fontSlider.snp.bottom).offset(10)
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.content.snp.bottom).offset(30)
            make.height.equalTo(imageViewHeight)
        }
        choiceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.top.equalTo(self.imageView.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func presentFullImage() {
        let vc = FullImageViewController()
        
        vc.picture = self.imageView.image(for: .normal)
        
        target.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - objc
    @objc
    func controlFont(_ sender: UISlider) {
        self.content.font = UIFont.systemFont(ofSize: CGFloat(sender.value))
    }
    
    
    @objc
    func loadFullImage(_ sender: UIButton) {
        presentFullImage()
    }
}

class FullImageViewController: UIViewController {
    
    lazy var dismissButton = { () -> UIButton in
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.dismissClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var imageView = { () -> UIScrollView in
        let scrollImg = UIScrollView()
        
        let imageView = UIImageView(image: self.picture)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        scrollImg.addSubview(imageView)
        scrollImg.contentMode = .scaleAspectFit
        scrollImg.center = self.view.center
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        return scrollImg
    }()
    
    weak var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(dismissButton)
        self.view.addSubview(imageView)
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchControl(_:))))
    }
    
    @objc
    func dismissClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func pinchControl(_ sender: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1.0
    }
}
