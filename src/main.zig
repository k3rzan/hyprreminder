const std = @import("std");
const rl = @import("raylib");
const ui = @import("ui.zig");
const httpz = @import("httpz");

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

    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // const alloc = arena.allocator();
    // defer arena.deinit();

    const address = try std.net.Address.parseIp("127.0.0.1", 3000);
    var server = try std.net.Address.listen(address, .{ .reuse_address = true });
    defer server.deinit();

    _ = try std.Thread.spawn(.{}, listener, .{&server});
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.light_gray);

        rl.drawText("hello world", ui.base_size, ui.base_size, ui.base_size * 3.0, .gray);

        category.render();
    }
}

const MAX_BUF = 1024;
fn accept(conn: std.net.Server.Connection) !void {
    defer conn.stream.close();

    std.log.info("Got new client({any})!", .{conn.address});

    var read_buffer: [MAX_BUF]u8 = undefined;
    var server = std.http.Server.init(conn, &read_buffer);
    while (server.state == .ready) {
        var request = server.receiveHead() catch |err| switch (err) {
            error.HttpConnectionClosing => return,
            else => return err,
        };

        var ws: std.http.WebSocket = undefined;
        var send_buf: [MAX_BUF]u8 = undefined;
        var recv_buf: [MAX_BUF]u8 align(4) = undefined;

        if (try ws.init(&request, &send_buf, &recv_buf)) {
            serveWebSocket(&ws) catch |err| switch (err) {
                error.ConnectionClose => {
                    std.log.info("Client({any}) closed!", .{conn.address});
                    break;
                },
                else => return err,
            };
        } else {
            try serveHTTP(&request);
        }
    }
}

fn serveHTTP(request: *std.http.Server.Request) !void {
    try request.respond(
        "Hello World from Zig HTTP server",
        .{
            .extra_headers = &.{
                .{ .name = "custom header", .value = "custom value" },
            },
        },
    );
}

fn serveWebSocket(ws: *std.http.WebSocket) !void {
    try ws.writeMessage("Message from zig", .text);
    while (true) {
        const msg = try ws.readSmallMessage();
        try ws.writeMessage(msg.data, msg.opcode);
    }
}

fn listener(server: *std.net.Server) void {
    while (true) {
        const conn = server.accept() catch |err| {
            std.log.err("failed to accept connection: {s}", .{@errorName(err)});
            continue;
        };
        _ = std.Thread.spawn(.{}, accept, .{conn}) catch |err| {
            std.log.err("unable to spawn connection thread: {s}", .{@errorName(err)});
            conn.stream.close();
            continue;
        };
    }
}

// fn getUser(req: *httpz.Request, res: *httpz.Response) !void {
//     res.status = 200;
//     try res.json(.{ .id = req.param("id").?, .name = "Teg" }, .{});
// }
