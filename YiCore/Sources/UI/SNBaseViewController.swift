//
//  SNBaseViewController.swift
//  Yi
//
//  Created by Darcy on 2020/10/24.
//

import UIKit

class SNBaseViewController: UIViewController {

    deinit {
        print("\(self) init")
    }
    
    var hideNavigationBar : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.pageBgColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
    }
    
    func validate(data: Dictionary<String, Any>?) -> Self? {
    
        return self
    }
    
}
