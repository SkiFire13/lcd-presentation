use rand::random;
use std::sync::mpsc;

fn main() {
    // Bounded channels are created using `sync_channel`.
    // Note that the given value is just a lower bound.
    //
    // The name comes from a historical flaw in the API of `channel`
    // (that is, `Sender` from `channel` is not `Sync`).
    // The rest of the API is the same as `channel`.
    let (sender, receiver) = mpsc::sync_channel(2);

    // Scope is still cleaner compared to `std::thread::spawn`.
    std::thread::scope(|scp| {
        scp.spawn(move || {
            for _ in 0..10 {
                let value = random::<u32>() % 10;
                println!("Producer: sending {value}");
                sender.send(value).unwrap();
            }
        });
        scp.spawn(move || {
            let value = receiver.recv().unwrap();
            println!("Consumer: received {value}");

            if let Ok(value) = receiver.try_recv() {
                println!("Consumer: immediately received {value}");
            } else {
                println!("Consumer: no value was ready");
            }

            for value in receiver {
                println!("Consumer: received {value}");
            }
        });
    });
}
