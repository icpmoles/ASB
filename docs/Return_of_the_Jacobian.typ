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
  watermark: ""
)
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
  -sin(thetap1),sin(thetap2);
  -cos(thetap1),cos(thetap2);
) $ ]


#let Jq =[ $ mat(
  sin(thetaa1),-sin(thetaa2);
  cos(thetaa1),-cos(thetaa2);
) $ ]
// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

= Kinematic Equations

(Angle conventions taken from "A Method for Optimal Kinematic Design of
Five-bar Planar Parallel Manipulators" )
#image("figures/chain.png")

The kinematic chain in polar form is written as:

$ L e ^ (j thetaa1) +  L e ^ (j thetap1) = 2L +
 L e ^ (j thetaa2) +  L e ^ (j thetap2) $

 Deriving in time and dividing by $L$:

 $ thetaa1d e ^ (j (thetaa1 + pi/2)) +  thetap1d e ^ (j (thetap1 + pi/2)) =
 thetaa2d e ^ (j (thetaa2 + pi/2)) +  thetap2d e ^ (j (thetap2 + pi/2)) $

 In Cartesian form:

 $ cases(
  thetaa1d sin(thetaa1) + thetap1d sin(thetap1) &= thetaa2d sin(thetaa2) + thetap2d sin(thetap2) ,
  thetaa1d cos(thetaa1) + thetap1d cos(thetap1) &= thetaa2d cos(thetaa2) + thetap2d cos(thetap2) ,
) $<cart1>

= Rotational Singularities

Let's define

$ omega_r = vec(thetap1d, thetap2d) ,  q = vec(thetaa1d, thetaa2d)  $

We want to find a form like

$ J_r omega_r = J_q q $

(taken from "Inverse kinematics and singularity analysis of a redundant
parallel robot ")

We can rearrange to have all the passive and active joint angles on one side:
 $ cases(
  thetaa1d sin(thetaa1) - thetaa2d sin(thetaa2)  &=   - thetap1d sin(thetap1)  +  thetap2d sin(thetap2) ,
  thetaa1d cos(thetaa1) - thetaa2d cos(thetaa2) &=   - thetap1d cos(thetap1)  + thetap2d cos(thetap2d)  ,
) $<cart2>

Convert it in matrix form

$ Jr omrv = Jq qv $

With these two Jacobian we can analyze the singularities between the actuators and the rotation of the passive joints:

$ det(J_r) = cos(thetap1) sin(thetap2) - sin(thetap1) cos(thetap2) = sin(thetap1 - thetap2) $

$ exists J_r ^(-1)   arrow.l.r thetap1 - thetap2 != k pi , k in NN $<notalligned>

This condition is asking for the 2nd and 3rd links to not be parallel.

If $J_r$ is invertible then we have:

$  omega_r = J_r ^(-1) J_q q = Lambda_q^r q $

$ Lambda_q^r = 1 / sin(thetap1 - thetap2)  
mat(
  cos(thetap2),-sin(thetap2);
  cos(thetap1),-sin(thetap1);
)  Jq = \ =

1 / sin(thetap1 - thetap2) 
mat(
  "left","as an";
  "exercise to","the reader";
) = \ =

1 / sin(thetap1 - thetap2) 
mat(
sin(thetaa1 - thetap2),sin(thetap2 - thetaa2);
sin(thetaa1 - thetap1),sin(thetap1 - thetaa2);
) = mat( g_(1 1) , g_(1 2) ;
g_(2 1), g_(2 2) )
$

// $ omrv = mat( g_(1 1) , g_(1 2) ;
// g_(2 1), g_(2 2) ) qv $<jacobianrot>


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


$ lamb(4,2) &=part(x_2,a2) =
-L sin(a2) -L sin(p2) g_22 + L/2 sin(p1) g_12
 \
lamb(5,2) &=part(y_2,a2) = L cos(a2) +  L cos(p2) g_22 - L/2 cos(p1) g_12 \
lamb(6,2) &=part(t2,a2) =  g_12 \
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


$ lamb(7,2) &= part(x_3,a2) =
-L sin(a2) -  L/2 sin(p2) g_22
 \
lamb(8,2) &=part(y_3,a2) = L cos(a2) + L/2 cos(p2) g_22  \
lamb(9,2) &=part(t3,a2) =  g_22 \
 $


 == Link 4

  $ cases(x_4 = 2L +  L/2 cos(a2) \ y_4 = L/2 sin(a2) \ theta_4 = a2) $
 $ lamb(10,1) =lamb(11,1) =lamb(12,1) =0 $

$ lamb(10,2) &= part(x_4,a2) =  -L/2 sin(a2) \
lamb(11,2) &=part(y_4,a2) =  L/2 cos(a2) \
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
where $mphm = "diag" [m , m , J_l + r^2 J_r, m , m , J_l, m , m , J_l, m , m , J_l + r^2 J_r] $

=== Why is the inertia of the first and last links like that? 
Assuming to have two actuator on the 1st and 2nd load shafts, the equivalent mechanical system is this:

#image("figures/FullLinksandRotor.png",width: 65%)

$J_l$ is the moment of inertia of the links (provided by the manufacturer)

$J_r$ is the total moment of inertia of the motor + gears assembly seen by the motor side (provided by the manufacturer), we can move $J_r$ to the load side by multiplying by $r^2$ (r = gear ratio = 70 ): $J_r^L = J_r r^2$

We can simply sum them and place the result in the inertia of the first and last links.

== Symbolic analysis

$J_a$ = Inertia of active links (I & IV), $J_p$ = Inertia of passive links (II & III)

#let mpdiag = [$mat(
  m, 0, 0, 0 , 0, 0, 0 , 0, 0, 0 , 0, 0, ;
  0, m, 0, 0 , 0, 0, 0 , 0, 0, 0 , 0, 0, ;
  0, 0, J_a, 0 , 0, 0, 0 , 0, 0, 0 , 0, 0, ;

  0, 0, 0, m , 0, 0, 0 , 0, 0, 0 , 0, 0, ;
  0, 0, 0, 0 , m, 0, 0 , 0, 0, 0 , 0, 0, ;
  0, 0, 0, 0 , 0, J_p, 0 , 0, 0, 0 , 0, 0, ;

  0, 0, 0, 0 , 0, 0, m , 0, 0, 0 , 0, 0, ;
  0, 0, 0, 0 , 0, 0, 0 , m, 0, 0 , 0, 0, ;
  0, 0, 0, 0 , 0, 0, 0 , 0, J_p, 0 , 0, 0, ;

  0, 0, 0, 0 , 0, 0, 0 , 0, 0, m , 0, 0, ;
  0, 0, 0, 0 , 0, 0, 0 , 0, 0, 0 , m, 0, ;
  0, 0, 0, 0 , 0, 0, 0 , 0, 0, 0 , 0, J_a, ;
  )
$]

$ mm = FullLamb^T  mpdiag FullLamb = \ =
mat(
 lamb(1,1), lamb(2,1) , lamb(3,1) ,  lamb(4,1) ,  lamb(5,1) ,  lamb(6,1) ,
   lamb(7,1),  lamb(8,1) , lamb(8,1) ,  lamb(10,1) ,  lamb(11,1) , lamb(12,1) ;

    lamb(1,2),  lamb(2,2) ,  lamb(3,2) , lamb(4,2) ,  lamb(5,2) , lamb(6,2) ,
   lamb(7,2),  lamb(8,2) ,  lamb(8,2) , lamb(10,2) , lamb(11,2) ,  lamb(12,2) ;

 ) 
mat(
  lamb(1,1) m,  lamb(1,2) m ;
  lamb(2,1) m,  lamb(2,2) m ;
  lamb(3,1) J_a,  lamb(3,2) J_a ;
  lamb(4,1)  m,  lamb(4,2) m ;
  lamb(5,1) m ,  lamb(5,2)  m;
  lamb(6,1) J_p ,  lamb(6,2) J_p ;
  lamb(7,1)  m,  lamb(7,2)  m;
  lamb(8,1)  m,  lamb(8,2)  m;
  lamb(9,1)  J_p,  lamb(9,2)  J_p ;
  lamb(10,1) m ,  lamb(10,2) m ;
  lamb(11,1)  m,  lamb(11,2)  m;
  lamb(12,1) J_a ,  lamb(12,2)  J_a;   
  ) = \ =

 mat(
m_11 , m_12; m_21, m_22

 )
$

$ m_11 =  m lamb(1,1)^2 + m lamb(2,1)^2  + J_a lamb(3,1)^2  +  m lamb(4,1)^2  +  m lamb(5,1)^2  + J_p lamb(6,1)^2  +   m lamb(7,1)^2 +  m lamb(8,1)^2 +  J_p lamb(9,1)^2  + \ m lamb(10,1)^2  +  m lamb(11,1)^2  + J_a lamb(12,1)^2  = \ =
m lamb(1,1)^2 + m lamb(2,1)^2  + J_a lamb(3,1)^2  +  m lamb(4,1)^2  +  m lamb(5,1)^2  + J_p lamb(6,1)^2  +   m lamb(7,1)^2 +  m lamb(8,1)^2 +  J_p lamb(9,1)^2  

$

$ m_22 =  m lamb(1,2)^2 + m lamb(2,2)^2  + J_a lamb(3,2)^2  +  m lamb(4,2)^2  +  m lamb(5,2)^2  + J_p lamb(6,2)^2  +   m lamb(7,2)^2 +  m lamb(8,2)^2 +  J_p lamb(9,2)^2 \ +  m lamb(10,2)^2  +  m lamb(11,2)^2  + J_a lamb(12,2)^2 = \ =
 m lamb(4,2)^2  +  m lamb(5,2)^2  + J_p lamb(6,2)^2  +   m lamb(7,2)^2 +  m lamb(8,2)^2 +  J_p lamb(9,2)^2  +  m lamb(10,2)^2  +  m lamb(11,2)^2  + J_a lamb(12,2)^2
 $


#let lambm(row,col) = [$lambda_(row,col) lambda_(col,row) $ ]

$ m_12 = m_21 =  m lambm(1,2) + m lambm(2,2)  + J_a lambm(3,2)  +  m lambm(4,2)  +  m lambm(5,2)  + J_p lambm(6,2)  \ +   m lambm(7,2) +  m lambm(8,2) +  J_p lambm(9,2)  +  m lambm(10,2)  +  m lambm(11,2)  + J_a lambm(12,2) = \ =
 m lambm(4,2)  +  m lambm(5,2)  + J_p lambm(6,2)  +   m lambm(7,2) +  m lambm(8,2) +  J_p lambm(9,2)  
$<mdiag>

= Results

Sampling the workspace the generalized matrix of inertia has the following values:

#image("figures/m11_real.png")
#image("figures/m22_real.png")
#figure(image("figures/m_diag_real.png"),caption:[(N.b: ignore the image title, this technically "off-diagonal")])


The 2 diagonal terms have a constant $approx$ 10 kg m^2 throughout the workspace. With some spikes at infinity in the singularities. (Unstoppable force vs unmovable object = $infinity$). (For the sake of visualization the values have been capped at 20.)

== What if we forgot about the inertia before the gearbox?

For the sake of the argument let's assume we forgot to account for the inertia of the motor assembly:


#image("figures/PartialLinkswithoutRotor.png", width: 70%)

We can sample again the system and see how it changes:

#image("figures/m11_partial.png")
#image("figures/m22_partial.png")
(Capped at 0.02)

#figure(image("figures/m_partial_od.png"),caption:[(N.b: ignore the image title, this technically "off-diagonal")])

We can see how the inertia of the diagonal terms is much smaller and less "stable"
This demonstrates the "decoupling effect of high gear ratios in robotics" which means that we can design a controller assuming a "constant" inertia.


By comparing the two off-diagonal graphs we can see that they are basically the same. This is consistent with @mdiag where $J_a$ doesn't appear.

= Takeaway from this

- The inertia seen by the motor is constant.

- Simply use the value seen at the rest point (10.2338 & 10.2346) and translate it to the motor shaft.
  
  $ J_1 = 10.2338/70^2 = 0.00208 "kg" m^2 $ 
  $ J_2 = 10.2346/70^2 = 0.00208 "kg" m^2 $ 

- Hopefully this is consistent with time constants and stuff somehow.