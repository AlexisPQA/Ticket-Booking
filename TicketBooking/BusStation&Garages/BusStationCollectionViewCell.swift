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
}
