//
//  StationInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit

class StationInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var utilitiesIncluedLabel: UILabel!
    @IBOutlet weak var garagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bus station"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        
        Utilities.styleImageFrame(image)
        
        garagesCollectionView.delegate = self
        garagesCollectionView.dataSource = self
        
    }

    @IBAction func showGarageView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "garageInfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showBookingView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ticketBookingViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showTicketView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ticketInfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = garagesCollectionView.dequeueReusableCell(withReuseIdentifier: "garageCollectionViewCell", for: indexPath) as! GarageCollectionViewCell
        
        cell.layer.cornerRadius = 6
        cell.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.shadowOffset = .init(width: 0, height: 3)
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.16
        
        return cell
    }
    
}

class GarageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}
