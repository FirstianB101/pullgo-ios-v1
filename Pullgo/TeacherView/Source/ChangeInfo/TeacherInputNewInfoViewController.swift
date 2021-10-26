//
//  TeacherInputNewInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa

class TeacherInputNewInfoViewController: UITableViewController {
	
	@IBOutlet weak var fullNameField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	
	let viewModel = TeacherInputNewInfoViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initializeField()
		setViewWidth([fullNameField, phoneField])
	}
	
	private func initializeField() {
		fullNameField.text = viewModel.getFullName()
		phoneField.text = viewModel.getPhone()
	}
	
	private func setViewWidth(_ views: [UIView]) {
		let width = self.view.frame.width * 0.4
		
		for view in views {
			view.snp.makeConstraints { make in
				make.width.equalTo(width)
			}
		}
	}
 
	
	@IBAction func done(_ sender: UIBarButtonItem) {
		bindInput()
		
		let alert = PGAlertPresentor()
		let okay = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
			self?.viewModel.patchInfo {
				alert.present(title: "알림", context: "회원정보 수정이 완료되었습니다.") { _ in
					self?.dismiss(animated: true, completion: nil)
				}
			}
		}
		
		alert.present(title: "알림", context: "입력하신 정보로 회원정보를 수정합니다.", actions: [alert.cancel, okay])
	}
	
	private func bindInput() {
		guard let fullName = fullNameField.text,
			  let phone = phoneField.text else { return }
		
		viewModel.fullName = fullName
		viewModel.phone = phone
	}
}

class TeacherInputNewInfoViewModel {
	
	var fullName: String = PGSignedUser.teacher.account.fullName
	var phone: String = PGSignedUser.teacher.account.phone
	
	public func getFullName() -> String {
		return self.fullName
	}
	
	public func getPhone() -> String {
		return self.phone
	}
	
	public func patchInfo(complete: @escaping (() -> Void)) {
		let teacher = Teacher()
        teacher.id = PGSignedUser.id
		teacher.account = PGSignedUser.teacher.account
		
		teacher.account.fullName = self.fullName
		teacher.account.phone = self.phone
		
		teacher.patch(success: { data in
			data?.log()
			
			guard let received = try? data?.toObject(type: Teacher.self) else {
				print("Teacher::patch failed.")
				return
			}
			
			PGSignedUser.teacher = received
			complete()
		})
	}
}
