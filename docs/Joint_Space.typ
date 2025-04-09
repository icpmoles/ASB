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
  watermark: ""
)

From the first lab I understood that we needed a rectangle in workspace but then it turned out we needed it in joint/configuration space. 

We can do in two ways:
+ Sample the workspace, whenever we have an admissible configuration we save the joint configuration and plot it at the end. This solution re-uses the inverse kinematics code

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

= Simulink Implementation

Test of trajectory around the safety bounds.


#image("figures/simulink_jointbounds.png")

#image("figures/simulink_jointboundsParameters.png")

#image("figures/jointBoundsWorkspace.png")

(Plot of trajectory in workspace)

Once we set-up a safety bound we can decide what happens when it's crossed:

We can virtually saturate the control voltage to slow it down and let us intervene or we can directly stop the machine.

My proposal is to have a "tiered" safety system: 

- Inside the safe bounds we use the nominal voltage limits (10V amplitude) (0th zone)

- In a small area around it (10° ?) we reduce the voltage limits to slow it down. (1V or 2V amplitude ?) (1st zone)

- Outside this we just give 0V and have a safe shutdown for 1 (?) second to get some debug traces.  (2nd zone)

#image("figures/errorZones.png")

(safety bounds not for scale, we have to decide)

#image("figures/racetrack.png")
Imagine this as a racetrack where in the 0th zone you can drive freely, in the 1st zone you are slowed down for safety but you can still make it back, and the 2nd zone is a no-go.

== Low level safety systems.

Going forward we are going to complicate the Simulink scheme a lot so my proposal is to implement all the safety checks in one block that we are going to reuse every time we want to interface with the target plant.

#image("figures/controllerExample.png")

Example of a generic control scheme: the intrinsic safety measures don't clutter the high-level design.

All the interesting signals of the plant are muxed to be able to connect to the logger with a single cable. We can always add other signals from the controler with a muxer afterwards.

As a quick reference here is the index of all the signals.

#table(
  columns: (auto, auto, auto,auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [muxer id], [.mat row], [*Name*],[Unit],[Description]
  ),
  [1],[2],[ENC0 / Y0],[rad],[angular distance from rest position],
  [2],[3],[ENC1 / Y1],[rad],[angular distance from rest position],
  [3],[4],[U0],[V],[voltage requested by control law (copy of input signal)],
  [4],[5],[U1],[V],[voltage requested by control law (copy of input signal)],
  [5],[6],[U0_SAT],[V],[actual voltage provided to actuator after saturation (for anti-windup)],
  [6],[7],[U1_SAT],[V],[actual voltage provided to actuator after saturation (for anti-windup)],
  [7],[8],[EC0],[/],[Error code for joint 0],
  [8],[9],[EC1],[/],[Error code for joint 1],
)

#page(flipped: true,margin: 1cm)[

#image("figures/safetyscheme.png")

Schematics of the safety system.

Copy of the code in the function block:
```matlab
function y = test_bounds(u, upper_0, lower_0, upper_1, lower_1)
%  0 = everything ok , 1 = low voltage ,  2 = shutting down
if u<upper_0 && u>lower_0
    y = 0;
elseif u<upper_1 && u>lower_1
    y = 1;
else
    y = 2;
end
```
]



