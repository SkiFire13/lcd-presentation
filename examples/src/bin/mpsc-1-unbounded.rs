use rand::random;
use std::sync::mpsc;

fn main() {
    // Unbounded channels are created using `channel`.
    // The two halves of the channel are returned in a tuple.
    let (sender, receiver) = mpsc::channel();

    // Channels work nicely with `std::thread::spawn` because they don't need
    // access to the environment.
    let sender_handle = std::thread::spawn(move || {
        // yield just to give a chance to the other thread to start
        std::thread::yield_now();

        for _ in 0..10 {
            let value = random::<u32>() % 10;
            println!("Producer: sending {value}");
            // `send` sends a value to the channel
            sender.send(value).unwrap();
        }
    });

    let receiver_handle = std::thread::spawn(move || {
        std::thread::yield_now();

        // `recv` blocks until a value is available in the channel.
        // returns an error if the channel is empty and no sender exists.
        let value = receiver.recv().unwrap();
        println!("Consumer: received {value}");

        // `try_recv` immediately return a value if it's available
        // otherwise it returns an error.
        if let Ok(value) = receiver.try_recv() {
            println!("Consumer: immediately received {value}");
        } else {
            println!("Consumer: no value was ready");
        }

        // Receivers can be iterated over, yielding all the elements sent
        // until no sender exists anymore.
        for value in receiver {
            println!("Consumer: received {value}");
        }
    });

    // When main ends all the threads are stopped, so join the handles.
    sender_handle.join().unwrap();
    receiver_handle.join().unwrap();
}
