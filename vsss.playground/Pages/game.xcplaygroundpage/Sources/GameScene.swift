import Foundation
import SpriteKit

class Player: SKSpriteNode {
    init(imageNamed: String, initialPosition: CGPoint) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 100, height: 100))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        self.position = initialPosition
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getOrientation() -> CGFloat {
        let front = SKNode()
        front.position.y = self.size.height / 2
        self.addChild(front)
        let position = self.convert(front.position, to: self.scene!)
        let orientation = atan2(position.y - self.position.y, position.x - self.position.x)
        
        return orientation
    }
    
    public func spin(intensity: CGFloat, clockwise: Bool = true) {
        self.physicsBody?.angularVelocity = intensity
    }
}

open class GameScene: SKScene {
    var field: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellowGreen: Player!
    var yellowPink: Player!
    var yellowPurple: Player!
    var blueGreen: Player!
    var bluePink: Player!
    var bluePurple: Player!
    var scoreLabel: SKLabelNode!
    
    var score: (yellow: Int, blue: Int) = (0, 0) {
        didSet {
            scoreLabel.text = "YELLOW \(score.yellow) x \(score.blue) BLUE"
        }
    }
    
    override public func didMove(to view: SKView) {
        field = childNode(withName: "//field") as? SKSpriteNode
        ball = childNode(withName: "//ball") as? SKSpriteNode
        
        resetField()
    }
    
    public func resetField() {
        yellowGreen = Player(imageNamed: "yellow_green", initialPosition: CGPoint(x: 0, y: 0))
        yellowPink = Player(imageNamed: "yellow_pink", initialPosition: CGPoint(x: 0, y: 0))
        yellowPurple = Player(imageNamed: "yellow_purple", initialPosition: CGPoint(x: 0, y: 0))
        blueGreen = Player(imageNamed: "blue_green", initialPosition: CGPoint(x: 0, y: 0))
        bluePink = Player(imageNamed: "blue_pink", initialPosition: CGPoint(x: 0, y: 0))
        bluePurple = Player(imageNamed: "blue_purple", initialPosition: CGPoint(x: 0, y: 0))
        scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.position = CGPoint(x: 0, y: 900)
        scoreLabel.fontSize = 200
        scoreLabel.fontColor = UIColor.darkGray
        score = (yellow: 0, blue: 0)
        
        self.addChild(yellowGreen)
        self.addChild(yellowPink)
        self.addChild(yellowPurple)
        self.addChild(blueGreen)
        self.addChild(bluePink)
        self.addChild(bluePurple)
        self.addChild(scoreLabel)
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
    
//    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let object: SKSpriteNode = yellow_green
//        if let location = touch?.location(in: self) {
//            let angle: CGFloat = atan2((location.y - object.position.y), (location.x - object.position.x))
//
//            let scale: CGFloat = 0.5
//            let dx = scale * cos(angle)
//            let dy = scale * sin(angle)
//            object.zRotation = angle - CGFloat(-Double.pi / 2)
//            object.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
////            let position = yellow_green.convert(front.position, to: field)
////            let orientation = atan2(position.y - yellow_green.position.y, position.x - yellow_green.position.x)
////            if (orientation != object.zRotation) {
////                object.physicsBody?.velocity.dx = 0
////                object.physicsBody?.velocity.dy = 0
////                print(atan2(position.y - yellow_green.position.y, position.x - yellow_green.position.x), object.zRotation)
////
////            }
//        }
//    }

    override public func update(_ currentTime: TimeInterval) {
        let players = [ yellowGreen,
                        yellowPink,
                        yellowPurple,
                        blueGreen,
                        bluePink,
                        bluePurple ]
    
        for player in players {
            player?.spin(intensity: 10)
        }
    }
    
    func radToPi(_ x: CGFloat) -> CGFloat {
        return x * CGFloat(180) / CGFloat(Double.pi)
    }
}
