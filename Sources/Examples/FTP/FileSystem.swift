//
//  File.swift
//  SessionTypeKit
//
//  Created by AlecNipp on 4/17/25.
//

import Foundation

struct File {
    let name: String
    var contents: String
}

final class FileSystem {
    private var files: [String: File]

    init(initialFiles: [File]) {
        self.files = Dictionary(uniqueKeysWithValues: initialFiles.map { ($0.name, $0) })
    }

    func get(filename: String) -> String? {
        return files[filename]?.contents
    }

    @discardableResult
    func put(filename: String, contents: String) -> String {
        files[filename] = File(name: filename, contents: contents)
        return "ok"
    }
    
    func dump() {
        for (name, file) in files {
            print("File: \(name), Contents: \(file.contents)")
        }
    }
}
