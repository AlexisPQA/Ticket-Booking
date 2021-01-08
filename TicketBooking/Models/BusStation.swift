//
//  BusStation.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class BusStation {
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
}
