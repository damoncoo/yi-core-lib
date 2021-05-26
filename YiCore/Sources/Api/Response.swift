//
//  Response.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import Foundation
import HandyJSON

class PageData : HandyJSON {
    
    var count : Int?
    var limit : Int?
    var current : Int?
    var page_count : Int?

    required init() {
        
    }
}

class BaseResponse : HandyJSON {
    
    var code : Int?
    var data : Any?
    var message : String?
    var page : PageData?

    required init(){
        
    }
}

class Response<T: HandyJSON > : HandyJSON {
        
    var item : T?
    var items : [T?]?
    var code : Int?
    var data : Any?
    var message : String?
    var page : PageData?
    
    required init(){
        
    }
    
    required init(baseResponse : BaseResponse){
        self.code = baseResponse.code
        self.message = baseResponse.message
        self.data = baseResponse.data
        self.page = baseResponse.page
    }
}

class DataJSON : HandyJSON {
    
    required init() {
        
    }
}
