import Foundation
import SpriteKit

// code snnipet copied from https://stackoverflow.com/questions/31421912/rotate-an-object-in-its-direction-of-motion
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
        self.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        self.physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.friction = 2
        self.position = initialPosition
    }
        
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // util func to convert radians to degrees
    func radToDeg(_ rad: CGFloat) -> CGFloat {
        return (rad * CGFloat(180) / CGFloat(Double.pi))
    }
    
        
    // --> GOALKEEPER
    
    // spin to kick the ball, depending on the side of it relative to goalkeeper
    func kick(clockwise: Bool) {
        var radAngle = CGFloat(180) * .pi / 180
        radAngle = clockwise ? radAngle : -radAngle
        let rotate = SKAction.rotate(byAngle: radAngle, duration: 0.5)
        run(rotate)
    }
    
    public func goalkeeper(ballPosition: CGPoint, speed: CGFloat) {
        let xRange: SKRange
        let yRange: SKRange
        let x = position.x
        let y = position.y
        let bx = ballPosition.x
        let by = ballPosition.y
        let xLimit: CGFloat = 610
        let yLimit: CGFloat = 400
        
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
        self.physicsBody?.allowsRotation = false
        self.constraints = [ lockToGoal ]

        // goalkeeper follows ball y coordinates
        let yDist = by - y
        self.physicsBody?.velocity.dx = 0
        self.physicsBody?.velocity.dy = speed * yDist
        
        // if abs distance of ball is too close, kick
        let dist = sqrt(pow(bx - x, 2) + pow(by - y, 2))
        let clockwise = (by > y) ? false : true
        if (dist < 75) {
            kick(clockwise: clockwise)
        } else {
            physicsBody?.angularVelocity = 0
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
        let dist = sqrt(pow(ballPosition.x - position.x, 2) + pow(ballPosition.y - position.y, 2))
        follow(speed: speed, target: ballPosition)
    }
    
}

public enum team {
    case yellow
    case blue
}
