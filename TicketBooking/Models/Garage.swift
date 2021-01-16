//
//  Garage.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

class Garage: Codable {
    
    var avatar: UIImage = UIImage()
    var id: String = ""
    var address: String = ""
    var busStation: String = "" // ID của Station
    var name: String = ""
    var openTime: String = ""
    var ticketPrice: String = "" // Giá dao động của nhà xe (Dùng để hiển thị, giá chi tiết vé lưu trong Route)ar
    var rating: Double = 0.0
    var manager: [String] = [] // E-mail của những account làm quản lý. Mỗi garage có nhiều quản lý
    
    init() { }
    
    init(id: String, address: String, busStation: String, name: String, openTime: String, ticketPrice: String, rating: Double, manager: [String]) {
        self.id = id
        self.address = address
        self.busStation = busStation
        self.name = name
        self.openTime = openTime
        self.ticketPrice = ticketPrice
        self.rating = rating
        for aManager in manager {
            self.manager.append(aManager)
        }
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.get("id") as! String
        self.address = document.get("address") as! String
        self.busStation = document.get("busStation") as! String
        self.name = document.get("name") as! String
        self.openTime = document.get("openTime") as! String
        self.ticketPrice = document.get("ticketPrice") as! String
        self.rating = document.get("rating") as! Double
        self.manager = document.get("manager") as! [String]
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        manager = try values.decode([String].self, forKey: .manager)
        rating = try values.decode(Double.self, forKey: .rating)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case address
        case busStation
        case name
        case openTime
        case ticketPrice
        case rating
        case manager
    }
}
