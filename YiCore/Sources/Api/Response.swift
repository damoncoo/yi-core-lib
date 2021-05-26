//
//  Response.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import Foundation
import HandyJSON

public class PageData : HandyJSON {
    
    public var count : Int?
    public var limit : Int?
    public var current : Int?
    public var page_count : Int?

    public required init() {
        
    }
}

public class BaseResponse : HandyJSON {
    
    public var code : Int?
    public var data : Any?
    public var message : String?
    public var page : PageData?

    public required init(){
        
    }
}

public class Response<T: HandyJSON > : HandyJSON {
        
    public var item : T?
    public var items : [T?]?
    public var code : Int?
    public var data : Any?
    public var message : String?
    public var page : PageData?
    
    public required init(){
        
    }
    
    public required init(baseResponse : BaseResponse){
        self.code = baseResponse.code
        self.message = baseResponse.message
        self.data = baseResponse.data
        self.page = baseResponse.page
    }
}

class DataJSON : HandyJSON {
    
    public required init() {
        
    }
}
