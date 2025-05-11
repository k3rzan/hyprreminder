const rl = @import("raylib");

const scale = 1.0;
const base_size = 16.0;

pub fn main() anyerror!void {
    const screenWidth = 450;
    const screenHeight = 1000;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.light_gray);

        rl.drawText("hello world", base_size, base_size, base_size * 2.0, .gray);

        rl.drawRectangle(base_size, base_size * 4, screenWidth - base_size * 2, base_size * 5.0, .gray);
        rl.drawText("New text here", base_size * 2, base_size * 5, base_size, .dark_gray);
    }
}
