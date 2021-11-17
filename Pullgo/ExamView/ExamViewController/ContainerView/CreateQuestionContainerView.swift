//
//  HistoryContainerView.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit
import SnapKit

class CreateQuestionContainerView: UIView, ContainerView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - UI
    lazy var questionContent = { () -> UITextView in
        let textView = UITextView()
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.2
        textView.textContainer.lineFragmentPadding = 10
        textView.setViewCornerRadius(radius: 15)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.addDismissToolbar()
        textView.delegate = self
        
        return textView
    }()
    
    lazy var questionLength = { () -> UILabel in
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "\(self.question?.content?.count ?? 0)/200자"
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var questionContentStack = { () -> UIStackView in
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        
        stack.addArrangedSubview(self.questionContent)
        stack.addArrangedSubview(self.questionLength)
        
        return stack
    }()
    
    lazy var addImageButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "LightAccent")
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitle(" 여기를 눌러 사진을 추가하세요.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.setViewCornerRadiusAndShadow(radius: 20)
        button.addTarget(self, action: #selector(self.addImage(_:)), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false
        
        return button
    }()
    
    lazy var deleteImageButton = { () -> UIButton in
        let button = UIButton()
        
        button.setTitle("사진 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .deleteBackground
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(self.deleteImageOfImageButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var editChoicesButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        
        guard let target = target as? CreateQuestionViewController else {
            fatalError("target is not a CreateQuestionViewController")
        }
        
        button.backgroundColor = UIColor(named: "LightAccent")
        button.setTitle("보기 작성", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setViewCornerRadiusAndShadow(radius: 25)
        
        button.addTarget(target, action: #selector(target.editChoice(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Property + Initializer
    var question: Question?
    let maxContentLength: Int = 200
    weak var target: UIViewController?
    var imagePicker = UIImagePickerController()
    
    required init(question: Question?, target: UIViewController) {
        self.question = question
        self.target = target
        super.init(frame: .zero)
        self.buildContraints()
        self.setContents()
        self.setBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackground() {
        self.backgroundColor = .white
    }
    
    private func buildContraints() {
        self.addSubview(questionContentStack)
        self.addSubview(addImageButton)
        self.addSubview(editChoicesButton)
        
        questionContentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.addImageButton.snp.top).offset(-30)
        }
        addImageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.editChoicesButton.snp.top).offset(-30)
            make.height.equalTo(40)
        }
        editChoicesButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        
        if self.question?.picture != nil {
            setAddImageButtonToImage()
        } else {
            deleteImageOfImageButton()
        }
    }
    
    private func setContents() {
        self.questionContent.text = question?.content ?? ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            PGNetwork.uploadImage(image: image, success: { url in
                self.question?.picture = image
                self.question?.pictureUrl = url
                self.setAddImageButtonToImage()
                
                self.target?.dismiss(animated: true, completion: nil)
            })
        } else {
            self.target?.dismiss(animated: true, completion: {
                let alert = PGAlertPresentor()
                alert.present(title: "오류", context: "이미지를 로드하지 못했습니다.")
            })
        }
    }
    
    private func setAddImageButtonToImage() {
        self.addImageButton.backgroundColor = .lightGray
        self.addImageButton.imageView?.contentMode = .scaleAspectFit
        self.addImageButton.setImage(self.question?.picture, for: .normal)
        self.addImageButton.setTitle(nil, for: .normal)
        
        self.addImageButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.questionContentStack.snp.bottom).offset(30)
            make.height.equalTo(250)
        }
        
        self.addSubview(deleteImageButton)
        self.deleteImageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.addImageButton.snp.bottom).offset(10)
            make.bottom.equalTo(self.editChoicesButton.snp.top).offset(-30)
            make.width.equalTo(80)
        }
        self.deleteImageButton.setViewCornerRadiusAndShadow(radius: 15)
    }
    
    
    
    // MARK: - objc Methods
    @objc
    func addImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            target?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc
    private func deleteImageOfImageButton() {
        self.addImageButton.backgroundColor = .lightAccent
        self.addImageButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        self.addImageButton.setTitle(" 여기를 눌러 사진을 추가하세요.", for: .normal)
        self.question?.picture = nil
        self.question?.pictureUrl = ""
        
        if self.subviews.contains(deleteImageButton) {
            deleteImageButton.removeFromSuperview()
        }
        self.addImageButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.questionContentStack.snp.bottom).offset(30)
            make.bottom.equalTo(self.editChoicesButton.snp.top).offset(-30)
            make.height.equalTo(40)
        }
    }
}

// TextView Placeholder
extension CreateQuestionContainerView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.question?.content = textView.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        
        if count > maxContentLength {
            textView.text.removeLast()
            questionLength.vibrate()
            return
        }
        
        questionLength.text = "\(count)/\(maxContentLength)자"
    }
}
