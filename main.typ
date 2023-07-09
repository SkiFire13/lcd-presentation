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
  - Separation between exclusive and shared access
  
  - Similar to Read-Write locks, but checked at compile time
  
  - By default exclusivity is required for mutation

  - Shared mutability is allowed by with some restrictions

    - For example: `Mutex`, `RwLock`, `Atomic*`, `RefCell`

  // - TODO: Niko's PHD Thesis?
]

#slide(title: "Lifetimes")[
  - Needed to enforce borrowing

  - Track the scope in which access is granted

  - Can be used by library code to enforce restrictions

  - Special lifetime `'static` lasts until the process stops
]

#slide(title: [ `Send` and `Sync` ])[
  - Traits automatically implemented based on fields

  - `Send` allows moving a value to a different thread

  - `Sync` allows sharing a value between different threads
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
    - creates and detaches a new thread
    - returns a guard that can be `join`ed
  
  - `std::thread::scope`
    - creates a scope that can borrow from the environment
    - provides structured concurrency
    - waits for the the child threads to stop
    - propagates unrecoverable errors
]

// TODO: thread example

#slide(title: "Threads (example)")

#slide(title: [ `Mutex<T>` and `RwLock<T>` ])[
  - Protect data instead of critical regions

  - Acquiring the lock yields a "guard" with access to the data
  
  - Ownership ensures the lock is released
]

#slide(title: "Mpsc channels")[
  - Multiple producers single consumer

  - Always split in sender and receiver halves

  - Two flavours:

    - Unbounded: non-blocking send, blocking receive

    - Bounded: blocking send and receive

  - Support fallible non-blocking and timeout mode

  - No non-deterministic choice

  - Third party libraries have better interfaces
]

// TODO: example code for rest of stdlib

#new-section("Data parallelism")

#slide(title: `rayon`)[
  - Utilities for plain parallelism

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
