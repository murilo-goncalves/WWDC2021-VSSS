import Foundation
import SpriteKit

public class ButtonNode: SKNode {
    var sprite: SKSpriteNode?
    var action: (() -> Void)?
    
    public init(sprite: SKSpriteNode, action: @escaping () -> Void) {
        self.sprite = sprite
        self.action = action
        super.init()
        self.isUserInteractionEnabled = true
        
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action?()
    }
    
    func animateVsss() {
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.3)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
        let actionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
        self.run(actionSequence)
    }
}
