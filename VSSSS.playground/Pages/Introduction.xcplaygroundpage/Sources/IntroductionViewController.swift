import Foundation
import UIKit
import SpriteKit

public class IntroductionViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView(frame: CGRect(x: 0, y: 0, width: 768, height: UIScreen.main.bounds.height - 30))
        let scene = IntroductionScene(size: CGSize(width: 3000, height: 3000))
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        self.view = view
    }
}

