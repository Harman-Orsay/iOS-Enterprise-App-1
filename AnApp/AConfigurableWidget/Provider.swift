//
//  Provider.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
        
    typealias Entry = WidgetEntry
    
    let users: [User]

    init(storeURL: URL?) {
        guard let storeUrl = storeURL else {
            self.users = []
            return
        }
        let data = (try? Data(contentsOf: storeUrl)) ?? Data()
        self.users = (try? JSONDecoder().decode([User].self, from: data)) ?? []
    }
    
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(),
                    configuration: WidgetConfigurationIntent(),
                    user: User.placeholder,
                    summary: nil)
    }

    func getSnapshot(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), configuration: configuration, user: nil, summary: nil)
        completion(entry)
    }

    func getTimeline(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []
        var filteredUsers: [User] = users.count > 0 || configuration.showMocks == false ? users : loadMockUsers()
        let summary: Summary = Summary(userCount: filteredUsers.count == 0 ? nil : filteredUsers.count,
                                       activeUserCount: filteredUsers.count == 0 ? nil : filteredUsers.filter{$0.isActive}.count)
        if configuration.showInactiveUsers == false{
            filteredUsers = filteredUsers.filter{$0.isActive}
        }
                
        filteredUsers.shuffle()

        var currentDate = Date()
        for user in filteredUsers { //5 minute difference at least
            let entryDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
            currentDate = entryDate
            let entry = WidgetEntry(date: entryDate, configuration: configuration, user: user, summary: summary)
            entries.append(entry)
        }

        if entries.count == 0 {
            let entry = WidgetEntry(date: Date(), configuration: configuration, user: nil, summary: nil)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

extension Provider {
    func loadMockUsers() -> [User] {
        class EmptyClass{}
        let data = (try? Data(contentsOf: Bundle(for: EmptyClass.self).url(forResource: "MockWidgetStore", withExtension: "json")!)) ?? Data()
        return (try? JSONDecoder().decode([User].self, from: data)) ?? []
    }
}
