#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Lab 5: emergency plan",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)


= What's the problem? 


#image("figures/lab4/T_exp_mot0.png")
#image("figures/lab4/T_exp_mot1.png")
#image("figures/lab4/T_wrong_alone.png")


We have a discrepancy in the gain for the complementary sensitivity function. This discrepancy is compatible with an underestimate of $mu$ in the model:

$ G (s) = mu / s(tau s + 1) $

Possible causes:

-  #underline[wrong estimation in the previous steps:] we are only humans and it's the first time for all of us. But until now all the experiments agreed on the previous identified parameters.

-  #underline[the model is not *time invariant*:] we know that $mu$ if function of the electric constant $K_e$ and friction coefficient $beta$:

#let tm = [$theta_m$]
#let tl = [$theta_l$]

Kirkoff:

$ V = R_a I_a + s L_a  I_a +E =  R_a I_a + s L_a I_a + s tm k_e \

I_a = (V-s tm k_e )/(s L_a + R_a)
$

From the force balance equation on the motor spindle:

$  s J_m^2 tm + beta s tm =T = k_e I_a \

s tm (s J_m  + beta ) = k_e (V-s tm k_e )/(s L_a + R_a) \

s tm (s L_a + R_a)(s J_m  + beta ) = k_e V- s tm k_e^2 \

k_e V = k_e^2 s tm +  s tm (s L_a + R_a)(s J_m  + beta )\

k_e V =   s tm [(s L_a + R_a)(s J_m  + beta ) +k_e^2]
$

Convert this in transfer function form:
$ G_m (s) = tm / V = 
(1/s)  k_e / ((s L_a + R_a)(s J_m  + beta ) +k_e^2)
$

$L_a$ is almost zero so we can approximate it as:


#let betinv = [$R_a/(R_a beta +k_e^2)$]
$ G_m (s) approx
(1/s) k_e / (R_a (s J_m  + beta ) +k_e^2) =

(1/s)  k_e/R_a / (s J_m  + beta  +k_e^2/R_a) =

(1/s)  k_e/R_a / (s J_m  + (R_a beta +k_e^2)/R_a) =\ =


(1/s)  ( k_e/R_a betinv) / (s J_m betinv  + 1) = 

(1/s)  ( k_e /(R_a beta +k_e^2) ) / (s (J_m R_a)/(R_a beta +k_e^2)  + 1) = 
(1/s) mu_m / (s tau +1)
$

with $mu_m = k_e /(R_a beta +k_e^2) $ and $tau=(J_m R_a)/(R_a beta +k_e^2)$

Converting on the load spindle (what we use by default in all the calculation) is just dividing the DC gain by r=70. The time constant is the same.

$ G (s) = mu / s(tau s + 1) $

with $mu = 1/r k_e /(R_a beta +k_e^2) $ and $tau=(J_m R_a)/(R_a beta +k_e^2)$


From the experiments we know that $beta$ is not fixed, it changes depending on the velocity due to the non-linearity of friction:

#image("figures/betaoveromega.png")

We should also remember that the openloop tests were done with a sinusoidal signal of amplitude 1V, while the closed loop reference following was done with up to 5V of amplitude at certain frequencies.

Higher voltage $arrow$ higher speed $arrow$ lower $beta arrow$ higher $mu arrow$ "Bump" in performance at higher frequencies, the T(s) doesn't fall as fast as predicted.

For now this is just an hypotheses, but maybe we can test it:

== Beta test

Let's redo the trajectory following at various frequencies but this time instead of an amplitude of 10° let's use lower and higher values. In theory the system should "return" to the open-loop parameters and give us the theoretical T(s).

#image("figures/lab4/T_wrong_multi.png")


If the system displays different frequencies characteristics then we can conclude that the discrepancy is caused by the friction non-linearity. Otherwise we are back to square one in terms of schedule.

#image("figures/schedule_issue.png")

= Other issues

Unfortunately due to a bug in my scheme we had the saturation engaged for all the disturbance tests. So we may need to repeat them, focusing only on a more sparse set of frequencies (e.g jumps of 3rad/s) to catch up faster. After all we don't need to identify much, we just need to see if it agrees on a general level. 

White noise test are not a huge problem, after all white-noise+saturation is still a white-noise. Just, remember to use the time series of the saturated control $u_"sat"$ (rows #underline[*6 & 7*] instead of 4&5)

= Plan

+ Trajectory Tracking at various amplitudes on one motor. Data analysis in the lab to verify the "boost effect". If it returns positive then we can move on because the other motor will have the same behavior.

+ While the data is being analyzed let's re-do the disturbance frequencies analysis.

+ State space experiments: if the experiment 1 succeeded then all the parameters are correct, let's try the 2D position control in State Space. 

- If experiment 1 fails then we have to decide between redoing the identification experiments or hiding this from the professor and acting like everything is ok.
