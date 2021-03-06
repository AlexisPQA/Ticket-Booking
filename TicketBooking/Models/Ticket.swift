//
//  Ticket.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

class Ticket : Codable {
    
    var id: String? = "" // ID của Ticket = route#account#Date().timeIntervalSinceReferenceDate
    
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
    var coupon: String = "" // Lưu Coupon().code
    var price: Int = 0
    var totalPrice: Int = 0
    var paymentMethod: Int = 0 // 0: Cast / 1: Internet banking
    
    init() { }
    
    init(id: String, account: String, passengerName: String, idCard: String, phone: String, pickUpAddress: String, route: String, seats: [Int], coupon: String, price: Int, totalPrice:Int, paymentMethod: Int) {
        self.id = id
        self.account = account
        self.passengerName = passengerName
        self.idCard = idCard
        self.phone = phone
        self.pickUpAddress = pickUpAddress
        self.route = route
        self.seats = seats
        self.coupon = coupon
        self.price = price
        self.totalPrice = totalPrice
        self.paymentMethod = paymentMethod
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.data()!["id"] as? String
        self.account = document.get("account") as! String
        self.idCard = document.get("idCard") as! String
        self.passengerName = document.get("passengerName") as! String
        self.paymentMethod = document.get("paymentMethod") as! Int
        self.phone = document.get("phone") as! String
        self.pickUpAddress = document.get("pickUpAddress") as! String
        self.price = document.get("price") as! Int
        self.route = document.get("route") as! String
        self.seats = document.get("seats") as! [Int]
        self.coupon = document.get("coupon") as! String
        self.totalPrice = document.get("totalPrice") as! Int
    }
}
