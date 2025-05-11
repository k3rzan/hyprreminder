const std = @import("std");
const rl = @import("raylib");
const ui = @import("ui.zig");

pub fn main() anyerror!void {
    const screenWidth = 450;
    const screenHeight = 1000;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    const text = ui.Font{
        .color = .dark_gray,
        .size = 16,
        .value = "This is a note",
    };

    const note = ui.Note().init(
        text,
        .{ .x = ui.base_size, .y = ui.base_size * 4 },
        .{ .h = ui.base_size * 5, .w = screenWidth - ui.base_size * 2 },
        .gray,
    );

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.light_gray);

        rl.drawText("hello world", ui.base_size, ui.base_size, ui.base_size * 2.0, .gray);

        note.render();
    }
}
