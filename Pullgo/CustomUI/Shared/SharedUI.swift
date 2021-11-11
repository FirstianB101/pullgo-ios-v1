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

extension CALayer {
    func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arrEdge {
            let border = CALayer()
            switch edge {
                case UIRectEdge.top:
                    border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                    break
                case UIRectEdge.bottom:
                    border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                    break
                case UIRectEdge.left:
                    border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                    break
                case UIRectEdge.right:
                    border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                    break
                default:
                    break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
