#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Joint Space",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

From the first lab I understood that we needed a rectangle in workspace but then it turned out we needed it in joint/configuration space. 

We can do in two ways:
+ Sample the workspace, whenever we have an admissible configuration we save the joint configuration and plot it at the end. With his solution re-uses the inverse kinematics code
+ Sample the joint space, if the direct kinematics is admissible with respect to some criteria save the pose, plot it at the end.

With #1 it's possible to save some time thanks to the code re-use but an uniform sampling in workspace doesn't translate well in joint space, leading to some artifacts that require a more fine-spaced sampling with more cumbersome calculations.

With #2 we need to write the direct kinematics function but the end result is more efficient.

= Direct Kinematics

Let's start with a generic configuration of our active joints:

#image("figures/freeLinks.png")

If the configuration *admits a solution* it will have up to two possible passive joints configurations.

#image("figures/greenAndRed.png")

In our case we are only interested in the "green".

To differentiate the two possible solutions we draw a line between the two passive joints (yellow line).
The middle point is our point C. The distance between C and E (call it $h$) is trivially calculated with the Pythagorean theorem.

By starting from C we add a vector of size $h$ and direction orthogonal counter-clockwise to $P_2-P_1$

#image("figures/directKinPositive.png")

By knowing the end-effector pose we can retrieve the passive joints configuration.

= Singularity crossings
We demonstrated how to solve the forward kinematics in the first case.

#image("figures/JointSingCrossing.png",width: 60%)

But if we apply this algorithm in the third case we'll end up with the red dot instead of the green dot.

Is it really a problem?

 If you think about it, going from the green configuration in the first case to the green configuration in the third case is impossible because you have to cross a singularity. 
The same happens if you want to go from the green first case to the red third case. (hint: you have to align the two right links to reach the left border of the *vesica piscis* found in the workspace singularity analysis).

#image("figures/vesica.png",width: 70%)

#image("figures/velocity_singularities_27022025.png",width: 50%)

Our focus now should be to detect the third case and categorize it as an inadmissible configuration.

== Invariants

#image("figures/jointsFirstThird.png",width: 80%)

In the third case the direct kinematics algorithm finds the red configuration instead of the green configuration.

What's the difference between them?

*First case*

$theta_(p 1)$ is counter-clockwise to $theta_(a 1)$

$theta_(p 2)$ is counter-clockwise to $theta_(a 2)$

*Second case*

$theta_(p 1)$ is counter-clockwise to $theta_(a 1)$

$theta_(p 2)$ is #underline("clockwise") to $theta_(a 2)$


=== Why does it happen?

To pass between those two configurations you need to fully extend the links of one side to reach the "vesica piscis" border. In this configuration on one side (either left or right) you have the active and passive joints perfectly aligned. From there you "invert" the the relative rotation and you can reach the red configuration.

You can see the external borders of the workspace like some sort of "portal" that allows you to switch between the two possible direct kinematics.

= Algorithm

#pseudocode-list[
  + for every sampled ($theta_"a1", theta_"a2"$) in joint space
    + calculate position of $P_1$ and $P_2$
    + *if* distance($P_1$,$P_2$) < 2L *then*
      + $x, y , theta_(p i) arrow.l $ directKinematics($theta_"a1", theta_"a2"$)
      + *if* counter-clockwise_check() is true *then*
        + return *Pose* = ($x, y , theta_(p i)$)
      + *else*
        + return *RedConfigurationError*
      + *end*
    + *else*
      + return *DistanceError*
    + *end*
  + *end*
]

= Result

#image("figures/jointSpace.png")

X-axis = $theta_(a 1)$, Y-axis = $theta_(a 2)$ in radians

Blue = admissible

Red = you have to cross a singularity to reach it.

Orange = you have to break the links to reach it.

Zooming in we can pick the joint bounds

I settled on:

 $theta_(a 1)$ = [-20° , 17 °] = [-0.36rad , 0.314rad]

$theta_(a 2)$ = [ 68° , 122 °] = [1.204rad , 2.14rad]
#image("figures/jointBounds.png")

