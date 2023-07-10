use std::time::Duration;

use rand::random;
use tokio::select;
use tokio::sync::mpsc;

// `current_thread` doesn't even spawn new threads
#[tokio::main(flavor = "current_thread")]
async fn main() {
    // In `tokio` `unbounded_channel` creates an unbounded channel,
    // while `channel` creates a bounded one.
    let (sender1, mut receiver1) = mpsc::unbounded_channel();
    tokio::spawn(async move {
        tokio::time::sleep(Duration::from_millis(250)).await;
        // Sending to an unbounded channel is always immediate
        // no `.await` needed.
        sender1.send("First channel").unwrap();
    });

    let (sender2, mut receiver2) = mpsc::channel(2);
    tokio::spawn(async move {
        tokio::time::sleep(Duration::from_millis(250)).await;
        // Sending to a bounded channel can block, so it needs
        // to `.await`
        sender2.send("Second channel").await.unwrap();
    });

    let some_future = async {
        // 251 milliseconds because the two `send`
        // will always finish executing last.
        tokio::time::sleep(Duration::from_millis(251)).await;
        "Some future"
    };

    // Yield to give the other task a change to execute.
    tokio::task::yield_now().await;

    // Select implements non-deterministic choice.
    let winner = select! {
        // We can wait for the result of each channel,
        // and even require a specific pattern to match.
        // `Some(value)` requires the channel to not be empty and closed.
        Some(value) = receiver1.recv() => value,
        Some(value) = receiver2.recv() => value,
        // We can even select on some arbitrary `Future`, not just receivers and add additional conditions.
        value = some_future, if random::<bool>() => value,
        // We can also add a default branch that will match if no other
        // branch matched after fully evalutating.
        else => "Nobody",
    };

    println!("{winner}");
}
