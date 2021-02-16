//
//  AppGroup.swift
//  AnApp
//
//  Created by Rohan Ramsay on 16/02/21.
//

import Foundation
import Utility

enum AppGroupTarget: String {
    case widget
    case configurableWidget
    case someCommonGroup
    
    var identifier: String {
        switch self {
        case .widget, .configurableWidget: return "group.com.harman-orsay.anapp.widget"
        case .someCommonGroup: return "group.com.harman-orsay.appgroup"
        }
    }
    
    var widgetKind: String? {
        switch self {
        case .widget: return "a_simple_widget"
        case .configurableWidget: return "a_configurable_widget"
        default: return nil
        }
    }
    
    var storeUrl: URL? {
        Path.inDirectory(at: containerUrl, fileName: storeName)
    }
    
    private var containerUrl: URL? {
        guard let container = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: self.identifier) else {return nil}
        return Path.inDirectory(at: container, fileName: storeDirectoryName, isDirectory: true)
    }
    
    private var storeDirectoryName: String {
        switch self {
        case .widget, .configurableWidget: return "widgetData"
        case .someCommonGroup: return "commonData"
        }
    }
    
    private var storeName: String {
        switch self {
        case .widget, .configurableWidget: return "users.json"
        case .someCommonGroup: return "data.json"
        }
    }
}

//real app group identifiers need to be setup in capabialities & on apple developer
//enum will hide implementation & group visibility from members
//same group can be used by multiple targets without them knowing
//each shared store is a single json file - sufficient for widgets
