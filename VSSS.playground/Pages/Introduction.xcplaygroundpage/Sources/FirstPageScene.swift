import Foundation
import SpriteKit

// code snippet from: https://stackoverflow.com/questions/40362204/add-glowing-effect-to-an-skspritenode
extension SKSpriteNode {
    func glow(radius: CGFloat) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        let newSpriteNode = SKSpriteNode(texture: texture, size: size)
        newSpriteNode.name = name
        effectNode.addChild(newSpriteNode)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
    
    func stopGlow() {
        self.parent?.parent?.removeAllChildren()
    }
}

public class FirstPageScene: SKScene {
    var vsss: SKSpriteNode!
    var field: SKSpriteNode!
    var gameCamera: SKSpriteNode!
    var firstCard: SKSpriteNode!
    var cameraCard: SKSpriteNode!
    var ballCard: SKSpriteNode!
    var yellowGreenCard: SKSpriteNode!
    var yellowPinkCard: SKSpriteNode!
    var yellowPurpleCard: SKSpriteNode!
    var blueGreenCard: SKSpriteNode!
    var bluePinkCard: SKSpriteNode!
    var bluePurpleCard: SKSpriteNode!
    var cards: SKNode!
    
    public override func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1.00)
        
        cards = SKNode()
        
        vsss = SKSpriteNode(texture: SKTexture(imageNamed: "vsss"))
        vsss.setScale(1.2)
        vsss.name = "vsss"
        vsss.position = CGPoint(x: 0, y: 1170)
        vsss.glow(radius: 300)
    
        self.addChild(vsss)
        buildField()
        buildCard(card: &firstCard, cardName: "first_card")
        firstCard.isHidden = false
        firstCard.position = CGPoint(x: 0, y: -1220)
        buildCard(card: &cameraCard, cardName: "camera_card")
        buildCard(card: &ballCard, cardName: "ball_card")
        buildCard(card: &yellowGreenCard, cardName: "ball_card")
        buildCard(card: &yellowGreenCard, cardName: "yellow_green_card")
        buildCard(card: &yellowPinkCard, cardName: "yellow_pink_card")
        buildCard(card: &yellowPurpleCard, cardName: "yellow_purple_card")
        buildCard(card: &blueGreenCard, cardName: "blue_green_card")
        buildCard(card: &bluePinkCard, cardName: "blue_pink_card")
        buildCard(card: &bluePurpleCard, cardName: "blue_purple_card")
        addChild(cards)
    }
    
    func buildField() {
        let playerSize = CGSize(width: 84, height: 84)
        let fieldPosY: CGFloat = -250
        
        field = SKSpriteNode(texture: SKTexture(imageNamed: "field"))
        field.setScale(1.2)
        field.position = CGPoint(x: 0, y: fieldPosY)
        
        gameCamera = SKSpriteNode(texture: SKTexture(imageNamed: "camera"))
        gameCamera.position = CGPoint(x: 0, y: 685)
        gameCamera.size = CGSize(width: 607.6, height: 243.6)
        gameCamera.name = "camera"
        
        let cameraCapture = SKSpriteNode(texture: SKTexture(imageNamed: "camera_capture"))
        cameraCapture.position = CGPoint(x: 0, y: 203)
        cameraCapture.setScale(0.25)
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))
        ball.position = CGPoint(x: 0, y: fieldPosY)
        ball.name = "ball"
        ball.size = CGSize(width: 46, height: 46)
        
        let yellowGreen = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_green"), size: playerSize)
        yellowGreen.position = CGPoint(x: -610, y: fieldPosY)
        yellowGreen.name = "yellow_green"
        yellowGreen.zRotation = -.pi / 2
        
        let yellowPink = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_pink"), size: playerSize)
        yellowPink.position = CGPoint(x: -400, y: 200 + fieldPosY)
        yellowPink.name = "yellow_pink"
        yellowPink.zRotation = -.pi / 2
        
        let yellowPurple = SKSpriteNode(texture: SKTexture(imageNamed: "yellow_purple"), size: playerSize)
        yellowPurple.position = CGPoint(x: -400, y: -200 + fieldPosY)
        yellowPurple.name = "yellow_purple"
        yellowPurple.zRotation = -.pi / 2
        
        let blueGreen = SKSpriteNode(texture: SKTexture(imageNamed: "blue_green"), size: playerSize)
        blueGreen.position = CGPoint(x: 610, y: fieldPosY)
        blueGreen.name = "blue_green"
        blueGreen.zRotation = .pi / 2
        
        let bluePink = SKSpriteNode(texture: SKTexture(imageNamed: "blue_pink"), size: playerSize)
        bluePink.position = CGPoint(x: 400, y: -200 + fieldPosY)
        bluePink.name = "blue_pink"
        bluePink.zRotation = .pi / 2
        
        let bluePurple = SKSpriteNode(texture: SKTexture(imageNamed: "blue_purple"), size: playerSize)
        bluePurple.position = CGPoint(x: 400, y: 200 + fieldPosY)
        bluePurple.name = "blue_purple"
        bluePurple.zRotation = .pi / 2
        
        let fieldFrameLeftTexture = SKTexture(imageNamed: "field_frame_left")
        let fieldFrameLeft = SKSpriteNode(texture: fieldFrameLeftTexture)
        fieldFrameLeft.setScale(1.005)
        let fieldFrameRightTexture = SKTexture(imageNamed: "field_frame_right")
        let fieldFtameRight = SKSpriteNode(texture: fieldFrameRightTexture)
        fieldFtameRight.setScale(1.005)
        
        field.addChild(fieldFrameLeft)
        field.addChild(fieldFtameRight)
        addChild(field)
        addChild(gameCamera)
        addChild(cameraCapture)
        addChild(ball)
        addChild(yellowGreen)
        addChild(yellowPink)
        addChild(yellowPurple)
        addChild(blueGreen)
        addChild(bluePink)
        addChild(bluePurple)
    }
    
    func buildCard(card: inout SKSpriteNode!, cardName: String) {
        card = SKSpriteNode(texture: SKTexture(imageNamed: cardName))
        card.name = cardName
        card.position = CGPoint(x: 0, y: -1000)
        card.isHidden = true
        cards.addChild(card)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        let node = self.atPoint(location)
        let robotNames = [ "yellow_green",
                           "yellow_pink",
                           "yellow_purple",
                           "blue_green",
                           "blue_pink",
                           "blue_purple" ]
        
        if (robotNames.contains(node.name ?? "nil")) {
            let robot = node as! SKSpriteNode
            let card = cards.childNode(withName: robot.name! + "_card")
            if (card!.isHidden == true) {
                stopAllGlows()
                robot.glow(radius: robot.size.width)
                _ = cards.children.map { $0.isHidden = true }
                card!.isHidden = false
            } else {
                stopAllGlows()
                _ = cards.children.map { $0.isHidden = true }
                cards.childNode(withName: "first_card")?.isHidden = false
            }
        } else if (node.name == "ball") {
            let ball = node as! SKSpriteNode
            let card = cards.childNode(withName: "ball_card")
            if (card!.isHidden == true) {
                stopAllGlows()
                ball.glow(radius: ball.size.width)
                _ = cards.children.map { $0.isHidden = true }
                card!.isHidden = false
            } else {
                stopAllGlows()
                _ = cards.children.map { $0.isHidden = true }
                cards.childNode(withName: "first_card")?.isHidden = false
            }
        } else if (node.name == "camera") {
            let camera = node as! SKSpriteNode
            let card = cards.childNode(withName: "camera_card")
            if (card!.isHidden == true) {
                stopAllGlows()
                camera.glow(radius: camera.size.height)
                _ = cards.children.map { $0.isHidden = true }
                card!.isHidden = false
            } else {
                stopAllGlows()
                _ = cards.children.map { $0.isHidden = true }
                cards.childNode(withName: "first_card")?.isHidden = false
            }
        } else if (node.name == "vsss") {
            animateVsss()
        }
    }
    
    func animateVsss() {
        let scaleUpAction = SKAction.scale(to: 1.3, duration: 0.3)
        let scaleDownAction = SKAction.scale(to: 1.2, duration: 0.3)
        let actionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
        vsss.run(actionSequence)
    }
    
    func stopAllGlows() {
        let robotNames = [ "yellow_green",
                           "yellow_pink",
                           "yellow_purple",
                           "blue_green",
                           "blue_pink",
                           "blue_purple" ]
        
        for child in children {
            if robotNames.contains(child.name ?? "nil") {
                child.removeAllChildren()
            }
            if (child.name == "ball") {
                child.removeAllChildren()
            }
        }
        
        gameCamera.removeAllChildren()
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
}

