fn main() {
    let (a, b) = (3, 4);
    let (mut sum, mut product) = (0, 0);

    // `spawn` can't guarantee it won't use `sum`, `a` and `b` after
    // they are no longer accessible/valid.
    // Even if it was `join`ed, the compiler doesn't know about it.
    std::thread::spawn(|| sum = a + b);
    std::thread::spawn(|| product = a * b);

    println!("sum = {sum}, product = {product}");
}
