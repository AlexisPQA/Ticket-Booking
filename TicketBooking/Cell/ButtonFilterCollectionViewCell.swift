//
//  ButtonFilterCollectionViewCell.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/19/21.
//

import UIKit


@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 16.0
    @IBInspectable var rightInset: CGFloat = 16.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
class ButtonFilterCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var fakeBtn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fakeBtn.layer.borderColor = Utilities.mainColor.cgColor
        fakeBtn.layer.borderWidth = 1
        fakeBtn.layer.cornerRadius = fakeBtn.frame.height/2
        
    }
}
