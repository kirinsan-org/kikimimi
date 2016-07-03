//
//  CategorySelectionViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class CategorySelectionViewController: UICollectionViewController {
	var selectedCategory: CommandCategory = .c1
	var selectionHandler: ((CommandCategory) -> Void)?

	static var defaultLayout: UICollectionViewLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 80, height: 80)
		layout.minimumInteritemSpacing = 8
		layout.minimumLineSpacing = 8
		return layout
	}

	init() {
		super.init(collectionViewLayout: CategorySelectionViewController.defaultLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView?.backgroundColor = UIColor.whiteColor()
		collectionView?.registerClass(Cell.self, forCellWithReuseIdentifier: "Cell")

		let selectedIndexPath = NSIndexPath(forRow: selectedCategory.rawValue - 1, inSection: 0)
		collectionView?.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let itemSize = (collectionView!.bounds.width - 8 - 8) / 3
		let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = CGSize(width: itemSize, height: itemSize)
	}
}

extension CategorySelectionViewController {
	final class Cell: UICollectionViewCell {
		let imageView = UIImageView()

		override init(frame: CGRect) {
			super.init(frame: frame)

			imageView.frame = contentView.bounds
			imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			imageView.contentMode = .ScaleAspectFill
			imageView.clipsToBounds = true

			contentView.addSubview(imageView)
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 24
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
		cell.imageView.image = UIImage(named: CommandCategory(rawValue: indexPath.item + 1)!.imageName)
		return cell
	}

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let category = CommandCategory(rawValue: indexPath.item + 1)!
		selectionHandler?(category)
	}
}
