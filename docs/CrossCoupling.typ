#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Cross interactions",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

= Why?
One of our hypotheses is that the two active arms are completely decoupled. Our main reason behind it is that the revolute joints don't transfer load between them and that the high gear ratio "blocks" every (small) disturbance on the load axle from reaching the motor axle.

This is a good first approximation because it allows us to ignore every cross-interactions between the two servo motors and design the controllers independently.

We can apply a more rigorous approach in the study of these effects before moving forward with other tasks. (Just in case the professor wants to be pedantic).

= 2-DOF Kinematics


Seen from the 2 load axles our system has only masses and moments of inertia, no potential energies or dissipations.

#let yd = [$underline(dot(y))$]
#let mphm = [$[m_"ph"]$]

$ T = 1/2 yd^T mphm yd $



Where  $mphm = [m , m , J_l + r^2 J_r, m , m , J_l, m , m , J_l, m , m , J_l + r^2 J_r]^T $

(n.b: $J_l$ is the moment of inertia of the links at the center of gravity, do not use the Huygens–Steiner theorem or that other moment of inertia around the pivot)

(n.n.b: $J_r$ is the moment of inertia of rotor moved on the load axle)

and $yd$ = 
$[x_"l1",y_"l1", theta_"l1",
x_"l2",y_"l2", theta_"l2",
x_"l3",y_"l3", theta_"l3",
x_"l4",y_"l4", theta_"l4"]^T$

is the vector of independent coordinates of the bodies according to this diagram:

#image("figures/diagramm_jacobian.png")

#let Lm = [$[Lambda_m]$]
#let qv = [$underline(q)$]
#let qdv = [$underline(dot(q))$]
#let qddv = [$underline(diaer(q))$]
#let mm = [$[m_0]$]
#let ta1 = [$theta_"A1"$]
#let ta2 = [$theta_"A2"$]

We can describe $yd$ in terms of our 2 dof $[q_1,q_2]^T = [ta1,ta2]^T$ via a Jacobian matrix $Lm$: 
$ yd = Lm qdv $

The new system will be:

$ T = 1/2 yd^T mphm yd = 1/2 qdv^T mm qdv $

With $mm = Lm^T mphm Lm$

The kinetic term of the Lagrangian equation becomes:

$
d/(d t) ( (partial T)/(partial qdv))^T - 
( (partial T)/(partial qv))^T = mm qddv
$

We can then calculate the work of the time dependent forces (our servo actuators):
#set math.vec(delim: "[")

$ delta W = delta underline(y)_f^T underline(f)_"ph" = [ delta ta1 , delta ta2] vec(tau_1, tau_2)  = [ delta q_1 , delta q_2] vec(tau_1, tau_2)  = delta qv^T underline(f)_"ph" $

(In this case $[Lambda_f]$ is simply the identity matrix)


$ underline(f)(t) = [Lambda_f]^T underline(f)_"ph"  = underline(f)_"ph"  $

Our Lagrange equation becomes:

$ mm qddv = underline(f)(t) $

$ vec( tau_1 , tau_2 ) = mat( m_11,  m_12 ; m_21, m_22) vec(diaer(q_1),diaer(q_2) ) $

With these equations we can calculate the torque applied on the load axles when a specific angular acceleration occurs (or if we invert it, the necessary torque to have a desired acceleration on the load axles).

This is a good starting point to analyze eventual cross interactions between the two axles.

== The humble Jacobian of Inertia

#let l11 = [$-L sin(ta1)$]
#let l21 = [$+L cos(ta1)$]
#let l31 = [$1$]

#let l102 = [$-L sin(ta2)$]
#let l112 = [$+L cos(ta2)$]
#let l122 = [$1$]
#let lamb(row,col) = [$lambda_(row,col)$]
#let FullLamb = [$mat(delim: "[",
  lamb(1,1) ,  lamb(1,2) ;
  lamb(2,1) ,  lamb(2,2) ;
  lamb(3,1) ,  lamb(3,2) ;
  lamb(4,1) ,  lamb(4,2) ;
  lamb(5,1) ,  lamb(5,2) ;
  lamb(6,1) ,  lamb(6,2) ;
  lamb(7,1) ,  lamb(7,2) ;
  lamb(8,1) ,  lamb(8,2) ;
  lamb(9,1) ,  lamb(9,2) ;
  lamb(10,1) ,  lamb(10,2) ;
  lamb(11,1) ,  lamb(11,2) ;
  lamb(12,1) ,  lamb(12,2) ;   
  )
$]
  
The system has 4 links (4x3 DOF = 12 DOF) and 5 revolute joints (each cosntraing 2 DOF => -10 DOF) : in total we have 2 DOF

Our Jacobian will be a 12x2 matrix

$Lm = FullLamb = mat(delim: "[",
  l11 ,  0 ;
  l21 ,  0 ;
  l31 ,  0 ;
  lamb(4,1) ,  lamb(4,2) ;
  lamb(5,1) ,  lamb(5,2) ;
  lamb(6,1) ,  lamb(6,2) ;
  lamb(7,1) ,  lamb(7,2) ;
  lamb(8,1) ,  lamb(8,2) ;
  lamb(9,1) ,  lamb(9,2) ;
  0 ,  l102 ;
  0 ,  l112 ;
  0 ,  l122 ;   
  ) $

  The remaining terms needs to be calculated keeping in mind the inverse kinematics, which is cumbersome by hand. I used the MATLAB Symbolic Math Toolbox. For this reason they  are _*slightly longer*_ and are left in the appendix for clarity.


With our Jacobian we can then calculate the generalized mass $mm$  (again with the Symbolic Toolbox)


= How decoupled are we?

$ vec( tau_1 , tau_2 ) = mat( m_11,  m_12 ; m_21, m_22) vec(diaer(q_1),diaer(q_2) ) $

Let's bring back the Lagrange equation and  see what happens at the "resting position":
```matlab
rgaf(0,pi/2,true)
```
 $ mm("rest") = mat( 10.2287  ,  0.0002;
    0.0002  , 10.2271)  $  

So, to obtain $1 "rad"/s^2$ of acceleration on the 1st active link we need $10.2287$ Nm on the 1st load axle and $0.0002$ Nm on the 2nd load axle (which when accounting for the r = 70 gear ratio results in 0.1461 Nm and  $2.8571 times 10^(-6)$ on the motor axles respectively)

Dually, by inverting we have:

$ vec(diaer(q_1),diaer(q_2) ) = mm^(-1) vec( tau_1 , tau_2 )  $

 $ mm^(-1)("rest") = mat(      0.0978 ,  -0.0000 ;
   -0.0000  ,  0.0978) $

Which means that when applying $ 1 N m$ on the 1st active load axle we'll end up with $ 0.0978 "rad"/s^2$ on the first active link and a negligible acceleration on the second load axle. *Great!*

Be aware that symbolically inverting $mm$ is useless because we can just invert the matrix after the evaluation.

= Relative gain array analysis

#image("figures/rga.png")

Standard control theory method to evaluate the decoupling (or not) of a MIMO system. I only have these slides in Italian, I'm sorry guys :(

#image("figures/rgadef.png", width: 90%)
#image("figures/rga2by21.png", width: 90%)
#image("figures/rga2by22.png", width: 90%)

== Analysis Approach

Let's plot $lambda_"rga"$ on the Cartesian workspace.
When $lambda_"rga" approx 1 $ it means we have high decoupling, otherwise we have cross-coupling between the active links:

#image("figures/rgaplot.png", width: 90%)

We can see how we have good decoupling everywhere but in the singularity region, which is great and makes sense  if you think about it:

#image("figures/crossc_atsing.png")

When near the singularity, every torque applied on one axle is fully transferred to the other axle = high RGA!

= Appendix

== Jacobian terms
```matlab
jac(4,1) = - L*sin(ta1) + (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(5,1) = L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(6,1) = -(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2)))/(4*L*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(7,1) = - L*sin(ta1) + (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(8,1) = L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(9,1) = (2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2)))/(4*L*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(4,2) = -(sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(5,2) = (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)); 
jac(6,2) = (2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))/(4*L*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(7,2) = - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(8,2) = (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

jac(9,2) = -(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))/(4*L*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));
```

== Generalized Mass

```matlab
mm(1,1) = Ja + M*(L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(L*cos(ta1) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + M*(L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(L*cos(ta1) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + (L^2*M*cos(ta1)^2)/4 + (L^2*M*sin(ta1)^2)/4 - M*(L*sin(ta1) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(- L*sin(ta1) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + M*(L*sin(ta1) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(L*sin(ta1) - (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + (Jp*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2)))^2)/(8*L^2*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));








mm(1,2) =  - M*((sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(- L*sin(ta1) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + M*((cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*(L*cos(ta1) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + (M*cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))*(L*cos(ta1) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (M*sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))*(L*sin(ta1) - (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (Jp*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*L^2*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));



mm(2,1) =  M*((sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)))*(L*sin(ta1) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))) + M*((cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)))*(L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))) + (M*cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))*(L*cos(ta1) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (M*sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))*(L*sin(ta1) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) - (Jp*(2*L^2*sin(ta1)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta1)*(sin(ta1) - sin(ta2)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*L^2*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) ;




mm(2,2) = Ja + M*((cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)))*((cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) - (cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2))) + (L^2*M*cos(ta2)^2)/4 + M*((sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) - angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)) + (sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)))*((sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(4*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) - (sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) - acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2))))/(8*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))) + (L^2*M*sin(ta2)^2)/4 + (Jp*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))^2)/(8*L^2*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (M*cos(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*cos(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))^2)/(64*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2)) + (M*sin(angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)) + acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L)))*sin(conj(acos((L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)^(1/2)/(2*L))) + angle(L*(sin(ta1) - sin(ta2))*(- 1 - 1i)))*(2*L^2*sin(ta2)*(cos(ta2) - cos(ta1) + 2) + 2*L^2*cos(ta2)*(sin(ta1) - sin(ta2)))^2)/(64*conj((1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2))*(L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)*(1 - (L^2*(cos(ta2) - cos(ta1) + 2)^2 + L^2*(sin(ta1) - sin(ta2))^2)/(4*L^2))^(1/2));

```