//
//  HomeController.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 26/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit
import FirebaseAuth

private let product_cell_identifier = "product_cell"

class HomeController: UIViewController {
    
    // MARK: - Properties
    var delegate: HomeControllerDelegate?
    var productsCollectionView: UICollectionView!
    var products: [Product] = []
    
    // add pane view
    let addPaneView = UIView()
    let productNameTextField = UITextField()
    let addBtn = UIButton()
    let cancelBtn = UIButton()
    
    // top search config
    var filtered:[Product] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    let firebaseAuth = Auth.auth()
    var user_id: String = "1"
    
    // refresh control init
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard (firebaseAuth.currentUser?.uid) != nil else { return }
        
        user_id = firebaseAuth.currentUser!.uid
        
        configureNavigationBar()
        configureSwipeRecognizer()
        configureCollectionView()
        
        loadProducts()
    }
    
    // MARK: layout
    private func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        productsCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.backgroundColor = .white
        productsCollectionView.alwaysBounceVertical = true
        productsCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: product_cell_identifier)
        
        productsCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshProducts(_:)), for: .valueChanged)
        
        view.addSubview(productsCollectionView)
        
        productsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productsCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        productsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        productsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        productsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    // navbar setup
    private func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = Utils.primaryColor
        navigationController?.navigationBar.barStyle = Utils.navBarStyle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add")?.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(addNewProductLayout))
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a poduct..."
        searchController.searchBar.tintColor = .white
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    // MARK: - Handlers
    @objc func handleMenuToggle() {
        
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func addNewProductAction() {
        
        print("adding new product")
        
        if let name = self.productNameTextField.text {
            
            let id = UUID().uuidString
            
            let product = Product(id: id, name: name, user_id: user_id)
            
            API.shared.addProductDocument(product: product)
            
            products.append(product!)
            
            addPaneView.removeFromSuperview()
            
            let indexPath = IndexPath(row: products.count - 1, section: 0)
            productsCollectionView.insertItems(at: [indexPath])
        }
        
    }
    
    @objc func addNewProductLayout() {
        
        addPaneView.frame = CGRect(x: 10, y: view.frame.height/2 - 100, width: view.frame.width - 20, height: 200)
        addPaneView.alpha = 0.98
        addPaneView.layer.cornerRadius = 10
        addPaneView.layer.masksToBounds = true
        
        addPaneView.backgroundColor = Utils.primaryColor
        
        productNameTextField.text = ""
        productNameTextField.placeholder = "product name"
        productNameTextField.frame = CGRect(x: 20, y: addPaneView.frame.height/2 - 20, width: addPaneView.frame.width - 40, height: 40)
        productNameTextField.backgroundColor = .white
        
        addBtn.frame = CGRect(x: 0, y: productNameTextField.frame.maxY + 10, width: addPaneView.frame.width, height: 40)
        addBtn.setTitle("Add product", for: UIControl.State.normal)
        addBtn.tintColor = .white
        addBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        addBtn.addTarget(self, action: #selector(addNewProductAction), for: UIControl.Event.touchUpInside)
        
        cancelBtn.frame = CGRect(x: addPaneView.frame.width - 50, y: 10, width: 40, height: 40)
        cancelBtn.setTitle("x", for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        cancelBtn.addTarget(self, action: #selector(closeAddPaneAction), for: UIControl.Event.touchDown)
        
        addPaneView.addSubview(productNameTextField)
        addPaneView.addSubview(addBtn)
        addPaneView.addSubview(cancelBtn)
        
        view.addSubview(addPaneView)
    }
    
    @objc func closeAddPaneAction() {
        
        print("closing new product pane")
        
        addPaneView.removeFromSuperview()
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                handleMenuToggle()
                print("Swiped right")
                
            case UISwipeGestureRecognizer.Direction.left:
                handleMenuToggle()
                print("Swiped left")
                
            default:
                break
            }
        }
    }
    
    private func configureSwipeRecognizer() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func loadProducts() {
        
        API.shared.getAllProductDocuments {
            
            self.products = API.shared.products
            self.productsCollectionView.reloadData()
        }
    }
    
    private func createSpinnerView() {
        
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    @objc private func refreshProducts(_ sender: Any) {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Getting products ...", attributes: nil)
        
        API.shared.getAllProductDocuments {
            
            self.products = API.shared.products
            self.productsCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

// MARK: - conform to CollectionView protocols
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive {
            return filtered.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: product_cell_identifier, for: indexPath) as! ProductCollectionViewCell
        
        var product: Product!
        
        if searchActive {
            product = filtered[indexPath.item]
        } else {
            product = products[indexPath.item]
        }
        
        cell.product = product
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - conform to ProductCellDelegate protocols
extension HomeController: ProductCellDelegate {
    
    func didTapDeleteCell(cell: ProductCollectionViewCell) {
        
        guard let indexPath = productsCollectionView.indexPath(for: cell) else { return }
        
        if searchActive {
            API.shared.deleteDocument(id: filtered[indexPath.item].id!)
            filtered.remove(at: indexPath.item)
        } else {
            API.shared.deleteDocument(id: products[indexPath.item].id!)
            products.remove(at: indexPath.item)
        }
        
        productsCollectionView.deleteItems(at: [indexPath])
        loadProducts()
    }
    
    func didTapSelectCell(cell: ProductCollectionViewCell) {
        
        guard let indexPath = productsCollectionView.indexPath(for: cell) else { return }
        products[indexPath.item].checked! = !products[indexPath.item].checked!
        productsCollectionView.reloadData()
        
        API.shared.updateProductDocument(product: products[indexPath.item])
    }
}

// MARK: - conform to SearchBar protocols
extension HomeController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true
        productsCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        productsCollectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchActive {
            searchActive = true
            productsCollectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        
        filtered = products.filter({ (item) -> Bool in
            
            let productName: NSString = item.name! as NSString
            
            return (productName.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        productsCollectionView.reloadData()
    }
}
