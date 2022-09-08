//
//  GameScene.swift
//  Farmer'sGuild
//
//  Created by Brian Pagani on 8/11/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, TimerControllerDelegete {
    
    
    //Tree Sprite
//    let treeSpriteNode = SKSpriteNode( imageNamed: "crop0")
//    var treeFrames = [SKTexture] ()
    
    //Testing Crop Growing
    var lemonTreeNode = SKSpriteNode(imageNamed: lemonTree.lemon_tree_bear.rawValue)
    
    // Nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var cameraNode: SKCameraNode?
    var cropNode: SKNode?
    var tree : SKNode?
    var weapon : SKNode?
    var ZombNode : SKNode?

    
    // Boolean
    var joystickAction = false
    var rewardIsNotTouched = false  //allows to count 1 at a time
    var isHit = false
    
    // Measure
    var knobRadius : CGFloat = 50.0
    
    //Score
    let scoreLabel = SKLabelNode()
    var score = 0
    
    //LifeSystem
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    
    //Timer
    let timerLabel = SKLabelNode()
    var timeRemaining = "00 : 00"
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed = 4.0
    
    // Player state
    var playerStateMachine : GKStateMachine!
    
    //Crop Controller
    
    
    // Timer
    var timerController = TimerController()
    

    

    // didmove
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        //music
        
        //        let soundAction = SKAction.repeatForever(SKAction.playSoundFileNamed("musicSound.mp3", waitForCompletion: false))
        //        run(soundAction)
        
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")

        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        cropNode = childNode(withName: "tree")
        weapon = childNode(withName: "playerWeapon")
        ZombNode = childNode(withName: "ZombNode")
        
        playerStateMachine = GKStateMachine(states: [
            JumpingState(playerNode: player!),
            WalkingState(playerNode: player!),
            IdleState(playerNode: player!),
            LandingState(playerNode: player!),
            StunnedState(playerNode: player!),
            CheerState(playerNode: player!),
        ])
        
        playerStateMachine.enter(IdleState.self)
        
        //LifeSystem
        heartContainer.position = CGPoint(x: -300, y: 140)
        heartContainer.zPosition = 5
        cameraNode?.addChild(heartContainer)
        fillHearts(count: 5)
        
        
        //Timer
        timerController.timeDelegate = self
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {(timer) in
            self.spawnZomb()
            
        }
        
        //ScoreLabel
        setUpScoreLabel()
        
        //ZombieScore
//        setUpZombScoreLabel()
        
        
        //Tree Sprite
        //Idea testing
//        setUpDummyTree()
        
        //TimerLabel
//        setUpTimerLabel()
    }
    
    func setUpScoreLabel() {
        scoreLabel.position = CGPoint(x: (cameraNode?.position.x)! + 310, y: 140)
        scoreLabel.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        scoreLabel.fontSize = 35
        scoreLabel.fontName = "SignPainter"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "Tap the Screen to Shoot"
        cameraNode?.addChild(scoreLabel)
     

        
        
        
    }
//    func setUpZombScoreLabel() {
//        scoreLabel.position = CGPoint(x: (cameraNode?.position.x)! + 250, y: 140)
//        scoreLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//        scoreLabel.fontSize = 24
//        scoreLabel.fontName = "Arial"
//        scoreLabel.horizontalAlignmentMode = .right
//        scoreLabel.text = String(score)
//        cameraNode?.addChild(scoreLabel)
//    }
    
    func setUpTimerLabel() {
        timerLabel.position = CGPoint(x: (cameraNode?.position.x)! + 110, y: 140)
        timerLabel.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        timerLabel.fontSize = 24
        timerLabel.fontName = "Arial"
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.text = String(timeRemaining)
        cameraNode?.addChild(timerLabel)
    }
    
    //https://stackoverflow.com/questions/34405620/update-change-the-image-of-skspritenode
//    func setUpDummyTree() {
//        lemonTreeNode.position = CGPoint(x: (cameraNode?.position.x)! + 110, y: 80)
//        lemonTreeNode.size = CGSize(width: 50, height: 50)
//        cameraNode?.addChild(lemonTreeNode)
//    }
}


// MARK: Touches
extension GameScene {
    // Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
            let location = touch.location(in:self)
            let touchedNode = atPoint(location)
        
            

            //jumping action
            if !(joystick?.contains(location))! {
                playerStateMachine.enter(JumpingState.self)
                
                let shot = SKSpriteNode(imageNamed: "playerWeapon")
                
                let physicsBody = SKPhysicsBody(circleOfRadius: 30)
                shot.physicsBody = physicsBody
                shot.physicsBody!.categoryBitMask = Collision.Masks.attack.bitmask
                shot.physicsBody!.collisionBitMask = Collision.Masks.enemy.bitmask
                shot.physicsBody!.contactTestBitMask = Collision.Masks.enemy.bitmask
                shot.physicsBody!.fieldBitMask = Collision.Masks.enemy.bitmask
                
         
                
                shot.physicsBody!.allowsRotation = false
                shot.physicsBody!.restitution = 0
                shot.zPosition = 5
                
               
            
                
                
                
               
                shot.name = "playerWeapon"
                shot.position = weapon?.position ?? (location)
//                if shot.contains(location) {

//                            let Bullet = SKSpriteNode(imageNamed: "playerWeapon.png")
//                            Bullet.zPosition = -5
//
//                    Bullet.position = CGPoint(x: shot.position.x, y: shot.position.y)
//                    Bullet.zRotation = weapon?.zRotation ?? (0)
//
//
//
//                    let action = SKAction.move(
//                        to: CGPoint(
//                            x: 400 * -cos(Bullet.zRotation - 1.57079633) + Bullet.position.x,
//                            y: 400 * -sin(Bullet.zRotation - 1.57079633) + Bullet.position.y
//                                    ),
//                                    duration: 0.8)
//                            let actionDone = SKAction.removeFromParent()
//                    Bullet.run(SKAction.sequence([action, actionDone]))
//
//                    Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
//                            Bullet.physicsBody?.affectedByGravity = false
//                    Bullet.physicsBody?.isDynamic = false
//                            self.addChild(Bullet)
//
//                        }

                

                shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
                
                
            
                
             
                addChild(shot)
                
               
                
                
                

                let movementRight = SKAction.move(to: CGPoint(x: 1900, y: shot.position.y), duration: 7); let movementLeft = SKAction.move(to: CGPoint(x: -1900, y: shot.position.y), duration: 7)
                
                if playerIsFacingRight == true { let sequence = SKAction.sequence([movementRight,  .removeFromParent()])
                shot.run(sequence)
                }else{  let otherWay = SKAction.sequence([movementLeft, .removeFromParent()])
                    shot.run(otherWay)
                }
            }
        }
    }
    
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Distance
        for touch in touches {
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    // Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 200.0
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
        }
    }
}

// MARK: Timer Delegate functions
extension GameScene {
    func timerSecondTick() {
        DispatchQueue.main.async {
            self.timerLabel.text = self.timerController.timeAsString()
        }
    }
    
    func cropTimerCompleted() {
        print("The Timer has completed call your growCrop function")
        rewardTouch()
        lemonTreeNode.texture = SKTexture(imageNamed: lemonTree.lemon_tree_lemons.rawValue)
    }
    
    func cropTimerStopped() {
        print("The timer has stopped")
    }
}
// MARK: Action
extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    func rewardTouch() {
        score += 3
        scoreLabel.text = String(score)
    }
    func zombScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    func fillHearts(count: Int) {
        for index in 1...count {
            let heart = SKSpriteNode(imageNamed: "lifelogo")
            let xPosition = heart.size.width * CGFloat(index - 1)
            heart.position = CGPoint(x: xPosition, y: 0)
            heartsArray.append(heart)
            heartContainer.addChild(heart)
        }
    }
    
    func loseHeart() {
        if isHit == true {
            let lastElementIndex = heartsArray.count - 1
            if heartsArray.indices.contains(lastElementIndex - 1) {
                let lastHeart = heartsArray[lastElementIndex]
                lastHeart.removeFromParent()
                heartsArray.remove(at: lastElementIndex)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    self.isHit = false
                }
            }
            else {
                dying()
                showDieScene()
                            }
            invincible()
        }
    }
    
    func invincible() {
        player?.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.player?.physicsBody?.categoryBitMask = 2
        }
    }
    
    func dying() {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        player?.run(dieAction)
        self.removeAllActions()
        fillHearts(count: 3)
    }
    func showDieScene() {
        let gameOverScene = GameScene(fileNamed: "GameOver")
        self.view?.presentScene(gameOverScene)
    }
    

}

     func saveTimeCropWasTouched() {
        UserDefaultManager.shared.setDate()
}


// MARK: Game Loop
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        rewardIsNotTouched = true
        
        //Camera
        cameraNode?.position.x = player!.position.x
        joystick?.position.y = (cameraNode?.position.y)! - 100
        joystick?.position.x = (cameraNode?.position.x)! - 300
        
        // Player movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let positivePosition = xPosition < 0 ? -xPosition : xPosition
        
        if floor(positivePosition) != 0 {
            playerStateMachine.enter(WalkingState.self)
        } else {
            playerStateMachine.enter(IdleState.self)
        }
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        }
        else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
    }
}



//parallax scroll if I want



//MARK: Collision

extension GameScene: SKPhysicsContactDelegate {
    struct Collision {
        
        enum Masks: Int {
            case smack, player, reward, ground , attack, enemy
            var bitmask: UInt32 { return 1 << self.rawValue }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks,_ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
            (first.bitmask == masks.second && second.bitmask == masks.first)
        }
        
        
        
        
        
        
        
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second:contact.bodyB.categoryBitMask))
        if collision.matches(.player, .enemy) {
           loseHeart()
            isHit = true
            playerStateMachine.enter(StunnedState.self)
        }
        if collision.matches(.attack, .enemy){
            if contact.bodyA.node?.name == "ZombNode"{
                contact.bodyA.node?.physicsBody?.categoryBitMask = 6
                contact.bodyA.node?.physicsBody?.node?.removeFromParent()
               
            }
        }
        else if contact.bodyB.node?.name == "ZombNode" {
            contact.bodyB.node?.physicsBody?.categoryBitMask = 6
            zombScore()
           
            
            contact.bodyB.node?.removeFromParent()
        }
        
        
        if collision.matches(.player, .ground){
            playerStateMachine.enter(LandingState.self)
        }
        
        
        
//        if collision.matches(.player, .reward) {
//            if contact.bodyA.node?.name == "tree" {
//                contact.bodyA.node?.physicsBody?.categoryBitMask = 0
//
//            }
//            else if contact.bodyB.node?.name == "tree" {
//                contact.bodyB.node?.physicsBody?.categoryBitMask = 0
//                contact.bodyB.node?.removeFromParent()
//            }
//
//            if rewardIsNotTouched {
//
//                rewardIsNotTouched = false
//                saveTimeCropWasTouched()
//                timerController.startTimer(time: Constants.cropTimeValue)
//            }
            
           
//            if collision.matches(.player, .enemy){
//                print("Die Worked")
//                if contact.bodyA.node?.name == "ZombNode", let ZombNode = contact.bodyA.node {ZombDie(at: ZombNode.position)
//                    ZombNode.removeFromParent()
//                }
//                if contact.bodyB.node?.name == "ZombNode", let ZombNode = contact.bodyB.node {ZombDie(at: ZombNode.position)
//                    ZombNode.removeFromParent()
//            }
//            }
                
                //Mark: Gun Collision
             
            if collision.matches(.attack, .enemy){
                if contact.bodyA.node?.name == "ZombNode" {
                    
                    
                }
                else if contact.bodyB.node?.name == "ZombNode" {
                
                    contact.bodyB.node?.removeFromParent()
                }
                    
                }
            }
      
        }
    

 //MARK: Zomb Spawn

extension GameScene {
    func spawnZomb() {
        //want to use either the Array or the Atlas to Animate the Zombie Sprite
        

        let node = SKSpriteNode(imageNamed: "character_zombie_switch1")
        node.name = "ZombNode"
        let randomXPosition = Int(arc4random_uniform(UInt32(self.size.width)))
        
        let zombAnimationKey = "Sprite Animation"
     
        let textures = SKTexture(imageNamed: "ZombWalk/0")
        lazy var action = { SKAction.animate(with: [textures], timePerFrame: 0.1)} ()

        func isValidNextState(_ stateClass: AnyClass) -> Bool {
            ZombNode?.removeAction(forKey: zombAnimationKey)
            ZombNode?.run(action, withKey: zombAnimationKey)

            return true
        }


            
        

        let runtextures : Array<SKTexture> = (0..<2).map({ return "ZombWalk/\($0)"}).map(SKTexture.init)
        lazy var runaction = { SKAction.repeatForever(.animate(with: runtextures, timePerFrame: 0.1))} ()
        
        func didEnter(from previousState: GKState?) {
            
            self.ZombNode!.removeAction(forKey: zombAnimationKey)
            self.ZombNode!.run(runaction, withKey: zombAnimationKey)
        }

    
        let moveLeft = SKAction.move(to: CGPoint(x: 100, y:10), duration: 5)
        let moveRight = SKAction.move(to: CGPoint(x: -100, y:-10), duration: 5)

        node.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
        node.position = CGPoint(x: randomXPosition, y: -50)
        node.size = CGSize(width: 100, height: 100)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.zPosition = 0
        
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 30)
        node.physicsBody = physicsBody
 
        physicsBody.categoryBitMask = Collision.Masks.enemy.bitmask
        physicsBody.collisionBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask |  Collision.Masks.attack.bitmask
        physicsBody.contactTestBitMask = Collision.Masks.player.bitmask|Collision.Masks.ground.bitmask
        physicsBody.fieldBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask | Collision.Masks.attack.bitmask
        
        
        
        physicsBody.affectedByGravity = false
        physicsBody.pinned = false
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.2
        physicsBody.friction = 10
        addChild(node)
    }
    
//    func ZombDie(at position: CGPoint) {
//        let node = SKSpriteNode(imageNamed: "character_zombie_slide")
//        node.position.x = position.x
//        node.position.y = position.y
//        node.zPosition = 4
//        node.size = CGSize(width: 100, height: 100)
//
//        addChild(node)
//
//        let action = SKAction.sequence([
//            SKAction.fadeIn(withDuration: 0.1),
//                SKAction.wait(forDuration: 2.0),
//                SKAction.fadeOut(withDuration: 0.2),
//                SKAction.removeFromParent(),
//            ])
//
//        node.run(action)
//}
    
}

