//
//  SortTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import DraggableCollectionView
import LMArrayChangeSets

class SortTaskView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource_Draggable {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var taskLabel: UILabel!
    
    var rows = [SortTaskItem]()
    var result: [Bool]?
    var hintVisibleRows = [SortTaskItem]()
    var task: SortTask! {
        didSet {
            taskLabel.text = task.configuration.question
            
            rows = task.configuration.presentedQuestions()
            self.collectionView.reloadData()
        }
    }
    
    var delegate: TaskDelegate?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        
        collectionView.registerNib(UINib(nibName: "SortTaskCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "cell")
        collectionView.registerClass(SortTaskLabelView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.registerClass(SortTaskLabelView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
    }
    
    @IBAction func verify() {
        // check the result validity
        var result = [Bool]()
        for (index, element) in rows.enumerate() {
            // true = item is correct
            result.append(element.correctPosition == index)
        }

        self.result = result
        
        // update the UI
        showCorrectAnswers()

        self.delegate?.taskCompleted(self.task, correct: result.reduce(true, combine: {$0 && $1}))
    }
    
    private func showCorrectAnswers() {
        let correctQuestions = task.configuration.correctQuestions()
        var newIndexSet = [Int]()
        for row in self.rows {
            newIndexSet.append(correctQuestions.indexOf({ $0 == row })!)
        }
        
        let indexChanges = NSArray.indexChangeSetsForUpdatedList([Int](0..<newIndexSet.count), previousList: newIndexSet) {
            (anyA:AnyObject!, anyB:AnyObject!) -> NSComparisonResult in
            let fst = anyA as! NSNumber
            let snd = anyB as! NSNumber
            
            return fst.compare(snd)            
        }
        
        self.collectionView.performBatchUpdates({ () -> Void in
            // highlight correct and wrong rows
            self.collectionView.reloadItemsAtIndexPaths(self.collectionView.indexPathsForVisibleItems())
            }) { (let completed) -> Void in
            self.collectionView.performBatchUpdates({ () -> Void in
                // reorder rows
                self.rows = correctQuestions
                self.collectionView.updateSection(0, withChangeSet: indexChanges)
                }, completion: nil)
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
        
        // if have a verification result, highlight the cell
        if let res = result?[indexPath.row] {
            cell.backgroundColor = res ? UIColor.correctColor() : UIColor.errorColor()
        } else {
            cell.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
        }
        
        if let cell = cell as? SortTaskCollectionViewCell {
            cell.configureForItem(item)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let item = rows[indexPath.row]
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 80, hintVisibleRows.contains(item) ? 90 : 60)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! SortTaskLabelView
            view.label.text = task.configuration.topDescription
            return view
        } else if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! SortTaskLabelView
            view.label.text = task.configuration.bottomDescription
            return view
        }
        
        return self.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)        
    }
    
    // MARK - UICollectionViewDataSource_Draggable
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if result == nil {
            return true
        }
        
        let item = rows[indexPath.row]
        if let index = hintVisibleRows.indexOf(item) {
            hintVisibleRows.removeAtIndex(index)
        } else {
            hintVisibleRows.append(item)
        }
        
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.reloadItemsAtIndexPaths([indexPath])
        }, completion: nil)
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let fromItem = rows[sourceIndexPath.row]
        
        rows.removeAtIndex(sourceIndexPath.item)
        rows.insert(fromItem, atIndex: destinationIndexPath.item)
    }
}
