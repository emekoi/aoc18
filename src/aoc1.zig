//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;

fn solution1(input: []const u8) !i32 {
    var result: i32 = 0;
    var start: usize = 0;

    for (input) |char, idx| {
        if (char == '\n') {
            result += try fmt.parseInt(i32, input[start..idx], 10);
            start = idx + 1;
        }
    }
    return result;
}

test "aoc1 -- pt. 1" {
    const input_file = @embedFile("../input/aoc1.txt");
    debug.warn(" {} ", solution1(input_file[0..]));
}

fn solution2(allocator: *std.mem.Allocator, input: []const u8) !i32 {
    const HashMap = std.AutoHashMap(i32, usize);
    var freq = HashMap.init(allocator);
    defer freq.deinit();

    var result: i32 = 0;

    while (true) {
        var start: usize = 0;
        
        for (input) |char, idx| {
            if (char == '\n') {
                result += try fmt.parseInt(i32, input[start..idx], 10);
                start = idx + 1;

                if (freq.get(result)) |_| {
                    return result;
                } else {
                    _ = try freq.put(result, 0);
                }
            }
        }

    }

    // return result;
}

test "aoc1 -- pt. 2" {
    const input_file = @embedFile("../input/aoc1.txt");

    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    debug.warn(" {} ", try solution2(&direct_allocator.allocator, input_file[0..]));
}
