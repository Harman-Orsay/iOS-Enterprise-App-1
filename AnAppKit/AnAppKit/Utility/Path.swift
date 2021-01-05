//
//  Path.swift
//
//  Created by Rohan Ramsay on 1/01/21.
//

struct Path {
    static func getAppSupportDirectoryPath() -> URL? {
        return try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    static func inAppSupportDirectory(directory: String) -> URL? {
        if let url = Path.getAppSupportDirectoryPath()?.appendingPathComponent(directory, isDirectory: true){
            if !FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            }
            return url
        }
        return getAppSupportDirectoryPath()
    }
    
    static func inAppSupportDirectory(_ fileName: String) -> URL {
        if let baseUrl = getAppSupportDirectoryPath() {
            return baseUrl.appendingPathComponent(fileName, isDirectory: false)
        }
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName, isDirectory: false)
    }
    
    static func inDirectory(at path: URL?, fileName: String) -> URL {
        if let baseUrl = path ?? getAppSupportDirectoryPath() {
            return baseUrl.appendingPathComponent(fileName, isDirectory: false)
        }
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName, isDirectory: false)
    }
    
    static func removeFileSecurity(filePath: String?) {
        guard let path = filePath else {return}
        try? FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: path)
    }
    
    @discardableResult
    static func deleteFromAppSupportDirectory(_ fileName: String) -> Bool{
        let url = inAppSupportDirectory(fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            try! FileManager.default.removeItem(at: url)
            return true
        }
        return false
    }
}
