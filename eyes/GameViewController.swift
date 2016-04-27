//
//  GameViewController.swift
//  eyes
//
//  Created by Serkan Sokmen on 24/04/16.
//  Copyright (c) 2016 Serkan Sokmen. All rights reserved.
//

import UIKit
import SpriteKit
import C4


class GameViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    
    @IBAction func rotated(sender: UIRotationGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            lastRotation = 0.0;
            return
        }
        
        let rotation = 0.0 - (sender.rotation - lastRotation)
        let trans = CGAffineTransformMakeRotation(rotation)
        
        let skView = self.view as! SKView
        if let skScene = skView.scene {
            let newGravity = CGPointApplyAffineTransform(CGPointMake(skScene.physicsWorld.gravity.dx, skScene.physicsWorld.gravity.dy), trans)
            skScene.physicsWorld.gravity = CGVectorMake(newGravity.x, newGravity.y)
        }
        
        lastRotation = sender.rotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.frame.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
