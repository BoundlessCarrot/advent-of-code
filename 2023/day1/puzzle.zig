const std = @import("std");
const ArrayList = std.ArrayList;

const data = @embedFile("input");
const split = std.mem.split;
const isDigit = std.ascii.isDigit;
const charToDigit = std.fmt.charToDigit;

// fn readFile(filename: []const u8, allocator: std.mem.Allocator) ![]const u8 {
//     const file = try std.fs.cwd().openFile(filename, .{});
//     defer file.close();

//     const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);

//     try std.io.getStdOut().writeAll(read_buf);
// }

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();

    // read from file
    var lines = split(u8, data, "\n");
    var running_count: usize = 0;

    // iterate over lines
    while (lines.next()) |line| {
        // temp container for numbers
        var temp = ArrayList(u8).init(std.heap.page_allocator);
        defer temp.deinit();

        // iterate within line (going forward)
        for (line) |char| {
            if (isDigit(char)) {
                try temp.append(try charToDigit(char, 10));
                break;
            }
        }

        // iterate within line (going backward)
        var x = std.mem.reverseIterator(line);
        while (x.next()) |char| {
            if (isDigit(char)) {
                try temp.append(try charToDigit(char, 10));
                break;
            }
        }

        // handle edge cases with incorrect # numbers
        switch (temp.items.len) {
            0 => continue,
            1 => try temp.append(temp.items[0]),
            else => {},
        }

        // add derived number to sum
        running_count += (temp.items[0] * 10) + temp.items[1];
    }

    std.debug.print("Running count: {d}\n", .{running_count});
}
