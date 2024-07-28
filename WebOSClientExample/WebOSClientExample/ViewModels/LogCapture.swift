//
//  LogCapture.swift
//  WebOSClientExample
//
//  Created by Ярослав Седышев on 28.07.2024.
//

import Foundation
import Combine

class LogCapture: ObservableObject {
    @Published private(set) var logOutput = ""
    
    private let pipe = Pipe()
    private let logQueue = DispatchQueue(label: "LogCaptureQueue")
    
    init() {
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let self = self else { return }
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8) {
                let filteredStr = self.filterMetadata(from: str)
                self.logQueue.async {
                    Task { @MainActor in
                        self.logOutput.append(contentsOf: filteredStr)
                    }
                }
            }
        }
    }
    
    deinit {
        pipe.fileHandleForReading.readabilityHandler = nil
    }
    
    @MainActor
    func clearLogs() {
        logOutput = ""
    }
    
    private func filterMetadata(from log: String) -> String {
        let pattern = #"OSLOG-[A-F0-9-]+ \d+ \d+ [A-Z] \w+ \{[^}]+\}\t"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) {
            let range = NSRange(location: 0, length: log.utf16.count)
            return regex.stringByReplacingMatches(in: log, options: [], range: range, withTemplate: "")
        } else {
            return log
        }
    }
}
