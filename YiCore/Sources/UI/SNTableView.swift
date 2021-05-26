//
//  SNTableView.swift
//  Yi
//
//  Created by Cxy on 2020/12/23.
//

import UIKit
import CRRefresh
import PromiseKit
import HandyJSON
import Alamofire

protocol SNCellDataProtocol : HandyJSON {  }

protocol SNPageDataProxy {
    
    func refresh() -> Promise<Void>
    func loadMore() -> Promise<Void>
    var hasMore : Bool { get }
}

class SNPageDataPresenter<T : HandyJSON>: NSObject, SNPageDataProxy {
    
    var page : Int16 = 1
    var limit : Int16 = 10
    var hasMore : Bool = false
    
    var items : [T?]?
    var item : T?
    
    @discardableResult
    func refresh() -> Promise<Void> {
        self.page = 1
        
        return firstly { self.fetchItems() }
            .done { [weak self] (response) in
            self?.items = response.items
        }
    }
    
    @discardableResult
    func loadMore() -> Promise<Void> {
        
        return firstly { fetchMoreItems() }.done { [weak self] (res) in
            
            if self?.items == nil {
                self?.items = []
            }
            self?.items?.append(contentsOf: res.items ?? [])
        }
    }
    
    func fetchItems() -> Promise<Response<T>> {
        return Promise<Response<T>> { p in
            
            let promise =  ApiClient.shared.R2(request: self.makeRequest()!) as Promise<Response<T>>
            promise.done { (res) in
                
                self.hasMore = res.page?.page_count ?? 0 > self.page
                if self.hasMore == false {
                } else {
                    self.page += 1
                }
                p.resolve(Result.fulfilled(res))
                
            }.catch { (err) in
                p.reject(err)
            }
        }
    }
    
    func fetchMoreItems() -> Promise<Response<T>> {
        
        return self.fetchItems()
    }
    
    func makeRequest() -> DataRequest? {
        
        return nil
    }
}

protocol ResiteryProxy {
    
    func registerCells() -> [WrapTableCell]
}

class SNTableView: UITableView {
    
    var headerFreshView : CRRefreshHeaderView?
    var footerFreshView : CRRefreshFooterView?
    var provider : ResiteryProxy?
    var presenter : SNPageDataProxy?
    
    var headerState : RefreshState = .none {
        
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
    var footerState : RefreshState = .none  {
        
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
    
    func setup(_ provider : ResiteryProxy?) {
        
        self.provider = provider
        self.headerFreshView = self.cr.addHeadRefresh(animator: SlackLoadingAnimator()) { [weak self] in
            self?.refresh()
        }
        
        self.footerFreshView = self.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.loadMore()
        }
        
        // 先禁止上拉加载更多
        self.footerState = .enable(enabled: false)
        
        for item in self.provider?.registerCells() ?? [] {
            if item.isNib {
                self.register(UINib(nibName: NSStringFromClass(item.type), bundle: Bundle.main), forCellReuseIdentifier: item.reuseId)
            } else {
                self.register(item.type, forCellReuseIdentifier: item.reuseId)
            }
        }
    }
    
    func refresh() {
        self.presenter?.refresh().done({ () in
            
        }).catch({ (err) in
            
        }).finally {
            self.headerState = .none
            self.footerState = .enable(enabled: self.presenter?.hasMore ?? false)
        }
    }
    
    func loadMore() {
        self.presenter?.loadMore().done({ () in
            
        }).catch({ (err) in
            
        }).finally {
            self.footerState = .enable(enabled: self.presenter?.hasMore ?? false)
        }
    }
    
}

extension UITableViewCell {
    
    static func blankCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.pageBgColor2
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
}


extension UIScrollView {
    
    func scrollToValidBottom(animated : Bool = true) {
        
        let validOffset = contentSize.height - bounds.size.height > 0
            ? contentSize.height - bounds.size.height
            : 0
        
        let bottomOffset = CGPoint(x: 0, y: validOffset)
        setContentOffset(bottomOffset, animated: animated)
    }
    
}


class SNBaseTableViewCell: UITableViewCell {
    
    
}

