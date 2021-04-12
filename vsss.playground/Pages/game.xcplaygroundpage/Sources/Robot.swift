import Foundation
import SpriteKit

// code snnipet from https://stackoverflow.com/questions/31421912/rotate-an-object-in-its-direction-of-motion
extension CGVector {
    func speed() -> CGFloat {
        return sqrt(dx*dx+dy*dy)
    }
    func angle() -> CGFloat {
        return atan2(dy, dx)
    }
}

public class Robot: SKSpriteNode {
    let playerSize = CGSize(width: 80, height: 80)
    let team: team
    
    public init(imageNamed: String, initialPosition: CGPoint, _ team: team) {
        self.team = team
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: playerSize)
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.friction = 2
        self.physicsBody?.mass = 10
        self.physicsBody?.categoryBitMask = Masks.Player
        self.physicsBody?.contactTestBitMask = 0
        self.position = initialPosition
    }
        
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    // --> GOALKEEPER
    
    // spin to kick the ball, depending on the side of it relative to goalkeeper
    func kick(clockwise: Bool, speed: CGFloat) {
        let velocity = clockwise ? speed : -speed
        physicsBody?.angularVelocity = velocity
    }
    
    public func goalkeeper() {
        let xRange: SKRange
        let yRange: SKRange
        let xLimit: CGFloat = 610
        let yLimit: CGFloat = 270
        physicsBody?.angularDamping = 2
        
        if (team == .yellow) {
            self.position = CGPoint(x: -xLimit, y: 0)
            xRange = SKRange(constantValue: -xLimit)
            yRange = SKRange(lowerLimit: -yLimit  , upperLimit: yLimit)

        } else {
            self.position = CGPoint(x: xLimit, y: 0)
            xRange = SKRange(constantValue: xLimit)
            yRange = SKRange(lowerLimit: -yLimit, upperLimit: yLimit)
        }
        
        // set goalkeeper area of action
        let lockToGoal = SKConstraint.positionX(xRange, y: yRange)
        self.constraints = [ lockToGoal ]
    }
    
    public func runGoalkeeper(ballPosition: CGPoint, speed: CGFloat) {
        let x = position.x
        let y = position.y
        let bx = ballPosition.x
        let by = ballPosition.y

        // goalkeeper follows ball y coordinates if not rotating
        let yDist = by - y
        let velocity = (yDist > 0) ? yDist * speed + 250 : yDist * speed - 250
        self.physicsBody?.velocity.dx = 0
        self.physicsBody?.velocity.dy = (self.physicsBody?.angularVelocity == 0) ? velocity : 0
        
        // if abs distance of ball is too close, kick
        let dist = sqrt(pow(bx - x, 2) + pow(by - y, 2))
        var clockwise: Bool = (by > y) ? false : true
        if (dist < 75) {
            clockwise = (team == .yellow) ? clockwise : !clockwise
            kick(clockwise: clockwise, speed: 40)
        } else {
            if (physicsBody!.angularVelocity > -10 && physicsBody!.angularVelocity < 10) {
                let delta: CGFloat = 0.05
                if ((zRotation > -delta && zRotation < delta)  ||
                    (zRotation > (CGFloat.pi - delta) && zRotation < (CGFloat.pi + delta)) ||
                    (zRotation > (-CGFloat.pi - delta) && zRotation < (-CGFloat.pi + delta))) {
                    physicsBody?.angularVelocity = 0                    
                }
            }
        }
    }

    
    // --> ATTACKER
    
    func follow(speed: CGFloat, target: CGPoint) {
        // foward motion
        let radAngle = atan2(target.y - position.y, target.x - position.x)
        self.physicsBody?.velocity = CGVector(dx: speed * cos(radAngle), dy: speed * sin(radAngle))
        
        // rotate motion
        if ((self.physicsBody?.velocity.speed())! > 0.01) {
            self.zRotation = (self.physicsBody?.velocity.angle())! + CGFloat.pi / 2
        }
    }
    
    func kickToGoal(speed: CGFloat) {
        let goalPositionX = (team == .yellow) ? 650 : -650
        follow(speed: speed, target: CGPoint(x: goalPositionX, y: 0))
    }

    public func attacker(ballPosition: CGPoint, speed: CGFloat) {
        let y = self.position.y
        let by = ballPosition.y
        let dist = sqrt(pow(ballPosition.x - position.x, 2) + pow(by - y, 2))
        follow(speed: speed + dist/2, target: ballPosition)
    }
    
}

public enum team {
    case yellow
    case blue
}
