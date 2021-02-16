//
//  IntentHandler.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import Intents
import WidgetKit

class WidgetConfigurationIntentHandler: INExtension, WidgetConfigurationIntentHandling {
    
    func provideDisplayedFieldsOptionsCollection(for intent: WidgetConfigurationIntent, with completion: @escaping (INObjectCollection<DisplayedFields>?, Error?) -> Void) {
        
        let displayedFieldSets: [DisplayedFields] = [DisplayableFieldSet.name.selectableField,
                                                     DisplayableFieldSet.name_email.selectableField,
                                                     DisplayableFieldSet.name_email_gender.selectableField]
        
        completion(INObjectCollection(items: displayedFieldSets), nil)
    }
}

extension DisplayableFieldSet {
    
    var identifier: String {
        switch self {
        case .unknown: return ""
        case .name: return "name"
        case .name_email: return "name_email"
        case .name_email_gender: return "name_email_gender"
        }
    }
    
    var displayName: String {
        switch self {
        case .unknown: return ""
        case .name: return "Name only"
        case .name_email: return "Name & Email"
        case .name_email_gender: return "Name, Email & Gender"
        }
    }
    
    var showEmail: Bool {
        switch self {
        case .unknown, .name: return false
        default: return true
        }
    }
    
    var showGender: Bool {
        self == .name_email_gender
    }
    
    var selectableField: DisplayedFields {
        let field = DisplayedFields(identifier: identifier, display: displayName)
        field.fields = self
        return field
    }
}
