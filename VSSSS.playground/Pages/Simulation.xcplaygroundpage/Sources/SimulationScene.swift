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
    
    func pulse() {
        let scaleUpAction = SKAction.scale(to: 7, duration: 0.3)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
        
        run(SKAction.sequence([scaleUpAction, scaleDownAction]))
    }
}

public class SimulationScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var scoreLabelGlowY: SKSpriteNode!
    var scoreLabelGlowB: SKSpriteNode!
    var isGamePaused: Bool = true
    var field: SKSpriteNode!
    var fieldFrameLeft: SKSpriteNode!
    var fieldFrameRight: SKSpriteNode!
    var ball: SKSpriteNode!
    var yellowGreen: RobotNode!
    var yellowPink: RobotNode!
    var yellowPurple: RobotNode!
    var blueGreen: RobotNode!
    var bluePink: RobotNode!
    var bluePurple: RobotNode!
    var runButton: ButtonNode!
    var pauseButton: ButtonNode!
    var resetButton: ButtonNode!
    
    var score: (yellow: Int, blue: Int) = (0, 0) {
        didSet {
            scoreLabel.text = "YELLOW  \(score.yellow) X \(score.blue)  BLUE"
        }
    }
    
    override public func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1.00)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    override public func didMove(to view: SKView) {
        resetScene()
    }
    
    func resetGame() {
        score = (0, 0)
        setPlayers()
        setBall()
        pauseGame()
    }
    
    func resetScene() {
        self.removeAllChildren()
        
        let runButtonSprite = SKSpriteNode(texture: SKTexture(imageNamed: "run_button"))
        runButton = ButtonNode(sprite: runButtonSprite, action: runGame)
        runButton.position = CGPoint(x: -600, y: -1100)
        
        let pauseButtonSprite = SKSpriteNode(texture: SKTexture(imageNamed: "pause_button"))
        pauseButton = ButtonNode(sprite: pauseButtonSprite, action: pauseGame)
        pauseButton.position = CGPoint(x: 3.5, y: -1100)
        
        let resetButtonSprite = SKSpriteNode(texture: SKTexture(imageNamed: "reset_button"))
        resetButton = ButtonNode(sprite: resetButtonSprite, action: resetGame)
        resetButton.position = CGPoint(x: 607, y: -1100)
        
        resetScore()
        resetField()
        resetPlayers()
        resetBall()
        
        addChild(runButton)
        addChild(pauseButton)
        addChild(resetButton)
        
        pauseGame()
    }
    
    func resetScore() {
        scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabel.position = CGPoint(x: 0, y: 1050)
        scoreLabel.fontSize = 200
        scoreLabel.fontColor = UIColor(red: 0.98, green: 0.57, blue: 0.19, alpha: 1.00)
        score = (yellow: 0, blue: 0)
        
        scoreLabelGlowY = SKSpriteNode(texture: SKTexture(imageNamed: "y"))
        scoreLabelGlowY.position = CGPoint(x: -600, y: 1100)
        scoreLabelGlowY.glow(radius: 500)
        scoreLabelGlowY.glow(radius: 500)
        scoreLabelGlowY.glow(radius: 500)
        scoreLabelGlowY.texture = nil
        
        scoreLabelGlowB = SKSpriteNode(texture: SKTexture(imageNamed: "b"))
        scoreLabelGlowB.position = CGPoint(x: 730, y: 1100)
        scoreLabelGlowB.glow(radius: 500)
        scoreLabelGlowB.glow(radius: 500)
        scoreLabelGlowB.glow(radius: 500)
        scoreLabelGlowB.texture = nil
        
        self.addChild(scoreLabelGlowY)
        self.addChild(scoreLabelGlowB)
        self.addChild(scoreLabel)
    }
    
    func resetField() {
        let fieldTexture = SKTexture(imageNamed: "field")
        field = SKSpriteNode(texture: fieldTexture)
        field.position = CGPoint(x: 0, y: 0)
        field.setScale(1.2)
        
        
        // field left physical limit
        let fieldFrameLeftTexture = SKTexture(imageNamed: "field_frame_left")
        fieldFrameLeft = SKSpriteNode(texture: fieldFrameLeftTexture)
        fieldFrameLeft.physicsBody = SKPhysicsBody(texture: fieldFrameLeftTexture, size: fieldFrameLeftTexture.size())
        fieldFrameLeft.physicsBody?.allowsRotation = false
        fieldFrameLeft.physicsBody?.pinned = true
        fieldFrameLeft.physicsBody?.mass = 9999
        fieldFrameLeft.physicsBody?.categoryBitMask = Masks.Field
        fieldFrameLeft.physicsBody?.collisionBitMask = ~Masks.Goal
        fieldFrameLeft.physicsBody?.contactTestBitMask = 0
        fieldFrameLeft.setScale(1.005)

        // field right physical limit
        let fieldFrameRightTexture = SKTexture(imageNamed: "field_frame_right")
        fieldFrameRight = SKSpriteNode(texture: fieldFrameRightTexture)
        fieldFrameRight.physicsBody = SKPhysicsBody(texture: fieldFrameRightTexture, size: fieldFrameRightTexture.size())
        fieldFrameRight.physicsBody?.allowsRotation = false
        fieldFrameRight.physicsBody?.pinned = true
        fieldFrameRight.physicsBody?.mass = 999999
        fieldFrameRight.physicsBody?.categoryBitMask = Masks.Field
        fieldFrameRight.physicsBody?.collisionBitMask = ~Masks.Goal
        fieldFrameRight.physicsBody?.contactTestBitMask = 0
        fieldFrameRight.setScale(1.005)
        
        field.addChild(fieldFrameLeft)
        field.addChild(fieldFrameRight)
        
        
        // add goal collision detectors
        let width = (1 / 16) * field.size.width
        let height = (4 / 13) * field.size.height
        let y: CGFloat = 0
        let leftX: CGFloat = -field.size.height / 2 - 50
        let rightX: CGFloat = field.size.height / 2 + 50
        
        let leftDetector = SKShapeNode(rectOf: CGSize(width: width, height: height))
        leftDetector.name = "left detector"
        leftDetector.position = CGPoint(x: leftX, y: y)
        leftDetector.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        leftDetector.physicsBody?.isDynamic = false
        leftDetector.physicsBody?.categoryBitMask = Masks.Goal
        leftDetector.physicsBody?.collisionBitMask = ~(Masks.Field | Masks.Player | Masks.Ball)
        leftDetector.physicsBody?.contactTestBitMask = Masks.Goal | Masks.Ball
        leftDetector.isHidden = true
        
        let rightDetector = SKShapeNode(rectOf: CGSize(width: width, height: height))
        rightDetector.name = "right detector"
        rightDetector.position = CGPoint(x: rightX, y: y)
        rightDetector.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        rightDetector.physicsBody?.isDynamic = false
        rightDetector.physicsBody?.categoryBitMask = Masks.Goal
        rightDetector.physicsBody?.collisionBitMask = ~(Masks.Field | Masks.Player | Masks.Ball)
        rightDetector.physicsBody?.contactTestBitMask = Masks.Ball
        rightDetector.isHidden = true
        
        field.addChild(leftDetector)
        field.addChild(rightDetector)
    
        self.addChild(field)
    }
    
    func resetBall() {
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))
        ball.name = "ball"
        ball.setScale(0.19)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.restitution = 0.5
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.mass = 1
        ball.physicsBody?.categoryBitMask = Masks.Ball
        ball.physicsBody?.collisionBitMask = ~Masks.Goal
        ball.physicsBody?.contactTestBitMask = Masks.Goal
        field.addChild(ball)
    }
    
    func resetPlayers() {
        yellowGreen = RobotNode(imageNamed: "yellow_green", team.yellow)
        yellowPink = RobotNode(imageNamed: "yellow_pink", team.yellow)
        yellowPurple = RobotNode(imageNamed: "yellow_purple", team.yellow)
        blueGreen = RobotNode(imageNamed: "blue_green", team.blue)
        bluePink = RobotNode(imageNamed: "blue_pink", team.blue)
        bluePurple = RobotNode(imageNamed: "blue_purple", team.blue)
        
        field.addChild(yellowGreen)
        field.addChild(yellowPink)
        field.addChild(yellowPurple)
        field.addChild(blueGreen)
        field.addChild(bluePink)
        field.addChild(bluePurple)
        
        setPlayers()
    }
    
    func setPlayers() {
        yellowGreen.goalkeeper()
        yellowPink.attacker(isTop: true)
        yellowPurple.attacker(isTop: false)
        
        blueGreen.goalkeeper()
        bluePink.attacker(isTop: false)
        bluePurple.attacker(isTop: true)
    }
    
    func setBall() {
        let myPhysicsBody = ball.physicsBody
        ball.physicsBody = nil
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody = myPhysicsBody
    }
    
    func runGame() {
        ball.physicsBody?.isDynamic = true
        yellowGreen.physicsBody?.isDynamic = true
        yellowPink.physicsBody?.isDynamic = true
        yellowPurple.physicsBody?.isDynamic = true
        blueGreen.physicsBody?.isDynamic = true
        bluePink.physicsBody?.isDynamic = true
        bluePurple.physicsBody?.isDynamic = true
        isGamePaused = false
    }
    
    func pauseGame() {
        ball.physicsBody?.isDynamic = false
        yellowGreen.physicsBody?.isDynamic = false
        yellowPink.physicsBody?.isDynamic = false
        yellowPurple.physicsBody?.isDynamic = false
        blueGreen.physicsBody?.isDynamic = false
        bluePink.physicsBody?.isDynamic = false
        bluePurple.physicsBody?.isDynamic = false
        
        isGamePaused = true
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        if (bodyA == "ball" || bodyB == "ball") {
            if (bodyA == "left detector" || bodyB == "left detector") {
                score.blue += 1
                scoreLabelGlowB.pulse()
                setPlayers()
                setBall()
            }
            
            if (bodyA == "right detector" || bodyB == "right detector") {
                score.yellow += 1
                scoreLabelGlowY.pulse()
                setPlayers()
                setBall()
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        let node = self.atPoint(location)
        
        if (node == fieldFrameLeft || node == fieldFrameRight) {
            run(SKAction.playSoundFileNamed("deselect.mp3", waitForCompletion: false))
            ball.position = touch!.location(in: field)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let object: SKSpriteNode = ball
        if let location = touch?.location(in: self) {
            let angle: CGFloat = atan2((location.y - object.position.y), (location.x - object.position.x))
            let scale: CGFloat = 140
            let dx = scale * cos(angle)
            let dy = scale * sin(angle)
            object.physicsBody?.applyImpulse((CGVector(dx: dx, dy: dy)))
        }
    }

    override public func update(_ currentTime: TimeInterval) {
        if (!isGamePaused) {
            yellowGreen?.runGoalkeeper(ballPosition: ball.position, speed: 1.2)
            yellowPink?.runAttacker(ballPosition: ball.position, speed: 400, isTop: true)
            yellowPurple.runAttacker(ballPosition: ball.position, speed: 400, isTop: false)
            
            blueGreen?.runGoalkeeper(ballPosition: ball.position, speed: 1.2)
            bluePink?.runAttacker(ballPosition: ball.position, speed: 400, isTop: false)
            bluePurple.runAttacker(ballPosition: ball.position, speed: 400, isTop: true)
        }
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
}

struct Masks {
    static let Field: UInt32 = 0b1 << 0
    static let Goal: UInt32 = 0b1 << 1
    static let Ball: UInt32 = 0b1 << 2
    static let Player: UInt32 = 0b1 << 3
}
