const std = @import("std");
const ArrayList = std.ArrayList;

// const data = openFile("input");
const split = std.mem.split;
const isDigit = std.ascii.isDigit;
const charToDigit = std.fmt.charToDigit;

// Open file and return contents in a slice
fn openFile(path: []const u8) ![]u8 {
    const allocator = std.heap.page_allocator;
    const max_size = std.math.maxInt(usize);

    var data = try std.fs.cwd().readFileAlloc(allocator, path, max_size);
    defer allocator.free(data);

    return data;
}

// Replace all words in a line with numbers recursively
// fn sanitizeData(line: []const u8) ![]const u8 {
//     switch (line) {
//         containsSubstring(line, "one") => {
//             replaceSubstring(line, "one", "1");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "two") => {
//             replaceSubstring(line, "two", "2");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "three") => {
//             replaceSubstring(line, "three", "3");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "four") => {
//             replaceSubstring(line, "four", "4");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "five") => {
//             replaceSubstring(line, "five", "5");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "six") => {
//             replaceSubstring(line, "six", "6");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "seven") => {
//             replaceSubstring(line, "seven", "7");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "eight") => {
//             replaceSubstring(line, "eight", "8");
//             sanitizeData(line);
//         },
//         containsSubstring(line, "nine") => {
//             replaceSubstring(line, "nine", "9");
//             sanitizeData(line);
//         },
//         else => {
//             return line;
//         },
//     }
// }

fn sanitizeData(line: []const u8) ![]const u8 {
    var substrings = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    var replacement_chars = [_][]const u8{ "1", "2", "3", "4", "5", "6", "7", "8", "9" };

    var newline: []u8 = undefined;

    for (substrings, 0..) |substring, i| {
        if (containsSubstring(line, substring)) {
            newline = try replaceSubstring(line, substring, replacement_chars[i]);
        }
    }

    return newline;
}

fn containsSubstring(str: []const u8, substr: []const u8) bool {
    var result = if (std.mem.count(u8, str, substr) > 0) true else false;
    return result;
}

fn replaceSubstring(str: []const u8, substr: []const u8, replacement: []const u8) ![]u8 {
    var allocator = std.heap.page_allocator;
    var replacement_size = std.mem.replacementSize(u8, str, substr, replacement);
    var output: []u8 = try allocator.alloc(u8, replacement_size);
    defer allocator.free(output);
    _ = std.mem.replace(u8, str, substr, replacement, output);
    return output;
}

pub fn main() !void {
    // read from file
    @breakpoint();
    const data = @as([]u8, try openFile("input"));
    var lines = split(u8, data, "\n");
    var running_count: usize = 0;

    // iterate over lines
    while (lines.next()) |line| {
        // temp container for numbers
        var temp = ArrayList(u8).init(std.heap.page_allocator);
        defer temp.deinit();

        // for pt 2 only
        @breakpoint();
        var sanitized_line = try sanitizeData(line);

        // iterate within line (going forward)
        for (sanitized_line) |char| {
            if (isDigit(char)) {
                try temp.append(try charToDigit(char, 10));
                break;
            }
        }

        // iterate within line (going backward)
        var x = std.mem.reverseIterator(sanitized_line);
        while (x.next()) |char| {
            if (isDigit(char)) {
                try temp.append(try charToDigit(char, 10));
                break;
            }
        }

        // handle edge cases with incorrect number of numbers
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
