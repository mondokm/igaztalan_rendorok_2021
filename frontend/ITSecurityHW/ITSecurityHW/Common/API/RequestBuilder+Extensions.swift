//
//  RequestBuilder+Extensions.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 24..
//

extension RequestBuilder {
    func addToken() -> Self {
        addHeader(name: "Authorization", value: "Bearer " + (AppData.shared.token ?? ""))
    }
}
