//
//  Session.swift
//  Yi
//
//  Created by Darcy on 2020/11/4.
//

import Foundation
import Alamofire
import PromiseKit
import HandyJSON
import CryptoKit

public class ApiURL: URLConvertible {
    
    var base, path: String
    
    init(base: String, path: String) {
        self.base = base
        self.path = path
    }
    
    public func asURL() throws -> URL {
        return URL(string: self.base + self.path)!
    }
}


public protocol ResponseAdapter {
    
    func adaptResponse(data : Data?) -> Request.ValidationResult
}

public protocol ResponseHooker {
    
    func adaptResponse(response : BaseResponse?)
}

public class ApiSession : NSObject {
                
    class InternalSession : Alamofire.Session {
        
    }
    
    private var queue: DispatchQueue = DispatchQueue(label: "api.session.monitir")

    private let session : InternalSession
        
    private let baseUrlAdapter : URLProviderProtocol
    
    private let requestAdapter : Interceptor?
    
    private let responseAdapter : ResponseAdapter?
    
    public var responseHooker : ResponseHooker?
    
    public init( baseUrlAdapter : URLProviderProtocol,
          requestAdapter: Interceptor? = nil,
          responseAdapter: ResponseAdapter? = nil) {
         
        self.requestAdapter = requestAdapter
        
        self.baseUrlAdapter = baseUrlAdapter
        
        self.responseAdapter = responseAdapter
        
        let config = URLSessionConfiguration.af.default
        config.httpAdditionalHeaders = [:]
        
        let sessionDelegate = SessionDelegate()
        self.session = InternalSession(configuration: config,
                                         delegate: sessionDelegate,
                                         rootQueue: DispatchQueue.global(),
                                         startRequestsImmediately: true,
                                         requestQueue: DispatchQueue.main,
                                         serializationQueue: DispatchQueue.main,
                                         interceptor:self.requestAdapter, serverTrustManager: nil,
                                         redirectHandler: nil,
                                         cachedResponseHandler: nil, eventMonitors: [])
    }
    
    
    public func useReponseHooker(hooker : ResponseHooker)  {
        self.responseHooker = hooker
    }
    
    func responseHook(response : BaseResponse?)  {
        self.responseHooker?.adaptResponse(response: response)
    }
    
    // 解析请求的时候调用这个
    public func R< E : HandyJSON >(path: String, method: HTTPMethod, data : Parameters?) -> Promise<Response<E>> {
        
        let request = self.makeRequest(path: path, method: method, data: data)
        return self.R2(request: request)
    }
    
    // 解析请求的时候调用这个
    public func R2< E : HandyJSON >(request : DataRequest) -> Promise<Response<E>> {
        return Promise<Response<E>>{ p in
        
            self.request(request: request).done { (res) in
                
                let responseModel = Response<E>(baseResponse: res)
                if (responseModel.code != 1) {
                    throw SNError.commonError(responseModel.message ?? "数据错误")
                } else if let d = responseModel.data as? NSDictionary {
                    responseModel.item = JSONDeserializer<E>.deserializeFrom(dict: d)
                } else if let a = responseModel.data as? Array<Any> {
                    responseModel.items = JSONDeserializer<E>.deserializeModelArrayFrom(array: a)
                }
                
                p.fulfill(responseModel)
                
            }.catch { (err) in
                p.reject(err)
            }
        }
    }
    
    // 不需要解析请求的时候调用
    public func request(request : DataRequest) -> Promise<BaseResponse>  {
        
        return Promise<BaseResponse>{ p in
                        
            request.validate { (req, res, data) -> DataRequest.ValidationResult in
                
                guard let resVali = self.responseAdapter else {
                    return DataRequest.ValidationResult.success(())
                }
                return resVali.adaptResponse(data: data)
                
            }.response(completionHandler: { [unowned self] (res) in
                
                let data = res.data
                let content = data?.string(encoding: .utf8)
                if content != nil {
                    let responseModel : BaseResponse? = JSONDeserializer<BaseResponse>.deserializeFrom(json: content!)
                    self.responseHook(response: responseModel)
                    
                    if (responseModel != nil) {
                        p.fulfill(responseModel!)
                    } else {
                        p.reject(SNError.commonError("解析错误"))
                    }
                } else {
                    p.reject(SNError.commonError("解析错误"))
                }
                
            }).resume()
        }
    }
    
    public func makeRequest(path: String, method: HTTPMethod, data : Parameters?) -> DataRequest  {
        
        var encoding : ParameterEncoding = URLEncoding.default
        if !(method == .get || method == .delete) {
            encoding = JSONEncoding.default
        }

        let request = self.session.request(ApiURL(base: self.baseUrlAdapter.baseUrl(), path: path), method: method, parameters : data, encoding: encoding )
        return request
    }
    
}


