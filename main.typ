#import "typst-slides/slides.typ": *
#import "typst-slides-unipd/unipd.typ": *

#set text(font: "New Computer Modern Sans")

#show: slides.with(
  title: "Concurrency in Rust",
  authors: "Giacomo Stevanato",
  date: "June 2023",
  aspect-ratio: "4-3",
  theme: unipd-theme(),
)

#slide(theme-variant: "title slide")


#new-section("Language design")

#slide(title: "History")[
  Developed at Mozilla
  
  Used in Servo, an "experimental parallel browser engine"

  Goals:
  - Replacement for C/C++
  - Safe
  - Performant
  - Modern
]

#slide(title: "Distinguishing features")[
  - Ownership
    - Affine types
  - Borrowing
    - Mutually exclusive sharing and mutability
  - `Send` and `Sync`
    - compile time checked concurrency TODO
]


#new-section("Standard Library")

#slide[
  - Threads
  - `Mutex`, `RwLock`, `CondVar`, atomics
  - Mpsc channels
]

#slide(title: "Threads")[
  - OS threads by default
  - Lifetimes checked
  - 
]

// TODO: Multiple slides for this?
