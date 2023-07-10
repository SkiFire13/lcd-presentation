#[allow(unused_imports)]
use rayon::prelude::*;
use std::thread::sleep;
use std::time::Duration;

fn main() {
    // `into_par_iter` can be used to convert some value
    // into a parallel iterator.
    // It will then execute the `map` in parallel.
    let mut some_numbers = (0..10)
        .into_par_iter()
        .map(|n| {
            sleep(Duration::from_millis(250));
            n + 1
        })
        .collect::<Vec<_>>();

    println!("{some_numbers:?}");

    // We can even safely mutate values in parallel, since
    // `par_iter_mut` guarantees each value to only be accessed once.
    some_numbers.par_iter_mut().for_each(|n| {
        sleep(Duration::from_millis(250));
        *n *= 2;
    });

    println!("{some_numbers:?}");
}
