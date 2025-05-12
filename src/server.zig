const std = @import("std");

pub fn initServer() void{
    std.http.Client.connect(client: *Client, host: []const u8, port: u16, protocol: Connection.Protocol)
}
