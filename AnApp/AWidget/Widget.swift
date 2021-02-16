//
//  AWidget.swift
//  AWidget
//
//  Created by Rohan Ramsay on 18/01/21.
//

import WidgetKit
import SwiftUI

@main
struct AWidget: Widget {
    let kind: String = AppGroupTarget.widget.widgetKind!

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
