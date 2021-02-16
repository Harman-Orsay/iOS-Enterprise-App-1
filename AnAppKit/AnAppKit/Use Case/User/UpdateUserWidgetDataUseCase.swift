//
//  UpdateUserWidgetDataUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 16/02/21.
//

import Foundation
import Utility

public class UpdateUserWidgetDataUseCase: UseCase {
    public typealias Result = Bool
    
    private var list: [User]
    private var storeUrl: URL
    
    init(widgetList: [User], widgetStoreUrl: URL) {
        self.list = widgetList
        self.storeUrl = widgetStoreUrl
    }
    
    public func execute(onStart: (() -> Void)?) -> Bool {
        let encodableList = list.map{UserDTO(from: $0)}
        do {
            let newData = try JSONEncoder().encode(encodableList)
            try File.update(content: newData, at: storeUrl)
            return true
        } catch {
            return false
        }
    }
}
