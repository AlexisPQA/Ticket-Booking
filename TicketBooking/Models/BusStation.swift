//
//  BusStation.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

class BusStation : Codable {
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var openTime: String = ""
    var utilitiesIncluded: String = ""
    var rating: Double = 0.0
    var manager: String = "" // E-mail của account. Mỗi Station có 1 quản lý
    
    init() { }
    
    init(id: String, name: String, address: String, openTime: String, utilities: String, rating: Double, manager: String) {
        self.id = id
        self.name = name
        self.address = address
        self.openTime = openTime
        self.utilitiesIncluded = utilities
        self.rating = rating
        self.manager = manager
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.get("id") as! String
        self.name = document.get("name") as! String
        self.address = document.get("address") as! String
        self.openTime = document.get("openTime") as! String
        self.utilitiesIncluded = document.get("utilitiesIncluded") as! String
        self.rating = document.get("rating") as! Double
        self.manager = document.get("manager") as! String
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rating = try values.decode(Double.self, forKey: .rating)
    }
}
