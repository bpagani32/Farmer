//
//  CropController.swift
//  FarmersGuild
//
//  Created by Brian Pagani on 8/24/22.
//

import UIKit
import SpriteKit

class CropController {
    
    static let shared = CropController()
    
    var crops: [Crop] = []
    
    //As soon as this file is called, the function inside the init statement will get called. The array of Crops will be added to our array variable above.
    init() {
        loadFromPersistentStorage()
    }
    
    func startHarvest(with date: Date) {
        let expirationDate = date.addingTimeInterval(Constants.cropTimeValue)
        let newHarvest = Crop(textureName: "lemon_tree_bear", cropStage: 0, startTime: date, expirationTime: expirationDate)
        crops.append(newHarvest)
        
        saveToPersistentStorage()
    }
    
    func advanceHarvest(of crop: Crop, by value: Int) {
        guard let index = crops.firstIndex(of: crop) else { return }
        
        //crop to update if found
        crops[index].cropStage = value
        crops[index].textureName = "lemon_tree_lemons"
        saveToPersistentStorage()
    }
    
    //MARK: - Persistance
    
    private func myFileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("Crop.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        do {
            let data = try JSONEncoder().encode(crops)
            try data.write(to: myFileURL())
        } catch {
            print("Error saving to persistent storage: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStorage() {
        do {
            let data = try Data(contentsOf: myFileURL())
            let crops = try JSONDecoder().decode([Crop].self, from: data)
            self.crops = crops
        } catch {
            print("Error loading from persistent storage: \(error.localizedDescription)")
        }
    }
}


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
