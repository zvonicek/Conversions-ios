//
//  SortTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class SortTaskView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSource_Draggable {
    @IBOutlet var collectionView: UICollectionView!

    var rows = [SortTaskItem]()
    var task: SortTask! {
        didSet {
            self.collectionView.reloadData()
            rows = task.configuration.questions
        }
    }
    
    var delegate: TaskDelegate?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        
        collectionView.registerNib(UINib(nibName: "SortTaskCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "cell")        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 80, 60);
        }
    }
    
    @IBAction func verify() {
        var correct = true
        for (index, element) in rows.enumerate() {
            if (element.correctPosition != index) {
                correct = false
            }
        }
        
        if correct {
            delegate?.taskCompleted(task)
        }
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let item = rows[indexPath.row]
        
        if let cell = cell as? SortTaskCollectionViewCell {
            cell.configureForItem(item)
        }
        
        return cell
    }
    
    // MARK - UICollectionViewDataSource_Draggable
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let fromItem = rows[sourceIndexPath.row]
        
        rows.removeAtIndex(sourceIndexPath.item)
        rows.insert(fromItem, atIndex: destinationIndexPath.item)
    }
}
