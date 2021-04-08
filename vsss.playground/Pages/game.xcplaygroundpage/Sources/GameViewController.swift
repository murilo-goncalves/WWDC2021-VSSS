import Foundation
import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView(frame: CGRect(x: 0, y: 0, width: 650, height: 640))
        let scene = GameScene(size: CGSize(width: 2500, height: 2500))
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        self.view = view
    }
}
