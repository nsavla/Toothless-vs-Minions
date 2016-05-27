//
//  GameScene.swift
//  Toothless
//
//  Created by igmstudent on 2/19/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import SpriteKit

enum LanePosition : CGFloat{
    case bottomLane = 200.0
    case midLane = 400.0
    case topLane = 600.0
}

class GameScene: SKScene,UIGestureRecognizerDelegate {
    
    let Toothless = SKSpriteNode(imageNamed:"Toothless")
    var fireballs = [Fireball]()
    let ScoreLabel = SKLabelNode(fontNamed: "Papyrus")
    var score = 0
    let lifeLabel = SKLabelNode(fontNamed: "Papyrus")
    var MinionsEscaped = 0
    //let Fireball : SKSpriteNode?
    
    var lastTouchLocation : CGPoint?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    
        let background = SKSpriteNode(imageNamed: "GameZone")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x:0 , y:100)
        background.zPosition = -1
        addChild(background)
        
        
        ScoreLabel.position = CGPointMake(80, 120)
        ScoreLabel.verticalAlignmentMode = .Baseline
        ScoreLabel.horizontalAlignmentMode = .Left
        ScoreLabel.text = "Minions Slayed: \(score)"
        ScoreLabel.fontColor = UIColor.redColor()
        ScoreLabel.fontSize = 25
        addChild(ScoreLabel)

        lifeLabel.position = CGPointMake(560, 120)
        lifeLabel.verticalAlignmentMode = .Baseline
        lifeLabel.horizontalAlignmentMode = .Left
        lifeLabel.text = "Minions Escaped or Fish Destroyed: \(MinionsEscaped)"
        lifeLabel.fontColor = UIColor.redColor()
        lifeLabel.fontSize = 25
        addChild(lifeLabel)

        
        Toothless.position = CGPoint(x:200,y:LanePosition.midLane.rawValue)
        Toothless.zPosition = 10
        Toothless.xScale = 0.35
        Toothless.yScale = 0.35
        addChild(Toothless)
      //  print("Repeat ACtion sTarts")
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(SpawnMinion),
            SKAction.waitForDuration(3.0)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(SpawnFish),
            SKAction.waitForDuration(3.0)])))
        
        
        // set up swipe gesture recognizer
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeDetectedUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeUp.delegate = self
        view.addGestureRecognizer(swipeUp)
       // print("Repeat aCtion End")
        
        
        // set up swipe gesture recognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDetectedDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeDown.delegate = self
        view.addGestureRecognizer(swipeDown)
        // print("Repeat aCtion End")
        
        // set up tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        //        tap.numberOfTapsRequired = 2
        //        tap.numberOfTouchesRequired = 2
        tap.delegate = self
        view.addGestureRecognizer(tap)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
   
    func sceneTouched(touchLocation:CGPoint) {
      //  print("Scene Touched Startrst")
        lastTouchLocation = touchLocation
        let xDifference = lastTouchLocation!.x - Toothless.position.x
        if xDifference < 50 {
            //CalculateLanePositionOnTouch(lastTouchLocation!.y)
        } else {

        }
    }
    
    func CalculateLanePositionOnTouch(TouchY : CGFloat){
        let Ydifference = TouchY - Toothless.position.y
        if Ydifference < 90 && Ydifference > -90 {
         //   print("Touch at same lane")
            return
        } else {
           
            if Ydifference > 0 {
                    Toothless.position.y = Toothless.position.y == LanePosition.bottomLane.rawValue ? LanePosition.midLane.rawValue : LanePosition.topLane.rawValue
                   // print("ToothLess moved at higher Lane")
            } else {
                   Toothless.position.y = Toothless.position.y == LanePosition.topLane.rawValue ? LanePosition.midLane.rawValue : LanePosition.bottomLane.rawValue
               // print("ToothLess moved at lower lane")
            }
        }
    }
    
    func SpawnMinion(){
        let Minion = SKSpriteNode(imageNamed: "Minions")
      //print("Spawn Minion Start")
        Minion.removeFromParent()
        Minion.position = CGPoint(x: size.width + Minion.size.width/2, y: RandomLaneforMinion())
            //CGFloat.random(min:CGRectGetMinY(playableRect) + enemy.size.height/2,
               // max: CGRectGetMaxY(playableRect) - enemy.size.height/2 ))
        Minion.xScale = 0.2
        Minion.yScale = 0.2
        Minion.name = "Minion"
       // print("Spawn Minion before adding")
        addChild(Minion)
        // print("Spawn Minion after adding")
  
        let key = arc4random_uniform(30) + 7
        let randomVelocity : Double = (Double)(key) / 10.0
        //print(randomVelocity)
        let actionMove = SKAction.moveToX(-Minion.size.width/2, duration: randomVelocity)
     
        let actionRemove = SKAction.removeFromParent()
        let loseAction = SKAction.runBlock() {
          // print("Player Loses")
            self.MinionsEscaped++
            if(self.MinionsEscaped >= 5){
             let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
                let delay = 0.2 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                
                
                //let sceneTransition = SKTransition.doorwayWithDuration(
                //sceneTransition.pausesOutgoingScene = true
                self.view?.presentScene(gameOverScene, transition: reveal)
                }
            }
             self.lifeLabel.text = "Minions Escaped or Fish Destroyed: \(self.MinionsEscaped)"
        }
        //monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        Minion.runAction(SKAction.sequence([actionMove, loseAction, actionRemove]))
        //print("Spawn Minion End")
    }

    
    func SpawnFish(){
        let key = arc4random_uniform(4)
       // print(" Fish Key = \(key)")
        if( key == 0){
            
        
        let Fish = SKSpriteNode(imageNamed: "Fish")
        Fish.position = CGPoint(x: size.width + Fish.size.width/2, y: RandomLaneforMinion())
        Fish.xScale = 0.5
        Fish.yScale = 0.5
        Fish.name = "Fish"
        addChild(Fish)

        let key = arc4random_uniform(20) + 40
        let randomVelocity : Double = (Double)(key) / 10.0
 
        let actionMove = SKAction.moveToX(-Fish.size.width/2, duration: randomVelocity)
        
        let actionRemove = SKAction.removeFromParent()
        let LifeUpdate = SKAction.runBlock(){
                self.MinionsEscaped--
             self.lifeLabel.text = "Minions Escaped or Fish Destroyed: \(self.MinionsEscaped)"
            }
            print("life minions- \(self.MinionsEscaped)")
        Fish.runAction(SKAction.sequence([actionMove, actionRemove, LifeUpdate]))

        }
    }
    
    
    func RandomLaneforMinion() -> CGFloat{
       let key = arc4random_uniform(3)
        if key == 1 { return LanePosition.topLane.rawValue}
        else if key == 2 { return LanePosition.midLane.rawValue}
        else { return LanePosition.bottomLane.rawValue}
    }
    
    func checkCollisions(){
       // print("Collision Start")
        for fireball in self.fireballs {
        var hitMinions: [SKSpriteNode] = []
        enumerateChildNodesWithName("Minion"){ node, _ in
            let minion = node as! SKSpriteNode
            
            if CGRectIntersectsRect(minion.frame, fireball.frame){
                hitMinions.append(minion)
                }
            
            
        }
        
        for minion in hitMinions{
            
            //var update = true
            let BoomNode = SKSpriteNode(imageNamed: "Boom")
            BoomNode.xScale = 0.3
            BoomNode.yScale = 0.3
            BoomNode.position = minion.position
            addChild(BoomNode)
            
            //let XScaleAction = SKAction.scaleBy(1.0, duration: 0.5)
            //BoomNode.runAction(XScaleAction)
            let delay = 0.01 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                
            minion.removeFromParent()
            BoomNode.removeFromParent()
            }
            score++
            print("Score is - \(score)")
            ScoreLabel.text = "Minions Slayed: \(score)"
            if (score >= 10) {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true)
            
                let delay = 0.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {

                self.view?.presentScene(gameOverScene, transition: reveal)
                    }
                }
            }
        }
      
       // print("Collision End")
        
        
        for fireball in self.fireballs {
            var hitFishes: [SKSpriteNode] = []
            enumerateChildNodesWithName("Fish"){ node, _ in
                let fish = node as! SKSpriteNode
                
                if CGRectIntersectsRect(fish.frame, fireball.frame){
                    hitFishes.append(fish)
                }
                
                
            }
            
            for fish in hitFishes{
                
                //var update = true
                let BoomNode = SKSpriteNode(imageNamed: "Boom")
                BoomNode.xScale = 0.3
                BoomNode.yScale = 0.3
                BoomNode.position = fish.position
                addChild(BoomNode)
                
                //let XScaleAction = SKAction.scaleBy(1.0, duration: 0.5)
                //BoomNode.runAction(XScaleAction)
                let delay = 0.01 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    
                    fish.removeFromParent()
                    BoomNode.removeFromParent()
                }
                self.MinionsEscaped++
                //print("Fish Score is - \(self.MinionsEscaped)")
                lifeLabel.text = "Minions Escaped or Fish Destroyed: \(self.MinionsEscaped)"
                
                    if(self.MinionsEscaped >= 5){
                        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                        let gameOverScene = GameOverScene(size: self.size, won: false)
                        let delay = 0.2 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            
                            
                            //let sceneTransition = SKTransition.doorwayWithDuration(
                            //sceneTransition.pausesOutgoingScene = true
                            self.view?.presentScene(gameOverScene, transition: reveal)
                        }
                    }
                    self.lifeLabel.text = "Minions Escaped or Fish Destroyed: \(self.MinionsEscaped)"
                }
        }
    }
    
    func swipeDetectedUp(sender:UISwipeGestureRecognizer){
        //print(previousRotation)
        if Toothless.position.y == LanePosition.topLane.rawValue {
            print("Cannot go up..Toothless is in Top Lane")
        } else {
            let moveAction = SKAction.moveTo(CGPoint(x:Toothless.position.x , y: Toothless.position.y + 200), duration: 0.1)
            //let moveAction = SKAction.moveByX(0, y: 2000, duration: 2)
            //let deleteAction = SKAction.removeFromParent()
            let blockAction = SKAction.runBlock({print("Done swiping, deleting")})
            Toothless.runAction(SKAction.sequence([moveAction,blockAction]))
        }
    }
    
    func swipeDetectedDown(sender:UISwipeGestureRecognizer){
        //print(previousRotation)
        if Toothless.position.y == LanePosition.bottomLane.rawValue {
            print("Cannot go up..Toothless is in Top Lane")
        } else {
            let moveAction = SKAction.moveTo(CGPoint(x:Toothless.position.x , y: Toothless.position.y - 200), duration: 0.1)
            //let moveAction = SKAction.moveByX(0, y: 2000, duration: 2)
            //let deleteAction = SKAction.removeFromParent()
            let blockAction = SKAction.runBlock({print("Done swiping, deleting")})
            Toothless.runAction(SKAction.sequence([moveAction,blockAction]))
        }
    }
    
    
    func tapDetected(sender:UISwipeGestureRecognizer){
        let fireball = Fireball()
        fireball.position = Toothless.position
        //Fireball.position.x = Toothless.position.x
        fireball.zPosition = 1
        fireball.xScale = 0.2
        fireball.yScale = 0.4
        //Fireball.position.x +=  600
        addChild(fireball)
        fireballs.append(fireball)
        let actionMove = SKAction.moveTo(CGPoint(x:fireball.position.x + 600 ,y:fireball.position.y), duration: 0.5)
        //let actionMove = SKAction.moveTo(Fireball.position, duration: 3)
        //print(Fireball.position.x)
        let actionRemove = SKAction.runBlock(){ self.fireballs.removeAtIndex(self.fireballs.indexOf(fireball)!)}
        let actionMoveDone = SKAction.removeFromParent()
        fireball.runAction(SKAction.sequence([actionMove, actionRemove, actionMoveDone]))
        fireball.position = Toothless.position
        
        print("Fire Breath")
        
        /*
        //print(previousRotation)
        if Toothless.position.y == LanePosition.bottomLane.rawValue {
            print("Cannot go up..Toothless is in Top Lane")
        } else {
            let moveAction = SKAction.moveTo(CGPoint(x:Toothless.position.x , y: Toothless.position.y - 200), duration: 0.1)
            //let moveAction = SKAction.moveByX(0, y: 2000, duration: 2)
            //let deleteAction = SKAction.removeFromParent()
            let blockAction = SKAction.runBlock({print("Done swiping, deleting")})
            Toothless.runAction(SKAction.sequence([moveAction,blockAction]))
        }
        */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        checkCollisions()
    }
}
