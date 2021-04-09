import Foundation
import SpriteKit

public class GameScene: SKScene {
    var field: SKSpriteNode!
    var fieldFrameLeft: SKSpriteNode!
    var fieldFrameRight: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellowGreen: Robot!
    var yellowPink: Robot!
    var yellowPurple: Robot!
    var blueGreen: Robot!
    var bluePink: Robot!
    var bluePurple: Robot!
    var scoreLabel: SKLabelNode!
    
    var score: (yellow: Int, blue: Int) = (0, 0) {
        didSet {
            scoreLabel.text = "YELLOW  \(score.yellow) x \(score.blue)  BLUE"
        }
    }
    
    public override func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override public func didMove(to view: SKView) {
        resetGame()
    }
    
    public func resetGame() {
        self.removeAllChildren()
        resetScore()
        resetField()
        resetPlayers()
        resetBall()
    }
    
    func resetScore() {
        scoreLabel = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
        scoreLabel.position = CGPoint(x: 0, y: 900)
        scoreLabel.fontSize = 200
        scoreLabel.fontColor = UIColor.darkGray
        score = (yellow: 0, blue: 0)
        
        self.addChild(scoreLabel)
    }
    
    func resetField() {
        let fieldTexture = SKTexture(imageNamed: "field")
        field = SKSpriteNode(texture: fieldTexture)
        field.setScale(1.2)
        
        
        // field left physical limit
        let fieldFrameLeftTexture = SKTexture(imageNamed: "field_frame_left")
        fieldFrameLeft = SKSpriteNode(texture: fieldFrameLeftTexture)
        fieldFrameLeft.physicsBody = SKPhysicsBody(texture: fieldFrameLeftTexture, size: fieldFrameLeftTexture.size())
        fieldFrameLeft.physicsBody?.allowsRotation = false
        fieldFrameLeft.physicsBody?.pinned = true
        fieldFrameLeft.physicsBody?.density = 99999
        fieldFrameLeft.setScale(1.005)

        // field right physical limit
        let fieldFrameRightTexture = SKTexture(imageNamed: "field_frame_right")
        fieldFrameRight = SKSpriteNode(texture: fieldFrameRightTexture)
        fieldFrameRight.physicsBody = SKPhysicsBody(texture: fieldFrameRightTexture, size: fieldFrameRightTexture.size())
        fieldFrameRight.physicsBody?.allowsRotation = false
        fieldFrameRight.physicsBody?.pinned = true
        fieldFrameRight.physicsBody?.density = 99999
        fieldFrameRight.setScale(1.005)
        
        field.addChild(fieldFrameLeft)
        field.addChild(fieldFrameRight)
        
        field.position = CGPoint(x: 0, y: 50)
        self.addChild(field)
    }
    
    func resetBall() {
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.setScale(0.21)
        field.addChild(ball)
    }
    
    func resetPlayers() {
        yellowGreen = Robot(imageNamed: "yellow_green", initialPosition: CGPoint(x: 0, y: 0), team.yellow)
        yellowPink = Robot(imageNamed: "yellow_pink", initialPosition: CGPoint(x: 0, y: 0), team.yellow)
        yellowPurple = Robot(imageNamed: "yellow_purple", initialPosition: CGPoint(x: 0, y: 0), team.yellow)
        blueGreen = Robot(imageNamed: "blue_green", initialPosition: CGPoint(x: 0, y: 0), team.blue)
        bluePink = Robot(imageNamed: "blue_pink", initialPosition: CGPoint(x: 0, y: 0), team.blue)
        bluePurple = Robot(imageNamed: "blue_purple", initialPosition: CGPoint(x: 0, y: 0), team.blue)
        
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
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let positionInScene = touch.locationInNode(self)
//
//        selectNodeForTouch(positionInScene)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let object: SKSpriteNode = ball
        if let location = touch?.location(in: self) {
            let angle: CGFloat = atan2((location.y - object.position.y), (location.x - object.position.x))
            let scale: CGFloat = 100
            let dx = scale * cos(angle)
            let dy = scale * sin(angle)
            object.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }

    override public func update(_ currentTime: TimeInterval) {
        yellowPink?.attacker(ballPosition: ball.position, speed: 400)
        yellowGreen?.goalkeeper(ballPosition: ball.position, speed: 50)
    }

}
