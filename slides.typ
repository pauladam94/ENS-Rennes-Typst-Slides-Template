#let slide-number = counter("slide-number")
#let sections = state("section")
#let global-title = state("title")
#let global-short-title = state("short-title")
#let global-subtitle = state("subtitle")
#let global-authors = state("authors")
#let global-short-authors = state("short-authors")
#let global-date = state("date")
#let global-color-accentuation = state("color-accentuation")
#let global-aspect-ratio = state("aspect-ratio")
#let global-logo-path = state("logo-path")

#let slides(
    title: none,
    short-title: none,
    subtitle: none,
    authors: none,
    short-authors: none,
    date: none,
    color-accentuation : none,
    aspect-ratio: "16-9",
    logo-path: none,
    body
) = {
  set text(
    font: "Fira Code",
    size: 25pt,
  )
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0pt
  )
  global-title.update(title)
  global-short-title.update(short-title)
  global-subtitle.update(subtitle)
  global-authors.update(authors)
  global-short-authors.update(short-authors)
  global-date.update(date)
  global-color-accentuation.update(color-accentuation)
  global-aspect-ratio.update(aspect-ratio)
  global-logo-path.update(logo-path)
  
  body
}

// ||==========SECTION==========||
#let section(
  title,
  level : 1
) = {
  if level < 1 {
    panic("level should be positive")
  }
  sections.update(
    arr => {
      if arr == none {
        ((title: title, level : level),)
      } else {
        arr.push((title: title, level: level))
        arr
      }
    }
  )
}

// ||==========TITLE==========||
#let title-slide(
) = {
  set align(center)
  locate(loc => {
    let body = [
      #text(
        size: 30pt,
        weight: 900,
        global-title.display()) \ \
      #text(
        size: 20pt,
        weight: 500,
        global-subtitle.display())
    ]
    let border = 3mm + global-color-accentuation.at(loc).at(0)
    
    block(
      stroke: (top: border, bottom: border),
      width: 80%,
      inset: 1.5em,
      above: 1fr,
      text(.8em, body)
    )
    // let path = global-logo-path.at(loc)
    let path = "logo-ENS-Rennes.png"
    if path != none {
      image(
        width: 150pt,
        path
      )
    }
    text(global-authors.at(loc) + [ \ ])
    text(14pt,global-date.at(loc))
    v(1fr)
  })
}

// ||==========MAXI-OUTLINE==========||
#let maxi-outline(
) = {
  let marker(level) = {
    if level == 1 [|>] else if level == 2 [->] else [--]
  }
  
  locate(loc => {
    let sections = sections.final(loc)
      list(
        spacing: 50pt,
        marker: [],
        ..sections.map(
          section => {
          box(
            inset : (left: ((section.level - 1)* 80 + 50)*1pt),
            [#marker(section.level) #section.title]
          )
        }
        )
      )
  })
}

// ||==========MINI-OUTLINE==========||
#let mini-outline(
) = {
  locate(loc => {
    let acc = ()
    let current_level = 0
    let arr = sections.at(loc)
    if arr != none {
      for i in range(arr.len() - 1, -1, step: -1) {
        let (title, level) = arr.at(i)
        if i == arr.len() - 1 {
          current_level = level
          acc.push(title)
        } else if current_level == level + 1 {
          acc.push(title)
          current_level = level
        } else if level == 1 {
          acc.push(title)
          break
        }
      }
    }
    for (i,title) in acc.rev().enumerate() {
        [-> #title ]
    }
  })
}

// ||==========HEADER==========||
#let header(
) = {
  locate(loc => {
    let body = [
      #grid(
        columns: (20fr, 6fr, 2fr, 1fr),
        mini-outline(),
        global-title.display(),
        {
        let path = global-logo-path.at(loc)
        if path != none {
        image(
          width: 20pt,
          path
        )
        }
      },
      image(width: 20pt, "logo-ENS-Rennes.png")
      )
    ]
    
    let border = 1mm + global-color-accentuation.at(loc).at(1)
    block(
      stroke: (bottom: border),
      width: 100%,
      inset: .2em,
      align(horizon)[#text(.5em, body)]
    )
  
  })
}


// ||==========FOOTER==========||
#let footer() = {
  locate(loc => {
    let body = [
      #grid(
      columns: (8fr, 8fr, 1fr),
      global-short-authors.display(),
      global-short-title.display(),
      [#slide-number.display() / #slide-number.final(loc).at(0)]
    )
  ]
  let border = 1mm + global-color-accentuation.at(loc).at(2)
  block(
    stroke: (top: border),
    width: 100%,
    inset: .3em,
    text(.5em, body)
  )
  })
}

#let title_show(title) = {
  block(
        inset: (left: 50pt, top: 0pt, bottom: 0pt),
        text(25pt, weight: "black", title)
  )
}

// ||==========SLIDE==========||
#let slide(
  type: none,
  title: none,
  .. bodies
) = {
  slide-number.step()
  if type == "title" and bodies.pos().len() == 0 and title == none { 
    // ||==========TITLE-SLIDE==========||
    title-slide()
    pagebreak()
  } else if type == "outline" and bodies.pos().len() == 0 and title == none {
    // ||==========OUTLINE-SLIDE==========||
    header()
    v(1fr)
    maxi-outline()
    v(2fr)
    footer()
    pagebreak()
  } else if type == none {
    // ||==========NORMAL-SLIDE==========||
    let acc = ()
    for (index, body) in bodies.pos().enumerate() {
      acc.push(body)
      // ||==========HEADER==========||
      header()
      // ||==========TITLE==========||
      title_show(title)
      // ||==========BODY==========||
      block(
        inset: (left: 20pt),
        for acc-body in acc {
        acc-body
        }
      )
      v(1fr)
      // ||==========FOOTER==========||
      footer()
      pagebreak(weak: true)
    }
  } else if (type == "outline" or type == "title") and title != none {
    panic("outline and title slide doesn't have a title" + "")
  } else if (type == "outline" or type == "title")  and bodies.pos().len() != 0 {
    panic("outline and title slide doesn't have a body")
  }
}
