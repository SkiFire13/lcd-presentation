use actix::prelude::*;

#[derive(Default)]
pub struct Server {
    count: u32,
}

impl Actor for Server {
    type Context = Context<Self>;
}

#[derive(Message)]
#[rtype(result = "i32")]
pub enum AddMul {
    Add(i32, i32),
    Mul(i32, i32),
}

// Messages can be enums with different variants
impl Handler<AddMul> for Server {
    type Result = i32;

    fn handle(&mut self, msg: AddMul, _ctx: &mut Self::Context) -> Self::Result {
        match msg {
            AddMul::Add(x, y) => x + y,
            AddMul::Mul(x, y) => x * y,
        }
    }
}

#[derive(Message)]
#[rtype(result = "u32")]
pub struct Count;

// But we can also implement `Handler` with different message types
impl Handler<Count> for Server {
    type Result = u32;

    fn handle(&mut self, _msg: Count, _ctx: &mut Self::Context) -> Self::Result {
        // We can access and mutate the state of the actor when
        // handling messages.
        self.count += 1;
        self.count
    }
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Panic;

impl Handler<Panic> for Server {
    type Result = ();

    fn handle(&mut self, _msg: Panic, _ctx: &mut Self::Context) -> Self::Result {
        panic!()
    }
}

#[actix::main]
async fn main() {
    let addr = Server::start_default();

    match addr.send(AddMul::Add(1, 2)).await {
        Ok(res) => println!("Add: ok {res}"),
        Err(err) => println!("Add: error {err}"),
    }
    match addr.send(AddMul::Mul(6, 7)).await {
        Ok(res) => println!("Mul: ok {res}"),
        Err(err) => println!("Mul: error {err}"),
    }

    match addr.send(Count).await {
        Ok(res) => println!("Count 1: ok {res}"),
        Err(err) => println!("Count 1: error {err}"),
    }
    match addr.send(Count).await {
        Ok(res) => println!("Count 2: ok {res}"),
        Err(err) => println!("Count 2: error {err}"),
    }

    match addr.send(Panic).await {
        Ok(_) => println!("Panic: ok"),
        Err(err) => println!("Panic: error {err}"),
    }
}
