use std::sync::Mutex;
use std::thread::sleep;
use std::time::Duration;

fn main() {
    let (a, b) = (3, 4);
    let results = Mutex::new(Vec::new());

    std::thread::scope(|scp| {
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            // `lock` can fail if a thread previously `panic`ed
            // while holding the lock.
            // In the "ok" case it returns a handle that dereferences
            // to the protected value (the `Vec` in this case).
            results.lock().unwrap().push(a + b)
        });
        scp.spawn(|| {
            sleep(Duration::from_secs(1));
            results.lock().unwrap().push(a * b)
        });
    });

    // Here we have full ownership of the lock, so we can consume it,
    // getting back the inner value, safely and without acquiring the lock.
    println!("results = {:?}", results.into_inner().unwrap());
}
