//
//  SNAssetsManager.swift
//  Yi
//
//  Created by Cxy on 2020/12/31.
//

import Foundation
import YPImagePicker
import PromiseKit
import HandyJSON
import Qiniu
import ADPhotoKit

public class SNAssets: NSObject {
    
    public var phtos  = [UIImage]()
}

extension YPMediaPhoto : SNMultiImage {

    public func image() -> UIImage {
        return self.image
    }
}

public protocol DataProtocol {
    
    func toData() -> Data?
}

extension UIImage : DataProtocol {
    
    public func toData() -> Data? {
        let compression : CGFloat = 0.75
        return self.compressedData(quality: compression)
    }
}

extension Data : DataProtocol {
    
    public func toData() -> Data? {
        return self
    }
}

public class SNAssetsManager : NSObject {
    
    public static let shared = SNAssetsManager()
    
    private var qiniuConf : QNConfiguration!
    private var qiniuManager : QNUploadManager!
    private weak var tokenProvider : QiniuTokenProtocol!
    
    private var resolver: Resolver<SNAssets>!
        
    override init() {
        super.init()
        self.qiniuConf = QNConfiguration.build { (builder) in
            builder?.useHttps = false
        }
        self.qiniuManager = QNUploadManager(configuration: self.qiniuConf)
    }
    
    public func initWithProvider(prodider : QiniuTokenProtocol)  {
        self.tokenProvider = prodider
    }
            
    public func showImagePicker(count : Int = 1 ,video : Bool = false, maxWidth : CGFloat = 1024) -> Promise<SNAssets>  {
        
        let promise = Promise<SNAssets> {p in

            self.resolver = p
            let fromViewController = UIViewController.visibleNavigationController()!
            
            ADPhotoKitUI
                .imagePicker(present: fromViewController,
                             style: .normal,
                             selected:  { [weak self] (assets, value) in
                                
                                let images: [UIImage] = assets.filter { item in
                                    return item.result?.image != nil
                                }.map { item in
                                    return item.result!.image!
                                }
                                
                                let assets = SNAssets()
                                assets.phtos = images
                                self?.resolver.fulfill(assets)
                             },
                             canceled: {
                                self.resolver.reject(SNError.commonError("User Canceled"))
                             })            
        }
        return promise
    }
    
    
    public func upload(images : [DataProtocol], progress : ( Float)? ) -> Promise<Array<String>> {
        
        return firstly {
            self.tokenProvider.getToken()
        }.then { [unowned self] token in
            self.uploadImage(images: images, token: token, progress: progress)
        }
    }
        
    public func uploadImage(images : [DataProtocol], token : QiniuToken, progress : ( Float)?) -> Promise<Array<String>> {
        
        let promises = images.map { (image) -> Promise<String> in
            return Promise<String> { [unowned self]  p in
                
                let uuid =  UUID().uuidString
                let date = Date()
                let imageKey = "\(token.bucket!)/\(date.year)/\(date.month)/\(date.day)/\(uuid).jpg"
                
                self.qiniuManager.put(image.toData()!, key:imageKey, token: token.token, complete: { (info, serverKey, resp) in
                    
                    if info?.statusCode == 200 {
                        p.fulfill(serverKey!)
                    } else {
                        p.reject(SNError.commonError("上传失败"))
                    }
                    
                }, option: QNUploadOption.init(progressHandler: { (key, progress) in
                    
                }))
            }
        }
        return when(fulfilled: promises)
    }
}
