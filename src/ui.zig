const rl = @import("raylib");

pub const scale = 1.0;
pub const base_size: f32 = 16.0;

pub const Font = struct {
    size: i32,
    value: [:0]const u8,
    color: rl.Color,
};
pub const Size = struct {
    w: i32,
    h: i32,
};
pub const Position = struct {
    x: f32,
    y: f32,
};
pub fn Note() type {
    return struct {
        const Self = @This();
        text: Font,
        bg_color: rl.Color,
        position: Position,
        size: Size,

        pub fn render(self: Self) void {
            rl.drawRectangle(@intFromFloat(self.position.x), @intFromFloat(self.position.y), self.size.w, self.size.h, self.bg_color);
            rl.drawText(self.text.value, @intFromFloat(self.position.x + base_size), @intFromFloat(self.position.y + base_size), self.text.size, self.text.color);
        }

        pub fn init(text: Font, position: Position, size: Size, bg_color: rl.Color) Self {
            return Self{
                .text = text,
                .position = position,
                .size = size,
                .bg_color = bg_color,
            };
        }
    };
}
