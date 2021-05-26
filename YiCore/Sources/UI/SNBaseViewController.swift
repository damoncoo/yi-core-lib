//
//  SNBaseViewController.swift
//  Yi
//
//  Created by Darcy on 2020/10/24.
//

import UIKit

open class SNBaseViewController: UIViewController {

    deinit {
        print("\(self) init")
    }
    
    public var hideNavigationBar : Bool = false
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.pageBgColor
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
    }
    
    open func validate(data: Dictionary<String, Any>?) -> Self? {
    
        return self
    }
    
}
