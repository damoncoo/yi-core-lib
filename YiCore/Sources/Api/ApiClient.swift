//
//  ApiClient.swift
//  YiCore
//
//  Created by Darcy on 2021/5/26.
//

import Foundation
import Alamofire
import PromiseKit
import HandyJSON

protocol SessionRequestProtocol {
    
    func makeRequest(path: String, method: HTTPMethod, data : Parameters?) -> DataRequest
    
    func R< E : HandyJSON >(path: String, method: HTTPMethod, data : Parameters?) -> Promise<Response<E>>

    func R2< E : HandyJSON >(request : DataRequest) -> Promise<Response<E>>
}

public class ApiClient : SessionRequestProtocol {
    
    private var session : ApiSession!
    
    public static let shared = ApiClient()

    func registerSession(session : ApiSession)  {
        self.session = session
    }
    
    func makeRequest(path: String, method: HTTPMethod, data: Parameters?) -> DataRequest {
        
        self.session.makeRequest(path: path, method: method, data: data)
    }
    
    func R<E>(path: String, method: HTTPMethod, data: Parameters?) -> Promise<Response<E>> where E : HandyJSON {
     
        self.session.R(path: path, method: method, data: data)
    }
    
    func R2<E>(request: DataRequest) -> Promise<Response<E>> where E : HandyJSON {
        
        self.session.R2(request: request)
    }
}
