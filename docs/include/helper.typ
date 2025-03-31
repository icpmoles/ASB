#let nb(body, title: "NB") = {
  rect(
    inset: 8pt,
    stroke: 2pt,
    radius: 5pt,
    [*#title*: #h(1fr) \ #body],
  )
}

#let FillCell = box(width: 1fr, repeat[ ])
