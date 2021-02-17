//
//  Model.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit
import Foundation

struct WidgetEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetConfigurationIntent
    
    let user: User?
    let summary: Summary?
}

//Similar to UserDTO - objctive is to avoid importing the whole AppKit & not sharing the files across targets unless absolutely essential. + using models from real kit will burden compliance -- easier for the widget to dictate the model!
//TODO: - Put this model in a separate file
//- add that file to main app target
//- add methods there to make sure app uses them to get the data it writes to the widget store!!!

struct User: Codable {
    let id: Int?
    let email: String
    let gender: String
    let name: String
    let status: String
    
    var isActive: Bool {
        status == "Active"
    }
    
    var isMale: Bool {
        gender == "Male"
    }
    
    var widgetUrl: URL {
        var components = URLComponents()
        components.scheme = "userwidget"
        components.host = "user"
        
        var parameters = [URLQueryItem]()
        if let id = self.id {
            parameters.append(URLQueryItem(name: "id", value: "\(id)"))
        }
        parameters.append(URLQueryItem(name: "email", value: email))
        parameters.append(URLQueryItem(name: "name", value: name))
        parameters.append(URLQueryItem(name: "gender", value: gender))
        components.queryItems = parameters
        
        return components.url ?? URL(string: "userwidget://formattingerror")!
    }
    
    static let placeholder: User = User(id: nil, email: "email", gender: "gender", name: "name", status: "status")
}

struct Summary {
    let userCount: Int?
    let activeUserCount: Int?
    
    var widgetUrl: URL {
        URL(string:"userwidget://summary")!
    }
}
