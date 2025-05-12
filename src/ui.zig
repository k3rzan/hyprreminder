const rl = @import("raylib");
const std = @import("std");

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

pub fn Category() type {
    return struct {
        const Self = @This();
        notes: std.ArrayListUnmanaged(Note()),
        title: Font,
        allocator: std.mem.Allocator,
        position: Position,

        pub fn render(self: *Self) void {
            const title_size: f32 = @floatFromInt(self.title.size);
            rl.drawText(self.title.value, @intFromFloat(self.position.x), @intFromFloat(self.position.y), base_size * 2, .dark_gray);
            for (self.notes.items, 0..) |*note, index| {
                const i: f32 = @floatFromInt(index);
                note.size = .{ .h = base_size * 5.0, .w = base_size * 20 };
                note.position = .{ .x = self.position.x, .y = self.position.y + title_size + (i * (@as(f32, @floatFromInt(note.size.h)) + base_size)) + base_size * 1.5 };
                note.render();
            }
        }

        pub fn deinit(_: Self) void {
            std.debug.print("deinited\n", .{});
        }

        pub fn init(note_values: [][:0]const u8, title: Font, position: Position) !Self {
            var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            const allocator = arena.allocator();
            var notes = try std.ArrayListUnmanaged(Note()).initCapacity(allocator, note_values.len);

            for (note_values) |value| {
                try notes.append(
                    allocator,
                    .{
                        .text = .{ .color = .dark_gray, .size = base_size, .value = value },
                        .bg_color = .gray,
                        .position = .{ .x = 0.0, .y = 0.0 },
                        .size = .{ .h = 0.0, .w = 0.0 },
                    },
                );
            }
            return Self{
                .title = title,
                .notes = notes,
                .allocator = allocator,
                .position = position,
            };
        }
    };
}
