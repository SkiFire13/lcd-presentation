use std::thread::sleep;
use std::time::{Duration, Instant};

fn main() {
    let now = Instant::now();

    let (a, b) = (3, 4);
    let (mut sum, mut product) = (0, 0);

    std::thread::spawn(|| {
        sleep(Duration::from_secs(1));
        sum = a + b;
    });

    std::thread::spawn(|| {
        sleep(Duration::from_secs(1));
        product = a * b;
    });

    println!("sum = {sum}, product = {product}");

    println!("Took {:?}", now.elapsed());
}
