const rgui = @import("raygui");
const rl = @import("raylib");

const scale = 1.0;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 450;
    const screenHeight = 1000;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    //
    rgui.setStyle(rgui.Control.default, rgui.ControlOrDefaultProperty{ .default = .text_size }, 28);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        _ = rgui.label(.{ .height = 120.0, .width = 150.0, .x = 60.0, .y = 100.0 }, "Your Goals");

        //----------------------------------------------------------------------------------
    }
}
