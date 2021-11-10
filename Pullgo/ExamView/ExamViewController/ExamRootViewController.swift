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

protocol ExamPagableViewModel {
    var currentQuestion: Question? { get set }
    var questions: [Question] { get set }
    var selectedExam: Exam { get }
    func hasQuestionNumber(_ number: Int) -> Bool
}

class ExamRootViewController: UIViewController {
    
    // MARK: - ViewModel + Initializer
    let viewModel: ExamPagableViewModel
    let type: ExamType
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ExamPagableViewModel,
         type: ExamType) {
        
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UI
    lazy var examNavigatorButton = { () -> UIBarButtonItem in
        let buttonEdge: CGFloat = 30
        
        let customView = UIButton()
        customView.frame.size = CGSize(width: buttonEdge, height: buttonEdge)
        customView.layer.cornerRadius = buttonEdge / 2
        customView.backgroundColor = UIColor(named: "LightAccent")
        customView.setTitleColor(.black, for: .normal)
        customView.setTitle(String(self.viewModel.currentQuestion?.questionNumber ?? 0), for: .normal)
        customView.addTarget(self, action: #selector(self.presentQuestionList(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: customView)
    }()
    
    lazy var titleBar = { () -> UINavigationBar in
        let bar = UINavigationBar()
        
        bar.barTintColor = .white
        bar.setItems([UINavigationItem()], animated: true)
        bar.topItem?.setLeftBarButton(self.examNavigatorButton, animated: false)
        
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
        let containerView = ContainerViewFactory.getContainerView(of: type, question: self.viewModel.currentQuestion)
        
        return containerView
    }(self.type)
    
    // MARK: - Method
    
    public func presentQuestion(at index: Int) {
        guard viewModel.hasQuestionNumber(index) else { return }
        guard let currentNumber = viewModel.currentQuestion else {
            print("ExamRootViewController::presentQuestion(at:) -> currentQuestion is nil.")
            return
        }
        
        
    }
    
    private func presentNewQuestion(at index: Int) {
        guard viewModel.hasQuestionNumber(index) else { return }
        
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
    private func presentNextQuestion(_ sender: UIButton) {
        guard let currentQuestionNumber = viewModel.currentQuestion?.questionNumber else {
            print("ExamRootViewController::presentNextQuestion(_:) -> currentQuestion is nil.")
            return
        }
        
        let nextQuestionNumber = currentQuestionNumber + 1
        guard viewModel.hasQuestionNumber(nextQuestionNumber) else {
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "마지막 문제입니다.")
            return
        }
        
        presentQuestion(at: nextQuestionNumber)
    }
    
    @objc
    private func presentPrevQuestion(_ sender: UIButton) {
        guard let currentQuestionNumber = viewModel.currentQuestion?.questionNumber else {
            print("ExamRootViewController::presentPrevQuestion(_:) -> currentQuestion is nil.")
            return
        }
        
        let prevQuestionNumber = currentQuestionNumber - 1
        guard viewModel.hasQuestionNumber(prevQuestionNumber) else {
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "첫 번째 문제입니다.")
            return
        }
        
        presentQuestion(at: prevQuestionNumber)
    }
}

extension ExamRootViewController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        container.addSubview(toView)
        
        let x: CGFloat = self.view.frame.maxX
        let y: CGFloat = 0
        toView.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            toView.transform = CGAffineTransform(translationX: -x, y: 0)
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
    }
}

extension ExamRootViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    // Half Modal
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented is QuestionChoiceViewController {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
        } else {
            return nil
        }
    }
}
