const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const filename = "./invaders/invaders.h";
    const file = std.fs.cwd().openFile(filename, .{}) catch unreachable;
    var buffer: [100]u8 = undefined;
    file.seekTo(0) catch unreachable;
    const bytes_read = file.readAll(&buffer) catch unreachable;

    var pc: u8 = 0;
    print("${x:>02}{x:>02} \n", .{buffer[5], buffer[4]});
    while (pc < bytes_read) {
        pc += disassemble8080p(&buffer, pc);
        // print("{d}", .{pc});
    }
}

fn disassemble8080p(codebuffer: []const u8, pc: u8) u8 {
    const code = codebuffer[pc];
    var opbytes: u8 = 1;
    print("{x:0>4} ", .{pc});
    switch (code) {
        0x00 => { print("NOP", .{}); },
        0x01 => { print("LXI    B,D16", .{}); opbytes = 3; },
        0x02 => { print("STAX   B", .{}); },
        0x03 => { print("INX    B", .{}); },
        0x04 => { print("INR    B", .{}); },
        0x05 => { print("DCR    B", .{}); },
        0x06 => { print("MVI    B,#${x:0>2}", .{codebuffer[pc + 1]}); },
        0x07 => { print("RLC"); },
        0x08 => { print("NOP"); },
        0x09 => { print("DAD    B"); },
        0x0a => { print("LDAX   B"); },
        0x07 => { print("RLC"); },
        0xc3 => { 
            print("JMP ${x:0>2}{x:0>2}", .{codebuffer[pc + 2], codebuffer[pc + 1]}); 
            opbytes = 3; 
        },
        else => {}
    } 
    print("\n", .{});
    return opbytes;
}

