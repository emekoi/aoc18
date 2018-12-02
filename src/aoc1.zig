//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;

test "aoc1 -- pt. 1" {
    const input_file = @embedFile("../input/aoc1.txt");
    var result: i32 = 0;
    var start: usize = 0;

    for (input_file[0..]) |char, idx| {
        if (char == '\n') {
            result += try fmt.parseInt(i32, input_file[start..idx], 10);
            start = idx + 1;
        }
    }
    debug.warn(" {} ", result);
}

fn solution2(allocator: *std.mem.Allocator, input: []const u8) !i32 {
    
}

test "aoc1 -- pt. 2" {
    const input_file = @embedFile("../input/aoc1.txt");

    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    const HashMap = std.AutoHashMap(i32, void);
    var freq = HashMap.init(&direct_allocator.allocator);
    defer freq.deinit();

    var result: i32 = 0;

    loop: while (true) {
        var start: usize = 0;
        for (input_file[0..]) |char, idx| {
            if (char == '\n') {
                result += try fmt.parseInt(i32, input_file[start..idx], 10);
                start = idx + 1;
                if (try freq.put(result, {})) |_| {
                    debug.warn(" {} ", result);
                    break :loop;
                }
            }
        }

    }
}
