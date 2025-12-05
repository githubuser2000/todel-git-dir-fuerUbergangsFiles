const std = @import("std");

const LOG_FILE = "/home/dein_user/clipboard.log";
const INTERVAL_MS = 2000;

fn getClipboard(allocator: *std.mem.Allocator) ![]u8 {
    var gpa = std.process.Process.spawn(.{
        .argv = &[_][]const u8{"wl-paste", "-n"},
        .stdout_behavior = .Capture,
    }) catch return error("Failed to spawn wl-paste");

    const result = gpa.stdout.readToEndAlloc(allocator) catch return error("Failed to read stdout");
    try gpa.wait();
    return std.mem.trimRight(result, "\n\r");
}

fn sha256Hash(allocator: *std.mem.Allocator, input: []const u8) ![]u8 {
    var hasher = std.crypto.hash.sha256.init();
    hasher.update(input);
    const hash = hasher.final(allocator) catch return error("SHA256 failed");
    return hash;
}

fn logClipboard(content: []const u8) !void {
    const now = std.time.milliTimestamp();
    var file = try std.fs.cwd().openFile(LOG_FILE, .{ .write = true, .append = true, .create = true });
    defer file.close();

    try file.writeAll("[" ++ std.fmt.allocPrint("{}\n", .{now}) catch "timestamp error");
    try file.writeAll(content);
    try file.writeAll("\n\n");
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var lastHash: []u8 = &[_]u8{0} ** 32; // initial dummy hash

    while (true) {
        const content = try getClipboard(allocator);
        if (content.len != 0) {
            const currentHash = try sha256Hash(allocator, content);
            if (!std.mem.eql(u8, lastHash, currentHash)) {
                try logClipboard(content);
                std.debug.print("Neuer Clipboard-Inhalt geloggt: {s}...\n", .{std.mem.slice(content, 0, std.math.min(content.len, 30))});
                allocator.free(lastHash);
                lastHash = currentHash;
            } else {
                allocator.free(currentHash);
            }
        }
        std.time.sleep(std.time.millisecond * INTERVAL_MS);
    }
}

fn error(msg: []const u8) !void {
    std.debug.print("Fehler: {s}\n", .{msg});
    return error.Unexpected;
}

