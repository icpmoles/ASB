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
  watermark: "NOT FINAL"
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