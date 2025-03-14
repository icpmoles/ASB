#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Lab 1 & 2: what to do now?",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

= Parameter estimation via step response

#let Goml = [$G_(omega l)$]

#let Gtl = [$G_(theta l)$]


We know that the transfer function from voltage to angular speed on the load shaft has the form:

$ Goml (s) = k / (s tau + 1) $

The angle measured by the encoder is a simple integrator:
$ Gtl (s) = 1/s k / (s tau + 1) $<angleLaw>

From the bump test we estimated both $tau$ (time constant) and $k$ (DC gain).

The parameters are somewhat consistent on both motors at various voltages so let's just do an average.

(The code calculates $k$ in modulo but we know the gain is negative)

$ k_0 = -1.51 \ tau_0 = 0.0504 $

#image("figures/motor0dc.png",width: 50%)
#image("figures/motor0tau.png",width: 50%)

$ k_1 = -1.65 \ tau_1 = 0.055 $

#image("figures/motor1dc.png",width: 50%)
#image("figures/motor1tau.png",width: 50%)

== Comments

The time constants are pretty consistent with the estimates from the datasheet.

The DC gain is instead wayyyyyy off, almost 4 order of magnitudes off.

My hypothesis is that in the time constant what matters is the Coulomb friction, after all we are at "zero relative velocity", instead at steady state we have to deal with the normal viscous friction and this results in a decreasing friction for high speeds.

 #image("figures/frictionModels.png",width: 80%)
Image from "Artificial Intelligent Based Friction Modelling and Compensation in Motion Control System"

 #image("figures/betaoveromega.png",width: 70%)
 #image("figures/betaoveromega2.png",width: 70%)

So the datasheet overestimates the friction coefficient because it provides the "static friction" while the DC gain actually needs the "dynamic friction"


= Validation

We expected these shapes for the frequency response

#image("figures/bodetheta.png")
#image("figures/bodeomega.png")