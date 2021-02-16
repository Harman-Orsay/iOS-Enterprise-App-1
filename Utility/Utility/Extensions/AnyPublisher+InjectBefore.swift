//
//  AnyPublisher+InjectBefore.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 4/01/21.
//

import Combine

public extension AnyPublisher {
    
    func inject(beforeStart: (() -> Void)?) -> Self {
        guard let block = beforeStart else {return self}
        
        return Just(())
            .handleEvents(receiveOutput: {_ in block()})
            .flatMap{_ -> Self in self}
            .eraseToAnyPublisher()
    }
}
