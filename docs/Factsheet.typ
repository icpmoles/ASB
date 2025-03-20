#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "CNC Fact sheet",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
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
// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!
// 

= Dynamical Model
== Mechanical & Electrical

$ G(s) =  K/(L Jt) / (s^2 + gamma s + delta ) vec(1/ S 1/r , 1) = mu / (s^2 + gamma s + delta ) vec(1/ S 1/r , 1) $

 Where $ gamma = (damp L + R J)/(Jt L)$,  $ delta = (k^2 + damp R)/(Jt L)$, $mu =  K/(Jt L) $


 == First order approximation (only mechanical)

Voltage #sym.arrow.r Angular Speed transfer function: $G_omega (s) = mu / (tau s + 1) $ 


Voltage #sym.arrow.r Shaft angle transfer function:  $G_theta (s) = 1/ s mu / (tau s + 1) $
=== Estimated parameters

#let FillCell = box(width: 1fr, repeat[ ])

#table(
  columns: (2fr, 1fr ,1fr),
  inset: 10pt,
table.header(
    [], [*Motor 0*], [*Motor 1*],
  ),
  [ $mu$ (DC Gain) #FillCell [$"rad"/s 1/V$]],[-1.58],[-1.65],
  [ $tau$ (Time constant) #FillCell [s]],[0.0505],[0.05546],
  [ $1/tau$ (Pole of the mechanical system)#FillCell [rad/s]],[19.8],[18],
)


= Joint space

$ theta_(A 1) in vec(-0.2967 ,0.5411 ) "rad" = vec(-17°, 31°)  approx 48° "peak peak" $

$ theta_(A 2) in vec(-0.4712 ,0.4712 ) "rad" = vec(-27°, 27°) approx 52° "peak peak"  $


= Control
== Frequency Based Design

- (Candidate) Control Bandwidth: 26 rad/s

- Phase Margin: 70° (balance between effort and overshoot)

- Control Scheme: PD

#table(
  columns: (1.2fr, 2fr ,2fr),
table.header(
    [], [*Motor 0*], [*Motor 1*],
  ),
  [ Kp ],[-21.4],[-21],
  [ Kd ],[-0.43],[-0.47],
  [ Rise Time #FillCell [s]],[0.0620],[ 0.0620],
  [ Settling Time #FillCell [s]],[0.1880],[ 0.1920],
  [Overshoot #FillCell [%]],[5.6800],[6.0723]
)


= MISC

- Conversion from encoder steps to radians: 
$ "(angle in radians)" = "(encoder steps)" times (2 pi) / 4096 
="(encoder steps)" times pi / 2048 $
- Hz to Rad/s and vice-versa:

$ omega = 2 pi f  \ f = omega /(2 pi) $

- .mat file row structure
#table(
  columns: (auto, auto,auto),
table.header(
     [*Row*],[*Quantity*],[*Unit*]
  ),
  [1],[time],[s],
  [2],[Encoder 0 ],[steps],
  [3],[Encoder 1 ],[steps],
  [4],[Motor 0 ],[V],
  [5],[Motor 1 ],[V],
)