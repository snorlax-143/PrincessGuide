//
//  CraftSummaryTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

protocol CraftSummaryTableViewCellDelegate: class {
    func craftSummaryTableViewCell(_ craftSummaryTableViewCell: CraftSummaryTableViewCell, didSelect index: Int)
}

typealias CraftDetailItem = CraftTableViewController.Row.Model

protocol CraftDetailConfigurable {
    func configure(for item: CraftDetailItem)
}

class CraftSummaryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CraftDetailConfigurable, UniqueCraftConfigurable {
    
    let titleLabel = UILabel()
    let layout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    weak var delegate: CraftSummaryTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.collectionView.indicatorStyle = theme.indicatorStyle
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        titleLabel.text = NSLocalizedString("Raw Materials", comment: "")
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        layout.itemSize = CGSize(width: 64, height: 92)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(92)
            make.bottom.equalToSuperview()
        }
        
        collectionView.register(CraftSummaryCollectionViewCell.self, forCellWithReuseIdentifier: CraftSummaryCollectionViewCell.description())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct Item {
        var number: Int
        var url: URL
    }
    
    private var items = [Item]()
    
    private func configure(for items:[Item]) {
        self.items = items
        collectionView.reloadData()
    }
    
    func configure(for item: CraftDetailItem) {
        guard case .summary(let equipment) = item else {
            fatalError()
        }
        let items = equipment.recursiveConsumes.map { Item(number: $0.consumeNum, url: $0.itemURL) }
        configure(for: items)
    }
    
    func configure(for item: UniqueCraftItem) {
        guard case .summary(let equipment) = item else {
            fatalError()
        }
        let items = equipment.recursiveConsumes.map { Item(number: $0.consumeNum, url: $0.itemURL) }
        configure(for: items)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.craftSummaryTableViewCell(self, didSelect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CraftSummaryCollectionViewCell.description(), for: indexPath) as! CraftSummaryCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(url: item.url, number: item.number)
        return cell
    }
}
