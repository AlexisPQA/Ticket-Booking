//
//  Coupon.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class Coupon {
    var code: String = ""
    var EFD: Date = .init() // Ngày có hiệu lực của coupon
    var EXP: Date = .init() // Ngày hết hiệu lực của coupon
    var discount : Double = 0 // Số % được discount (30 -> 30%)
    
    init() { }
    
    init(_ _code: String, _ _EFD: Date, _ _EXP: Date, _ _discount: Double) {
        self.code = _code
        self.EFD = _EFD
        self.EXP = _EXP
        self.discount = _discount
    }
    
    func calTotalPrice(price: Int) -> Int {
        return Int((1.0 - self.discount/100) * Double(price))
    }
}
