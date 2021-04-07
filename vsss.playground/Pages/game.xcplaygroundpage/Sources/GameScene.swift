import Foundation
import SpriteKit

public class GameScene: SKScene {
    var field: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellow_green: SKSpriteNode!
    var yellow_pink: SKSpriteNode!
    var yellow_purple: SKSpriteNode!
    var blue_green: SKSpriteNode!
    var blue_pink: SKSpriteNode!
    var blue_purple: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: (yellow: Int, blue: Int) = (0, 0) {
        didSet {
            scoreLabel.text = "Yellow \(score.yellow) x \(score.blue) Blue"
        }
    }
    
    
    override public func didMove(to view: SKView) {
        field = childNode(withName: "//field") as? SKSpriteNode
        field.physicsBody = SKPhysicsBody(edgeLoopFrom: field.frame)
        ball = childNode(withName: "//ball") as? SKSpriteNode
        yellow_green = childNode(withName: "//yellow_green") as? SKSpriteNode
        yellow_pink = childNode(withName: "//yellow_pink") as? SKSpriteNode
        yellow_purple = childNode(withName: "//yellow_purple") as? SKSpriteNode
        blue_green = childNode(withName: "//blue_green") as? SKSpriteNode
        blue_pink = childNode(withName: "//blue_pink") as? SKSpriteNode
        blue_purple = childNode(withName: "//blue_purple") as? SKSpriteNode
        scoreLabel = childNode(withName: "//score") as? SKLabelNode
        score = (yellow: 0, blue: 0)
    }
    
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let object: SKSpriteNode = yellow_green
        if let location = touch?.location(in: self) {
            let angle: CGFloat = atan2((location.y - object.position.y), (location.x - object.position.x))
            
            let scale: CGFloat = 0.05
            let dx = scale * cos(angle)
            let dy = scale * sin(angle)
//            let vdx = object.physicsBody?.velocity.dx
//            let vdy = object.physicsBody?.velocity.dy
            object.zRotation = angle - CGFloat(-Double.pi / 2)
            object.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
//            if (atan2(vdy!, vdx!) != object.zRotation) {
//                object.physicsBody?.velocity.dx = 0
//                object.physicsBody?.velocity.dy = 0
//            }
        }
    }

    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

public class GameViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView()
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        self.view = view
    }
}
