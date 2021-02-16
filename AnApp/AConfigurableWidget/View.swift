//
//  View.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit
import SwiftUI

struct AConfigurableWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let user = entry.user {
            UserWidgetView(user: user,
                           showEmail: entry.configuration.displayedFields?.fields.showEmail == true,
                           showGender: entry.configuration.displayedFields?.fields.showGender == true)
        } else {
            Text("No users found, launch the app to load users OR enable mocks")
                .lineLimit(nil)
                .padding()
        }
    }
}

struct UserWidgetView : View {
    var user: UserDTO
    var showEmail: Bool
    var showGender: Bool
    
    var body: some View {
        VStack {
            Text(user.name)
            
            if showEmail {
                Text(user.email)
            }
            
            if showGender {
                Text(user.gender)
            }
        }
        .padding()
    }
}


struct AConfigurableWidget_Previews: PreviewProvider {
    static var previews: some View {
        AConfigurableWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: WidgetConfigurationIntent(), user: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
