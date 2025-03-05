// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#import "helper.typ": *
#let project(title: "", authors: (), group: "", watermark: "", body) = {
  // Set the document's basic properties.
  set document(author: group, title: title)
  set page(
    numbering: "1", 
    number-align: center,
    header: [
    #set text(8pt)
    #smallcaps[#group]
    #h(1fr) 
    #context [ 
      #if here().page() > 1 [
        #title
      ] else [ Compiled at
        #datetime.today().display("[day]/[month repr:short]/[year] ")
      ]
  ]
  
  ],
  foreground: rotate(-60deg,
  text(90pt, fill: rgb(200, 27, 30,30))[
    *#watermark*
  ]
)
  )
  set math.equation(numbering: "1.")
  // Save heading and body font families in variables.
  let body-font = "New Computer Modern"
  let sans-font = "New Computer Modern Sans"

  // Set body font family.
  set text(font: body-font, lang: "en")
  show math.equation: set text(weight: 400)
  show heading: set text(font: sans-font)

  // Title row.
  align(center)[
    #block(text(font: sans-font, weight: 700, 1.75em, title))
  ]

  // Main body.
  set par(justify: true)

  body
}