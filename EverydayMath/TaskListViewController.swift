//
//  TaskListViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import FSQCollectionViewAlignedLayout

class TaskListViewController: UIViewController {
    
    let categories = TaskFactory.tasksByCategory
    let sections = TaskFactory.categories
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewLayout: FSQCollectionViewAlignedLayout!
    
    override func viewDidLoad() {
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        collectionViewLayout.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionViewLayout.defaultCellAttributes = FSQCollectionViewAlignedLayoutCellAttributes.withInsets(UIEdgeInsetsMake(10, 0, 0, 0), shouldBeginLine: false, shouldEndLine: false, startLineIndentation: false)
        
        collectionView.registerClass(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LoadingViewController, cell = sender as? TaskListCollectionViewCell, task = cell.task {
            destination.task = task
        }
    }
}

extension TaskListViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
}

extension TaskListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = categories[sections[section]]
        return section?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let section = categories[sections[indexPath.section]]
        
        if let cell = cell as? TaskListCollectionViewCell, task = section?[indexPath.row] {
            cell.configureForTask(task)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath, remainingLineSpace:CGFloat) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) / 3 - 3.4, height: CGRectGetWidth(collectionView.frame) / 3 - 3.4)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceHeightForHeaderInSection section: NSInteger) -> CGFloat {
        return 40
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! HeaderView
            let section = sections[indexPath.section]
            headerView.configure(section)
            return headerView
        }
        
        return self.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
}