//
//  QiniuToken.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import Foundation
import HandyJSON
import PromiseKit

public class QiniuToken : HandyJSON {
    var token : String!
    var bucket : String!

    public required init() {}
}

public protocol QiniuTokenProtocol : AnyObject {
    
    func getToken() -> Promise<QiniuToken>    
}
