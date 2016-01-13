//
//  CurrencyDragTask.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit
import SEDraggable

class CurrencyDragTaskView: UIView {
//    @IBOutlet var topView: SEDraggableLocation!
    @IBOutlet var fromValueLabel: UILabel!
    @IBOutlet var toDragView: SEDraggableLocation!
    @IBOutlet var fromDragView: SEDraggableLocation!
    
    var draggableMapping = [SEDraggable: Float]()
    
    var task: CurrencyDragTask! {
        didSet {
            fromValueLabel.text = String(format: "%.0f %@", task.configuration.fromValue, task.configuration.fromCurrency)
            
//            for note in task.configuration.fromNotes {
//                let noteView = BankNote.instanceFromNib(note)
//                let draggable = SEDraggable(imageView: noteView)
//                addDraggableToTop(draggable)
//            }
            
            var index = 0
            for (note, count) in task.configuration.availableNotes {
                for _ in 0..<count {
                    let noteView = BankNote.instanceFromNib(note)
                    let draggable = SEDraggable(imageView: noteView)
                    draggable.tag = index
                    draggableMapping[draggable] = note.value
                    addDraggableToFrom(draggable)
                }
                index++
            }
        }
    }
    
    var delegate: TaskDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
//        topView.enableOrdering = false
//        topView.userInteractionEnabled = false
//        configureDraggableLocation(topView)
        configureDraggableLocation(toDragView)
        configureDraggableLocation(fromDragView)
        
        toDragView.enableOrdering = false
        
//        topView.layer.borderColor = UIColor.whiteColor().CGColor
//        topView.layer.borderWidth = 1.0
        toDragView.layer.borderColor = UIColor.whiteColor().CGColor
        toDragView.layer.borderWidth = 1.0
    }
    
    func configureDraggableLocation(draggableLocation: SEDraggableLocation) {
        draggableLocation.objectWidth = 65
        draggableLocation.objectHeight = 40
        
        // set the bounding margins for this location
        draggableLocation.marginLeft = 10
        draggableLocation.marginRight = 10
        draggableLocation.marginTop = 10
        draggableLocation.marginBottom = 10
        
        // set the margins that should be preserved between auto-arranged objects in this location
        draggableLocation.marginBetweenX = 10
        draggableLocation.marginBetweenY = 10
        
        // set up highlight-on-drag-over behavior
        draggableLocation.highlightColor = UIColor.greenColor().CGColor
        draggableLocation.highlightOpacity = 0.4
        draggableLocation.shouldHighlightOnDragOver = true
        
        // you may want to toggle this on/off when certain events occur in your app
        draggableLocation.shouldAcceptDroppedObjects = true
        
        // set up auto-arranging behavior
        draggableLocation.shouldKeepObjectsArranged = true
        draggableLocation.fillHorizontallyFirst = true // NO makes it fill rows first
        draggableLocation.allowRows = true
        draggableLocation.allowColumns = true
        draggableLocation.shouldAnimateObjectAdjustments = true // if this is set to NO, objects will simply appear instantaneously at their new positions
        draggableLocation.animationDuration = 0.5
        draggableLocation.animationDelay = 0.0
        draggableLocation.animationOptions = UIViewAnimationOptions.LayoutSubviews
        
        draggableLocation.shouldAcceptObjectsSnappingBack = true;
    }
    
    func addDraggableToTop(draggable: SEDraggable) {
//        topView.addDraggableObject(draggable, animated: false)
    }
    
    func addDraggableToFrom(draggable: SEDraggable) {
        draggable.addAllowedDropLocation(toDragView)
        draggable.addAllowedDropLocation(fromDragView)
        draggable.homeLocation = fromDragView
        fromDragView.addDraggableObject(draggable, animated: false)
    }
    
    @IBAction func verify() {
        let outputSum = toDragView.containedObjects.reduce(0.0) { (value: Float, item: AnyObject) -> Float in
            let item = item as! SEDraggable
            return value + (draggableMapping[item] ?? 0)
        }
        
        if (task.verifyResult(outputSum)) {
            toDragView.backgroundColor = UIColor.greenColor()
            delegate?.taskCompleted(task, correct: true)
        } else {
            toDragView.backgroundColor = UIColor.redColor()
            delegate?.taskCompleted(task, correct: false)
        }
    }
}
