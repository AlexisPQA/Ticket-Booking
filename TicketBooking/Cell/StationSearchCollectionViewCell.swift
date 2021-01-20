//
//  StationSearchCollectionViewCell.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/19/21.
//

import UIKit

class StationSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.width/2
        
    }
}
