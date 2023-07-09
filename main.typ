#import "typst-slides/slides.typ": *
#import "typst-slides-unipd/unipd.typ": *

#set text(font: "New Computer Modern Sans")

#show: slides.with(
  title: "Concurrency in Rust",
  authors: "Giacomo Stevanato",
  date: "July 2023",
  aspect-ratio: "4-3",
  theme: unipd-theme(),
)

#slide(theme-variant: "title slide")


#new-section("Language design")

#slide(title: "History")[
  - Created at Mozilla
  
  - Developed for Servo, an "experimental parallel browser engine"

  - Safer and modern replacement for C/C++

  - Version 1.0 released in 2015

  - Version 1.70 in June 2023
]

#slide(title: "Why Rust?")[
  - Safe

  - Strong type system

  - Performant

  - Thin abstractions over hardware and OS

  - Modern (no null, type inference, ...)

  - Functional features (union types, pattern matching, ...)
]

// TODO: thin abstraction -> no runtime for concurrency -> only parallelism

#slide(title: "Core concepts")[
  - Ownership
  
  - Borrowing
  
  - Lifetimes

  - `Send` and `Sync`
]

#slide(title: "Ownership")[
  - Affine types or move semantics
  
  - A value can be "consumed" *at most* once

  - Used to handle deallocation and release of resources

  // TODO: Example of move error?
]

#slide(title: "Borrowing")[
  - *Shared* (`&`) vs *Exclusive* (`&mut`) access
  
  - Like compile time Read-Write locks
  
  - Only exclusivity allows mutation

  - Shared mutability allowed but restricted

    - For example: `Mutex`, `RwLock`, `Atomic*`, `RefCell`

  // - TODO: Niko's PHD Thesis?
]

#slide(title: "Lifetimes")[
  - Track the *scope* in which access is granted

  - Functions can use them to enforce restrictions

  - Special lifetime `'static` lasts until the process stops
]

#slide(title: [ `Send` and `Sync` ])[
  - Traits automatically implemented

  - `Send` allows *moving* a value to a different thread

  - `Sync` allows *sharing* a value between different threads
]

#new-section("Standard Library")

#slide[
  - Threads
  
  - `Mutex`, `RwLock`
  
  - Mpsc channels

  - `Atomic*`
  
  - `CondVar`, `Once`, `OnceLock`, `Barrier`, etc etc
]

#slide(title: "Threads")[
  - Heavy OS threads
  
  - `std::thread::spawn`
    
    - creates a new detached thread

  - `std::thread::scope`

    - can borrow from the environment
    
    - structured concurrency
]

// TODO: thread example

#slide(title: [ `Mutex<T>` and `RwLock<T>` ])[
  - Protect data instead of critical regions

  - Acquiring the lock yields a "guard" with access to the data
  
  - Ownership ensures the lock is released
]

#slide(title: "Mpsc channels")[
  - Multiple producers single consumer

  - Split in `Sender` and `Receiver`

  - Two flavours:

    - Unbounded: non-blocking send, blocking receive

    - Bounded: blocking send and receive

  - Fallible non-blocking and timeout mode

  - No non-deterministic choice
]

// TODO: example code for rest of stdlib

#new-section("Data parallelism")

#slide(title: `rayon`)[
  - Thread pooling and work stealing

  - Fork-join

  - Scope (predates the stdlib one)

  - Parallel iterators
]

// TODO: example code for rayon

#new-section("Async")

#slide(title: `async`)[
  - Alternative to lightweight threads

  - Concurrency without parallelism

  - Transform sequential code to a state machine

  - Poll-based design

  - Many details left to third party libraries

  // TODO: cooperative, non-blocking

  // TODO: Problem of missing structured concurrency + lifetimes?
]

#slide(title: `tokio`)[
  - Most used async runtime

  - Add replacements for common non-`async` APIs

  - Lot of concurrency primitives as well

  // TODO: JoinSet

  // TODO: anything else?
]

// TODO: previous examples but in tokio
// TODO: comparison when lot of threads? (Be careful pc doesn't explode)
// TODO: example of using `join` and `select`

// TODO: producer-consumer

#new-section("Other models")

#slide(title: "Actor model")[
  - `actix` implements the actor model
]

// TODO: small example (?)
