#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Sensitivity",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)


This is the scheme we used in LAB4:

#image("figures/control_loop_GO4.png")

We ran mainly two types of experiments: reference following and disturbance rejection.

= Reference following

#image("figures/control_loop_CTF.png")

We are seeing "how good is our control loop at following a reference signal". This is described in frequency by the *_COMPLEMENTARY SENSITIVITY TRANSFER FUNCTION T(S)_*:

$ C(s)^"PD"_"ideal" = P + D s = P(s P/D +1) = P (s T +1) $

With $T = P/D$ = time constant of our controller.

$ G(s) = mu / (s (tau s +1 )) $

$ L(s)=C(s) G(s) = (P mu (s T +1))/ (s (tau s +1 )) = N(s)/D(s) $

$ T(s) = L(s)/(1+L(s))= (N(s)/D(s))/(1+N(s)/D(s)) = N(s) / (D(s)+N(s)) = \ =
(P mu (s T +1)) / ( s (tau s +1 ) + P mu (s T +1)) = 
(P mu (s T +1)) / (s^2 tau + s(P mu T +1) + P mu)
$


We expect two poles (P1&P2) and one zero (Z).

The  static gain is: $T(0) = (P mu) / (P mu) = 1$ (Thanks to the integrator from the motor!)

The asymptotic graph has the following shape:
#image("figures/complementarytransfunction_asympt.png")


In MATLAB, using the plant and controller we get:
#image("figures/complementarytransfunction.png")

_(There is a bump, trust me)_

If you remember the reference tracking experiment we had a good tracking at "low" frequency, some overshoot at medium and undershoot at high.

#nb(title:"TODO",[
- Analyze the frequency response from the experiment

- It matches in shape, but will it also overlap in value???


])

= Input Sensitivity Function

#image("figures/control_loop_DSF.png")

Sometimes called *LOAD DISTURBANCE SENSITIVITY FUNCTION*, it describes how good is our system at dealing with disturbance in the load. It's the only "replicable" experiment that we can do so we have to do it.


$ S_i (s) = G(s) / (1+L(s)) = 

 mu / (s (tau s +1 )) / (1 + (P mu (s T +1))/ (s (tau s +1 )) ) =
 mu / (s (tau s +1 ) + P mu (s T +1) ) =
 mu / (s^2 tau + s(P mu T +1) + P mu) 
$

The denominator is the same as $T(s)$ so we have the same poles, and no zeroes.

The  static gain is: $S_i (0) = ( mu) / (P mu) = 1/P $ 

#image("figures/loadsensisivity_asympt.png")
#image("figures/loadsensisivity_matlab.png")

We can see that at "low" frequency the attenuation mainly comes from the proportional gain.

Assuming to have a "step": $(A times "step"(t) arrow A/s)$ as the disturbance, the final effect on the output is given by the final value theorem:

$ y_infinity^"step" = lim_(s arrow 0) s A/s S_i (s) = 
 A S_i (0) = A P
$


#nb(title:"TODO",[
- Check if it's consistent with the "fixed bias" experiments

- Write some conclusions: this feels like a "bad" disturbance rejection, is it a worthy trade-off for not using an integrator? 
])

