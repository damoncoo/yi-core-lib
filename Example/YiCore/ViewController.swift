//
//  ViewController.swift
//  YiCore
//
//  Created by damoncoo@gmail.com on 05/26/2021.
//  Copyright (c) 2021 damoncoo@gmail.com. All rights reserved.
//

import UIKit
import YiCore
import HandyJSON

enum Actions: String {
    case imagePicker
}

typealias Function = () -> Void

class Resource: HandyJSON {

    required init() {
        self.action = .imagePicker
        self.function = {
            
        }
    }
    
    let action: Actions
    
    let function: Function
    
    init(action: Actions, fn: @escaping Function){
        self.action = action
        self.function = fn
    }
}

let ImagePickerCellID = "ImagePickerCellID"

class ViewController: SNWrapTableViewController<Resource> {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func datamodel() -> WrapMpdel<Any>? {
        
        return WrapMpdel(items: [
            Resource(action: .imagePicker, fn: self.goToPicker)
        ])
    }
    
    override func registerCells() -> [WrapTableCell] {
        return [
            WrapTableCell(reuseId: ImagePickerCellID, isNib: false, type: UITableViewCell.self, nib: nil)
        ]
    }
    
    override func cellForItemIn(item: Resource, indexPath: IndexPath? = nil) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImagePickerCellID, for: indexPath!)
        cell.textLabel?.text = item.action.rawValue
        return cell
    }
    
    override func didSelectRow(item: Resource) {
        item.function()
    }
    
    func goToPicker()  {
        let imagePicker = ImagePicker()
        imagePicker.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(imagePicker)
    }
    
}

