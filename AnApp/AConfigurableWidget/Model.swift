//
//  Model.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetConfigurationIntent
    let user: UserDTO?
}

//DUPLICATE from APP KIT - dont wanna import appkit but dont wann redeclare a model either ???
//soln - a smaller struct derived from the main DTO ?
struct UserDTO: Codable { // for GET & POST
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let email: String
    let gender: String
    let name: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case gender
        case name
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static let placeholder: UserDTO = UserDTO(id: 1, createdAt: nil, updatedAt: nil, email: "email", gender: "gender", name: "name", status: "status")
}

extension UserDTO {
    
    var isActive: Bool {
        status == "Active"
    }
    
    var createdAtDate: Date? {
        createdAt?.toDate(dateFormatter: Self.dateFormatter)
    }
    
    var updatedAtDate: Date? {
        updatedAt?.toDate(dateFormatter: Self.dateFormatter)
    }
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}
