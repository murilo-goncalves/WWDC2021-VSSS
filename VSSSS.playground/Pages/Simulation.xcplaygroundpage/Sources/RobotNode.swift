import Foundation
import SpriteKit

// code snippet from: https://stackoverflow.com/questions/31421912/rotate-an-object-in-its-direction-of-motion
extension CGVector {
    func speed() -> CGFloat {
        return sqrt(dx*dx+dy*dy)
    }
    func angle() -> CGFloat {
        return atan2(dy, dx)
    }
}

public class RobotNode: SKSpriteNode {
    let playerSize = CGSize(width: 75, height: 75)
    let team: team
    
    public init(imageNamed: String, _ team: team) {
        self.team = team
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: playerSize)
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.friction = 2
        physicsBody?.angularDamping = 2
        self.physicsBody?.mass = 3
        self.physicsBody?.categoryBitMask = Masks.Player
        self.physicsBody?.contactTestBitMask = 0

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
        let xLimit: CGFloat = 620
        let yLimit: CGFloat = 500
        let myPhysicsBody = self.physicsBody
        self.physicsBody = nil
        
        if (team == .yellow) {
            self.position = CGPoint(x: -xLimit, y: 0)
            xRange = SKRange(constantValue: -xLimit)
            yRange = SKRange(lowerLimit: -yLimit  , upperLimit: yLimit)

        } else {
            self.position = CGPoint(x: xLimit, y: 0)
            xRange = SKRange(constantValue: xLimit)
            yRange = SKRange(lowerLimit: -yLimit, upperLimit: yLimit)
        }
        
        self.physicsBody = myPhysicsBody
        
        // set goalkeeper area of action
        let lockToGoal = SKConstraint.positionX(xRange, y: yRange)
        self.constraints = [ lockToGoal ]
    }
    
    public func runGoalkeeper(ballPosition: CGPoint, speed: CGFloat) {
        let x = position.x
        let y = position.y
        let bx = ballPosition.x
        let by = ballPosition.y
        let baseSpeed: CGFloat = 300

        // goalkeeper follows ball y coordinates if not rotating
        let yDist = by - y
        let velocity = (yDist > 0) ? yDist * speed + baseSpeed : yDist * speed - baseSpeed
        self.physicsBody?.velocity.dx = 0
        self.physicsBody?.velocity.dy = (self.physicsBody?.angularVelocity == 0) ? velocity : 0
        
        // if abs distance of ball is too close, kick
        let dist = sqrt(pow(bx - x, 2) + pow(by - y, 2))
        var clockwise: Bool = (by > y) ? false : true
        if (dist < 70) {
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
            self.zRotation = (self.physicsBody?.velocity.angle())! - CGFloat.pi / 2
        }
    }
    
    public func attacker(isTop: Bool) {
        let x: CGFloat = (team == .yellow) ? -300 : 300
        let y: CGFloat = isTop ? 200 : -200
        let myPhysicsBody = self.physicsBody
        self.physicsBody = nil
        self.zRotation = (team == .yellow) ? -.pi / 2 : .pi / 2
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = myPhysicsBody
    }
    
    public func runAttacker(ballPosition: CGPoint, speed: CGFloat, isTop: Bool) {
        let x = self.position.x
        let y = self.position.y
        let bx = ballPosition.x
        let by = ballPosition.y
        let dist = sqrt(pow(bx - x, 2) + pow(by - y, 2))
        let kickSpeed: CGFloat = 40
        let friedlyArea: CGFloat = 500
        let distToKick: CGFloat = 75
        
        // second attacker waits for ball on the other side of field
        if ((isTop && ballPosition.y <= 0) || (!isTop && ballPosition.y > 0)) {
            follow(speed: speed, target: CGPoint(x: ballPosition.x, y: isTop ? 200 : -200))
        }
        else if (team == .yellow) {
                if (dist < distToKick) {
                    if (x < bx - 30) {
                        kick(clockwise: by < 0, speed: kickSpeed)
                    }
                }
                if (bx < -friedlyArea) { // attacker don't enter frindly penalty area
                    follow(speed: 200, target: CGPoint(x: -300, y: 0))
                } else {
                    follow(speed: speed + dist/2, target: ballPosition)
                }
            } else { // team is blue
                if (dist < distToKick) {
                    if (x > bx + 30) {
                        kick(clockwise: by > 0, speed: kickSpeed)
                    }
                }
                if (bx > friedlyArea) {
                    follow(speed: 200, target: CGPoint(x: 300, y: 0))
                } else {
                    follow(speed: speed + dist/2, target: ballPosition)
                }
            }
        }
}

public enum team {
    case yellow
    case blue
}
