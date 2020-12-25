//
//  Ticket.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class Ticket {
    
    var account: String = "" // Lưu e-mail của account đặt vé
    
    // Thông tin của passenger
    var passengerName: String = ""
    var idCard: String = ""
    var phone: String = ""
    var pickUpAddress: String = ""
    
    // Thông tin của Route
    var route: String = "" // Lưu RouteID
    var seats: [Int] = []
    
    // Thông tin thanh toán
    var coupon: Coupon = Coupon()
    var price: Int = 0
    var totalPrice: Int = 0
    
    init(_ _account: String, _ _passengerName: String, _ _idCard: String, _ _phone: String, _ _pickUpAddress: String, _ _route: String, _ _seats: [Int], _ _coupon: Coupon, _ _price: Int, _ _totalPrice:Int) {
        self.account = _account
        self.passengerName = _passengerName
        self.idCard = _idCard
        self.phone = _phone
        self.pickUpAddress = _pickUpAddress
        self.route = _route
        self.seats = _seats
        self.coupon = _coupon
        self.price = _price
        self.totalPrice = _totalPrice
    }
}
