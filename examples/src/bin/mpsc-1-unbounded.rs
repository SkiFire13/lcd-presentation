use rand::random;
use std::sync::mpsc;

fn main() {
    let (sender, receiver) = mpsc::channel();

    let sender_handle = std::thread::spawn(move || {
        std::thread::yield_now();
        for _ in 0..10 {
            let value = random::<u32>() % 10;
            println!("Producer: sending {value}");
            sender.send(value).unwrap();
        }
    });

    let receiver_handle = std::thread::spawn(move || {
        std::thread::yield_now();

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

    // When main ends all the threads are stopped, so join the handles.
    sender_handle.join().unwrap();
    receiver_handle.join().unwrap();
}
