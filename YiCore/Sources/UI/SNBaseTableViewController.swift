//
//  SNBaseTableViewController.swift
//  Yi
//
//  Created by Darcy on 2020/10/24.
//

import UIKit
import PromiseKit
import CRRefresh
import RxCocoa
import RxSwift
import Alamofire
import HandyJSON
import SwifterSwift

public enum RefreshState {
    case none
    case refreshing
    case enable(enabled : Bool)
}

public struct WrapTableCell{

    var reuseId : String
    var isNib : Bool
    var type : UITableViewCell.Type
    var nib : String?
    
    public init(reuseId : String, isNib : Bool, type : UITableViewCell.Type, nib : String?) {
        self.reuseId = reuseId
        self.isNib = isNib
        self.type = type
        self.nib = nib
    }
    
}

public struct WrapMpdel <T> {
    var items : [T]
    
    public init(items: [T]) {
        self.items = items
    }
    
}

public protocol WrapTableViewProtocol : class {
    
    func makeRequest(page : NSInteger, limit : NSInteger) -> DataRequest?
    
    func registerCells() -> [WrapTableCell]
    
    func datamodel() -> WrapMpdel<Any>?
    
    func onDataFreshBefore()
    
    func onDataFresh()
    
}

public class SNTableViewInfo<T : HandyJSON >: NSObject {
    
    weak var tableView : UITableView?
    weak var provider : WrapTableViewProtocol?

    public var page = 1
    public var limit = 10
    public var hasMore = false
    
    var items : [T?]?
    var wrapModel : WrapMpdel<Any>?
    
    var headerFreshView : CRRefreshHeaderView?
    var footerFreshView : CRRefreshFooterView?
    
    var headerState : RefreshState = .none {
        
        didSet {
            switch self.headerState {
            case RefreshState.none :
                self.tableView?.cr.endHeaderRefresh()
            case .refreshing:
                self.tableView?.cr.beginHeaderRefresh()
            case .enable(let enabled):
                self.headerFreshView?.isHidden = !enabled
            }
        }
        
    }
    var footerState : RefreshState = .none  {
        
        didSet {
            switch self.footerState {
            case RefreshState.none :
                self.tableView?.cr.endLoadingMore()
            case .enable(let enabled):
                self.footerFreshView?.isHidden = !enabled
            case .refreshing:
                self.footerFreshView?.beginRefreshing()
            }
        }
    }
    
    deinit {
        self.items = nil
    }
    
    init(tableView : UITableView, provider : WrapTableViewProtocol) {
        super.init()
        self.tableView = tableView
        self.provider = provider
        self.setup()
    }
    
    func setup() {
        
        let normalHeaderAnimator = NormalHeaderAnimator()
        normalHeaderAnimator.pullToRefreshDescription = "下拉刷新"
        normalHeaderAnimator.loadingDescription = "刷新中..."
        normalHeaderAnimator.releaseToRefreshDescription = "下拉刷新"

        self.headerFreshView = self.tableView?.cr.addHeadRefresh(animator: normalHeaderAnimator) { [weak self] in
            self?.refresh()
        }
        
        self.footerFreshView = self.tableView?.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.loadMore()
        }
        
        // 先禁止上拉加载更多
        self.footerState = .enable(enabled: false)
        
        // 数据从页面拿
        self.wrapModel = self.provider?.datamodel()
        if self.wrapModel != nil {
            self.headerState = .enable(enabled: false)
            self.items = self.wrapModel?.items as? [T]
            self.tableView?.reloadData()
        } else {
            self.headerState = .enable(enabled: true)
        }
        
        for item in self.provider!.registerCells() {
            if item.isNib {
                self.tableView?.register(UINib(nibName: item.nib!, bundle: Bundle.main), forCellReuseIdentifier: item.reuseId)
            } else {
                self.tableView?.register(item.type, forCellReuseIdentifier: item.reuseId)
            }
        }
    }
        
    func refresh() {
        self.page = 1
        
        firstly {
            fetchItems()
        }
        .done { (response) in
            self.items = response.items
        }.catch { (err) in
            
        }.finally {
            self.headerState = .none
            self.provider?.onDataFresh()
        }
    }
    
    func loadMore() {
        firstly {
            fetchMoreItems()
        }.done {  (res) in
            self.items = self.items ?? []
            self.items?.append(contentsOf: res.items ?? [])
        }.catch { (err) in
            
        }.finally {
            
            self.provider?.onDataFresh()
        }
    }
        
    func fetchItems() -> Promise<Response<T>> {
        return Promise<Response<T>> { p in
            
            let promise =  ApiClient.shared.R2(request: self.provider!.makeRequest(page: self.page, limit: self.limit)!) as Promise<Response<T>>
            promise.done {(res) in
                
                self.hasMore = res.page?.page_count ?? 0 > self.page
                p.resolve(Result.fulfilled(res))

                if self.hasMore == false {
                    self.footerState = .enable(enabled: false)
                } else {
                    self.page += 1
                    self.footerState = .enable(enabled: true)
                }
                
            }.catch { (err) in
                p.reject(err)
            }
        }
    }
    
    func fetchMoreItems() -> Promise<Response<T>> {
        
        return self.fetchItems()
    }
    
    func reload() {
        self.wrapModel = self.provider?.datamodel()
        self.tableView?.reloadData()
    }
}

open class SNBaseTableViewController: UITableViewController, RouteFatory {
    
    public static func initWithData(data: Dictionary<String, Any>?) -> UIViewController? {
        return self.init().validate(data: data)
    }
    
    
    open func validate(data: Dictionary<String, Any>?) -> Self? {
        return self
    }
    
    public var hideNavigationBar : Bool = false
        
    deinit {
        print("\(self) deint")
    }
        
    open override func viewDidLoad() {

        super.viewDidLoad()
        self.tableView.separatorColor = .sepColor
        guard #available(iOS 11.0, *) else {
            self.automaticallyAdjustsScrollViewInsets = false
            return
        }

        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
    }
    
    
    // MARK: - Table view data source
    open override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  0
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return  UITableViewCell()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


open class SNWrapTableViewController<T : HandyJSON>: SNBaseTableViewController, WrapTableViewProtocol {

    public var tableViewInfo : SNTableViewInfo<T>?
    public var refreshState = RefreshState.none
    public var inifiteState = RefreshState.none
    
    public var disposeBag = DisposeBag()
        
    deinit {
        self.tableView.cr.endHeaderRefresh()
        self.tableView.cr.endLoadingMore()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewInfo = SNTableViewInfo(tableView: self.tableView, provider: self)
        self.tableView.tableFooterView = UIView()
        
        guard #available(iOS 11.0, *) else {
            self.automaticallyAdjustsScrollViewInsets = false
            return
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: animated)
    }
            
    // MARK: - Table view data source
    public override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableViewInfo?.items?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.tableViewInfo?.items?[indexPath.row]
        return self.cellForItemIn(item: item!, indexPath: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.tableViewInfo?.items?[indexPath.row]
        return self.heightForItemIn(item: item!)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.tableViewInfo?.items?[indexPath.row]
        self.didSelectRow(item: item!)
    }
    
    open func cellForItemIn(item : T, indexPath : IndexPath? = nil) -> UITableViewCell {
        return UITableViewCell()
    }
    
    open func heightForItemIn(item : T) -> CGFloat {
        return UITableView.automaticDimension        
    }
    
    open func didSelectRow(item : T) {
        
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: WrapTableViewProtocol
    open func registerCells() -> [WrapTableCell] {
        return []
    }
    
    open func makeRequest(page : NSInteger, limit : NSInteger) -> DataRequest? {
        return nil
    }
    
    open func datamodel() -> WrapMpdel<Any>? {
        
        return nil
    }
    
    open func onDataFreshBefore() {

        self.tableViewInfo?.refresh()
        self.view.showLoading()
    }
    
    open func onDataFresh() {
        
        self.tableView.reloadData()
        self.view.stopLoading()
    }    
}
