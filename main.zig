const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const Class = extern struct {
    self: *Class,
    vtable0: [*]usize,
    vtable1: [*]usize,
    vtable2: [*]usize,
    Unk3: *Unk3VT,
    Dynlib: *DynlibVT,
    vtable5: [*]usize,
    Debug: *DebugVT,
    Timer: *TimerVT,
    vtable8: [*]usize,
    vtable9: [*]usize,
    StrRand: *StrRandVT,
    vtable11: [*]usize,
    vtable12: [*]usize,

    const TimerVT = extern struct {
        base: *c_void,
        InitTimer: fn (*Class, *TMRCtx, fn (*Class, *c_void, u32) callconv(.C) i32) callconv(.C) i32,
        RegisterTimer: fn (*Class, *TMRCtx, u32, u32, u32, u32) callconv(.C) i32,
        UnregisterTimer: fn (*Class, *TMRCtx) callconv(.C) i32,
        GetCurrentTime: fn () callconv(.C) u64,
        unk_4: *c_void,
    };

    const Unk3VT = extern struct {
        base: *c_void,
        unk_0: *c_void,
        unk_1: *c_void,
        unk_2: *c_void,
        unk_3: *c_void,
        unk_4: *c_void,
        unk_5: *c_void,
        unk_6: *c_void,
        unk_7: *c_void,
        unk_8: *c_void,
        GetMethods: fn (*Class, *Class, [*:0]const u8, u32, u32, ?*u32, ?*u32) callconv(.C) *c_void,
        unk_10: *c_void,
        unk_11: *c_void,
        unk_12: *c_void,
        unk_13: *c_void,
        unk_14: *c_void,
        unk_15: *c_void,
        unk_16: *c_void,
        unk_17: *c_void,
        unk_18: *c_void,
    };

    const DynlibVT = extern struct {
        base: *c_void,
        unk_0: *c_void,
        unk_1: *c_void,
        unk_2: *c_void,
        unk_3: *c_void,
        unk_4: *c_void,
        unk_5: *c_void,
        Exit: fn (*Class, ?*Class, i32) callconv(.C) i32,
        Load: fn (*Class, [*:0]const u8, **Class, u32, u32) callconv(.C) i32,
        Unload: fn (*Class, *Class) callconv(.C) i32,
        unk_9: *c_void,
        unk_10: *c_void,
        unk_11: *c_void,
    };

    const DebugVTBase = extern struct {
        ErrorHandler: *c_void,
        EnableLogCategory: fn (u32) callconv(.C) void,
        DisableLogCategory: fn (u32) callconv(.C) void,
        AssertMsg: *c_void,
        EnableAssertLog: fn (u32) callconv(.C) void,
        EnableDebugLog: fn (u32, ?[*:0]const u8) callconv(.C) void,
    };

    const StrRandVT = extern struct {
        base: *c_void,
        atof: fn ([*:0]const u8) callconv(.C) f32,
        atoi: fn ([*:0]const u8) callconv(.C) i32,
        atol: fn ([*:0]const u8) callconv(.C) i64,
        strtod: *c_void,
        strtol: *c_void,
        strtoul: *c_void,
        bsearch: *c_void,
        srand: fn (u32) callconv(.C) void,
        rand: fn () callconv(.C) i32,
        itoa: fn (i32, [*:0]u8, u32) callconv(.C) [*:0]u8,
    };

    const DebugVT = extern struct {
        base: *DebugVTBase,
        PrintfDebugMsg: fn (u32, [*:0]const u8, [*:0]const u8, ...) callconv(.C) i32,
        PrintDebugMsg: fn (u32, [*:0]const u8, [*]const u8, i32) callconv(.C) i32,
        Assert: *c_void,
    };

    comptime {
        std.debug.assert(@sizeOf(Class) == 56);
    }
};

const TMRCtx = extern struct {
    fill: [28]u8,
};

const GRPCtx = extern struct {
    fill: [64]u8,
};

const GRPSurface = @OpaqueType();

const GRPMethods = extern struct {
    unk_0: *c_void,
    unk_1: *c_void,
    InitCtx: fn (*Class, *GRPCtx) callconv(.C) i32,
    SetCtxParam: fn (*Class, *GRPCtx, u32, u32) callconv(.C) i32,
    unk_4: *c_void,
    unk_5: fn (*Class, *GRPSurface, u32, u32, *GRPCtx) callconv(.C) i32,
    unk_6: *c_void,
    unk_7: *c_void,
    FillRect: fn (*Class, *GRPSurface, u32, u32, u32, u32, *GRPCtx) callconv(.C) i32,
    unk_9: *c_void,
    unk_10: *c_void,
    unk_11: *c_void,
    unk_12: *c_void,
    DrawPie: fn (*Class, *GRPSurface, u32, u32, u32, u32, u32, u32, *GRPCtx) callconv(.C) i32,
    DrawPieFilled: fn (*Class, *GRPSurface, u32, u32, u32, u32, u32, u32, *GRPCtx) callconv(.C) i32,
    DrawText: fn (*Class, *GRPSurface, u32, u32, [*:0]const u8, i32, *GRPCtx) callconv(.C) i32,
    unk_16: *c_void,
    unk_17: *c_void,
    unk_18: *c_void,
    Push: fn (*Class, u32, *GRPSurface, u32, u32, u32, u32) callconv(.C) void,
    unk_20: *c_void,
    unk_21: *c_void,
    unk_22: *c_void,
    unk_23: *c_void,
    unk_24: *c_void,
    unk_25: *c_void,
    unk_26: *c_void,
    unk_27: *c_void,
    unk_28: *c_void,
    unk_29: *c_void,
    unk_30: *c_void,
    unk_31: *c_void,
    unk_32: *c_void,
    unk_33: *c_void,
    unk_34: *c_void,
    unk_35: *c_void,
    unk_36: *c_void,
    unk_37: *c_void,
    unk_38: *c_void,
    unk_39: *c_void,
    unk_40: *c_void,
    unk_41: *c_void,
    unk_42: *c_void,
    unk_43: *c_void,
    GetSurface: fn (*Class, *Class, u32, u32, u32, u32, u32) callconv(.C) *GRPSurface,
    DestroySurface: fn (*Class, *GRPSurface) callconv(.C) i32,
    unk_46: *c_void,
    unk_47: *c_void,
    unk_48: *c_void,
    unk_49: *c_void,
    unk_50: *c_void,
    unk_51: *c_void,
    unk_52: *c_void,
    unk_53: *c_void,
    unk_54: *c_void,
    unk_55: *c_void,
    unk_56: *c_void,
    unk_57: *c_void,
    unk_58: *c_void,
    unk_59: *c_void,
    unk_60: *c_void,
};

fn UnloadAndExit() void {
    _ = grp_if.DestroySurface(grp_klass, grp_surface);
    _ = this_klass.Dynlib.Unload(this_klass, grp_klass);
    _ = this_klass.Timer.UnregisterTimer(this_klass, &tmr_ctx);
    _ = this_klass.Dynlib.Exit(this_klass, null, 0);
}

fn Command3(_klass: *Class, id: u32, arg1: u32, arg2: u32) callconv(.C) i32 {
    _ = _klass.Debug.PrintDebugMsg(0x20000000, "CMD3", "Exiting...\n", -1);
    // UnloadAndExit();
    return 0;
}

fn Command5(_klass: *Class, id: u32, arg1: u32, arg2: u32) callconv(.C) i32 {
    if (arg1 != @enumToInt(Keys.Ok))
        return 0;
    _ = _klass.Debug.PrintDebugMsg(0x20000000, "CMD5", "Pressed OK...\n", -1);
    UnloadAndExit();
    return 0;
}

fn CommandGeneric(_klass: *Class, id: u32, arg1: u32, arg2: u32) callconv(.C) i32 {
    var msg_buf: [16]u8 = undefined;

    var msg = fmt.bufPrint(msg_buf[0..], "{} {x} {x}\n", .{ id, arg1, arg2 }) catch
        unreachable;
    _ = _klass.Debug.PrintDebugMsg(0x20000000, "CMD?", msg.ptr, @bitCast(isize, msg.len));
    return 0;
}

var klass: *Class = undefined;

const ExportFn = fn (*Class, u32, u32, u32) callconv(.C) i32;
var Exports = [_]extern struct { id: u32, handler: ?ExportFn }{
    .{ .id = 0x00000001, .handler = CommandGeneric },
    .{ .id = 0x00000003, .handler = Command3 },
    .{ .id = 0x00000004, .handler = CommandGeneric },
    .{ .id = 0x00000005, .handler = Command5 },
    .{ .id = 0x00000012, .handler = CommandGeneric },
    .{ .id = 0x00000013, .handler = CommandGeneric },
    .{ .id = 0x00000014, .handler = CommandGeneric },
    .{ .id = 0xffffffff, .handler = null },
};

const Keys = extern enum(u32) {
    Back = 0xfffffff0,
    Up = 0xffffffff,
    Menu = 0xfffffffa,
    Left = 0xfffffffd,
    Ok = 0xfffffffb,
    Right = 0xfffffffc,
    Down = 0xfffffffe,
};

comptime {
    @export(Exports, .{ .name = "Exports", .linkage = .Strong });
}

export fn _finish(_klass: *Class, arg1: usize, arg2: usize) callconv(.C) i32 {
    _ = _klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Bye!\n", -1);
    return 0;
}

var uvu: usize = 0;
export fn BOGUS() callconv(.C) void {
    if (Exports[0].id != 1) @breakpoint();
    uvu = @ptrToInt(&_finish);
}

var grp_klass: *Class = undefined;
var grp_surface: *GRPSurface = undefined;
var grp_if: *GRPMethods = undefined;

var this_klass: *Class = undefined;

var tmr_ctx: TMRCtx = undefined;

const RADIUS = 10;
var pos_x: u32 = 240 / 2 - RADIUS;
var pos_y: u32 = 320 / 2 - RADIUS;
var d_x: i32 = 5;
var d_y: i32 = 5;
var ball_color: u32 = 0xff0000;

fn my_callback(_klass: *Class, timer_obj: *c_void, arg: u32) callconv(.C) i32 {
    var hit = false;
    if (pos_x <= RADIUS) {
        d_x *= -1;
        hit = true;
    } else if (pos_x + RADIUS >= 240) {
        d_x *= -1;
        hit = true;
    }
    if (pos_y <= RADIUS) {
        d_y *= -1;
        hit = true;
    } else if (pos_y + RADIUS >= 320) {
        d_y *= -1;
        hit = true;
    }

    if (hit) {
        var random_color_r = @truncate(u8, @bitCast(u32, _klass.StrRand.rand()));
        var random_color_g = @truncate(u8, @bitCast(u32, _klass.StrRand.rand()));
        var random_color_b = @truncate(u8, @bitCast(u32, _klass.StrRand.rand()));
        var random_color = @as(u32, random_color_r) << 16 |
            @as(u32, random_color_g) << 8 | @as(u32, random_color_b);
        ball_color = random_color;
    }

    pos_x +%= @bitCast(u32, d_x);
    pos_y +%= @bitCast(u32, d_y);

    var ctx: GRPCtx = undefined;
    _ = grp_if.InitCtx(grp_klass, &ctx);

    var bbox = [_]u32{ 0, 0, 240, 320 };
    _ = grp_if.SetCtxParam(grp_klass, &ctx, 0, @ptrToInt(&bbox));
    // 1 => Foreground color
    // 2 => Background color
    _ = grp_if.SetCtxParam(grp_klass, &ctx, 1, 0x00000000);
    _ = grp_if.FillRect(grp_klass, grp_surface, 0, 0, 240, 320, &ctx);

    _ = grp_if.SetCtxParam(grp_klass, &ctx, 1, ball_color);
    _ = grp_if.SetCtxParam(grp_klass, &ctx, 2, 0x00000000);
    _ = grp_if.DrawPieFilled(
        grp_klass,
        grp_surface,
        pos_x - RADIUS,
        pos_y - RADIUS,
        2 * RADIUS,
        2 * RADIUS,
        0,
        360,
        &ctx,
    );

    grp_if.Push(grp_klass, 0, grp_surface, 0, 0, 240, 320);

    return 0;
}

export fn _start(_klass: *Class, arg1: usize, arg2: usize) callconv(.C) i32 {
    this_klass = _klass;

    _klass.Debug.base.EnableDebugLog(3, null);
    _klass.Debug.base.EnableLogCategory(0xffffffff);
    _ = _klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Hello!\n", -1);

    _klass.StrRand.srand(0x12345678);

    _ = _klass.Dynlib.Load(_klass, "MC_GRP.ali", &grp_klass, 0, 0);
    grp_if = @ptrCast(
        *GRPMethods,
        @alignCast(
        @alignOf(*GRPMethods),
        _klass.Unk3.GetMethods(_klass, grp_klass, "_AtMC_grp", 1, 0, null, null),
    ),
    );

    _ = _klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Loaded!\n", -1);

    var ctx: GRPCtx = undefined;
    _ = grp_if.InitCtx(grp_klass, &ctx);
    grp_surface = grp_if.GetSurface(grp_klass, _klass, 0, 0, 240, 320, 0xfffffffe);

    _ = _klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Surface!\n", -1);

    var bbox = [_]u32{ 0, 0, 240, 320 };
    _ = grp_if.SetCtxParam(grp_klass, &ctx, 0, @ptrToInt(&bbox));
    // 1 => Foreground color
    // 2 => Background color
    _ = grp_if.SetCtxParam(grp_klass, &ctx, 1, 0x00000000);
    _ = grp_if.FillRect(grp_klass, grp_surface, 0, 0, 240, 320, &ctx);
    // _ = grp_if.SetCtxParam(grp_klass, &ctx, 1, 0xffffffff);
    // _ = grp_if.SetCtxParam(grp_klass, &ctx, 2, 0x00000000);

    // _ = _klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Fill!\n", -1);

    grp_if.Push(grp_klass, 0, grp_surface, 0, 0, 240, 320);

    _ = _klass.Timer.InitTimer(_klass, &tmr_ctx, my_callback);
    _ = _klass.Timer.RegisterTimer(_klass, &tmr_ctx, 0x50, 0, 1234, 1);

    return 0;
}

const builtin = @import("builtin");
pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
    _ = this_klass.Debug.PrintDebugMsg(0x20000000, "HAXX", "Panic!\n", -1);
    while (true) {}
}
