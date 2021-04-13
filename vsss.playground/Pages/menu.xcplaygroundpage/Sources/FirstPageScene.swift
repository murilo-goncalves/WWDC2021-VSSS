import Foundation
import SpriteKit

// code snippet from: https://stackoverflow.com/questions/40362204/add-glowing-effect-to-an-skspritenode
extension SKSpriteNode {
    func glow(radius: CGFloat) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture, size: size))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
}

public class FirstPageScene: SKScene {
    var vsss: SKSpriteNode!
    var field: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellowGreen: SKSpriteNode!
    var yellowPink: SKSpriteNode!
    var yellowPurple: SKSpriteNode!
    var blueGreen: SKSpriteNode!
    var bluePink: SKSpriteNode!
    var bluePurple: SKSpriteNode!
    var robotCard: SKSpriteNode!
    
    public override func sceneDidLoad() {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1.00)
        
        vsss = SKSpriteNode(texture: SKTexture(imageNamed: "vsss"))
        vsss.setScale(1.2)
        vsss.position = CGPoint(x: 0, y: 1070)
        vsss.glow(radius: 300)
        
        buildField()
        
        robotCard = SKSpriteNode(texture: SKTexture(imageNamed: "robot_card"))
        robotCard.position = CGPoint(x: 0, y: -800)
        
        self.addChild(vsss)
        self.addChild(field)
        self.addChild(robotCard)
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func buildField() {
        let playerSize = CGSize(width: 80, height: 80)
        
        field = SKSpriteNode(texture: SKTexture(imageNamed: "field"))
        field.setScale(1.2)
        field.position = CGPoint(x: 0, y: -100)
        
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))
        ball.glow(radius: ball.size.width / 2)
        ball.setScale(0.21)
        
        yellowGreen = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_green"), size: playerSize)
        yellowGreen.position = CGPoint(x: -610, y: 0)
        yellowGreen.zRotation = -.pi / 2
        yellowGreen.glow(radius: 80)
        yellowPink = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_pink"), size: playerSize)
        yellowPink.position = CGPoint(x: -400, y: 200)
        yellowPink.zRotation = -.pi / 2
        yellowPink.glow(radius: 80)
        yellowPurple = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_purple"), size: playerSize)
        yellowPurple.position = CGPoint(x: -400, y: -200)
        yellowPurple.zRotation = -.pi / 2
        yellowPurple.glow(radius: 80)
        
        blueGreen = SKSpriteNode(texture: SKTexture(imageNamed: "blue_green"), size: playerSize)
        blueGreen.position = CGPoint(x: 610, y: 0)
        blueGreen.zRotation = .pi / 2
        blueGreen.glow(radius: 80)
        bluePink = SKSpriteNode(texture: SKTexture(imageNamed: "blue_pink"), size: playerSize)
        bluePink.position = CGPoint(x: 400, y: -200)
        bluePink.zRotation = .pi / 2
        bluePink.glow(radius: 80)
        bluePurple = SKSpriteNode(texture: SKTexture(imageNamed: "blue_purple"), size: playerSize)
        bluePurple.position = CGPoint(x: 400, y: 200)
        bluePurple.zRotation = .pi / 2
        bluePurple.glow(radius: 80)
        
        field.addChild(ball)
        field.addChild(yellowGreen)
        field.addChild(yellowPink)
        field.addChild(yellowPurple)
        field.addChild(blueGreen)
        field.addChild(bluePink)
        field.addChild(bluePurple)
    }
}

