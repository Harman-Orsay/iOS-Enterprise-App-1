//
//  IntentHandler.swift
//  IntentHandlerProvider
//
//  Created by Rohan Ramsay on 15/02/21.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if intent is WidgetConfigurationIntent {
            return WidgetConfigurationIntentHandler()
        }
        
        return self
    }
    
}

/*
 Ramsay sayth - Since most intents will be used within their respective targets (eg. widget configuration intent will stay inside the widget), it's a better design to keep the intent handler inside that product & only use this as a common IntentExtension for all intents -- acting as a provider for particular intent handlers.

 1. The .intentDefinition & the real intent handler files must be made members of this target (in addition to their own)
 2. Intent class must be added to the Supported intents of this target; use it for differentiating between intents in the handler method.
 */
