//
//  ExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class ExamRootViewController: UIViewController {
    
    // MARK: - ViewModel + Initializer
    let viewModel: ExamPagableViewModel
    let examType: ExamType
    let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ExamPagableViewModel,
         type: ExamType) {
        
        self.viewModel = viewModel
        self.examType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI
    lazy var examNavigatorButton = { () -> UIBarButtonItem in
        let buttonEdge: CGFloat = 30
        
        let customView = UIButton()
        customView.frame.size = CGSize(width: buttonEdge, height: buttonEdge)
        customView.setViewCornerRadius(radius: buttonEdge / 2)
        customView.backgroundColor = UIColor(named: "LightAccent")
        customView.setTitleColor(.black, for: .normal)
        customView.addTarget(self, action: #selector(self.presentQuestionList(_:)), for: .touchUpInside)
        
        self.viewModel.currentQuestionSubject
            .map({ $0?.questionNumber })
            .map({ $0 == nil ? "E" : String($0!) })
            .bind(onNext: { title in
                customView.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: customView)
    }()
    
    lazy var exitButton = { () -> UIBarButtonItem in
        let exit = UIBarButtonItem(title: "나가기", style: .plain, target: self, action: #selector(self.exitExam(_:)))
        
        return exit
    }()
    
    lazy var titleBar = { () -> UINavigationBar in
        let bar = UINavigationBar()
        
        bar.barTintColor = .white
        bar.setItems([UINavigationItem()], animated: true)
        bar.topItem?.setLeftBarButtonItems([self.examNavigatorButton, .fixedSpace(20), self.exitButton], animated: true)
        
        return bar
    }()
    
    lazy var examNavigator = { () -> ExamNavigator in
        let pager = ExamNavigator(viewModel: self.viewModel)
        
        return pager
    }()
    
    lazy var tabBarPager = { () -> ExamTabBarPager in
        let pager = ExamTabBarPager(viewModel: self.viewModel)
        
        return pager
    }()
    
    lazy var containerView = { (type: ExamType) -> UIView in
        let containerView = ContainerViewFactory.getContainerView(of: type, question: self.viewModel.currentQuestion, target: self)
        
        return containerView
    }(self.examType)
    
    // MARK: - Method
    
    public func presentQuestion(at index: Int) {
        
        let animateDirection: AnimateDirection = (index < self.viewModel.currentQuestion!.questionNumber! ? .prev : .next)
        viewModel.setCurrentQuestion(to: index)
        
        let newContainerView = ContainerViewFactory.getContainerView(of: self.examType, question: viewModel.currentQuestion, target: self)
        
        presentContainerViewWithAnimation(newContainerView, direction: animateDirection)
        tabBarPager.setPagerButtonStatus()
    }
    
    private func presentNewQuestion(at index: Int) {
        guard viewModel.hasQuestionNumber(index) else { return }
        
    }
    
    enum AnimateDirection {
        case prev
        case next
        
        func getFrame(origin: CGRect) -> CGRect {
            let x = (self == .next ? origin.maxX : -origin.maxX)
            
            return CGRect(x: x, y: origin.minY, width: origin.width, height: origin.height)
        }
        
        func getAffineTransform(origin: CGRect) -> CGAffineTransform {
            let translationX = (self == .next ? -origin.width : origin.width)
            
            return CGAffineTransform(translationX: translationX, y: 0)
        }
    }
    
    private func presentContainerViewWithAnimation(_ newContainerView: ContainerView, direction: AnimateDirection) {
        let containerViewFrame = self.containerView.frame
        newContainerView.frame = direction.getFrame(origin: containerViewFrame)
        
        let tempContainerView = self.containerView
        
        self.view.addSubview(tempContainerView)
        self.view.addSubview(newContainerView)
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            let transform = direction.getAffineTransform(origin: containerViewFrame)
            tempContainerView.transform = transform
            newContainerView.transform = transform
        }
        animator.addCompletion { _ in
            self.containerView = ContainerViewFactory.getContainerView(of: self.examType, question: self.viewModel.currentQuestion, target: self)
            self.rebuildContainerViewConstraints()
            
            tempContainerView.removeFromSuperview()
            newContainerView.removeFromSuperview()
        }
        
        animator.startAnimation()
    }
    
    private func presentQuestionListWithAnimation() {
        self.view.addSubview(examNavigator)
        examNavigator.snp.makeConstraints { make in
            make.top.equalTo(self.titleBar.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        examNavigator.popUp()
    }
    
    private func dismissQuestionListWithAnimation() {
        examNavigator.popDown {
            self.examNavigator.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(titleBar)
        self.view.addSubview(tabBarPager)
        self.view.addSubview(containerView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTapGestureRecognizer(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        buildConstraints()
        addtabBarPagerTargets()
    }
    
    private func buildConstraints() {
        titleBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tabBarPager.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarPager.snp.top)
            make.top.equalTo(titleBar.snp.bottom)
        }
    }
    
    private func rebuildContainerViewConstraints() {
        self.view.addSubview(self.containerView)
        
        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarPager.snp.top)
            make.top.equalTo(titleBar.snp.bottom)
        }
    }
    
    private func addtabBarPagerTargets() {
        tabBarPager.addNextQuestionTarget(self, action: #selector(presentNextQuestion(_:)))
        tabBarPager.addPrevQuestionTarget(self, action: #selector(presentPrevQuestion(_:)))
    }
}

// MARK: - objc methods
extension ExamRootViewController {
    
    @objc
    private func presentQuestionList(_ sender: UIButton) {
        if self.view.subviews.contains(examNavigator) {
            dismissQuestionListWithAnimation()
        }
        else {
            presentQuestionListWithAnimation()
        }
    }
    
    @objc
    private func dismissTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if self.view.subviews.contains(examNavigator) {
            dismissQuestionListWithAnimation()
        }
    }
    
    @objc
    private func exitExam(_ sender: UIBarButtonItem) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "나가기", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.present(title: "나가기",
                      context: """
                      시험 문제 수정을 종료할까요?
                      변경 사항은 저장되지 않습니다.
                      """,
                      actions: [cancel, okay])
    }
    
    @objc
    private func presentNextQuestion(_ sender: UIButton) {
        guard let currentQuestionNumber = viewModel.currentQuestion?.questionNumber else {
            print("ExamRootViewController::presentNextQuestion(_:) -> currentQuestion is nil.")
            return
        }
        
        let nextQuestionNumber = currentQuestionNumber + 1
        presentQuestion(at: nextQuestionNumber)
    }
    
    @objc
    private func presentPrevQuestion(_ sender: UIButton) {
        guard let currentQuestionNumber = viewModel.currentQuestion?.questionNumber else {
            print("ExamRootViewController::presentPrevQuestion(_:) -> currentQuestion is nil.")
            return
        }
        
        let prevQuestionNumber = currentQuestionNumber - 1
        presentQuestion(at: prevQuestionNumber)
    }
}

extension ExamRootViewController: UIViewControllerTransitioningDelegate {
    // Half Modal
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
