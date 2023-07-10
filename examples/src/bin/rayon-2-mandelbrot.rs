use image::{Pixel, Rgb, RgbImage};
use num_complex::Complex;
#[allow(unused_imports)]
use rayon::prelude::*;

fn main() {
    let x0 = -2.5;
    let y0 = -1.;

    let offx = 3.5;
    let offy = 2.;

    let width = 800;
    let height = (width as f64 * offy / offx) as u32;

    let max_iters = 10_000;
    let file_name = "mandelbrot.png";

    let color_in = Rgb([0, 0, 0]);
    let color_out = Rgb([15, 0, 0]);

    let pixels = (0..width * height)
        // .into_par_iter()
        .map(|i| {
            let (px, py) = (i % width, i / width);

            let x = x0 + (offx * px as f64) / width as f64;
            let y = y0 + (offy * py as f64) / height as f64;

            let z = Complex::new(x, y);
            let mut zn = Complex::new(0., 0.);
            let mut iters = 0;

            while zn.norm() <= 2. && iters < max_iters {
                zn = zn * zn + z;
                iters += 1;
            }

            let speed = if iters < max_iters {
                (iters + 1) as f64 - f64::log10(f64::log2(zn.norm())) / max_iters as f64
            } else {
                0.
            };

            color_in.map2(&color_out, |s, e| (s as f64 + (e - s) as f64 * speed) as u8)
        })
        .flat_map(|Rgb(components)| components)
        .collect();

    let image = RgbImage::from_vec(width, height, pixels).expect("Couldn't create image");

    image.save(file_name).expect("Couldn't save file");
}
