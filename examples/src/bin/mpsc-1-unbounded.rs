use rand::random;
use std::sync::mpsc;

fn main() {
    let (sender, receiver) = mpsc::channel();

    std::thread::scope(|scp| {
        scp.spawn(move || {
            for _ in 0..10 {
                let value = random::<u32>() % 10;
                println!("Producer: sending {value}");
                sender.send(value).unwrap();
            }
        });
        scp.spawn(|| {
            let value = receiver.recv().unwrap();
            println!("Consumer: received {value}");

            for value in receiver {
                println!("Consumer: received {value}");
            }
        });
    });
}
