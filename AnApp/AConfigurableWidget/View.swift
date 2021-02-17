//
//  View.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit
import SwiftUI

struct UserWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if let user = entry.user, widgetFamily == .systemMedium {
            Link(destination: user.widgetUrl) {
                UserWidgetView_medium(user: user,
                                      showEmail: entry.configuration.displayedFields?.fields.showEmail == true,
                                      showGender: entry.configuration.displayedFields?.fields.showGender == true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .blue]),
                                               startPoint: .top,
                                               endPoint: .bottomLeading))
            }
            
        } else if let summary = entry.summary, widgetFamily == .systemSmall {
            
            SummaryWidgetView_small(summary: summary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]),
                                           startPoint: .top,
                                           endPoint: .bottom))
                .widgetURL(summary.widgetUrl)
            
        } else {
            
            Text("No users found!\n\nLaunch the app to load users OR enable mocks")
                .lineLimit(nil)
                .padding()
        }
    }
}

struct UserWidgetView_medium: View {
    var user: User
    var showEmail: Bool
    var showGender: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Random user")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                    
                    if showEmail {
                        Text(user.email)
                    }
                }
                
                if showGender {
                    VStack {
                        Text(Image(systemName: user.isMale ? "iphone" : "iphone.slash"))
                            .foregroundColor(user.isMale ? .blue : .pink)
                        Text(user.gender)
                            .foregroundColor(user.isMale ? .blue : .pink)
                    }
                }
            }
        }
        .padding()
    }
}

struct SummaryWidgetView_small: View {
    var summary: Summary
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 24){
            
            Text("Summary")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    Text("Users: ")
                        .font(.headline)
                    if let ucount = summary.userCount {
                        Text("\(ucount)")
                    } else {
                        Text("NA")
                    }
                }
                
                HStack{
                    Text("Active Users: ")
                        .font(.headline)
                    if let acount = summary.activeUserCount {
                        Text("\(acount)")
                    } else {
                        Text("NA")
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
    }
}


struct AConfigurableWidget_Previews: PreviewProvider {
    static var previews: some View {
        UserWidgetEntryView(entry: WidgetEntry(date: Date(), configuration: WidgetConfigurationIntent(), user: nil, summary: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
