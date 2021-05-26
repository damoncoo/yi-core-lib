//
//  SNWrapCollectionViewController.swift
//  Yi
//
//  Created by Darcy on 2021/2/5.
//

import UIKit
import HandyJSON

public class SNWrapCollectionViewController < T : SNCellDataProtocol > : SNBaseViewController, CellProtocol, CollectionResiteryProxy  {
  
    public typealias CollectionItem = T

    public var presenter : SNPageDataPresenter<T>? = nil
    
    public var flow : UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    public var collectionView : SNCollectionView<T, SNWrapCollectionViewController >!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.collectionView.reloadData()
    }
    
    func beforeSetup() {
        
    }
    
    func afterSetup() {
        
    }
    
    func setup()  {
        
        self.beforeSetup()
                
        let presenter = SNPageDataPresenter<T>()
        self.presenter = presenter
        
        let flow = self.flow
        self.collectionView = SNCollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreenWidth, height: UIScreenWidth * 0.6), collectionViewLayout: flow)

        self.collectionView.setup(self, presenter: presenter, cellProtocol: self)
        self.view.addSubview(self.collectionView)
        
        self.afterSetup()
    }
    
    public func fillWithData(item: T, cell: SNCollectionCell) {
        
    }

    public func getReuseID(item: T) -> String {
        return ""
    }
    
    public func sizeForItem(item: T) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    public func didSelectRow(item: T) {
        
    }

    public func registerCells() -> [WrapCollectionCell] {
        return [
            WrapCollectionCell
        ]()
    }
}
