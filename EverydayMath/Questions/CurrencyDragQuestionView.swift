//
//  CurrencyDragQuestion.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit
import SEDraggable

class NoteDraggable: SEDraggable {
    var config: CurrencyDragQuestionConfigurationNote!
    lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NoteDraggable.handleTap))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapRecognizer)
    }
    
    override init!(imageView: UIImageView!) {
        super.init(imageView: imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap() {
        for location in self.droppableLocations {
            if let location = location as? SEDraggableLocation where location != currentLocation {
                location.draggableObjectWasDroppedInside(self, animated: true)
                break
            }
        }
    }
}

class CurrencyDragQuestionView: UIView {
    @IBOutlet var taskVerticalSpace: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fromValueLabel: UILabel!
    @IBOutlet var toDragView: SEDraggableLocation!
    @IBOutlet var fromDragView: SEDraggableLocation!
    var hintView: UIView?

    lazy var toDragViewNotesLimit: Int = {
        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular {
            return 10;
        } else {
            // limit of 8 notes on iPhone because of smaller screen
            return 8;
        }
    }()
    
    var question: CurrencyDragQuestion! {
        didSet {
            titleLabel.text = String(format: NSLocalizedString("Drag the notes to estimate the conversion of %@ to %@", comment: "Drag task title"), question.configuration.fromCurrency, question.configuration.toCurrency)
            fromValueLabel.text = String(format: "%@ %@", NSNumberFormatter.formatter.stringFromNumber(question.configuration.fromValue)!, question.configuration.fromCurrency)
            var index = 0
            for note in question.configuration.availableNotes {
                for _ in 0..<note.count {
                    let noteView = BankNote.instanceFromNib(note)
                    let draggable = NoteDraggable(imageView: noteView)
                    draggable.config = note
                    draggable.tag = index
                    addDraggableToFrom(draggable)
                }
                index += 1
            }
        }
    }
    
    var delegate: QuestionDelegate?

    deinit {
        toDragView.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        configureDraggableLocation(toDragView)
        configureDraggableLocation(fromDragView)
        
        toDragView.enableOrdering = false
        toDragView.delegate = self
        
        toDragView.layer.borderColor = UIColor.whiteColor().CGColor
        toDragView.layer.borderWidth = 1.0
        toDragView.layer.cornerRadius = 3.0
    }

    override func didMoveToSuperview() {
        if UIScreen.mainScreen().bounds.size.height == 480 {
            taskVerticalSpace.constant = 5
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular {
//            for noteView in self.fromDragView.containedObjects {
//                var noteView = noteView as! UIView
//                var frame = noteView.frame
//                frame.size = CGSizeMake(noteView.frame.size.width * 1.5, noteView.frame.size.height * 1.5)
//                noteView.frame = frame
//            }
//        }
//    }
    
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
    
    func addDraggableToFrom(draggable: SEDraggable) {
        draggable.addAllowedDropLocation(toDragView)
        draggable.addAllowedDropLocation(fromDragView)
        draggable.homeLocation = fromDragView
        fromDragView.addDraggableObject(draggable, animated: false)
    }
    
    @IBAction func verify() {
        let outputSum = toDragView.containedObjects.reduce(0.0) { (value: Float, item: AnyObject) -> Float in
            let item = item as! NoteDraggable
            return value + item.config.value
        }
        let outputValues = toDragView.containedObjects.map { (item: AnyObject) -> String in
            let item = item as! NoteDraggable
            return NSNumberFormatter.formatter.stringFromNumber(item.config.value)!
        }
        
        if (question.verifyResult(outputSum)) {
            toDragView.backgroundColor = UIColor.correctColor()
            delegate?.questionCompleted(question, correct: true, accuracy: question.isPrecise(outputSum) ? .Precise : .Imprecise, answer: self.question.answerLogForAnswer(outputSum, notes: outputValues))
        } else {
            if let hint = question.configuration.hint where self.hintView == nil {
                handleFailure()
                let hintView = hint.getHintView()
                self.hintView = hintView
                showHintView(hintView)
                
                delegate?.questionGaveSecondTry(question)
            } else {
                handleSecondFailure()
                self.userInteractionEnabled = false
                toDragView.backgroundColor = UIColor.errorColor()
                delegate?.questionCompleted(question, correct: false, accuracy: nil, answer: self.question.answerLogForAnswer(outputSum, notes: outputValues))
            }
        }
    }
    
    private func handleFailure() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toDragView.backgroundColor = UIColor.errorColor()
            }, completion: { _ -> Void in
                UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.toDragView.backgroundColor = UIColor.clearColor()
                    }, completion: { _ -> Void in
                        self.clearAnswerView()
                })
        })
    }
    
    private func handleSecondFailure() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toDragView.backgroundColor = UIColor.errorColor()
            }, completion: { _ -> Void in
                UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.toDragView.backgroundColor = UIColor.clearColor()
                    }, completion: { _ -> Void in
                        self.clearAnswerView()
                        
                        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                        dispatch_after(delayTime, dispatch_get_main_queue()) {
                            self.showCorrectAnswer()
                        }
                })
        })
    }
    
    private func clearAnswerView() {
        for object in toDragView.containedObjects {
            if let object = object as? SEDraggable {
                fromDragView.draggableObjectWasDroppedInside(object, animated: true)
            }
        }
    }
    
    private func showCorrectAnswer() {
        var correctDraggables = [NoteDraggable]()
        var remainingCorrect = self.question.configuration.correctNotes
        for note in self.fromDragView.containedObjects {
            let note = note as! NoteDraggable
            if let i = remainingCorrect.indexOf({$0.value == note.config.value}) {
                correctDraggables.append(note)
                remainingCorrect.removeAtIndex(i)
            }
        }
        
        for draggable in correctDraggables {
            toDragView.draggableObjectWasDroppedInside(draggable, animated: true)
        }
    }
    
    private func showHintView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.addSubview(view)
        view.frame = CGRectMake(0, -view.frame.size.height, self.frame.width, view.frame.size.height)
        UIView.animateWithDuration(0.4, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        }, completion: nil)
    }
}

extension CurrencyDragQuestionView: SEDraggableLocationEventResponder {
    func draggableLocationDidRecalculateObjectPositions(location: SEDraggableLocation!) {
        if (location == toDragView) {
            location.shouldAcceptDroppedObjects = location.containedObjects.count < self.toDragViewNotesLimit
        }
    }
}
