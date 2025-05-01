#import "include/template.typ": *
#import "@preview/lovelace:0.3.0": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Todo List",
  authors: (
    "Iacopo Moles",
  ),
  group: "Automatici Strike Back",
  watermark: ""
)

 = Trajectory 

When converting the limits from joint space to taskspace we have the following shape: 

#image("figures/available_taskspace.png")

It's big enough for an 8cm x 8cm square centered at (x,y)= (13.0 , 13.5)cm. (Round number, easier to remember when prototyping). We can obviously make it bigger as long as it's inside the blue dots.

#image("figures/my_figures.png")

(The simple shaped I tested in the last lab)

== Experiment Results

To have an idea of what the CNC is capable of (and what it's not):

#image("figures/lissajous_family.png")
#grid(
  columns: (1fr,1fr),

image("figures/lissajous/pp1.png",width: 100%),
image("figures/lissajous/pp2.png",width: 100%),
image("figures/lissajous/pp3.png",width: 100%),
image("figures/lissajous/pp4.png",width: 100%),
image("figures/lissajous/pp5.png",width: 100%),
image("figures/lissajous/pp6.png",width: 100%)

)

We can see that at $omega = 6 "rad/s"$ (1st row, 2nd column) the distortion starts getting noticeable (controller+plant can't keep up with the desired trajectory).


This was just a simple experiment to have a rough idea of how fast we can go.

#nb(title: "TODO")[

  Try to come up with some neat trajectory to plot with the machine.#footnote([Don't make me do it because before the professor mentioned it, the best I could come up with was "30 & L"])

  We only need a time law for x and y that fits inside the "blue dots"


  #table(columns: (1fr,1fr,1fr),
  [*t*],[*x*],[*y*],
  [0.00],[0.002],[0.0452],
  [0.02],[0.006],[0.0452],
[0.04],[0.023],[0.004],
[0.06],[0.023],[0.072],
[0.08],[0.003],[0.098],
[...],[...],[...]
  )

(random numbers as an example, as long as it's a MATLAB matrix with these 3 components it's ok) 

]


= Advanced Control: MPC


The professor mentioned MPC as a possible advanced topic, unfortunately I'm not familiar with it. So if someone want's to take a shot at it it would be nice. 
