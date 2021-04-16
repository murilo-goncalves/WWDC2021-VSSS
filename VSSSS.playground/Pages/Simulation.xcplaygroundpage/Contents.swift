/*: [Introduction](@previous)
 
 - - -
 - Note:
  If the simulation doesn't start automaticaly and keep stuck at "Running...", you can stop and run again the playground page. This issue is discussed in this Apple Developer Forum [post](https://developer.apple.com/forums/thread/101346?page=1).
 - - -
 
 ## Welcome to the VSSS Simulator, or VSSSS! 🐍
 
 Here you can play with a VSSS game simulation! Use the **mouse click** to set ball position and **mouse dragging** to apply impulse to the ball when the simulation is running.
 
 - Note:
  You can pause, reposition the ball and run the game again to see how the robots will respond.
 
 - Note:
  Those little guys may get stuck on the wall, which would cause a referee intervention in real life, you can act like one and reposition the ball!

 - - -

 ### Goalkeeper
 The goalkeeper strategy is pretty simple: it follows the ball's *y* coordinate and kicks if the ball gets too close. The kick is a clockwise or counterclockwise rotation, depending on the goalkeeper's team color and the ball's *y* position relative to the goalkeeper's *y* position.

 - - -
 
 ### Attackers
 The attackers' strategies are just as simple!
 The one at the *ball's sector* (either top or bottom) follows the ball and kicks if its *x* coordinate is "behind" the ball, depending on the attacker's team color. Besides, if the ball is inside the attacker's team penalty area, the attacker won't follow the ball and will slowly move away, to avoid own goals and give the goalkeeper space to kick.
 
 The one at the *opposite sector* follows the ball's *x* coordinate and waits for the rebound.
 */


import PlaygroundSupport

PlaygroundPage.current.setLiveView(SimulationViewController())


