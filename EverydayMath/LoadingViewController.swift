//
//  LoadingViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import Foundation

class LoadingViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var game: Game?
    var config: GameConfiguration?
    
    override func viewDidLoad() {
        assert(game != nil)
        
        self.nameLabel.text = "\(game!.category.description()) – \(game!.name)"
        startButton.setTitle("Loading", forState: UIControlState.Normal)
        startButton.enabled = false
        
        APIClient.getConfigurationForGame(self.game!, callback: { (let configuration: GameConfiguration) -> Void in
            self.configurationLoaded(configuration)
        })        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func configurationLoaded(config: GameConfiguration) {
        startButton.setTitle("Play", forState: UIControlState.Normal)
        startButton.enabled = true
        
        self.config = config
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? GameViewController, game = game, config = config {
            do {
                try destination.gameRun = game.run(config)
            } catch {                
            }
        }
    }
    
}
