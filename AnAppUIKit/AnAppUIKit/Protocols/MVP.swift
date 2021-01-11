//
//  MVP.swift
//  AnAppUIKit
//
//  Created by Rohan Ramsay on 11/01/21.
//

import Foundation

//markers
 
public protocol Presenter: class {
    func uiDidLoad()
}
public protocol UI: class {}
public protocol Responder: class {}
public protocol Navigator: Responder {}
//reposnder & navigator r both implemented by view model / presenter For //for presenter / view model (they receive it)

