#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Cross interactions",
  authors: (
    "Iacopo Moles",
  ),
  group: "PRIVATE",
  watermark: ""
)

= Steady State experiment

#image("figures/mail/scheme.png")
#image("figures/mail/scheme_steady.png")

At steady state:

$ tau_L =beta dot omega_L $

$ tau_L =  K_g dot eta_g dot tau_M = K_g dot eta_g dot eta_m dot  K_t dot I $

$ I = (V - E ) / R = (V - K_m dot omega_m ) / R $

$ beta = ((K_g dot eta_g dot eta_m dot  K_t ))/ omega_L ((V - K_m dot omega_L dot K_g)) / R $

#image("figures/mail/betaoveromega_L.png")

= Steiner Links

$ J_(b,"piv") =  J_(b,"og") + m_b dot (L_b/2)^2 = 3.49e-4  "[Kg m2]" $

= x 25 error

#image("figures/mail/gears.png")

$ J_G = K_"GI"^2 dot J_24 + 2 dot J_72 + J_120 =25 dot J_24 + 2 dot J_72 + J_120 =  5.5242e-05 "[Kg m2]" $



(Row 163)

```matlab
Jg = J24 + 2 * J72 + J120; % 5.2822e-05
```