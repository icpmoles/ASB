#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Return of the Jacobian",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: "NOT FINAL"
)

= Why?

The previous model wasn't elegant enough. Hopefully this makes more sense.

== From the previous episodes
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

$ omrv =

1 / sin(thetap1 - thetap2) 
mat(
sin(thetaa1 - thetap2),sin(thetap2 - thetaa2);
sin(thetaa1 - thetap1),sin(thetap1 - thetaa2);
) qv =
 mat( g_(1 1) , g_(1 2) ;
g_(2 1), g_(2 2) ) qv $

= Calculations

#let lamb(row,col) = [$lambda_(row,col)$]
Some notation first:

$ x_i , y_i$ are the cartesian positions of the COG of the i-th link 

$ theta_i$ is the angle of the i-th link.

$ lamb(i,j)$ is the element of the i-th row, j-th column of the mass jacobian.

== Link 1 

#let a1 = [$theta_(a 1)$]
#let a2 = [$theta_(a 2)$]
#let p1 = [$theta_(p 1)$]
#let p2 = [$theta_(p 2)$]
#let t1 = [$theta_1$]
#let t2 = [$theta_2$]
#let t3 = [$theta_3$]
#let t4 = [$theta_4$]


#let part(num,dem) = [$(partial num)/(partial dem)$]

$ cases( x_1 = L/2 cos(a1) \ y_1 = L/2 sin(a1) \ theta_1 = a1) $

$  lamb(1,1) &=part(x_1,a1) =  -L/2 sin(a1) \
lamb(2,1) &=part(y_1,a1) =  L/2 cos(a1) \
lamb(3,1) &= part(t1,a1) =  1\
 $

 $ lamb(1,2) =lamb(2,2) =lamb(2,3) =0 $


 == Link 2

Kinematic chain from A1  to 2nd link:

$ cases(x_2 (a1,p1) = L cos(a1) + L/2 cos(p1) \ 
y_2 (a1,p1)= L sin(a1)  + L/2 sin(p1) \ 
theta_2  (a1,p1)= p1) $


$ lamb(4,1) &= part(x_2,a1) =  -L sin(a1) +  L/2 part(cos(p1),a1)
= \ &= -L sin(a1) +  L/2 part(cos(p1),p1) part(p1,a1) =
-L sin(a1)  - L/2 sin(p1) g_11
 \
lamb(5,1) &=part(y_2,a1) =  L cos(a1) + L/2 cos(p1) g_11 \
lamb(6,1) &= part(t2,a1) =  g_11 \
 $

Now  we follow the kinematic chain from the opposite direction (A2  to 2nd link)

 $ cases(x_2 (a2,p2,p1) = 2L + L cos(a2)  + L cos(p2) - L/2 cos(p1) \ 
y_2 (a2,p2,p1)= L sin(a2)  + L sin(p2) - L/2 sin(p1) \ 
theta_2  (a2,p2,p1)= p1) $


$ lamb(4,2) &=part(x_2,a1) =
-L sin(a2) -L sin(p2) g_21 + L/2 sin(p1) g_12
 \
lamb(5,2) &=part(y_2,a1) = L cos(a2) +  L cos(p2) g_21 - L/2 cos(p1) g_12 \
lamb(6,2) &=part(t2,a1) =  g_12 \
 $


 == Link 3


$ cases(x_3 (a1,p1,p2) = L cos(a1) + L cos(p1) -L/2 cos(p2) \ 
y_3 (a1,p1,p2)= L sin(a1)  + L sin(p1)  -L/2 sin(p2) \ 
theta_3  (a1,p1,p2)= p2) $


$ lamb(7,1) &=part(x_3,a1)  =
-L sin(a1)  - L sin(p1) g_11 + L/2 sin(p2) g_21
 \
lamb(8,1) &=part(y_3,a1) =  L cos(a1) + L cos(p1) g_11  - L/2 cos(p2) g_21\
lamb(9,1) &=part(t3,a1) =  g_21 \
 $


 $ cases(x_3 (a2,p2) = 2L + L cos(a2)  + L/2 cos(p2)  \ 
y_3 (a2,p2)= L sin(a2)  + L/2 sin(p2)  \ 
theta_3  (a2,p2)= p2) $


$ lamb(7,2) &= part(x_3,a1) =
-L sin(a2) -  L/2 sin(p2) g_22
 \
lamb(8,2) &=part(y_3,a1) = L cos(a2) + L/2 cos(p2) g_22  \
lamb(9,2) &=part(t2,a1) =  g_22 \
 $


 == Link 4

  $ cases(x_4 = 2L +  L/2 cos(a2) \ y_4 = L/2 sin(a2) \ theta_4 = a2) $
 $ lamb(10,1) =lamb(11,1) =lamb(12,1) =0 $

$ lamb(10,2) &= part(x_4,a2) =  -L/2 sin(a2) \
lamb(11,2) &=part(y_4,a1) =  L/2 cos(a2) \
lamb(12,2) &=part(t4,a2) =  1\
 $


= Implementation
#let yd = [$underline(dot(y))$]
#let mphm = [$[m_"ph"]$]
#let Lm = [$[Lambda_m]$]
#let qv = [$underline(q)$]
#let qdv = [$underline(dot(q))$]
#let qddv = [$underline(diaer(q))$]
#let mm = [$[m_0]$]
#let ta1 = [$theta_"A1"$]
#let ta2 = [$theta_"A2"$]
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
For a given (x,y) workspace coordinate, we use the inverse kinematics to calculate $theta_"ai", theta_"pi"$.

Then we fill the mass jacobian according to the previously specified laws.
$ Lm =FullLamb $
We calculate the generalized matrix of inertia with $ mm = Lm^T mphm Lm $
where $mphm = [m , m , J_l + r^2 J_r, m , m , J_l, m , m , J_l, m , m , J_l + r^2 J_r]^T $

=== Why is the inertia of the first and last links like that? 
Assuming to have two actuator on the 1st and 2nd load axles, the equivalent mechanical system is this:

#image("figures/FullLinksandRotor.png",width: 65%)

$J_l$ is the moment of inertia of the links (provided by the manufacturer)

$J_r$ is the total moment of inertia of the motor + gears assembly seen by the motor side (provided by the manufacturer), we can move $J_r$ to the load side by multiplying by $r^2$ (r = gear ratio = 70 ): $J_r^L = J_r r^2$

We can simply sum them and place the result in the inertia of the first and last links.