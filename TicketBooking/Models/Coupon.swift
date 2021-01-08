//
//  Coupon.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class Coupon : Codable {
    var code: String = ""
    var EFD: Date = .init() // Ngày có hiệu lực của coupon
    var EXP: Date = .init() // Ngày hết hiệu lực của coupon
    var discount : Double = 0 // Số % được discount (30 -> 30%)
    
    init() { }
    
    init(code: String, EFD: Date, EXP: Date, discount: Double) {
        self.code = code
        self.EFD = EFD
        self.EXP = EXP
        self.discount = discount
    }
    
    // true: EFD <= bookingDate <= EXP
    func isValid(bookingDate: Date) -> Bool {
        return ((EFD.compare(bookingDate).rawValue >= 0) && (bookingDate.compare(EXP).rawValue >= 0))
    }
    
    func calTotalPrice(price: Int) -> Int {
        //Check hiệu lực của coupon
        return Int((1.0 - self.discount/100) * Double(price))
    }
}
