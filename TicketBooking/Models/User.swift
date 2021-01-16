//
//  User.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/25/20.
//

import Foundation

class User {
    var email: String = ""
    var name: String = ""
    var phone: String = ""
    var idCard: String = ""
    var address: String = ""
    var permission: Int = 0 // 0: chưa đăng nhập. 1: người dùng thường. 2: quản lý garage. 3: quản lý station.
}
