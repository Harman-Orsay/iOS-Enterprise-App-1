//
//  AConfigurableWidget.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 12/02/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct AConfigurableWidget: Widget {
    let kind: String = AppGroupTarget.configurableWidget.widgetKind!

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: WidgetConfigurationIntent.self,
                            provider: Provider(storeURL: AppGroupTarget.configurableWidget.storeUrl)) { entry in
            
            UserWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemSmall])
        .configurationDisplayName("A configurable Widget")
        .description("A configurable widget showing random users")
    }
}


