//
//  URLProviderProtocol.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import Foundation

public protocol URLProviderProtocol : class {
    func baseUrl() -> String
    func setBaseURL(url : String)
}