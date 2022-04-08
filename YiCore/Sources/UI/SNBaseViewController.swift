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
    public var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .never

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = self.largeTitleDisplayMode
    }
    
    public  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
    }
    
    open func validate(data: Dictionary<String, Any>?) -> Self? {
    
        return self
    }
    
}
