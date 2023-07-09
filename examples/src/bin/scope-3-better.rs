use std::thread::sleep;
use std::time::{Duration, Instant};

fn main() {
    let now = Instant::now();

    let (a, b) = (3, 4);
    let (sum, product) = std::thread::scope(|scp| {
        let sum = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a + b
        });
        let product = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a * b
        });
        (sum.join().unwrap(), product.join().unwrap())
    });
    println!("sum = {sum}, product = {product}");

    println!("Took {:?}", now.elapsed());
}
