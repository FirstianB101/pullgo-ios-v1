//
//  TeacherRemoveExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/23.
//

import UIKit
import XLPagerTabStrip

class TeacherRemoveExamViewController: UIViewController, IndicatorInfoProvider {
    
    var viewModel: TeacherManageExamViewModel
    
    init?(coder: NSCoder, viewModel: TeacherManageExamViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("TeacherRemoveExamViewController: viewModel is nil.")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "취소 및 종료")
    }

    @IBAction func cancel(_ sender: UIButton) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "취소합니다.", style: .destructive) { [weak self] _ in
            self?.viewModel.selectedExam.cancel { _ in
                self?.completeAlertAndHandler(kind: "취소")
            }
        }
        let exit = UIAlertAction(title: "아니오", style: .default)
        
        alert.present(title: "시험 취소",
                      context: "\(viewModel.name) 시험을 정말 취소할까요?",
                      actions: [exit, okay])
    }
    
    @IBAction func finish(_ sender: UIButton) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "종료합니다.", style: .destructive) { [weak self] _ in
            self?.viewModel.selectedExam.cancel { _ in
                self?.completeAlertAndHandler(kind: "종료")
            }
        }
        let exit = UIAlertAction(title: "아니오", style: .default)
        
        alert.present(title: "시험 종료",
                      context: "\(viewModel.name) 시험을 정말 종료할까요?",
                      actions: [exit, okay])
    }
    
    func completeAlertAndHandler(kind: String) {
        let alert = PGAlertPresentor()
        alert.present(title: "알림",
                      context: "시험이 정상적으로 \(kind)되었습니다.") { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
