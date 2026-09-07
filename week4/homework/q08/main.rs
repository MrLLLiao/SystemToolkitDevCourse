/// 场景：掷骰子 —— 用 rand 生成 [1,6] 的随机点数
use rand::Rng;

fn roll_dice() -> u32 {
    rand::thread_rng().gen_range(1..=6)
}

fn main() {
    let n = roll_dice();
    println!("掷出点数：{n}");
    if n == 6 {
        println!("大成功！");
    }
}
