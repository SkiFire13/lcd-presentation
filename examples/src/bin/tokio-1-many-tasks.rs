use std::time::Duration;

#[tokio::main]
async fn main() {
    // We can spawn lot of tasks, if we tried with with threads
    // it would use >100GB of RAM
    for _ in 0..100_000 {
        tokio::spawn(async {
            tokio::time::sleep(Duration::from_secs(1)).await;
        });
    }
}
