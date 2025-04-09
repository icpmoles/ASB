#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Singularity Analysis",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)
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
  thetaa1d sin(thetaa1) - thetap2d sin(thetap2) &=   - thetap1d sin(thetap1)  + thetaa2d sin(thetaa2)  ,
  thetaa1d cos(thetaa1) - thetap2d cos(thetap2) &=   - thetap1d cos(thetap1)  + thetaa2d cos(thetaa2)  ,
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
  -cos(thetap2),sin(thetap2);
  -cos(thetap1),sin(thetap1);
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

$ omrv = mat( g_(1 1) , g_(1 2) ;
g_(2 1), g_(2 2) ) qv $<jacobianrot>

= Velocity Singularities

#image("figures/velocity.jpg", width: 60%)

From the linearized left side of the chain:

$ cases(
  delta X_E = - L delta thetaa1 sin(thetaa1) - L delta thetap1 sin(thetap1)\
   delta Y_E =  L delta thetaa1 cos(thetaa1) + L delta thetap1 cos(thetap1)
) $

In matrix form:

$ v = vec(delta X_E , delta Y_E) = L 
mat(- sin(thetaa1) , - sin(thetap1) ;
cos(thetaa1) ,cos(thetap1)
) vec(delta thetaa1 , delta thetap1) = J_1^x vec(delta thetaa1 , delta thetap1)  $

We have a relation between the angles of the left links and the velocity of the End Effector. Ideally we would like a relation between the actuators and the velocity. We can use the relations found in @jacobianrot for that.

$ vec(delta thetaa1 , delta thetap1) = mat( 1, 0 ;
g_(1 1) , g_(1 2) ) qv $

$ v = J_1^x mat( 1, 0 ;
g_(1 1) , g_(1 2) ) qv = Lambda_q^x q  $

With 
$  Lambda_q^x= L 
mat(- sin(thetaa1) , - sin(thetap1) ;
cos(thetaa1) ,cos(thetap1)
)  
mat( 1, 0 ;
g_(1 1) , g_(1 2) ) = \ =
L mat( - sin(thetaa1) - sin(thetap1) g_(1 1) , 
- sin(thetap1) g_(1 1) ;
cos(thetaa1) + cos(thetap1) g_(1 2) , 
cos(thetap1) g_(1 2) ;
)
$<Jvel>

(N.b. In the MATLAB code $ g_(1 1), g_(1 2)$ are galled g1 and g2 respectively)

In this case the singularity analysis is not as straightforward as the rotational case.

= Inverse Kinematics

We can sample the Cartesian Workspace and see where $det(Lambda_q^x)=0$.

Before doing that we need to find a function that given a Cartesian coordinate returns the joint angles.

#image("figures/links.png",width: 80%)

$ beta_1= tan^(-1)(y/x) $

$ beta_2= tan^(-1)(y/(x-2L)) $

$ d_1 = sqrt(x^2 + y^2) $

$ d_2 = sqrt( (x-2 L)^2 + y^2) $

$ alpha_1 = cos ^(-1) (d_1 / (2 L)) $

$ alpha_2 = cos ^(-1) (d_2 / (2 L)) $

$ thetaa1 = beta_1 -alpha_1 $

$ thetaa2 = beta_2 -alpha_2 $

$ thetap1 = tan^(-1)( (y - L sin(thetaa1)) / (x - L cos(thetaa1))) $

$ thetap2 = tan^(-1)( (y - L sin(thetaa2)) / (x - 2 L -L cos(thetaa2))) $

= Computer assisted analysis

Now that we have the inverse kinematic law it's possible to analyze the properties of the robot.


#pseudocode-list[
  + for every sampled (x,y) in workspace
    + *if* distance(x,y) is feasible *then*
      + $theta_(a i) , theta_(p i) arrow.l $ inverseKinematics(x,y)
      + calculate $Lambda_q^x (theta_(a i) theta_(p i))$
      + calculate $Lambda_q^r (theta_(a i) theta_(p i)) $
      + return *$[det(Lambda_q^x),Lambda_q^x,det(Lambda_q^r),Lambda_q^r]$*
    + *else*
      + return *error*
    + *end*
  + *end*
]

= Results

#image("figures/rot_sing_27022025.png",width: 80%)
#image("figures/velocity_singularities_27022025.png",width: 80%)
#image("figures/vector_field_vel_27022025.png",width: 80%)