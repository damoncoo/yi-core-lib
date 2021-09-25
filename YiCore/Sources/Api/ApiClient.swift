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
    
    public var session : ApiSession!
    
    public static let shared = ApiClient()

    public func useSession(session : ApiSession)  {
        self.session = session
    }
    
    public func makeRequest(path: String, method: HTTPMethod, data: Parameters?) -> DataRequest {
        
        self.session.makeRequest(path: path, method: method, data: data)
    }
    
    public func R<E>(path: String, method: HTTPMethod, data: Parameters?) -> Promise<Response<E>> where E : HandyJSON {
     
        return self.session.R(path: path, method: method, data: data)
    }
    
    public func R2<E>(request: DataRequest) -> Promise<Response<E>> where E : HandyJSON {
        
        return self.session.R2(request: request)
    }
}
