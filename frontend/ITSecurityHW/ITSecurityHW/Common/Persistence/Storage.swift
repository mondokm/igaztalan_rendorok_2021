//
//  Storage.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 24..
//

import Foundation
import Valet

@propertyWrapper struct Storage<T: Codable> {
    private enum Constants {
        static var teamId: String { "W76JU8772Y" }
        static var accessGroup: String { "hu.bme.hit.itsec.hw.ITSecurityHW" }
    }

    public var projectedValue: Storage<T> { self }
    public var wrappedValue: T? {
        get {
            guard let data = try? valet.object(forKey: key.rawValue) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            try? valet.setObject(data, forKey: key.rawValue)
        }
    }

    private let valet = Valet.sharedGroupValet(with: SharedGroupIdentifier(appIDPrefix: Constants.teamId,
                                                                           nonEmptyGroup: Constants.accessGroup)!,
                                               accessibility: .afterFirstUnlock)

    let key: SettingsKey
}
