import Foundation
import SpriteKit

class ButtonNode: SKNode {
    var sprite: SKSpriteNode?
    var action: (() -> Void)?
    
    init(sprite: SKSpriteNode, action: @escaping () -> Void) {
        self.sprite = sprite
        self.action = action
        super.init()
        self.isUserInteractionEnabled = true
        
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action?()
    }
}
