//
//  ImagePicker.swift
//  YiCore_Example
//
//  Created by Darcy on 2021/9/13.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import YiCore
import SnapKit
import RxSwift
import RxCocoa

class ImagePicker: SNBaseViewController {

    let selectButton = UIButton()
    let imageView = UIImageView()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ImagePicker"
        self.configureUI()
    }
    
    func configureUI()  {
        self.selectButton.setTitle("选择", for: .normal)
        self.selectButton.setTitleColor(UIColor.red, for: .normal)
        self.selectButton.rx.tap.observeOn(MainScheduler.instance)
            .subscribe { event in
            self.didHitSelect()
        }.disposed(by: self.bag)
        
        self.view.addSubview(self.selectButton)
        self.selectButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(50)
        }
        
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.selectButton.snp.bottom).offset(10)
            make.width.height.equalTo(200)
        }
    }
    
    func didHitSelect() {
        
        SNAssetsManager.shared.showImagePicker()
            .done { assets in
                self.imageView.image = assets.phtos.first
            }.catch { err in
                
            }
    }
    
}
