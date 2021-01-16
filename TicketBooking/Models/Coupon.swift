//
//  Coupon.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        EFD = try values.decode(Date.self, forKey: .EFD)
        EXP = try values.decode(Date.self, forKey: .EXP)
        discount = try values.decode(Double.self, forKey: .discount)
    }
    
    init(document: DocumentSnapshot) {
        self.code = document.get("code") as! String
        
        var date = document.get("EFD") as! NSNumber
        var timeInterval = TimeInterval(date.intValue)
        self.EFD = Date(timeIntervalSince1970: timeInterval)
        
        date = document.get("EXP") as! NSNumber
        timeInterval = TimeInterval(date.intValue)
        self.EXP = Date(timeIntervalSince1970: timeInterval)
        
        self.discount = document.get("discount") as! Double
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
