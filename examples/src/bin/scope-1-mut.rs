use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let (mut sum, mut product) = (0, 0);

    std::thread::scope(|scp| {
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            // From the scoped threads we can access and even mutate
            // values in the original thread.
            // The compiler will check that only one thread can do
            // this at any point in time.
            sum = a + b;
        });
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            product = a * b;
        });
    });

    println!("sum = {sum}, product = {product}");
}
