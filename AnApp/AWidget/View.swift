//
//  EntryView.swift
//  AWidgetExtension
//
//  Created by Rohan Ramsay on 12/02/21.
//

import WidgetKit
import SwiftUI

struct AWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Text("Users")
                .font(.headline)
            Text(entry.date, style: .time)

        }
    }
}


struct AWidget_Previews: PreviewProvider {
    static var previews: some View {
        AWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
