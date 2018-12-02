//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;

pub fn countRepeats(input: []const u8, twos: *usize, threes: *usize) void {
    var table = []usize{0} ** 26;
    var c2: ?usize = null;
    var c3: ?usize = null;

    for (input) |c| {
        table[c - 97] += 1;
    }

    for (table) |i| {
        switch (i) {
            2 => if (c2 == null) { c2 = 1; },
            3 => if (c3 == null) { c3 = 1; },
            else => {},
        }
    }

    twos.* += c2 orelse 0;
    threes.* += c3 orelse 0;
}

test "aoc2 -- pt. 1" {
    const input_file = @embedFile("../input/aoc2.txt");

    var start: usize = 0;
    var twos: usize = 0;
    var threes: usize = 0;

    for (input_file[0..]) |char, idx| {
        if (char == '\n') {
            countRepeats(input_file[start..idx], &twos, &threes);
            start = idx + 1;
        }
    }
    debug.warn(" {} ", twos * threes);
}

test "aoc2 -- pt. 2" {
    const input_file = @embedFile("../input/aoc2.txt");
    defer std.debug.warn(" ");
    std.debug.warn(" ");

    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    var ids = std.ArrayList([]const u8).init(&direct_allocator.allocator);
    defer ids.deinit();

    var start: usize = 0;

    for (input_file[0..]) |char, idx| {
        if (char == '\n') {
            try ids.append(input_file[start..idx]);
            start = idx + 1;
        }
    }
    
    loop: for (ids.toSliceConst()) |id0| {
        for (ids.toSliceConst()) |id1| {
            var count: usize = 0;

            for (id0) |c, i| {
                if (c != id1[i]) {
                    count += 1;
                }
            }

            if (count == 1) {
                for (id0) |c, i| {
                    if (c == id1[i]) {
                        std.debug.warn("{c}", c);
                    }
                }
                break :loop;
            }
        }
    }
}
