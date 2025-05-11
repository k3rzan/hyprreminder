const rgui = @import("raygui");
const rl = @import("raylib");

const scale = 1.0;

pub fn main() anyerror!void {
    const screenWidth = 450;
    const screenHeight = 1000;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rgui.setStyle(rgui.Control.default, rgui.ControlOrDefaultProperty{ .default = .text_size }, 28);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        _ = rgui.label(.{ .height = 120.0, .width = 150.0, .x = 60.0, .y = 100.0 }, "Your Goals");
    }
}
