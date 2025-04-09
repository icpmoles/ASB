#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Friction",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)


= Static Friction
We saw that we have a small "stiction" effect at the start. We can estimate it by feeding a slow ramp of voltage and recording the value at which the "detach" occours:

The zero velocity torque ("locked rotor") is given by:

$ T =  k_e i \ i = V/R_a \ T = V k_e / R_a $


#grid(
  columns: (1fr, 1fr),
image("figures/deadzone1.png"),
image("figures/deadzone2.png"),
image("figures/deadzone3.png"),
table(
   columns: (1fr, 1fr, 1fr),
   [],[Mot 0],[Mot 1],
   [V+],[6.8E-0.4],[N/A],
   [V-],[4.2E-0.4],[4.6E-0.4],
)
)

You can see how the static friction torque is not "stable" even in the same motor.

#image("figures/qualitative_friction_m0.png")

#image("figures/qualitative_friction_m1.png")


= Non Linear Friction 
Taken from: _Control of Machines with Friction (B Armstrong-Hélouvry)_

Quick overview of what real friction looks like: the #text(fill:rgb(255, 27, 255))["viscous law"] $T_f = beta  omega$ is an approximation that only works at high velocities (when the light-blue line asymptotically approaches the purple line)

#image("figures/armstrong_control_w_friction.png")

At zero/low velocities we have huge non-linearity that creates a loss of precision during position control:


#image("figures/static_error_overview.png")

#image("figures/static_error.png")

It's possible to see how this non-linearity shows up at low voltage -> low error -> near the set point.

(Error) e = 0.127° = 2.21E-3 rad

With Kp = -21.4 and low velocity ($dot(e) approx 0$)

$ u = e K_p = 0.04 V $<frictionCondition>  $0.04 V << 0.15 V $ needed for detach. (see graphs at the start)

= Conclusions

- Friction is bad

#pagebreak(to:none)

= Countermeasures

== Add an Integrator

From PD to PID:

Good:

- Integrators help with "low frequency" disturbances and you can model friction as a disturbance.

Bad:

- It goes against our specifications (we have already enough integrators in our loop)

- Hunting ($approx$ Wind-up in reverse): the integrator accumulates error and is able to overcome the stiction, but now it has to deplete this internal energy so it overshoots. Rinse and repeat

  #image("figures/PIDHunting.png")


 - Solution (?) PID reset: as soon as you reach the set point, just reset the integrator. Supported in a lot of PID and in Simulink.

      #image("figures/PIDReset.png")

== Increase the Kp

From @frictionCondition we can see that if Kp is high enough we can get rid of this problem:

Our desired "max error" is given by the precision of the encoder

$ theta_("err max") = (2 pi) / 4096 = 1.533 times 10^(-3) "rad" $

Let's take a "deadzone voltage" of around 0.3V (highest measurment x 150% as a safety margin)

$ |K_(p,"min")| = u_(d z) / theta_("err max") = 195 $

Good:

- It should just work...

Bad:

- ...as long as you don't care about the controller specifications (Bandwidth, moderation, stability!)

  - It's basically asking for 10 times the previous bandwidth!

Solutions:

- Redesign the PD controller with a fixed Kp and Bandwidth by moving the Derivator's zero/poles.
- If someone is familiar with H∞ this looks like an appropriate situation for Loop Shaping.

== Friction Compensation

*If* we have a reliable model of the friction then we can just invert it, do a table lookup with the speed and use it as a feedforward compensator.

Good:

- We place it, it works, we forget about it. All the design in frequency, state-space, whatever can be done with a linear model in mind.

Bad:

- We need a *really good model* of the friction. All errors in modelling will be amplified (chattering or instability)

== Dithering

Feed a high frequency signal at low velocity, it helps overcoming the stiction effects.

Good:

- We place it, it works, we forget about it. All the design in frequency, state-space, whatever can be done with a linear model in mind.

Bad:

- Mechanical models don't like high frequency disturbances (wear of components, vibrations etc etc etc). We also have a lot of gears which may "damp" this signal and end up with only a partial solution of the problem.
