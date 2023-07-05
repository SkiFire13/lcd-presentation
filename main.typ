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

  First stable version released in 2015
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

  - Used to handle deallocation and release of resources
]

#slide(title: "Borrowing")[
  - Separation between exclusive and shared access
  
  - Similar to Read-Write locks, but checked at compile time
  
  - By default exclusivity is required for mutation

  - Shared mutability is allowed by with some restrictions

    - For example: `Mutex`

  // - TODO: Niko's PHD Thesis?
]

#slide(title: "Lifetimes")[
  - Needed to enforce borrowing

  - Track the scope in which access is granted

  - Can be used by library code to enforce restrictions
]

#slide(title: [ `Send` and `Sync` ])[
  - Traits automatically implemented based on fields

  - `Send` allows sending a value to a different thread

  - `Sync` allows sharing a value between different threads
]

#new-section("Standard Library")

#slide[
  - Threads
  
  - `Mutex`, `RwLock`, `CondVar`, atomics, etc etc
  
  - Mpsc channels
]

#slide(title: "Threads")[
  - Heavy OS threads
  
  - `std::thread::spawn`
    - creates and detaches a new thread
  
  - `std::thread::scope`
    - creates a scope that can borrow from the environment
    - provides structured concurrency (partially)
    - ends when the child threads end
    - propagate unrecoverable errors
]

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
  impl<'scp, 'env> Scope<'scp, 'env> {
      pub fn spawn<F, T>(&'scp self, f: F)
          -> ScopedJoinHandle<'scp, T>
      where
          F: FnOnce() -> T + Send + 'scp,
          T: Send + 'scp,
  }
  ```
]

#slide(title: [ `Mutex` and `RwLock` ])[
  - Protect data instead of critical regions

  - Acquiring the lock yields a "guard" with access to the data
  
  - Ownership ensures the lock is released
]

#slide(title: "Mpsc channels")[
  - A bit lacking

    - No multiple consumers

    - No non-deterministic choice

  - Multiple libraries extend them with better interface
]

// TODO: example code for all stdlib

#slide(title: "Data parallelism")[
  - `rayon`
  
    - provides convient API for data parallelism
  
    - iterators guarantee disjoint access
  
    - with thread pooling and work stealing
]

// TODO: example code
