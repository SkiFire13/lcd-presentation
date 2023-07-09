use std::sync::Mutex;
use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let results = Mutex::new(Vec::new());

    std::thread::scope(|scp| {
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            results.lock().unwrap().push(a + b)
        });
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            results.lock().unwrap().push(a * b)
        });
    });

    println!("results = {:?}", results.into_inner().unwrap());
}
