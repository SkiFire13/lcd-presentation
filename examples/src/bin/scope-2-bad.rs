use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let mut sum = 0;

    std::thread::scope(|scp| {
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            sum = a + b;
        });
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            sum = a * b;
        });
    });

    println!("sum = {sum}");
}
