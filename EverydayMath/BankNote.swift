//
//  BankNote.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 12.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class BankNote: UIImageView {

    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
    }
    
    class func instanceFromNib(config: CurrencyDragQuestionConfigurationNote) -> BankNote {
        let note = UINib(nibName: "BankNote", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! BankNote
        note.priceLabel.text = String(format: "%@ %@", NSNumberFormatter.formatter.stringFromNumber(config.value)!, config.currency)
        
        return note
    }

}
