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
        .size = 24,
        .value = "This is a title",
    };

    var notes = [_][:0]const u8{
        "this is a test",
        "this is another test",
        "this is another test",
        "this is another test",
    };
    var category = try ui.Category().init(notes[0..], text, .{ .x = ui.base_size, .y = ui.base_size * 5 });
    defer category.deinit();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.light_gray);

        rl.drawText("hello world", ui.base_size, ui.base_size, ui.base_size * 3.0, .gray);

        category.render();
    }
}
