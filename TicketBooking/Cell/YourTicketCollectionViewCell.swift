//
//  YourTicketCollectionViewCell.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/19/21.
//

import UIKit

class YourTicketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var garage: UILabel!
    @IBOutlet weak var Transshipment: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var licenseplate: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
        layer.shadowOffset = CGSize(width: 3, height: 2.0)//CGSizeMake(0, 2.0);
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        layer.cornerRadius = 6
    }
}
