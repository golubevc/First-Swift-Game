//
//  MainMenu.swift
//  Game 3
//
//  Created by Alexey Golubev on 15/09/2019.
//  Copyright © 2019 Alexey Golubev. All rights reserved.

/*import SpriteKit


class MainMenu: SKScene {

    var starfield:SKSpriteNode!
    
    var newGameBtnNode:SKSpriteNode!
    var levelBtnNode:SKSpriteNode!
    var labelLevelNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        starfield = self.childNode(withName: "starFieldAnim") as! SKEmitterNode
        
        starfield.advnceSimulationTime(10)
        
        newGameBtnNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        newGameBtnNode.texture = SKTexture(imageNamed: "newGameBtn")
        
        levelBtnNode = self.childNode(withName: "levelBtn") as! SKSpriteNode
        levelBtnNode.texture = SKTexture(imageNamed: "levelBtn")

        labelLevelNode = self.childNode(withName: "labelLevelBtn") as! SKLabelNode
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let loaction = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameBtn" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            
        }
    }
    
    
}
*/
