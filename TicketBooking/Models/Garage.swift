//
//  Garage.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class Garage {
    
    var id: String = ""
    var address: String = ""
    var busStation: String = "" // ID của Station
    var name: String = ""
    var openTime: String = ""
    var ticketPrice: String = "" // Giá dao động của nhà xe (Dùng để hiển thị, giá chi tiết vé lưu trong Route)ar
    var rating: Double = 0.0
    var manager: [String] = [] // E-mail của những account làm quản lý. Mỗi station có nhiều quản lý
    
}
