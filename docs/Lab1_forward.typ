#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Lab 1: what to do now?",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

Congrats, you've just completed your first day in the lab. In those 5 hours (more like 4 and half to be honest...) we performed our fair share of experiments and it's now time to see what can we obtain from all the data.

= Gray Box Model identification

#let om = [$omega_m$]
#let omd = [$dot(omega)_m$]
#let ol = [$omega_l$]
#let old = [$dot(omega)_l$]

#let taum = [$tau_m$]
#let damping = [$beta$] 
#let Jt = [$J_"tot"$]
#let Jlt = [$J_l (t) $]
#let tl = [$theta_L$]
#let tld = [$dot(theta)_L$]
#let id = [$dot(i)$]
#let xv = [$vec(tl,om,i)$]
#let xdv = [$vec(tld,omd,id)$]
#let damp = [$beta$]
#let Am =[ $ mat(
  0 , 1/r , 0;
  0 , - damp / Jt ,  k/Jt;
  0 , - k/L, -R/L;
) $ ]

#let Bm = [$vec(0,0,1/L)$]

#let Cm =[ $ mat(
  1 ,0 , 0; 0 ,1 ,0 
) $ ]
#let yv = [$vec(tl,om)$]
#let detsia = [$s((s+damp/Jt)(s+R/L)+k^2/(Jt L))$]
#let detsiashort = [$s (s^2 + gamma s + delta )$]


(From the "quick sketch" photo I shared previously)

#image("figures/inertiaandMotorLab1.jpg")

Where 
$Jt = J_m + J_l/(r^2 eta_g) $
 and $beta$ is a generic parameter that contains in itself all additional mechanical losses due to friction (supposed linear to angular speed).

 $ tau_m = J omd + beta om $

 At steady state:

 $ tau_m = beta overline(omega)_m $

 $ beta = tau_m(om) / overline(omega)_m $

From the electrical circuit:

$ tau_m(om)  = eta_m k I(om) $

$ I = (V-E)/R = (V-k om)/R   $ 

$ tau_m(om)  = eta_m k (V-k om)/R  $

Once we know the speed at steady state it's possible to estimate the parameter $beta$ and plug it in the dynamic model.


= Signal processing

We have two tasks:

+ Derive the angle to find the speed

+ Filter out (relatively) high frequency "noise" 

My proposal is to use a pure derivator (s) and two poles ($tau_1,tau_2$ ) at  whatever rad/s to obtain a "band pass filter".

$ "Filter"(s) =  tau_1 tau_2 s/((s+tau_1)(s+tau_2)) $

== Numerical Examples

From `data_04-Mar-2025_17-41-21.mat`:

#image("figures/174121.png")

After derivation with poles at 80 & 400 rad/s:

#image("figures/174121deriv.png")

We can see the encoder speed settling at 1.57 rad/s:

```matlab
omega_l = 1.57;
V = 1;

omega_m = 70*omega_l;
R = 2.6;
k = 7.68e-3;
E = k * omega_m  = 0.8440
I = (V-E)/R = 0.0600
torque = I * k = 4.6071e-04
beta = torque/omega_m = 4.1920e-06
```

Repeat this for all the experiments :)

Then do an average or something.