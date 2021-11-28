//
//  Service.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 25..
//

private enum ServiceError: Error {
    case unknownError
}

protocol Service { }

extension Service {
    static func log(_ message: String?, file: String = #file, function: String = #function, line: Int = #line) {
        dump("APISuccess: \(message ?? "unknown")\(log(file: file, function: function, line: line))")
    }

    static func log(_ error: Error?, file: String = #file, function: String = #function, line: Int = #line) {
        dump("APIError: \(error ?? ServiceError.unknownError)\(log(file: file, function: function, line: line))")
    }

    static func log(_ any: Any, file: String = #file, function: String = #function, line: Int = #line) {
        dump("APISuccess: \(any)\(log(file: file, function: function, line: line))")
    }
}

extension Service {
    private static func log(file: String, function: String, line: Int) -> String {
        " in \(file), in \(function) at \(line)"
    }
}
