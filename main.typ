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
  Developed at Mozilla
  
  Used in Servo, an "experimental parallel browser engine"

  Goals:
  - Replacement for C/C++
  - Safe
  - Performant
  - Modern
]

#slide(title: "Features")[
  - Ownership
  
  - Borrowing
  
  - Lifetimes

  - `Send` and `Sync`

  - `async`
]

#slide(title: "Ownership")[
  - Affine types or move semantics
  
  - A value can be "consumed" *at most* once
]

#slide(title: "Borrowing")[
  - Distintion between exclusive and shared access
  
  - Mutability needs exclusive access by default
  
  - Inspired by Read-Write locks

  - TODO: Niko's PHD Thesis?
]

#slide(title: "Lifetimes")[
  - Track the scope in which references are valid

  - Neede to enforce borrowing

  - Can be used by library code to enforce restrictions
]

#slide(title: [ `Send` and `Sync` ])[
  - Traits automatically implemented

  - `Send` means a value can be sent to a different thread

  - `Sync` means a value can be shared between different threads
]

#new-section("Standard Library")

#slide[
  - Threads
  
  - `Mutex`, `RwLock`, `CondVar`, atomics
  
  - Mpsc channels
]

#slide(title: "Threads")[
  - OS threads by default
  
  - `std::thread::spawn`
    - creates and detaches a new thread  
    - data captured needs to be `'static`
  
  - `std::thread::scope`
    - creates a scope that can borrow from the environment
    - provides structured concurrency (partially)
]

// TODO: example code

#slide[
  ```rs
  pub fn spawn<F, T>(f: F) -> JoinHandle<T>
  where
      F: FnOnce() -> T + Send + 'static,
      T: Send + 'static,
  ```
  #h(1em)
  ```rs
  pub fn scope<'env, F, T>(f: F) -> T
  where
      F: for<'scp> FnOnce(&'scp Scope<'scp, 'env>) -> T,
  ```
  #h(1em)
  ```rs
  impl<'scope> Scope<'scope> {
      pub fn spawn<F, T>(&'scope self, f: F)
          -> ScopedJoinHandle<'scope, T>
      where
          F: FnOnce() -> T + Send + 'scope,
          T: Send + 'scope,
  }
  ```  
]

#slide(title: "Data parallelism")[
  - `rayon`
  
    - provides convient API for data parallelism
  
    - iterators guarantee disjoint access
  
    - with thread pooling and work stealing
]

// TODO: example code
