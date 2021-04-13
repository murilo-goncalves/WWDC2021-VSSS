import Foundation
import SpriteKit

public class FirstPageScene: SKScene {
    var vsss: SKLabelNode!
    var field: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellowGreen: SKSpriteNode!
    var yellowPink: SKSpriteNode!
    var yellowPurple: SKSpriteNode!
    var blueGreen: SKSpriteNode!
    var bluePink: SKSpriteNode!
    var bluePurple: SKSpriteNode!
    
    public override func sceneDidLoad() {
        let playerSize = CGSize(width: 80, height: 80)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1.00)
        
        vsss = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        vsss.text = "VSSS"
        vsss.fontSize = 400
        vsss.position = CGPoint(x: 0, y: 900)
        vsss.fontColor = UIColor(red: 0.94, green: 0.35, blue: 0.27, alpha: 1.00)
        
        field = SKSpriteNode(texture: SKTexture(imageNamed: "field"))
        field.setScale(1.2)
        field.position = CGPoint(x: 0, y: -100)
        
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "red_ball"))
        ball.setScale(0.21)
        
        yellowGreen = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_green"), size: playerSize)
        yellowGreen.position = CGPoint(x: -610, y: 0)
        yellowGreen.zRotation = -.pi / 2
        yellowPink = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_pink"), size: playerSize)
        yellowPink.position = CGPoint(x: -400, y: 200)
        yellowPink.zRotation = -.pi / 2
        yellowPurple = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_purple"), size: playerSize)
        yellowPurple.position = CGPoint(x: -400, y: -200)
        yellowPurple.zRotation = -.pi / 2
        
        blueGreen = SKSpriteNode(texture: SKTexture(imageNamed: "blue_green"), size: playerSize)
        blueGreen.position = CGPoint(x: 610, y: 0)
        blueGreen.zRotation = .pi / 2
        bluePink = SKSpriteNode(texture: SKTexture(imageNamed: "blue_pink"), size: playerSize)
        bluePink.position = CGPoint(x: 400, y: -200)
        bluePink.zRotation = .pi / 2
        bluePurple = SKSpriteNode(texture: SKTexture(imageNamed: "blue_purple"), size: playerSize)
        bluePurple.position = CGPoint(x: 400, y: 200)
        bluePurple.zRotation = .pi / 2
        
        addChild(vsss)
        addChild(field)
        
        field.addChild(ball)
        field.addChild(yellowGreen)
        field.addChild(yellowPink)
        field.addChild(yellowPurple)
        field.addChild(blueGreen)
        field.addChild(bluePink)
        field.addChild(bluePurple)
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
}

