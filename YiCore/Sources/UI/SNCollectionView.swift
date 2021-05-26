//
//  SNCollectionView.swift
//  Yi
//
//  Created by Cxy on 2021/2/5.
//

import Foundation
import CRRefresh
import PromiseKit
import HandyJSON
import Alamofire


public struct WrapCollectionCell{

    var reuseId : String
    var isNib : Bool
    var type : UICollectionViewCell.Type
    var nib : String?
}

public protocol CellProtocol {
    
    associatedtype CollectionItem
    
    func fillWithData(item : CollectionItem, cell : SNCollectionCell)
    
    func didSelectRow(item : CollectionItem)
    
    func getReuseID(item : CollectionItem) -> String
    
    func sizeForItem(item : CollectionItem) -> CGSize
    
}

public protocol CollectionResiteryProxy {
    
    func registerCells() -> [WrapCollectionCell]
}

public class SNCollectionCell: UICollectionViewCell {
    
}

public class SNCollectionView < T : SNCellDataProtocol, CellProtocolType > : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  where CellProtocolType : CellProtocol {

    private var headerFreshView : CRRefreshHeaderView?
    private var footerFreshView : CRRefreshFooterView?
    
    private var provider : CollectionResiteryProxy?
    private var presenter : SNPageDataPresenter<T>?
        
    private  var cellProtocol : CellProtocolType?
    
    public var headerState : RefreshState = .none {
        
        didSet {
            switch self.headerState {
            case RefreshState.none :
                self.cr.endHeaderRefresh()
            case .refreshing:
                self.cr.beginHeaderRefresh()
            case .enable(let enabled):
                self.headerFreshView?.isHidden = !enabled
            }
        }
    }
    
    public var footerState : RefreshState = .none  {
        
        didSet {
            switch self.footerState {
            case RefreshState.none :
                self.cr.endLoadingMore()
            case .enable(let enabled):
                self.footerFreshView?.isHidden = !enabled
            case .refreshing:
                self.footerFreshView?.beginRefreshing()
            }
        }
    }
    
    public func setup(_ provider : CollectionResiteryProxy?, presenter : SNPageDataPresenter<T>? = nil, cellProtocol : CellProtocolType? = nil) {
        
        self.backgroundColor = .pageBgColor
        
        self.showsHorizontalScrollIndicator = false

        self.provider = provider
        
        if case RefreshState.enable(let enabled) = self.headerState  {
            if enabled {
                self.headerFreshView = self.cr.addHeadRefresh(animator: SlackLoadingAnimator()) { [weak self] in
                    self?.refresh()
                }
            }
        }
        
        if case RefreshState.enable(let enabled) = self.footerState  {
            if enabled {
                self.footerFreshView = self.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
                    self?.loadMore()
                }
            }
        }

        // 先禁止上拉加载更多
        self.footerState = .enable(enabled: false)
        
        for item in self.provider?.registerCells() ?? [] {
            if item.isNib {
                self.register(UINib(nibName: NSStringFromClass(item.type), bundle: Bundle.main), forCellWithReuseIdentifier: item.reuseId)
            } else {
                self.register(item.type, forCellWithReuseIdentifier: item.reuseId)
            }
        }
        
        self.presenter = presenter
        self.cellProtocol = cellProtocol
        
        self.delegate = self
        self.dataSource = self
        
//        self.reloadData()
    }
    
    public func refresh() {
        self.presenter?.refresh().done({ () in
            
        }).catch({ (err) in
            
        }).finally {
            self.headerState = .none
            self.footerState = .enable(enabled: self.presenter?.hasMore ?? false)
        }
    }
    
    public func loadMore() {
        self.presenter?.loadMore().done({ () in
            
        }).catch({ (err) in
            
        }).finally {
            self.footerState = .enable(enabled: self.presenter?.hasMore ?? false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.presenter?.items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item : T = (self.presenter?.items?[indexPath.row])!
        let reuseId = self.cellProtocol?.getReuseID(item: item as! CellProtocolType.CollectionItem)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId!, for: indexPath) as! SNCollectionCell
        self.cellProtocol?.fillWithData(item: item as! CellProtocolType.CollectionItem , cell: cell)
        return cell
    }
        
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item : T = (self.presenter?.items?[indexPath.row])!
        self.cellProtocol?.didSelectRow(item: item as! CellProtocolType.CollectionItem )
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item : T = (self.presenter?.items?[indexPath.row])!
        let size = self.cellProtocol?.sizeForItem(item: item as! CellProtocolType.CollectionItem)
        return size ?? CGSize.zero
    }
    
}
