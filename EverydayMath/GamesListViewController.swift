//
//  GamesListViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import FSQCollectionViewAlignedLayout

class GamesListViewController: UIViewController {
    
    let categories = GameFactory.categories
    
    lazy var sections: [GameCategory] = {
        return Array(self.categories.keys)
    }()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewLayout: FSQCollectionViewAlignedLayout!
    
    override func viewDidLoad() {
        collectionViewLayout.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionViewLayout.defaultCellAttributes = FSQCollectionViewAlignedLayoutCellAttributes.defaultCellAttributes()
        
        collectionView.registerClass(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LoadingViewController, cell = sender as? GameListCollectionViewCell, game = cell.game {
            destination.game = game
        }
    }
}

extension GamesListViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
}

extension GamesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
        if let cell = cell as? GameListCollectionViewCell, game = section?[indexPath.row] {
            cell.configureForGame(game)
        }
        
        // temp
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColor(red: 45/255.0, green: 196/255.0, blue: 66/255.0, alpha: 1.0);
        } else if (indexPath.row == 1) {
            cell.backgroundColor = UIColor(red: 245/255.0, green: 147/255.0, blue: 0/255.0, alpha: 1.0);
        } else {
            cell.backgroundColor = UIColor(red: 216/255.0, green: 53/255.0, blue: 82/255.0, alpha: 1.0);
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath, remainingLineSpace:CGFloat) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) / 2 - 2.5, height: CGRectGetWidth(collectionView.frame) / 2 - 2.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceHeightForHeaderInSection section: NSInteger) -> CGFloat {
        return 25
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