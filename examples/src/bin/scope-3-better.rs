use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let (sum, product) = std::thread::scope(|scp| {
        // `spawn` returns a handle that can be `join`ed to
        // get the thread result. This is better than uselessly
        // mutating values.
        let sum_handle = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a + b
        });

        let product_handle = scp.spawn(|| {
            sleep(Duration::from_secs(1));
            a * b
        });

        // `scope` can also return values.
        (sum_handle.join().unwrap(), product_handle.join().unwrap())
    });
    println!("sum = {sum}, product = {product}");
}
