// spec-template.typ

#let doc_name = [$if(doc_name)$$doc_name$$else$Untitled Specification$endif$]
#let doc_id = [$if(doc_id)$$doc_id$$else$N/A$endif$]
#let revision = [$if(revision)$$revision$$else$N/A$endif$]

#set document(title: doc_name)

#set text(
  size: 11pt,
  font: "$if(mainfont)$$mainfont$$else$Arial$endif$",
)

#set par(
  justify: true,
  spacing: 0.65em,
)

// Use enough numbering depth for ###### clauses.
#set heading(numbering: "$if(section-numbering)$$section-numbering$$else$1.1.1.1.1.1$endif$")

// ------------------------------------------------------------
// Heading / clause formatting
// ------------------------------------------------------------
//
// #      -> bold, slightly larger
// ##     -> bold, 11pt
// ###    -> bold, 11pt
// ####   -> bold, 11pt
// #####  -> bold, 11pt
// ###### -> regular, 11pt, used as numbered spec paragraph / clause
//
// Each level is indented a bit more.
//
#let heading-indent(level) = 1.1em * (level - 1)

#let normal-heading-above = 0.65em
#let normal-heading-below = 0.35em

#show heading: it => {
  let level = it.level
  let is_clause = level == 6

  let size = if level == 1 {
    13pt
  } else {
    11pt
  }

  let weight = if level == 1 {
    "bold"
  } else {
    "regular"
  }

  let above = if level == 1 {
    1.0em
  } else {
    normal-heading-above
  }

  let below = normal-heading-below
  let indent = heading-indent(level)

  block(
    sticky: true,
    above: above,
    below: below,
  )[
    #pad(left: indent)[
      #text(size: size, weight: weight)[
        #context counter(heading).display()
        #h(0.8em)
        #it.body
      ]
    ]
  ]
}

// ------------------------------------------------------------
// Header / footer
// ------------------------------------------------------------

#let spec_header = [
  #grid(
    columns: (1fr, 3fr),
    column-gutter: 12pt,
    align: (left, right),
    [
      $if(logo)$
      #image("$logo$", height: 24pt)
      $endif$
    ],
    [
      #text(size: 10pt, weight: "bold")[#doc_name] \
      #text(size: 8pt)[Document ID: #doc_id #h(1em) Revision: #revision]
    ],
  )
  #v(2pt)
  #line(length: 100%, stroke: 0.5pt)
]

#let spec_footer = context [
  #line(length: 100%, stroke: 0.5pt)
  #grid(
    columns: (1fr, auto),
    [
      #text(size: 8pt)[#doc_id · Rev #revision]
    ],
    [
      #text(size: 8pt)[Page #counter(page).display("1 / 1", both: true)]
    ],
  )
]

#set page(
  paper: "$if(papersize)$$papersize$$else$a4$endif$",
  margin: (
    top: 28mm,
    bottom: 20mm,
    left: 20mm,
    right: 20mm,
  ),
  header: spec_header,
  footer: spec_footer,
)

// ------------------------------------------------------------
// Title block
// ------------------------------------------------------------

#align(center)[
  #text(size: 18pt, weight: "bold")[#doc_name]
  #v(8pt)
  #text(size: 10pt)[Document ID: #doc_id]
  #linebreak()
  #text(size: 10pt)[Revision: #revision]
]

#v(2em)



// ------------------------------------------------------------
// Table of contents
// ------------------------------------------------------------

$if(toc)$
#outline(
  title: [Table of Contents],
  depth: $if(toc-depth)$$toc-depth$$else$5$endif$,
)

$endif$


// ------------------------------------------------------------
// Signature table
// ------------------------------------------------------------

#text(size: 12pt, weight: "bold")[Signatures]
#v(0.5em)

#table(
  columns: (1.3fr, 1.3fr, 1.8fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt,

  table.header(
    [*Name*],
    [*Function*],
    [*Signature*],
    [*Date*],
  ),

$if(signatures)$
$for(signatures)$
  [$signatures.name$],
  [$signatures.function$],
  [$signatures.signature$],
  [$signatures.date$],
$endfor$
$else$
  [], [Originator], [], [],
  [], [Reviewer], [], [],
  [], [Approver], [], [],
$endif$
)

#v(2em)

// ------------------------------------------------------------
// Main document body
// ------------------------------------------------------------

$body$

#v(2em)

// ------------------------------------------------------------
// Revision history table
// ------------------------------------------------------------

#text(size: 12pt, weight: "bold")[Revision History]
#v(0.5em)

#table(
  columns: (0.6fr, 1fr, 2.5fr, 1.2fr),
  inset: 6pt,
  stroke: 0.5pt,

  table.header(
    [*Rev*],
    [*DCO*],
    [*Change Description*],
    [*Originator*],
  ),

$if(revision_history)$
$for(revision_history)$
  [$revision_history.rev$],
  [$revision_history.dco$],
  [$revision_history.change$],
  [$revision_history.originator$],
$endfor$
$else$
  [A], [], [Initial release], [],
$endif$
)
