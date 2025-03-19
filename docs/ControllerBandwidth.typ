#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Controller Bandwidth Candidate",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

#let ob = [$omega_b$]
#set math.mat(delim: "[")
#set math.vec(delim: "[")
#let thetaa1 = [$theta_(a 1)$]
#let thetaa2 = [$theta_(a 2)$]
#let thetap1 = [$theta_(p 1)$]
#let thetap2 = [$theta_(p 2)$]

#let thetaa1d = [$dot(theta)_(a 1)$]
#let thetaa2d = [$dot(theta)_(a 2)$]
#let thetap1d = [$dot(theta)_(p 1)$]
#let thetap2d = [$dot(theta)_(p 2)$]

#let omrv = [$vec(thetap1d, thetap2d)$]
#let qv = [$vec(thetaa1d, thetaa2d)$]
#let Jr =[ $ mat(
  sin(thetap1),-sin(thetap2);
  cos(thetap1),-cos(thetap2);
) $ ]


#let Jq =[ $ mat(
  -sin(thetaa1),sin(thetaa2);
  -cos(thetaa1),cos(thetaa2);
) $ ]
// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

Background theory from "Modern Control Engineering Fifth Edition"

#image("figures/book1bw.png")
#image("figures/book2bw.png")


= The basic Idea

My proposal is to focus the Bandwidth  $ob$ specification on avoiding the non-linearities.

We know:
- The available joint space in radians.
- The voltage$arrow$angle transfer function $G_theta (j omega)$.
- The voltage limits of the power supply.

Suppose that we want to control the angular position with a sinusoidal reference bounded between $theta_(m a x)$ and $theta_(m i n)$. Ideally this signal would come from an Inverse Kinematics module upstream, which in turns is trying to follow a *continuos* shape in the cartesian workspace.

#image("figures/control_scheme_ik_fk.png")

Let's assume for now that the Inverse Kinematics module doesn't add higher order frequencies to the output signals. 

Let's assume that we want the Inverse Kinematics module to use the whole *"allowed joint space rectangle"* (AJSR from now on) and that we want the servo controller to be able to track whichever signal up to $ob$.

#image("figures/AJSR.jpg")

From all the analysis we know that the angular transfer function is $ G_theta ( j omega ) = 1 /s mu/ ( s tau +1) $

The bode plot of the gain is:

#image("figures/asympt_angle.png")

We can interpret this as: Given a voltage with amplitude $A_v$ and frequency $overline(omega)$, the shaft angle at steady state will oscillate with the same frequency and with an amplitude $ A_theta = A_v  |G_theta (j overline(omega))| $ 

We know that we have a limit on the voltage, so we are interested to know at which frequency the gain $|G_theta (j omega )|$ is not enough to cover the whole AJSR amplitude. From the graph is easy to see how this happens at higher frequency.

= Implementation

Let's focus on Motor 0, but this argument can extended on Motor 1 without loss of generality.

Motor0 can move from -17° to +31°, so a sinusoidal angular movement should cover in total $theta_(p p) = 48° = 0.83 "rad"$

Both motors can be driven up to ±10V for "short periods" of time which translates in $V_(p p ) = 20V$

The minimum gain (at the maximum frequency) is

$ |G_theta^min (j omega_(max) )| = 0.83/20 = 0.0419 = -27.5582 "dB" $

Let's plot the bode gain and see where it crosses -27dB:

#image("figures/saturation_crossing.png")


It happens at around *26rad/s.*

= Controller synthesys and verification

I designed a simple PD controller with MATLAB's PIDTUNE():

#image("figures/pidSaturationMethod.png", width: 65%)

$ cases("Kp" = -21.4 \ "Kd" = -0.43) $

Then with a simple SIMULINK scheme I tested if it was able to follow a sinusoidal angle reference without hitting the saturation limits:

#image("figures/scheme_sim_saturation.png")

Test at 26 rad/s, amplitude = $theta_ ("pp")/2 =  0.4189 "rad"$

#image("figures/19marchangles.png", width: 85%)

#image("figures/19marchvoltages.png", width: 85%)


It almost follows the angle trajectory in its full range with some saturation (see blue line in the second graph).

This is due to the fact that at 26rad/s we are already at -3dB (70%) in terms gain.

= Comments

== It feels a little bit too slow

The group of the previous year used 30rad/s as the tuning bandwidth if I recall correctly, this is not too slow if compared to them and it's from a "rigorous" analysis.

== 70° of phase margin comes from?

It's the standard phase margin of the automation course. Too high means increased controller effort (more voltage, more saturation), too low and the system oscillates in case of step response (we may overshoot the AJSR).

We can increase the phase margin but at the cost of bandwidth (design decision, let's what happens in the lab).

== What to do in the lab

Implement PD controller, check if we have saturations when trying with the AJSR at 26rad/s.




