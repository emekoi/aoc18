const Builder = @import("std").build.Builder;

const challenges = [][]const u8 {
    "aoc1.zig"
};

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const solution_step = b.step("run", "run the solutions");

    inline for (challenges) |challenge| {
        var solution = b.addTest("src/" ++ challenge);
        solution_step.dependOn(&solution.step);
        solution.setBuildMode(mode);
    }
}
