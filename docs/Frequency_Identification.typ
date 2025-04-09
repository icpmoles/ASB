#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Frequency identification",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)

== Quick Glossary

In a first order system:

- $tau = J/beta $ = Time constant (s) = "Projection" of the slope at t=0 due to a step response

  #image("figures/RC_response.png",width: 70%)

- $P$ = Pole (rad/s) = $1 / tau = beta/J $ $approx$ frequency at which the effect of the "inertia" component overcomes the effect of the "damping" component 

#image("figures/LTI1st.png")

= Recap of previous episodes

From the step response we found an estimate for the time constant:

#image("figures/moto0tauandPfromStep.png")
#image("figures/moto1tauandPfromStep.png")

Then from the frequency response we saw that the pole was actually higher.

Why did it happen? Probably non-linearities at low voltage/speed compounded with the intrinsic limitations of sampling/quantization.
(The error was around 10ms, which is almost 5 time samples.)


= LAB3 results

#image("figures/freqIdMot0.png")
#image("figures/freqIdMot1.png")

N.b.: at 24 rad/s we have around 2.5° of angular resolution, 
while at 90 rad/s we have around 10° 

New estimated models:


#table(
  columns: (1fr, 1fr ,1fr),
  inset: 10pt,
table.header(
    [], [*Motor 0*], [*Motor 1*],
  ),
  [ $mu$ (DC Gain) #FillCell [$"rad"/s 1/V$]],[-1.4479],[-1.4684],
  [ $tau$ (Time constant) #FillCell [s]],[0.0401],[0.0409],
  [ $1/tau$ (Pole )#FillCell [rad/s]],[24.9218],[24.4398],
)




= Verification (kind-of)

At the start of Lab3 we ran some experiments with a PD tuned on a "wrong" model. As expected the step responses were off compared to the simulations.

#image("figures/PD_wrong_design.png")

But what if we are able it into useful insights?
After all we know the PD parameters, and we have a (hopefully) better estimate of our motors:

#image("figures/PD_real_half.png")


#image("figures/PD_lab3_verif_no_sat.png")

Aaaaand the results still don't match.

But wait, we forgot to account for saturations!

#image("figures/PD_real_full.png")


#image("figures/PD_lab3_verif_w_sat.png")

The results are so much better, right?

#image("figures/PD_lab3_verif_w_sat_zoom.png")


(Ignore the static error due to the deadzone on the right)