//: [Previous](@previous)

import PlaygroundSupport

PlaygroundPage.current.setLiveView(GameViewController())


/*:
 
 ### Welcome to VSSS Simulator, or VSSSS! 🐍
 
 Here you can play with a VSSS game simulation! Use the **mouse click** to set ball position and **mouse dragging** to apply impulse to the ball when the simulation is running.
 
 - - -

 The goalkeeper strategy is pretty simple: it follows the ball's *y* coordinate and kicks the ball if it gets too close. The kick is a clockwise or counterclockwise rotation, depending on the goalkeeper's team color and the ball's *y* position relative to the goalkeeper's *y* position.

 - - -
 
 The attackers' strategies are just as simple!
 The one at the ball's sector (either top or bottom) follows the ball and kicks if its *x* coordinate is "behind" the ball, depending on the attacker's team color. Besides, if the ball is inside the attacker's team penalty area, the attacker won't follow the ball and will slowly move away, to avoid own goals and give the goalkeeper space to kick.

 */

