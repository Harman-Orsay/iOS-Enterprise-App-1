//
//  Provider.swift
//  AConfigurableWidget
//
//  Created by Rohan Ramsay on 15/02/21.
//

import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
        
    typealias Entry = SimpleEntry
    
    let users: [UserDTO]

    init(storeURL: URL?) {
        guard let storeUrl = storeURL else {
            self.users = []
            return
        }
        let data = (try? Data(contentsOf: storeUrl)) ?? Data()
        self.users = (try? JSONDecoder().decode([UserDTO].self, from: data)) ?? []
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: WidgetConfigurationIntent(), user: UserDTO.placeholder)
    }

    func getSnapshot(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, user: nil)
        completion(entry)
    }

    func getTimeline(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var filteredUsers: [UserDTO] = users.count > 0 || configuration.showMocks == false ? users : loadMockUsers()
        
        if configuration.showInactiveUsers == false{
            filteredUsers = users.filter{$0.isActive}
        }
        
        filteredUsers.shuffle()

        let currentDate = Date()
        for user in filteredUsers { //5 minute difference at least! - didn work - 5, 15
            let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, user: user)
            entries.append(entry)
        }

        if entries.count == 0 {
            let entry = SimpleEntry(date: Date(), configuration: configuration, user: nil)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

extension Provider {
    func loadMockUsers() -> [UserDTO] {
        class EmptyClass{}
        let data = (try? Data(contentsOf: Bundle(for: EmptyClass.self).url(forResource: "MockWidgetStore", withExtension: "json")!)) ?? Data()
        return (try? JSONDecoder().decode([UserDTO].self, from: data)) ?? []
    }
}
