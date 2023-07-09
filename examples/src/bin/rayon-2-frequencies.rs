use rand::distributions::{Alphanumeric, DistString};
use rand::Rng;
use rayon::prelude::*;
use std::collections::HashMap;
use std::time::Instant;

fn count_words_sequential(strings: &[String]) -> HashMap<&str, usize> {
    strings
        .iter()
        .flat_map(|string| string.split_whitespace())
        .fold(HashMap::new(), |mut counts, word| {
            *counts.entry(word).or_insert(0) += 1;
            counts
        })
}

fn count_words_parallel(strings: &[String]) -> HashMap<&str, usize> {
    strings
        .par_iter()
        .flat_map_iter(|string| string.split_whitespace())
        .fold(HashMap::new, |mut counts, word| {
            *counts.entry(word).or_insert(0) += 1;
            counts
        })
        .reduce(HashMap::new, |mut map1, map2| {
            for (word, count) in map2 {
                *map1.entry(word).or_insert(0) += count;
            }
            map1
        })
}

fn random_word(max_length: usize) -> String {
    let mut rng = rand::thread_rng();
    let length = rng.gen_range(2..=max_length);
    Alphanumeric.sample_string(&mut rng, length)
}

fn random_words(words: usize, max_length: usize) -> String {
    (0..words)
        .flat_map(|_| [String::from(" "), random_word(max_length)])
        .skip(1)
        .collect()
}

fn time<T>(f: impl FnOnce() -> T) -> T {
    let now = Instant::now();
    let result = f();
    println!("Took {:?}", now.elapsed());
    result
}

fn main() {
    let strings = (0..100_000)
        .map(|_| random_words(100, 4))
        .collect::<Vec<_>>();

    time(|| count_words_sequential(&strings));
    time(|| count_words_parallel(&strings));
}
