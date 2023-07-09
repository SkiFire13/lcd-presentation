use std::thread::sleep;
use std::time::Duration;

use rayon::prelude::*;

fn main() {
    let result = (0..20)
        .into_par_iter()
        .map(|n| {
            sleep(Duration::from_secs(1));
            n + 1
        })
        .collect::<Vec<_>>();

    println!("{result:?}");
}
