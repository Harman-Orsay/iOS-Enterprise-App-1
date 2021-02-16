//
//  File.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 25/12/20.
//

import Foundation

public class File {
    
    public static func getData(name: String, withExtension: String = "json") -> Data? {
        let bundle = Bundle(for: Self.self)
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try? Data(contentsOf: fileUrl!)
        return data
    }
    
    public static func getData(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
    
    public static func update(content: Data, at url: URL) throws {
        try content.write(to: url, options: .atomic)
    }
}
