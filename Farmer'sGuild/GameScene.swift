//
//  GameScene.swift
//  Farmer'sGuild
//
//  Created by Brian Pagani on 8/11/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, TimerControllerDelegete {
    func cropTimerCompleted() {
        print("The Timer has completed call your growCrop function")
        CropController.growCrop()
    }
    
    func cropTimerStopped() {
        print("The timer has stopped")
    }
    //Tree Sprite
    let treeSpriteNode = SKSpriteNode( imageNamed: "crop0")
     var treeFrames = [SKTexture] ()
    
    // Nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var cameraNode: SKCameraNode?
    var cropNode: SKNode?
    var tree : SKNode?
    
    // Boolean
    var joystickAction = false
    var rewardIsNotTouched = false  //allows to count 1 at a time
    
    // Measure
    var knobRadius : CGFloat = 50.0
    
    //Score
    let scoreLabel = SKLabelNode()
    var score = 0
    
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
        
        playerStateMachine = GKStateMachine(states: [
            JumpingState(playerNode: player!),
            WalkingState(playerNode: player!),
            IdleState(playerNode: player!),
            LandingState(playerNode: player!),
            StunnedState(playerNode: player!),
            CheerState(playerNode: player!),
            ])
        
        playerStateMachine.enter(IdleState.self)
        
     
        //Timer
        timerController.timeDelegate = self
        
        
        //ScoreLabel
        scoreLabel.position = CGPoint(x: (cameraNode?.position.x)! + 310, y: 140)
        scoreLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "Arial"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = String(score)
        cameraNode?.addChild(scoreLabel)
        
        //Tree Sprite
   
        }
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
            
            let location = touch.location(in: self)
            //jumping action
            if !(joystick?.contains(location))! {
                playerStateMachine.enter(JumpingState.self)
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

// MARK: Action
extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    func rewardTouch(){
        score += 3
        scoreLabel.text = String(score)
    }
    
    func saveTimeCropWasTouched() {
        UserDefaultManager.shared.setDate()
    }
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
            case smack, player, reward, ground
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
        if collision.matches(.player, .smack) {
            let jumpforjoy = SKAction.moveTo(y: 75, duration: 2)
            player?.run(jumpforjoy)
        }
        if collision.matches(.player, .reward) {
            if contact.bodyA.node?.name == "tree" {
                contact.bodyA.node?.physicsBody?.categoryBitMask = 0
               
            }
            else if contact.bodyB.node?.name == "tree" {
                contact.bodyB.node?.physicsBody?.categoryBitMask = 0
                contact.bodyB.node?.removeFromParent()
            }
            if rewardIsNotTouched{
                rewardTouch()
                rewardIsNotTouched = false
                saveTimeCropWasTouched()
                //TODO: - for testing: set the timer based on the time the crop was touched and add a few seconds to that time
                timerController.startTimer(time: 0.3)
                                
            }
         
    }
}
}
