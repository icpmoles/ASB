#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Kalman Filter design",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)

#let xd = [$dot(x)$]
#let xk = [$x(k)$]
#let xk1 = [$x(k+1)$]
#let yk = [$y(k)$]
#let uk = [$u(k)$]



#let Ad = [$overline(A)$]
#let Cd = [$overline(C)$]
#let Bd = [$overline(B)$]
#let Qd = [$overline(Q)$]
#let Gammad = [$overline(Gamma)$]
#let Gaus(av,var) = [$cal(N)(av,var)$]



= Theory

We assume that our model in continuos time is:

$ cases(xd = A x + B u +  w ,
y = C x + D u + v
) $

$ x = vec(theta, omega) , u = v $

With A,B,C all fully identified and D = 0

With all the independence assumptions about $w "and" v$. (Z = 0)

$ w tilde Gaus(0,Q) \ 
v tilde Gaus(0,R) \

 Q = mat(sigma_theta^2 , sigma_(theta , omega)^2;
sigma_(theta , omega)^2 , sigma_(omega)^2;
) \

R = vec(sigma_"encoder"^2)
$

The system in discrete time is:


$ cases(xk1 &= Ad xk + Bd uk &+  &w ,
yk &= Cd xk &+ &v
) $

With $ Ad &= I + A dot Delta t \
Bd &=  B dot Delta t \
Cd &=  C
$

== Problem

How do you calculate Q and R?

=== R matrix

Assuming that the discretization from the encoder is the only noise corrupting our "true" $theta$ we can see $v$ as a gaussian noise with zero mean and standard deviation of $sigma_"enc" = "LSB"/sqrt(12) = 2 pi / (4096 sqrt(12) ) $  .

= The literature

Taken from "Kalman and Bayesian Filters in Python" #link("https://drive.google.com/file/d/0By_SW19c1BfhSVFzNHc0SjduNzg/view?usp=sharing&resourcekey=0-41olC9ht9xE3wQe2zHZ45A")[(Link)].

== Chapter 7.3.2

Ignoring the control we can rewrite our state equation as:

$ xd = A x + Gamma alpha $

With $Gamma = vec(0 , 1)$ and $alpha = dot(omega)$ describing the acceleration of the angle caused by "something" (control, disturbances, noise, whatever).

Assuming to have a constant acceleration in our sampling period we can discretize it as:

$ xk1 = Ad  xk + Gammad alpha(k) $

With 

$ Gammad = vec(1/2 Delta t^2 , Delta t ) $

The covariance of this process will be:

$ Qd = Gammad sigma^2_omega  Gammad^T $

For $sigma_omega$ just use the rule of thumb: 

 $ sigma_omega in [1/2 , 1] alpha_"max" $

 $alpha_"max"$ can be estimated from the model, simply assume feeding the max voltage to the motor.

This a good starting point but it has a big drawback: it doesn't use the experimental data.

=== Approximation from 7.3.4

We can see that Q will have the form:

$  Qd = mat(1/4 Delta t^4 , 1/2 Delta t ^3;
1/2 Delta t ^3,  Delta t 
 )sigma^2_omega approx mat(0,0; 0, sigma^2_omega Delta t ) $

In continuos form: 

$ Q approx mat(0,0; 0, sigma^2_omega ) $ <lowerQ>

This is suggesting to us that instead of a diagonal matrix we can focus on a lower triangular matrix. And that we need to estimate only one parameter.

Intuitively this make sense, in fact every source of noise will primarily affect the speed (disturbances on the voltage source, disturbances due to the nonlinearity of friction, disturbances due to the motion of the arm etc. all can be seen as a torque disturbance on the shaft, which will in turn act as a noise for the speed). Disturbance for the angle do exists (think about backslash or flexibility of the shaft) but they are not a problem for our case. They are also already accounted for in the R matrix.


== "Autocovariance Least-Squares" (ALS) & "Optimized Kalman Filter"  (OKF)

From: [ #link("https://en.wikipedia.org/wiki/Kalman_filter#Estimation_of_the_noise_covariances_Qk_and_Rk") ]

These two methods are respectively described as:

#set quote(block: true)

#quote(attribution: "Wikipedia")[Extensive research has been done to estimate these covariances from data. One practical method of doing this is the autocovariance least-squares (ALS) technique that uses the time-lagged autocovariances of routine operating data to estimate the covariances.]

#quote(attribution: "Wikipedia")[Another approach is the Optimized Kalman Filter (OKF), which considers the covariance matrices not as representatives of the noise, but rather, as parameters aimed to achieve the most accurate state estimation.]

Given these "general outlines" I propose this method:


#pseudocode-list[
  + take a reasonable range for $sigma_omega^2$  
  + *iterate over the possible range* and for each  $sigma_omega^2$:
    + Build Q as in @lowerQ
    + Calculate the optimal Kalman Gain given the system + R + Q
    + Simulate the discrete time Kalman Filter with the data from the open loop experiments
    + Calculate the error of the prediction
    + Calculate the auto-covariance of the prediction error (residuals)
  + *end*
  + Check if any of the autocovariances is "acceptable"
  + Pick the $sigma_omega^2$ with the "best" autocovariances
]

A lot of stuff going on there:

- How do you define an autocovariance as "acceptable"

- How do you compare them to find the best?


For now let's see what the error autocovariance looks like:

#grid(columns: (1fr,1fr),

image("figures/sigma001.png"),

image("figures/sigma1.png")
)

The auto-covariance (like the autocorrelation) has value 1 for lag = 0 and $<1$ for everything else. It's also symmetric.

For clarity I forced the 0-lag to 0 (it will also be useful later when calculating the norm).

A signal is a white-noise if the autocorrelation is 0 for every lag value different from 0. This is unreasonable in the real world so a generally accepted whiteness test usually checks if the autocorrelation is bounded betwen $plus.minus 0.2$ for lags different from 0.


- For $sigma^2 = 0.01$ we can see how the Kalman Filter does a bad job at predicting, with an almost flat autocovariance.

- For $sigma^2 = 1$ the quality improves but it's still not acceptable.

We can plot the results in between:

#image("figures/sigmaLandscape.png")

We see that at around  $sigma^2 = 0.1$ the shape is almost flat:

#image("figures/optimalSigma.png")

This indicates that our Kalman Filter is able to extract as much information as possible from the data for this specific Q.

We can further optimize it by calculating the L2 norm of the residuals and picking the lowest value.

#image("figures/optimalL2.png")

Repeating this for multiple dataset we see that the "optimal" $sigma^2$ doesn't change that much.

#grid(columns: (1fr,1fr),

image("figures/optimalM0.png"),

image("figures/optimalM1.png")

)

But we still have a small difference between motors.

This was expected due to the effects noticed while experimenting (drifting).

=== Example of Kalman Filter with optimal Q:

#image("figures/optimalFilter.png")