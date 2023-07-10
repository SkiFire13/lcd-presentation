#[allow(unused_imports)]
use rayon::prelude::*;
use std::thread::sleep;
use std::time::Duration;

fn main() {
    let mut some_numbers = (0..10)
        .into_par_iter()
        .map(|n| {
            sleep(Duration::from_millis(250));
            n + 1
        })
        .collect::<Vec<_>>();

    println!("{some_numbers:?}");

    some_numbers.par_iter_mut().for_each(|n| {
        sleep(Duration::from_millis(250));
        *n *= 2;
    });

    println!("{some_numbers:?}");
}
