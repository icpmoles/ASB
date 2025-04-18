#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Dynamical Model",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)
#let om = [$omega_m$]
#let omd = [$dot(omega)_m$]
#let ol = [$omega_l$]
#let old = [$dot(omega)_l$]

#let taum = [$tau_m$]
#let damping = [$beta$] 
#let Jt = [$J_"tot"$]
#let Jlt = [$J_l (t) $]


= Mechanical Model

We can schematize the mechanical assembly in this way:

#image("figures/real mech model.png")

(from left to right)

We start with the DC motor attached to the support. Attached to this motor we have the inertia of the rotor and the inertia of the tachometer (n.b: it's connected to the motor shaft but not connected to the acquisition board, we can't access it).

The motor shaft is then connected to a set of gears in torque multiplying configuration (r = 70) that end at the load shaft.

On the load shaft we have our load and the quadrature encoder (no inertia reported on it from the manufacturer).

== Dynamical Model

We can use the power balance to find a dynamic equation describing the mechanical model: 

$ P_m =  taum om - J_m om omd  - tau_("friction") om =  taum om - J_m om omd  - damping om om "         "("exiting") $

$ P_l = Jlt ol old "                                                                                  "("entering") $ 


$ P_l = eta_g P_m $

$ Jlt ol old  =  eta_g ( taum om - J_m om omd  - damping om om)  $

$ (Jlt )/r^2 om omd  =  eta_g ( taum  - J_m  omd  - damping  om) om $

$ Jlt /r^2  omd  =  eta_g ( taum  - J_m  omd  - damping  om)  $

$ (Jlt /(eta_g r^2) + J_m)  omd + damping  om = taum   $

$ Jt (t) omd + damping  om = taum   $

$  taum = s Jt  (t) omd + damping  om   $

We can see how we have a simple mass/friction system with no conservative forces. This is positive because it implies no resonances in the mechanical system.

Unfortunately we have a time varying term in the inertia. This may cause a degradation of performance for our controller but luckily the high-gear ratio combined with the already small inertia of the links renders their contribution negligible. (This is consistent with the decoupling effect of high gear ratios in robotics, albeit in that case is with open kinematic chains).

#nb(title: "To Do")[
  We need to verify this somehow. My proposal is multiple experiments with step voltages to see if the response doesn't change:
  - Servo with no load.
  - Servo with 1 Link
  - Servo with full chain (4 Links)
  
]

= Electric Model

Pictures taken from DEMD lab 3 slides:

#image("figures/pmdc.png")

#image("figures/elecmechmatrices.png")

In our case we don't have a torque (moment of forces) $m_l$ coming from the load (YET!).

In our case we also don't have a way to read the speed, only velocity. We can rewrite the equations above taking this into consideration.

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

$ s i &=  - k/L om - R/L i + 1/L v \
  s om &= - damp / Jt om + K/Jt i   \
  s tl &= 1/r om 
$

In state space form:

$ xdv =& underbrace(Am,"A") xv  +  underbrace(Bm,"B") v \ 
yv =& underbrace(Cm,"C") xv $

$ G(s) = C(s I-A)^(-1)B $

$ (s I-A)^(-1) = mat( m_11 m_12 m_13 ; m_21 m_22 m_23 ;m_31 m_32 m_33 ) \
(s I-A)^(-1)B = mat( m_11 m_12 m_13 ; m_21 m_22 m_23 ;m_31 m_32 m_33 ) Bm = 1/L vec( m_13, m_23, m_33) \
C(s I-A)^(-1)B = 1/L Cm vec( m_13, m_23, m_33) = 1/L vec(m_13,m_23)
$

Let's invert $A$

$ det(s I-A) = det mat(
  s , -1/r , 0;
  0 , s+ damp / Jt , - k/Jt;
  0 , k/L, s+R/L;
)  = detsia  = s (s^2 + gamma s + delta )$


$  (s I-A)^(-1) = 1/det(s I-A) a d j( s I-A) = 1/det(s I-A)
mat( (dot) (dot) K/(Jt r) ; (dot) (dot) s K/Jt ; (dot) (dot) (dot) )
$

$ m_13 =  K/(Jt r) 1/det(s I-A)  =  K/(Jt r) 1/detsiashort  = 1/ S  K/(Jt r) / (s^2 + gamma s + delta )
$
$
m_23 = s K/ Jt 1 /det(s I-A)  =  s K/ Jt 1/detsiashort =  K/Jt / (s^2 + gamma s + delta )
$

$ G(s) =  K/(L Jt) / (s^2 + gamma s + delta ) vec(1/ S 1/r , 1) = mu / (s^2 + gamma s + delta ) vec(1/ S 1/r , 1) $

 Where $ gamma = (damp L + R J)/(Jt L) $  $ delta = (k^2 + damp R)/(Jt L) $ $ mu =  K/(Jt L) $
 
We have the "ideal" transfer function from the voltage to the load angle and the motor velocity. This is useful for the parameter identification phase because we are not going blind into it. We know that the relationship between voltage and velocity is a second  order function (so we may have resonances).

#nb(title: "What if")[
Depending on how much we trust the parameters in the datasheet we can already synthesize a servo controller and have it running in the first lab if have time after the experiments.

Then before the second lab, with the model obtained from the parameter identification procedure we can synthesize a new "true to life" controller.
]


= Simplified Mechanical Model

#let tm = [$theta_m$]

$ s^2 tm J + s tm beta = T
\ s^2 tm J + s tm beta = k/R V - s tm k^2/R
\ s tm [ s J + (beta + k^2/R)] =  k/R V

\ G_tm (s) = tm/V = r/s  k/R / ( s J + (beta + k^2/R) ) =
r/s mu / (tau s + 1)
\ G_tl (s) = tm/V = 1/s  k/(r R) / ( s J + (beta + k^2/R) ) =
1/s mu / (tau s + 1)
 $

$ d/(d t) vec(theta_l,omega_m)  = 
mat(0 ,1/r; 0, -(beta+k^2/R)/J) 
vec(theta_l,omega_m) + vec(0, k/(R J)) V
$