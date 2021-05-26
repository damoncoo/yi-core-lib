//
//  SNError.swift
//  Yi
//
//  Created by Cxy on 2020/10/22.
//

import Foundation

public enum SNError: Error {
    
    case commonError(String)
    
    public static func errorMessage(err : Error, defaultStr: String) -> String {
        
        var msg = defaultStr
        if case let SNError.commonError(message) = err {
            msg = message
        }
        return msg
    }
}


public enum LoginError : Error {
    
    
}
