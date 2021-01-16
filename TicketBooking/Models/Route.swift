//
//  Route.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

class Route : Codable {
    
    var id: String = ""
    var garage: String = "" // ID của garage
    // Nơi đi lấy từ garage
    var destination: String = ""
    var licensePlate: String = ""
    var seats = [Bool](repeating: true, count: 46)
    var aSeatPrice: Int = 0
    var departureTime: Date = Date()
    
    init() { }
    
    init(id: String, garage: String, destination: String, license: String, seats: [Bool], aSeatPrice: Int, departureTime: Date) {
        self.id = id
        self.garage = garage
        self.destination = destination
        self.licensePlate = license
        for i in 0...45 {
            self.seats[i] = seats[i]
        }
        self.seats = seats
        self.aSeatPrice = aSeatPrice
        self.departureTime = departureTime
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        seats = try values.decode([Bool].self, forKey: .seats)
        aSeatPrice = try values.decode(Int.self, forKey: .aSeatPrice)
        departureTime = try values.decode(Date.self, forKey: .departureTime)
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.get("id") as! String
        self.garage = document.get("garage") as! String
        self.destination = document.get("destination") as! String
        self.licensePlate = document.get("licensePlate") as! String
        self.seats = document.get("seats") as! [Bool]
        self.aSeatPrice = document.get("aSeatPrice") as! Int
        
        let date = document.get("departureTime") as! NSNumber
        let timeInterval = TimeInterval(date.intValue)
        self.departureTime = Date(timeIntervalSince1970: timeInterval)
    }
    
}
