//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;

const width = 1000;
const height = 1000;

const Claim = struct {
    data: [4]usize,
    cursor: usize,
};

fn displayFabric(fabric: []const usize) void {
    for (fabric) |i, idx| {
        if ((idx % width) == 0) {
            std.debug.warn("\n");
        }
        switch (i) {
            0 => std.debug.warn("."),
            1 => std.debug.warn("{}", idx),
            else => std.debug.warn("X"),
        }
    }
}

fn parseInput(allocator: *std.mem.Allocator, input: []const u8) !std.ArrayList(Claim) {
    var claims = std.ArrayList(Claim).init(allocator);

    var i: usize = 0;
    var start: usize = 0;
    var claim = Claim {
        .data = []usize{0} ** 4,
        .cursor = 0,
    };

    while (i < input.len) : (i += 1) {
        switch (input[i]) {
            '#' => {
                while (input[i] != '@') : (i += 1) {}
            },
            '0'...'9' => {
                start = i;
                while (
                    input[i + 1] >= '0' and  
                    input[i + 1] <= '9'
                ) : (i += 1) {}
                claim.data[claim.cursor] = try fmt.parseInt(usize, input[start..i + 1], 10);
                claim.cursor += 1;
            },
            '\n' => {
                try claims.append(claim);
                claim = Claim {
                    .data = []usize{0} ** 4,
                    .cursor = 0,
                };
            },
            else => {},
        }
    }
    
    return claims;
}

test "aoc3 -- pt. 1" {
    const input_file = @embedFile("../input/aoc3.txt")[0..];
    var fabric = []usize{0} ** (width * height);

    defer std.debug.warn(" ");
    std.debug.warn(" ");

    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    const claims = try parseInput(&direct_allocator.allocator, input_file);
    defer claims.deinit();
    
    var overlap: usize = 0;

    for (claims.toSliceConst()) |c, idx| {
        var y = (c.data[1]);

        while (y < c.data[3] + c.data[1]) : (y += 1) {
            var x0 = (y * width) + c.data[0];
            for (fabric[x0..(x0 + c.data[2])]) |*si| {
                if (si.* == 1) {
                    overlap += 1;
                }
                si.* += 1;
            }
        }
    }

    std.debug.warn("{}", overlap);
}

test "aoc3 -- pt. 2" {
    const input_file = @embedFile("../input/aoc3.txt")[0..];
    var fabric = []usize{0} ** (width * height);

    defer std.debug.warn(" ");
    std.debug.warn(" ");

    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    const claims = try parseInput(&direct_allocator.allocator, input_file);
    defer claims.deinit();
    var unique = std.AutoHashMap(usize, usize).init(&direct_allocator.allocator);
    defer unique.deinit();

    for (claims.toSlice()) |*c, id| {
        var y = (c.data[1]);
        c.*.cursor = id;

        while (y < c.data[3] + c.data[1]) : (y += 1) {
            var x0 = (y * width) + c.data[0];
            for (fabric[x0..(x0 + c.data[2])]) |*si, idx| {
                si.* += 1;
                switch (si.*) {
                    1 => _ = try unique.put(x0 + idx, id),
                    else => _ = unique.remove(x0 + idx),
                }
            }
        }
    }

    std.debug.warn("{}", unique.count());
    // for (unique.toSliceConst()) |claim| {
    //     std.debug.warn("{}", c);
    // }
}
