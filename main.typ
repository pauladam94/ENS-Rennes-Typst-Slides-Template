#import "slides.typ": *

#let test = 5

#show: slides.with(
  title: "Big Nice And Long Title",
  short-title : "Short Title",
  subtitle: "sub title",
  authors: "Author Jean Robert Kennedy",
  short-authors: "Author J. R. K.",
  // date: datetime.today(),
  date: "5th May 1789",
  color-accentuation : (
    eastern,
    blue,
    teal,
    navy
  ),
)

#set text(font: "Fira Code", size: 18pt)
#set list(marker: ([->], [--]))


#slide(type: "title")

#slide(type: "outline")

#section("What is Ground ?")

#slide(title: "What is Ground?")[

    Everithing in one slide
  
    - First Point
    
    - Second Point
    
    - Third Point
]

#slide(title: "What is Ground?")[
  One Slide after an another
][
  - First Point
][
  - Second Point
][
  - Third Point
]
