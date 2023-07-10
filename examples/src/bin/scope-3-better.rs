use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let (sum, product) = std::thread::scope(|scp| {
        // `spawn` returns a handle that can be `join`ed to
        // get the thread result. This is better than uselessly
        // mutating values.
        let sum = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a + b
        });

        let product = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a * b
        });

        // `scope` can also return values.
        (sum.join().unwrap(), product.join().unwrap())
    });
    println!("sum = {sum}, product = {product}");
}
