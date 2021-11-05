//
//  SharedUI.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class ManageSendRequestCell: UICollectionViewCell {
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    var cancel: (() -> Void) = { }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        cancel()
    }
}
