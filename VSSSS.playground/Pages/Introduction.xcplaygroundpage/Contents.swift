/*:
 - Note:
 For optimal experience, run this playground in full screen and close the Debug Area!
 
 - - -
# What's VSSS?
 
 ![Real life VSSS match](real_life.png "Real life VSSS match")
 
Hey there WWDC! Today I’m going to talk about a fairly unknown robotics competition: the IEEE Very Small Size Soccer, or VSSS! ⚽️🤖

The ideia behind this category is to build a fully functional 🧠 **autonomous** 🧠 soccer team with three small robots.
 
In order to achieve that, besides the robots themselves, teams have to use a camera and a computer. The camera records the game in real time and transfers each frame image to the team's computer, which will do all the image processing and computer vision 👁 necessary to send movement information to the robots’ motors.
 
Beyond the robotics control and computer vision, that are already a challenge, the real fun part of this category is to come up with strong and clever 💡 strategies, that range from simple conditional movement (as shown in the next page) to artificial potential fields and machine learning algorithms!
 
As an entry robotics category, the VSSS is a powerful incentive for those starting in the robotics and AI fields. It's an affordable project and anyone with few resources can start to build a team!
 
 
You can learn more about VSSS and the VSS League on this external [website](https://ieeevss.github.io/vss/index_ptbr.html).


 - - -
[Go to simulation](@next)
 - - - 
 */


import PlaygroundSupport

PlaygroundPage.current.setLiveView(IntroductionViewController())
