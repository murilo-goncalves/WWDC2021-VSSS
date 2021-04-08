import Foundation
import SpriteKit

class Player: SKSpriteNode {
    let playerSize = CGSize(width: 80, height: 80)
    init(imageNamed: String, initialPosition: CGPoint) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: playerSize)
        self.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
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
