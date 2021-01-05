//
//  UseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 1/01/21.
//

import Foundation
import Combine

public protocol UseCase {
    associatedtype Result
    
    func execute(onStart: (() -> Void)?) -> Result
}

typealias CancellableUseCase = UseCase & Cancellable

public enum LoginError: Error{
    case network
    case notFound
}
public enum LogOutError: Error{ //in case logout has an api call
    case network
    case unknown
}

public enum SessionError: Error {
    case expired
    case notFound
}

public enum ErrorX: Error {
    case unknown
}
