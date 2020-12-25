//
//  GarageInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit

class GarageInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var garageNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var routesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Garage"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        
        Utilities.styleImageFrame(image)
        Utilities.styleFloatButton(dateButton)
        
        routesCollectionView.delegate = self
        routesCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = routesCollectionView.dequeueReusableCell(withReuseIdentifier: "routeCollectionViewCell", for: indexPath) as! RouteCollectionViewCell
        
        cell.layer.cornerRadius = 6
        cell.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.shadowOffset = .init(width: 0, height: 3)
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.16
        
        return cell
    }
}

class RouteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
