//
//  String.swift
//  Yi
//
//  Created by Cxy on 2020/11/24.
//

import Foundation
import CommonCrypto
import SwifterSwift

public extension String {
    
    static func themeStr() -> String {
        
        let theme = SNTheme.default.theme
        switch theme  {
        case .imovie:
            return "#4A90E2"
        case .yi:
            return "#9C86EF"
        case .other(let colorTheme):
            return "#\(colorTheme)"
        }
    }
    
    func regexp() throws -> NSRegularExpression {
        return try NSRegularExpression.init(pattern: self, options: .allowCommentsAndWhitespace)
    }
    
    func toPicString() -> Self {
        
        if self.starts(with: "http") {
            return self
        }
        return "http://pics.seungyu.cn/" + self
    }
    
    func toBase64String() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(
            options: Data.Base64EncodingOptions(rawValue: 0))
    }

    func toData() -> Data? {
        return self.data(using: String.Encoding.utf8)
    }
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    func toZZZDate(format : String = "yyyy-MM-dd'T'HH:mm:ssZZZ") -> Date? {
        
        return self.date(withFormat: format)
    }
}

extension Data {
    
    public func toString() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}


extension NSRegularExpression {
        
    func isMatch(text : String) -> Bool {
        
        let res = self.matches(in: text, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, text.count))
        return res.count > 0
    }
    
    public func matchedString(content : String) -> String? {
        
        let match = self.firstMatch(in: content, options: .withTransparentBounds, range: NSMakeRange(0, content.count))
        if match != nil {
            return String(content[Range(match!.range, in: content)!])
        }
        return nil
    }
    
    public static func isValidEmail(email : String) -> Bool {
        
        let regexp = try! "^[a-zA-Z0-9][a-z0-9A-Z_-]+@([a-z0-9A-Z]+([-]?[a-z0-9A-Z]+)*\\.)+([a-zA-Z]){2,}$".regexp()
        return regexp.isMatch(text: email)
    }
    
    public static func isValidPhone(phone : String) -> Bool {
        
        let regexp = try! "^1[0-9]{10}$".regexp()
        return regexp.isMatch(text: phone)
    }

    
}
