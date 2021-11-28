//
//  TopLevel+Extensions.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 25..
//

import Foundation

func readCaffFile(nameWithoutExtension: String = "1") -> String? {
    guard let url = Bundle.main.url(forResource: nameWithoutExtension, withExtension: "caff") else { return nil }
    return try? Data(contentsOf: url).base64EncodedString()
}
