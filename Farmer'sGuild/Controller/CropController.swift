//
//  CropController.swift
//  FarmersGuild
//
//  Created by Brian Pagani on 8/24/22.
//

import UIKit
import SpriteKit
import GameplayKit

class CropController :SKScene {
//    class TreeObject: SKScene {
//        var Tree = SKSpriteNode()
//
//        var TextureAtlas = SKTextureAtlas()
//        var TextureArray = [SKTexture]()
//
//
//    func didMoveView(view:SKView) {
//
//          TextureAtlas = SKTextureAtlas(named: "Images")
//          for i in 1...TextureAtlas.textureNames.count{
//              let Name = "crop\(i).png"
//              TextureArray.append(SKTexture(imageNamed: Name))
//
//
//          }
//
//          self.addChild(Tree)
//
//       }
//
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            Tree.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
//        }
//
//    }
//
//    var textures: [SKTexture] = []
//    for i in 1...3 {
//        textures.append(SKTexture(imageNamed: "crop\(i)"))
//    }
//    textures.append(textures[2])
//    textures.append(textures[1])
//
//    treeAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)

    
    //how dynamically siwtch out texture images or swap images
    
  
    
    
   static func growCrop() {

           
       
       
        // identify the crop state that its in
        //for example, is it bare or have lemons already
        
        //if texture is bare then turn it to lemons
        
        //update the texutre (image) on the main queue dispatchqueue.main.asynch
       
       print("\n[CropController] -  growCrop: switch the bare lemon tree texture image to a tree with lemons texture image\nThe bare lemon tree now has a ton of lemons!!\n")
        
    }

    
    
    
    
}
