//
//  BusStationCollectionViewCell.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/23/20.
//

import UIKit
import Cosmos
class BusStationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var RatingStar: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.height/2
        backgroundColor = UIColor.white
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
