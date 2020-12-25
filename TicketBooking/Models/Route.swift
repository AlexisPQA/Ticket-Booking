//
//  Route.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class Route {
    
    var id: String = ""
    var garage: String = "" // ID của garage
    // Nơi đi lấy từ garage
    var destination: String = ""
    var licensePlate: String = ""
    var seats: [Bool] = [true]
    var aSeatPrice: Int = 0
    var departureTime: Date = .init()
    
}
