//
//  QiniuToken.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import Foundation
import HandyJSON
import PromiseKit

class QiniuToken : HandyJSON {
    var token : String!
    var bucket : String!

    required init() {}
}

protocol QiniuTokenProtocol : class {
    
    func getToken() -> Promise<QiniuToken>    
}
