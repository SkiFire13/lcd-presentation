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

#slide(theme-variant: "title")


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

  - Fast

  - Thin abstractions over hardware and OS

  - Modern (no null, type inference, traits, ...)

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
  
  - A value can be "consumed"/"moved" *at most once*

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

  - Borrowing ensures you can't forget to use/lock them
]

#slide(title: "Mpsc channels")[
  - Multiple producers single consumer

  - Split in `Sender` and `Receiver`

  - Two flavours:

    - Unbounded: non-blocking send, blocking receive

    - Bounded: blocking send and receive

  - Fallible non-blocking and timeout mode

  - No "guarded sum"
]

// TODO: example code for rest of stdlib

#new-section("Data parallelism")

#slide(title: `rayon`)[
  - Thread pooling and work stealing

  - Fork-join

  - Scope (predates the stdlib one)

  - Parallel iterators
]

#new-section("Async")

#slide(title: `async`)[
  - Alternative to lightweight threads

  - Concurrency without parallelism

  - Cooperative, poll-based, non-blocking

  - Based on the `Future` trait

  - Runtimes and integration left to third party libraries

    - For example: `tokio`, `async-std`, `pollster`, etc etc
]

#slide(title: `tokio`)[
  - Standard async runtime _de facto_

  - Replacement for non-`async` APIs:

    - `AsyncRead`/`AsyncWrite`, `File`s, `TCP`/`UDP`, `sleep`, etc etc

  - Lot of `async` concurrency primitives:

    - `spawn`, `select`, `timeout`, `join`, `channel`, `Mutex`, etc etc
]

// TODO: coffee example
// TODO: example of using `join` and `select`

// TODO: producer-consumer

// TODO: Make list with `timeout`, `join` and other APIs

#new-section("Other")

#slide(title: [ Actor model: `actix` ] )[
  - Built on `async` and `tokio`

  - `Actor` trait for basic lifecycle

    - starting an actor returns its `Addr`

  - `Handler<M>` trait for handling messages

    - supports multiple message types

    - messages can have a response type
]

#slide(theme-variant: "end")[
  Thank you for your attention
]
