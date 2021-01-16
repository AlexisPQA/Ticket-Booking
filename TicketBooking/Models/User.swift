//
//  User.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation
import Firebase

class User : Codable {
    var email: String = ""
    var name: String = ""
    var phone: String = ""
    var idCard: String = ""
    var address: String = ""
    var permission: Int = 0 // 0: chưa đăng nhập. 1: người dùng thường. 2: quản lý garage. 3: quản lý station.
    
    init() {}
    
    init(permission: Int) {
        self.permission = permission
    }
    
    init(email: String, name: String, phone: String, idCard: String, address: String, permission: Int) {
        self.email = email
        self.name = name
        self.phone = phone
        self.idCard = idCard
        self.address = address
        self.permission = permission
    }
    
    init(document: DocumentSnapshot) {
        self.email = document.get("email") as! String
        self.name = document.get("name") as! String
        self.phone = document.get("phone") as! String
        self.idCard = document.get("idCard") as! String
        self.address = document.get("address") as! String
        self.permission = document.get("permission") as! Int
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        permission = try values.decode(Int.self, forKey: .permission)
    }
}
