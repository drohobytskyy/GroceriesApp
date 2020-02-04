//
//  ProductCollectionViewCell.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 03/02/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    
    func didTapDeleteCell(cell: ProductCollectionViewCell)
    
    func didTapSelectCell(cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properites
    var delegate: ProductCellDelegate?
    
    var productNameLabel: UILabel = {
        
        let productNameLabel = UILabel()
        productNameLabel.textColor = .white
        productNameLabel.textAlignment = .center
        return productNameLabel
    }()
    
    var checkMarkLabel: UILabel = {
        
        let checkMarkLabel = UILabel()
        checkMarkLabel.textColor = .green
        checkMarkLabel.font = UIFont.systemFont(ofSize: 40)
        return checkMarkLabel
    }()
    
    lazy var deleteButton: UIButton = {
        
        let deleteButton = UIButton()
        deleteButton.setTitle("x", for: UIControl.State.normal)
        deleteButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
        return deleteButton
    }()
    
    @objc func deleteAction() {
        
        delegate?.didTapDeleteCell(cell: self)
    }
    
    lazy var selectButton: UIButton = {
        
        let selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectAction), for: UIControl.Event.touchUpInside)
        return selectButton
    }()
    
    @objc func selectAction() {
        
        delegate?.didTapSelectCell(cell: self)
    }
    
    var product: Product? {
        didSet {
            
            guard let product = product else { return }
            
            productNameLabel.text = product.name
            checkMarkLabel.text = product.checked! ? "✓" : ""
            alpha = product.checked! ? 1 : 0.8
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout(frame: frame)
    }
    
    private func setLayout(frame: CGRect) {
        
        backgroundColor = Utils.primaryColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        productNameLabel.frame = CGRect(x: 0, y: 30, width: frame.width, height: 20)
        checkMarkLabel.frame = CGRect(x: frame.width/2, y: frame.height/2, width: frame.width, height: 40)
        deleteButton.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        selectButton.frame = CGRect(x: 0, y: 30, width: frame.width, height: frame.height-30)
        
        addSubview(productNameLabel)
        addSubview(deleteButton)
        addSubview(checkMarkLabel)
        addSubview(selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
