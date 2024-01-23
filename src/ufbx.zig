pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_labs = @import("std").zig.c_builtins.__builtin_labs;
pub const __builtin_llabs = @import("std").zig.c_builtins.__builtin_llabs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
pub const int_least8_t = __int_least8_t;
pub const int_least16_t = __int_least16_t;
pub const int_least32_t = __int_least32_t;
pub const int_least64_t = __int_least64_t;
pub const uint_least8_t = __uint_least8_t;
pub const uint_least16_t = __uint_least16_t;
pub const uint_least32_t = __uint_least32_t;
pub const uint_least64_t = __uint_least64_t;
pub const int_fast8_t = i8;
pub const int_fast16_t = c_long;
pub const int_fast32_t = c_long;
pub const int_fast64_t = c_long;
pub const uint_fast8_t = u8;
pub const uint_fast16_t = c_ulong;
pub const uint_fast32_t = c_ulong;
pub const uint_fast64_t = c_ulong;
pub const intmax_t = __intmax_t;
pub const uintmax_t = __uintmax_t;
pub const ptrdiff_t = c_long;
pub const wchar_t = c_int;
pub const max_align_t = extern struct {
    __clang_max_align_nonce1: c_longlong align(8) = @import("std").mem.zeroes(c_longlong),
    __clang_max_align_nonce2: c_longdouble align(16) = @import("std").mem.zeroes(c_longdouble),
};
pub extern fn memcpy(__dest: ?*anyopaque, __src: ?*const anyopaque, __n: c_ulong) ?*anyopaque;
pub extern fn memmove(__dest: ?*anyopaque, __src: ?*const anyopaque, __n: c_ulong) ?*anyopaque;
pub extern fn memccpy(__dest: ?*anyopaque, __src: ?*const anyopaque, __c: c_int, __n: c_ulong) ?*anyopaque;
pub extern fn memset(__s: ?*anyopaque, __c: c_int, __n: c_ulong) ?*anyopaque;
pub extern fn memcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: c_ulong) c_int;
pub extern fn __memcmpeq(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn memchr(__s: ?*const anyopaque, __c: c_int, __n: c_ulong) ?*anyopaque;
pub extern fn strcpy(__dest: [*c]u8, __src: [*c]const u8) [*c]u8;
pub extern fn strncpy(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) [*c]u8;
pub extern fn strcat(__dest: [*c]u8, __src: [*c]const u8) [*c]u8;
pub extern fn strncat(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) [*c]u8;
pub extern fn strcmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: c_ulong) c_int;
pub extern fn strcoll(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strxfrm(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) c_ulong;
pub const struct___locale_data_1 = opaque {};
pub const struct___locale_struct = extern struct {
    __locales: [13]?*struct___locale_data_1 = @import("std").mem.zeroes([13]?*struct___locale_data_1),
    __ctype_b: [*c]const c_ushort = @import("std").mem.zeroes([*c]const c_ushort),
    __ctype_tolower: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __ctype_toupper: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __names: [13][*c]const u8 = @import("std").mem.zeroes([13][*c]const u8),
};
pub const __locale_t = [*c]struct___locale_struct;
pub const locale_t = __locale_t;
pub extern fn strcoll_l(__s1: [*c]const u8, __s2: [*c]const u8, __l: locale_t) c_int;
pub extern fn strxfrm_l(__dest: [*c]u8, __src: [*c]const u8, __n: usize, __l: locale_t) usize;
pub extern fn strdup(__s: [*c]const u8) [*c]u8;
pub extern fn strndup(__string: [*c]const u8, __n: c_ulong) [*c]u8;
pub extern fn strchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strrchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strchrnul(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strcspn(__s: [*c]const u8, __reject: [*c]const u8) c_ulong;
pub extern fn strspn(__s: [*c]const u8, __accept: [*c]const u8) c_ulong;
pub extern fn strpbrk(__s: [*c]const u8, __accept: [*c]const u8) [*c]u8;
pub extern fn strstr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn strtok(__s: [*c]u8, __delim: [*c]const u8) [*c]u8;
pub extern fn __strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strcasestr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn memmem(__haystack: ?*const anyopaque, __haystacklen: usize, __needle: ?*const anyopaque, __needlelen: usize) ?*anyopaque;
pub extern fn __mempcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn mempcpy(__dest: ?*anyopaque, __src: ?*const anyopaque, __n: c_ulong) ?*anyopaque;
pub extern fn strlen(__s: [*c]const u8) c_ulong;
pub extern fn strnlen(__string: [*c]const u8, __maxlen: usize) usize;
pub extern fn strerror(__errnum: c_int) [*c]u8;
pub extern fn strerror_r(__errnum: c_int, __buf: [*c]u8, __buflen: usize) c_int;
pub extern fn strerror_l(__errnum: c_int, __l: locale_t) [*c]u8;
pub extern fn bcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: c_ulong) c_int;
pub extern fn bcopy(__src: ?*const anyopaque, __dest: ?*anyopaque, __n: usize) void;
pub extern fn bzero(__s: ?*anyopaque, __n: c_ulong) void;
pub extern fn index(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn rindex(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn ffs(__i: c_int) c_int;
pub extern fn ffsl(__l: c_long) c_int;
pub extern fn ffsll(__ll: c_longlong) c_int;
pub extern fn strcasecmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncasecmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: c_ulong) c_int;
pub extern fn strcasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __loc: locale_t) c_int;
pub extern fn strncasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize, __loc: locale_t) c_int;
pub extern fn explicit_bzero(__s: ?*anyopaque, __n: usize) void;
pub extern fn strsep(noalias __stringp: [*c][*c]u8, noalias __delim: [*c]const u8) [*c]u8;
pub extern fn strsignal(__sig: c_int) [*c]u8;
pub extern fn __stpcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn stpcpy(__dest: [*c]u8, __src: [*c]const u8) [*c]u8;
pub extern fn __stpncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn stpncpy(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) [*c]u8;
pub extern fn strlcpy(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) c_ulong;
pub extern fn strlcat(__dest: [*c]u8, __src: [*c]const u8, __n: c_ulong) c_ulong;
pub extern fn __assert_fail(__assertion: [*c]const u8, __file: [*c]const u8, __line: c_uint, __function: [*c]const u8) noreturn;
pub extern fn __assert_perror_fail(__errnum: c_int, __file: [*c]const u8, __line: c_uint, __function: [*c]const u8) noreturn;
pub extern fn __assert(__assertion: [*c]const u8, __file: [*c]const u8, __line: c_int) noreturn;
pub const ufbx_real = f64;
pub const struct_ufbx_string = extern struct {
    data: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    length: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_string = struct_ufbx_string;
pub const struct_ufbx_blob = extern struct {
    data: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
    size: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_blob = struct_ufbx_blob;
const struct_unnamed_3 = extern struct {
    x: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    y: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
const union_unnamed_2 = extern union {
    unnamed_0: struct_unnamed_3,
    v: [2]ufbx_real,
};
pub const struct_ufbx_vec2 = extern struct {
    unnamed_0: union_unnamed_2 = @import("std").mem.zeroes(union_unnamed_2),
};
pub const ufbx_vec2 = struct_ufbx_vec2;
const struct_unnamed_5 = extern struct {
    x: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    y: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    z: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
const union_unnamed_4 = extern union {
    unnamed_0: struct_unnamed_5,
    v: [3]ufbx_real,
};
pub const struct_ufbx_vec3 = extern struct {
    unnamed_0: union_unnamed_4 = @import("std").mem.zeroes(union_unnamed_4),
};
pub const ufbx_vec3 = struct_ufbx_vec3;
const struct_unnamed_7 = extern struct {
    x: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    y: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    z: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    w: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
const union_unnamed_6 = extern union {
    unnamed_0: struct_unnamed_7,
    v: [4]ufbx_real,
};
pub const struct_ufbx_vec4 = extern struct {
    unnamed_0: union_unnamed_6 = @import("std").mem.zeroes(union_unnamed_6),
};
pub const ufbx_vec4 = struct_ufbx_vec4;
const struct_unnamed_9 = extern struct {
    x: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    y: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    z: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    w: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
const union_unnamed_8 = extern union {
    unnamed_0: struct_unnamed_9,
    v: [4]ufbx_real,
};
pub const struct_ufbx_quat = extern struct {
    unnamed_0: union_unnamed_8 = @import("std").mem.zeroes(union_unnamed_8),
};
pub const ufbx_quat = struct_ufbx_quat;
pub const UFBX_ROTATION_ORDER_XYZ: c_int = 0;
pub const UFBX_ROTATION_ORDER_XZY: c_int = 1;
pub const UFBX_ROTATION_ORDER_YZX: c_int = 2;
pub const UFBX_ROTATION_ORDER_YXZ: c_int = 3;
pub const UFBX_ROTATION_ORDER_ZXY: c_int = 4;
pub const UFBX_ROTATION_ORDER_ZYX: c_int = 5;
pub const UFBX_ROTATION_ORDER_SPHERIC: c_int = 6;
pub const UFBX_ROTATION_ORDER_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_rotation_order = c_uint;
pub const ufbx_rotation_order = enum_ufbx_rotation_order;
pub const UFBX_ROTATION_ORDER_COUNT: c_int = 7;
const enum_unnamed_10 = c_uint;
pub const struct_ufbx_transform = extern struct {
    translation: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    rotation: ufbx_quat = @import("std").mem.zeroes(ufbx_quat),
    scale: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_transform = struct_ufbx_transform;
const struct_unnamed_12 = extern struct {
    m00: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m10: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m20: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m01: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m11: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m21: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m02: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m12: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m22: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m03: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m13: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    m23: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
const union_unnamed_11 = extern union {
    unnamed_0: struct_unnamed_12,
    cols: [4]ufbx_vec3,
    v: [12]ufbx_real,
};
pub const struct_ufbx_matrix = extern struct {
    unnamed_0: union_unnamed_11 = @import("std").mem.zeroes(union_unnamed_11),
};
pub const ufbx_matrix = struct_ufbx_matrix;
pub const struct_ufbx_void_list = extern struct {
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_void_list = struct_ufbx_void_list;
pub const struct_ufbx_bool_list = extern struct {
    data: [*c]bool = @import("std").mem.zeroes([*c]bool),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_bool_list = struct_ufbx_bool_list;
pub const struct_ufbx_uint32_list = extern struct {
    data: [*c]u32 = @import("std").mem.zeroes([*c]u32),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_uint32_list = struct_ufbx_uint32_list;
pub const struct_ufbx_real_list = extern struct {
    data: [*c]ufbx_real = @import("std").mem.zeroes([*c]ufbx_real),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_real_list = struct_ufbx_real_list;
pub const struct_ufbx_vec2_list = extern struct {
    data: [*c]ufbx_vec2 = @import("std").mem.zeroes([*c]ufbx_vec2),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_vec2_list = struct_ufbx_vec2_list;
pub const struct_ufbx_vec3_list = extern struct {
    data: [*c]ufbx_vec3 = @import("std").mem.zeroes([*c]ufbx_vec3),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_vec3_list = struct_ufbx_vec3_list;
pub const struct_ufbx_vec4_list = extern struct {
    data: [*c]ufbx_vec4 = @import("std").mem.zeroes([*c]ufbx_vec4),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_vec4_list = struct_ufbx_vec4_list;
pub const struct_ufbx_string_list = extern struct {
    data: [*c]ufbx_string = @import("std").mem.zeroes([*c]ufbx_string),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_string_list = struct_ufbx_string_list;
pub const UFBX_DOM_VALUE_NUMBER: c_int = 0;
pub const UFBX_DOM_VALUE_STRING: c_int = 1;
pub const UFBX_DOM_VALUE_ARRAY_I8: c_int = 2;
pub const UFBX_DOM_VALUE_ARRAY_I32: c_int = 3;
pub const UFBX_DOM_VALUE_ARRAY_I64: c_int = 4;
pub const UFBX_DOM_VALUE_ARRAY_F32: c_int = 5;
pub const UFBX_DOM_VALUE_ARRAY_F64: c_int = 6;
pub const UFBX_DOM_VALUE_ARRAY_RAW_STRING: c_int = 7;
pub const UFBX_DOM_VALUE_ARRAY_IGNORED: c_int = 8;
pub const UFBX_DOM_VALUE_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_dom_value_type = c_uint;
pub const ufbx_dom_value_type = enum_ufbx_dom_value_type;
pub const UFBX_DOM_VALUE_TYPE_COUNT: c_int = 9;
const enum_unnamed_13 = c_uint;
pub const ufbx_dom_node = struct_ufbx_dom_node;
pub const struct_ufbx_dom_node_list = extern struct {
    data: [*c][*c]ufbx_dom_node = @import("std").mem.zeroes([*c][*c]ufbx_dom_node),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_dom_node_list = struct_ufbx_dom_node_list;
pub const struct_ufbx_dom_value = extern struct {
    type: ufbx_dom_value_type = @import("std").mem.zeroes(ufbx_dom_value_type),
    value_str: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value_blob: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    value_int: i64 = @import("std").mem.zeroes(i64),
    value_float: f64 = @import("std").mem.zeroes(f64),
};
pub const ufbx_dom_value = struct_ufbx_dom_value;
pub const struct_ufbx_dom_value_list = extern struct {
    data: [*c]ufbx_dom_value = @import("std").mem.zeroes([*c]ufbx_dom_value),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_dom_value_list = struct_ufbx_dom_value_list;
pub const struct_ufbx_dom_node = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    children: ufbx_dom_node_list = @import("std").mem.zeroes(ufbx_dom_node_list),
    values: ufbx_dom_value_list = @import("std").mem.zeroes(ufbx_dom_value_list),
};
pub const UFBX_PROP_UNKNOWN: c_int = 0;
pub const UFBX_PROP_BOOLEAN: c_int = 1;
pub const UFBX_PROP_INTEGER: c_int = 2;
pub const UFBX_PROP_NUMBER: c_int = 3;
pub const UFBX_PROP_VECTOR: c_int = 4;
pub const UFBX_PROP_COLOR: c_int = 5;
pub const UFBX_PROP_COLOR_WITH_ALPHA: c_int = 6;
pub const UFBX_PROP_STRING: c_int = 7;
pub const UFBX_PROP_DATE_TIME: c_int = 8;
pub const UFBX_PROP_TRANSLATION: c_int = 9;
pub const UFBX_PROP_ROTATION: c_int = 10;
pub const UFBX_PROP_SCALING: c_int = 11;
pub const UFBX_PROP_DISTANCE: c_int = 12;
pub const UFBX_PROP_COMPOUND: c_int = 13;
pub const UFBX_PROP_BLOB: c_int = 14;
pub const UFBX_PROP_REFERENCE: c_int = 15;
pub const UFBX_PROP_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_prop_type = c_uint;
pub const ufbx_prop_type = enum_ufbx_prop_type;
pub const UFBX_PROP_FLAG_ANIMATABLE: c_int = 1;
pub const UFBX_PROP_FLAG_USER_DEFINED: c_int = 2;
pub const UFBX_PROP_FLAG_HIDDEN: c_int = 4;
pub const UFBX_PROP_FLAG_LOCK_X: c_int = 16;
pub const UFBX_PROP_FLAG_LOCK_Y: c_int = 32;
pub const UFBX_PROP_FLAG_LOCK_Z: c_int = 64;
pub const UFBX_PROP_FLAG_LOCK_W: c_int = 128;
pub const UFBX_PROP_FLAG_MUTE_X: c_int = 256;
pub const UFBX_PROP_FLAG_MUTE_Y: c_int = 512;
pub const UFBX_PROP_FLAG_MUTE_Z: c_int = 1024;
pub const UFBX_PROP_FLAG_MUTE_W: c_int = 2048;
pub const UFBX_PROP_FLAG_SYNTHETIC: c_int = 4096;
pub const UFBX_PROP_FLAG_ANIMATED: c_int = 8192;
pub const UFBX_PROP_FLAG_NOT_FOUND: c_int = 16384;
pub const UFBX_PROP_FLAG_CONNECTED: c_int = 32768;
pub const UFBX_PROP_FLAG_NO_VALUE: c_int = 65536;
pub const UFBX_PROP_FLAG_OVERRIDDEN: c_int = 131072;
pub const UFBX_PROP_FLAG_VALUE_REAL: c_int = 1048576;
pub const UFBX_PROP_FLAG_VALUE_VEC2: c_int = 2097152;
pub const UFBX_PROP_FLAG_VALUE_VEC3: c_int = 4194304;
pub const UFBX_PROP_FLAG_VALUE_VEC4: c_int = 8388608;
pub const UFBX_PROP_FLAG_VALUE_INT: c_int = 16777216;
pub const UFBX_PROP_FLAG_VALUE_STR: c_int = 33554432;
pub const UFBX_PROP_FLAG_VALUE_BLOB: c_int = 67108864;
pub const UFBX_PROP_FLAGS_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_prop_flags = c_uint;
pub const ufbx_prop_flags = enum_ufbx_prop_flags;
const union_unnamed_14 = extern union {
    value_real_arr: [4]ufbx_real,
    value_real: ufbx_real,
    value_vec2: ufbx_vec2,
    value_vec3: ufbx_vec3,
    value_vec4: ufbx_vec4,
};
pub const struct_ufbx_prop = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    _internal_key: u32 = @import("std").mem.zeroes(u32),
    type: ufbx_prop_type = @import("std").mem.zeroes(ufbx_prop_type),
    flags: ufbx_prop_flags = @import("std").mem.zeroes(ufbx_prop_flags),
    value_str: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value_blob: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    value_int: i64 = @import("std").mem.zeroes(i64),
    unnamed_0: union_unnamed_14 = @import("std").mem.zeroes(union_unnamed_14),
};
pub const ufbx_prop = struct_ufbx_prop;
pub const struct_ufbx_prop_list = extern struct {
    data: [*c]ufbx_prop = @import("std").mem.zeroes([*c]ufbx_prop),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_prop_list = struct_ufbx_prop_list;
pub const ufbx_props = struct_ufbx_props;
pub const struct_ufbx_props = extern struct {
    props: ufbx_prop_list = @import("std").mem.zeroes(ufbx_prop_list),
    num_animated: usize = @import("std").mem.zeroes(usize),
    defaults: [*c]ufbx_props = @import("std").mem.zeroes([*c]ufbx_props),
};
pub const UFBX_PROP_TYPE_COUNT: c_int = 16;
const enum_unnamed_15 = c_uint;
pub const UFBX_WARNING_MISSING_EXTERNAL_FILE: c_int = 0;
pub const UFBX_WARNING_IMPLICIT_MTL: c_int = 1;
pub const UFBX_WARNING_TRUNCATED_ARRAY: c_int = 2;
pub const UFBX_WARNING_MISSING_GEOMETRY_DATA: c_int = 3;
pub const UFBX_WARNING_DUPLICATE_CONNECTION: c_int = 4;
pub const UFBX_WARNING_INDEX_CLAMPED: c_int = 5;
pub const UFBX_WARNING_BAD_UNICODE: c_int = 6;
pub const UFBX_WARNING_BAD_ELEMENT_CONNECTED_TO_ROOT: c_int = 7;
pub const UFBX_WARNING_DUPLICATE_OBJECT_ID: c_int = 8;
pub const UFBX_WARNING_EMPTY_FACE_REMOVED: c_int = 9;
pub const UFBX_WARNING_UNKNOWN_OBJ_DIRECTIVE: c_int = 10;
pub const UFBX_WARNING_TYPE_FIRST_DEDUPLICATED: c_int = 5;
pub const UFBX_WARNING_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_warning_type = c_uint;
pub const ufbx_warning_type = enum_ufbx_warning_type;
pub const struct_ufbx_warning = extern struct {
    type: ufbx_warning_type = @import("std").mem.zeroes(ufbx_warning_type),
    description: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    element_id: u32 = @import("std").mem.zeroes(u32),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_warning = struct_ufbx_warning;
pub const struct_ufbx_warning_list = extern struct {
    data: [*c]ufbx_warning = @import("std").mem.zeroes([*c]ufbx_warning),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_warning_list = struct_ufbx_warning_list;
pub const UFBX_FILE_FORMAT_UNKNOWN: c_int = 0;
pub const UFBX_FILE_FORMAT_FBX: c_int = 1;
pub const UFBX_FILE_FORMAT_OBJ: c_int = 2;
pub const UFBX_FILE_FORMAT_MTL: c_int = 3;
pub const UFBX_FILE_FORMAT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_file_format = c_uint;
pub const ufbx_file_format = enum_ufbx_file_format;
pub const UFBX_EXPORTER_UNKNOWN: c_int = 0;
pub const UFBX_EXPORTER_FBX_SDK: c_int = 1;
pub const UFBX_EXPORTER_BLENDER_BINARY: c_int = 2;
pub const UFBX_EXPORTER_BLENDER_ASCII: c_int = 3;
pub const UFBX_EXPORTER_MOTION_BUILDER: c_int = 4;
pub const UFBX_EXPORTER_BC_UNITY_EXPORTER: c_int = 5;
pub const UFBX_EXPORTER_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_exporter = c_uint;
pub const ufbx_exporter = enum_ufbx_exporter;
pub const struct_ufbx_application = extern struct {
    vendor: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    version: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_application = struct_ufbx_application;
pub const UFBX_THUMBNAIL_FORMAT_UNKNOWN: c_int = 0;
pub const UFBX_THUMBNAIL_FORMAT_RGB_24: c_int = 1;
pub const UFBX_THUMBNAIL_FORMAT_RGBA_32: c_int = 2;
pub const UFBX_THUMBNAIL_FORMAT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_thumbnail_format = c_uint;
pub const ufbx_thumbnail_format = enum_ufbx_thumbnail_format;
pub const struct_ufbx_thumbnail = extern struct {
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    width: u32 = @import("std").mem.zeroes(u32),
    height: u32 = @import("std").mem.zeroes(u32),
    format: ufbx_thumbnail_format = @import("std").mem.zeroes(ufbx_thumbnail_format),
    data: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
};
pub const ufbx_thumbnail = struct_ufbx_thumbnail;
pub const UFBX_SPACE_CONVERSION_TRANSFORM_ROOT: c_int = 0;
pub const UFBX_SPACE_CONVERSION_ADJUST_TRANSFORMS: c_int = 1;
pub const UFBX_SPACE_CONVERSION_MODIFY_GEOMETRY: c_int = 2;
pub const UFBX_SPACE_CONVERSION_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_space_conversion = c_uint;
pub const ufbx_space_conversion = enum_ufbx_space_conversion;
pub const UFBX_MIRROR_AXIS_NONE: c_int = 0;
pub const UFBX_MIRROR_AXIS_X: c_int = 1;
pub const UFBX_MIRROR_AXIS_Y: c_int = 2;
pub const UFBX_MIRROR_AXIS_Z: c_int = 3;
pub const UFBX_MIRROR_AXIS_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_mirror_axis = c_uint;
pub const ufbx_mirror_axis = enum_ufbx_mirror_axis;
pub const struct_ufbx_metadata = extern struct {
    warnings: ufbx_warning_list = @import("std").mem.zeroes(ufbx_warning_list),
    ascii: bool = @import("std").mem.zeroes(bool),
    version: u32 = @import("std").mem.zeroes(u32),
    file_format: ufbx_file_format = @import("std").mem.zeroes(ufbx_file_format),
    may_contain_no_index: bool = @import("std").mem.zeroes(bool),
    may_contain_missing_vertex_position: bool = @import("std").mem.zeroes(bool),
    may_contain_broken_elements: bool = @import("std").mem.zeroes(bool),
    is_unsafe: bool = @import("std").mem.zeroes(bool),
    has_warning: [11]bool = @import("std").mem.zeroes([11]bool),
    creator: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    big_endian: bool = @import("std").mem.zeroes(bool),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    relative_root: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_relative_root: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    exporter: ufbx_exporter = @import("std").mem.zeroes(ufbx_exporter),
    exporter_version: u32 = @import("std").mem.zeroes(u32),
    scene_props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    original_application: ufbx_application = @import("std").mem.zeroes(ufbx_application),
    latest_application: ufbx_application = @import("std").mem.zeroes(ufbx_application),
    thumbnail: ufbx_thumbnail = @import("std").mem.zeroes(ufbx_thumbnail),
    geometry_ignored: bool = @import("std").mem.zeroes(bool),
    animation_ignored: bool = @import("std").mem.zeroes(bool),
    embedded_ignored: bool = @import("std").mem.zeroes(bool),
    max_face_triangles: usize = @import("std").mem.zeroes(usize),
    result_memory_used: usize = @import("std").mem.zeroes(usize),
    temp_memory_used: usize = @import("std").mem.zeroes(usize),
    result_allocs: usize = @import("std").mem.zeroes(usize),
    temp_allocs: usize = @import("std").mem.zeroes(usize),
    element_buffer_size: usize = @import("std").mem.zeroes(usize),
    num_shader_textures: usize = @import("std").mem.zeroes(usize),
    bone_prop_size_unit: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    bone_prop_limb_length_relative: bool = @import("std").mem.zeroes(bool),
    ktime_second: i64 = @import("std").mem.zeroes(i64),
    original_file_path: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_original_file_path: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    space_conversion: ufbx_space_conversion = @import("std").mem.zeroes(ufbx_space_conversion),
    root_rotation: ufbx_quat = @import("std").mem.zeroes(ufbx_quat),
    root_scale: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    mirror_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    geometry_scale: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_metadata = struct_ufbx_metadata;
pub const UFBX_COORDINATE_AXIS_POSITIVE_X: c_int = 0;
pub const UFBX_COORDINATE_AXIS_NEGATIVE_X: c_int = 1;
pub const UFBX_COORDINATE_AXIS_POSITIVE_Y: c_int = 2;
pub const UFBX_COORDINATE_AXIS_NEGATIVE_Y: c_int = 3;
pub const UFBX_COORDINATE_AXIS_POSITIVE_Z: c_int = 4;
pub const UFBX_COORDINATE_AXIS_NEGATIVE_Z: c_int = 5;
pub const UFBX_COORDINATE_AXIS_UNKNOWN: c_int = 6;
pub const UFBX_COORDINATE_AXIS_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_coordinate_axis = c_uint;
pub const ufbx_coordinate_axis = enum_ufbx_coordinate_axis;
pub const struct_ufbx_coordinate_axes = extern struct {
    right: ufbx_coordinate_axis = @import("std").mem.zeroes(ufbx_coordinate_axis),
    up: ufbx_coordinate_axis = @import("std").mem.zeroes(ufbx_coordinate_axis),
    front: ufbx_coordinate_axis = @import("std").mem.zeroes(ufbx_coordinate_axis),
};
pub const ufbx_coordinate_axes = struct_ufbx_coordinate_axes;
pub const UFBX_TIME_MODE_DEFAULT: c_int = 0;
pub const UFBX_TIME_MODE_120_FPS: c_int = 1;
pub const UFBX_TIME_MODE_100_FPS: c_int = 2;
pub const UFBX_TIME_MODE_60_FPS: c_int = 3;
pub const UFBX_TIME_MODE_50_FPS: c_int = 4;
pub const UFBX_TIME_MODE_48_FPS: c_int = 5;
pub const UFBX_TIME_MODE_30_FPS: c_int = 6;
pub const UFBX_TIME_MODE_30_FPS_DROP: c_int = 7;
pub const UFBX_TIME_MODE_NTSC_DROP_FRAME: c_int = 8;
pub const UFBX_TIME_MODE_NTSC_FULL_FRAME: c_int = 9;
pub const UFBX_TIME_MODE_PAL: c_int = 10;
pub const UFBX_TIME_MODE_24_FPS: c_int = 11;
pub const UFBX_TIME_MODE_1000_FPS: c_int = 12;
pub const UFBX_TIME_MODE_FILM_FULL_FRAME: c_int = 13;
pub const UFBX_TIME_MODE_CUSTOM: c_int = 14;
pub const UFBX_TIME_MODE_96_FPS: c_int = 15;
pub const UFBX_TIME_MODE_72_FPS: c_int = 16;
pub const UFBX_TIME_MODE_59_94_FPS: c_int = 17;
pub const UFBX_TIME_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_time_mode = c_uint;
pub const ufbx_time_mode = enum_ufbx_time_mode;
pub const UFBX_TIME_PROTOCOL_SMPTE: c_int = 0;
pub const UFBX_TIME_PROTOCOL_FRAME_COUNT: c_int = 1;
pub const UFBX_TIME_PROTOCOL_DEFAULT: c_int = 2;
pub const UFBX_TIME_PROTOCOL_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_time_protocol = c_uint;
pub const ufbx_time_protocol = enum_ufbx_time_protocol;
pub const UFBX_SNAP_MODE_NONE: c_int = 0;
pub const UFBX_SNAP_MODE_SNAP: c_int = 1;
pub const UFBX_SNAP_MODE_PLAY: c_int = 2;
pub const UFBX_SNAP_MODE_SNAP_AND_PLAY: c_int = 3;
pub const UFBX_SNAP_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_snap_mode = c_uint;
pub const ufbx_snap_mode = enum_ufbx_snap_mode;
pub const struct_ufbx_scene_settings = extern struct {
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    axes: ufbx_coordinate_axes = @import("std").mem.zeroes(ufbx_coordinate_axes),
    unit_meters: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    frames_per_second: f64 = @import("std").mem.zeroes(f64),
    ambient_color: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    default_camera: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    time_mode: ufbx_time_mode = @import("std").mem.zeroes(ufbx_time_mode),
    time_protocol: ufbx_time_protocol = @import("std").mem.zeroes(ufbx_time_protocol),
    snap_mode: ufbx_snap_mode = @import("std").mem.zeroes(ufbx_snap_mode),
    original_axis_up: ufbx_coordinate_axis = @import("std").mem.zeroes(ufbx_coordinate_axis),
    original_unit_meters: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_scene_settings = struct_ufbx_scene_settings;
pub const struct_ufbx_node_list = extern struct {
    data: [*c][*c]ufbx_node = @import("std").mem.zeroes([*c][*c]ufbx_node),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_node_list = struct_ufbx_node_list;
pub const UFBX_ELEMENT_UNKNOWN: c_int = 0;
pub const UFBX_ELEMENT_NODE: c_int = 1;
pub const UFBX_ELEMENT_MESH: c_int = 2;
pub const UFBX_ELEMENT_LIGHT: c_int = 3;
pub const UFBX_ELEMENT_CAMERA: c_int = 4;
pub const UFBX_ELEMENT_BONE: c_int = 5;
pub const UFBX_ELEMENT_EMPTY: c_int = 6;
pub const UFBX_ELEMENT_LINE_CURVE: c_int = 7;
pub const UFBX_ELEMENT_NURBS_CURVE: c_int = 8;
pub const UFBX_ELEMENT_NURBS_SURFACE: c_int = 9;
pub const UFBX_ELEMENT_NURBS_TRIM_SURFACE: c_int = 10;
pub const UFBX_ELEMENT_NURBS_TRIM_BOUNDARY: c_int = 11;
pub const UFBX_ELEMENT_PROCEDURAL_GEOMETRY: c_int = 12;
pub const UFBX_ELEMENT_STEREO_CAMERA: c_int = 13;
pub const UFBX_ELEMENT_CAMERA_SWITCHER: c_int = 14;
pub const UFBX_ELEMENT_MARKER: c_int = 15;
pub const UFBX_ELEMENT_LOD_GROUP: c_int = 16;
pub const UFBX_ELEMENT_SKIN_DEFORMER: c_int = 17;
pub const UFBX_ELEMENT_SKIN_CLUSTER: c_int = 18;
pub const UFBX_ELEMENT_BLEND_DEFORMER: c_int = 19;
pub const UFBX_ELEMENT_BLEND_CHANNEL: c_int = 20;
pub const UFBX_ELEMENT_BLEND_SHAPE: c_int = 21;
pub const UFBX_ELEMENT_CACHE_DEFORMER: c_int = 22;
pub const UFBX_ELEMENT_CACHE_FILE: c_int = 23;
pub const UFBX_ELEMENT_MATERIAL: c_int = 24;
pub const UFBX_ELEMENT_TEXTURE: c_int = 25;
pub const UFBX_ELEMENT_VIDEO: c_int = 26;
pub const UFBX_ELEMENT_SHADER: c_int = 27;
pub const UFBX_ELEMENT_SHADER_BINDING: c_int = 28;
pub const UFBX_ELEMENT_ANIM_STACK: c_int = 29;
pub const UFBX_ELEMENT_ANIM_LAYER: c_int = 30;
pub const UFBX_ELEMENT_ANIM_VALUE: c_int = 31;
pub const UFBX_ELEMENT_ANIM_CURVE: c_int = 32;
pub const UFBX_ELEMENT_DISPLAY_LAYER: c_int = 33;
pub const UFBX_ELEMENT_SELECTION_SET: c_int = 34;
pub const UFBX_ELEMENT_SELECTION_NODE: c_int = 35;
pub const UFBX_ELEMENT_CHARACTER: c_int = 36;
pub const UFBX_ELEMENT_CONSTRAINT: c_int = 37;
pub const UFBX_ELEMENT_POSE: c_int = 38;
pub const UFBX_ELEMENT_METADATA_OBJECT: c_int = 39;
pub const UFBX_ELEMENT_TYPE_FIRST_ATTRIB: c_int = 2;
pub const UFBX_ELEMENT_TYPE_LAST_ATTRIB: c_int = 16;
pub const UFBX_ELEMENT_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_element_type = c_uint;
pub const ufbx_element_type = enum_ufbx_element_type;
pub const struct_ufbx_connection = extern struct {
    src: [*c]ufbx_element = @import("std").mem.zeroes([*c]ufbx_element),
    dst: [*c]ufbx_element = @import("std").mem.zeroes([*c]ufbx_element),
    src_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    dst_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_connection = struct_ufbx_connection;
pub const struct_ufbx_connection_list = extern struct {
    data: [*c]ufbx_connection = @import("std").mem.zeroes([*c]ufbx_connection),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_connection_list = struct_ufbx_connection_list;
pub const ufbx_scene = struct_ufbx_scene;
pub const struct_ufbx_element = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
    type: ufbx_element_type = @import("std").mem.zeroes(ufbx_element_type),
    connections_src: ufbx_connection_list = @import("std").mem.zeroes(ufbx_connection_list),
    connections_dst: ufbx_connection_list = @import("std").mem.zeroes(ufbx_connection_list),
    dom_node: [*c]ufbx_dom_node = @import("std").mem.zeroes([*c]ufbx_dom_node),
    scene: [*c]ufbx_scene = @import("std").mem.zeroes([*c]ufbx_scene),
};
pub const ufbx_element = struct_ufbx_element;
const struct_unnamed_17 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_16 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_17,
};
const struct_unnamed_19 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_18 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_19,
};
pub const struct_ufbx_face = extern struct {
    index_begin: u32 = @import("std").mem.zeroes(u32),
    num_indices: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_face = struct_ufbx_face;
pub const struct_ufbx_face_list = extern struct {
    data: [*c]ufbx_face = @import("std").mem.zeroes([*c]ufbx_face),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_face_list = struct_ufbx_face_list;
const struct_unnamed_21 = extern struct {
    a: u32 = @import("std").mem.zeroes(u32),
    b: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_20 = extern union {
    unnamed_0: struct_unnamed_21,
    indices: [2]u32,
};
pub const struct_ufbx_edge = extern struct {
    unnamed_0: union_unnamed_20 = @import("std").mem.zeroes(union_unnamed_20),
};
pub const ufbx_edge = struct_ufbx_edge;
pub const struct_ufbx_edge_list = extern struct {
    data: [*c]ufbx_edge = @import("std").mem.zeroes([*c]ufbx_edge),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_edge_list = struct_ufbx_edge_list;
pub const struct_ufbx_vertex_vec3 = extern struct {
    exists: bool = @import("std").mem.zeroes(bool),
    values: ufbx_vec3_list = @import("std").mem.zeroes(ufbx_vec3_list),
    indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    value_reals: usize = @import("std").mem.zeroes(usize),
    unique_per_vertex: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_vertex_vec3 = struct_ufbx_vertex_vec3;
pub const struct_ufbx_vertex_vec2 = extern struct {
    exists: bool = @import("std").mem.zeroes(bool),
    values: ufbx_vec2_list = @import("std").mem.zeroes(ufbx_vec2_list),
    indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    value_reals: usize = @import("std").mem.zeroes(usize),
    unique_per_vertex: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_vertex_vec2 = struct_ufbx_vertex_vec2;
pub const struct_ufbx_vertex_vec4 = extern struct {
    exists: bool = @import("std").mem.zeroes(bool),
    values: ufbx_vec4_list = @import("std").mem.zeroes(ufbx_vec4_list),
    indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    value_reals: usize = @import("std").mem.zeroes(usize),
    unique_per_vertex: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_vertex_vec4 = struct_ufbx_vertex_vec4;
pub const struct_ufbx_vertex_real = extern struct {
    exists: bool = @import("std").mem.zeroes(bool),
    values: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
    indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    value_reals: usize = @import("std").mem.zeroes(usize),
    unique_per_vertex: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_vertex_real = struct_ufbx_vertex_real;
pub const struct_ufbx_uv_set = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    index: u32 = @import("std").mem.zeroes(u32),
    vertex_uv: ufbx_vertex_vec2 = @import("std").mem.zeroes(ufbx_vertex_vec2),
    vertex_tangent: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    vertex_bitangent: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
};
pub const ufbx_uv_set = struct_ufbx_uv_set;
pub const struct_ufbx_uv_set_list = extern struct {
    data: [*c]ufbx_uv_set = @import("std").mem.zeroes([*c]ufbx_uv_set),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_uv_set_list = struct_ufbx_uv_set_list;
pub const struct_ufbx_color_set = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    index: u32 = @import("std").mem.zeroes(u32),
    vertex_color: ufbx_vertex_vec4 = @import("std").mem.zeroes(ufbx_vertex_vec4),
};
pub const ufbx_color_set = struct_ufbx_color_set;
pub const struct_ufbx_color_set_list = extern struct {
    data: [*c]ufbx_color_set = @import("std").mem.zeroes([*c]ufbx_color_set),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_color_set_list = struct_ufbx_color_set_list;
const struct_unnamed_23 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_22 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_23,
};
const union_unnamed_25 = extern union {
    value_real: ufbx_real,
    value_vec2: ufbx_vec2,
    value_vec3: ufbx_vec3,
    value_vec4: ufbx_vec4,
};
const struct_unnamed_27 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_26 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_27,
};
pub const UFBX_TEXTURE_FILE: c_int = 0;
pub const UFBX_TEXTURE_LAYERED: c_int = 1;
pub const UFBX_TEXTURE_PROCEDURAL: c_int = 2;
pub const UFBX_TEXTURE_SHADER: c_int = 3;
pub const UFBX_TEXTURE_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_texture_type = c_uint;
pub const ufbx_texture_type = enum_ufbx_texture_type;
const struct_unnamed_29 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_28 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_29,
};
pub const struct_ufbx_video = extern struct {
    unnamed_0: union_unnamed_28 = @import("std").mem.zeroes(union_unnamed_28),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    absolute_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    relative_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_absolute_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_relative_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    content: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
};
pub const ufbx_video = struct_ufbx_video;
pub const UFBX_BLEND_TRANSLUCENT: c_int = 0;
pub const UFBX_BLEND_ADDITIVE: c_int = 1;
pub const UFBX_BLEND_MULTIPLY: c_int = 2;
pub const UFBX_BLEND_MULTIPLY_2X: c_int = 3;
pub const UFBX_BLEND_OVER: c_int = 4;
pub const UFBX_BLEND_REPLACE: c_int = 5;
pub const UFBX_BLEND_DISSOLVE: c_int = 6;
pub const UFBX_BLEND_DARKEN: c_int = 7;
pub const UFBX_BLEND_COLOR_BURN: c_int = 8;
pub const UFBX_BLEND_LINEAR_BURN: c_int = 9;
pub const UFBX_BLEND_DARKER_COLOR: c_int = 10;
pub const UFBX_BLEND_LIGHTEN: c_int = 11;
pub const UFBX_BLEND_SCREEN: c_int = 12;
pub const UFBX_BLEND_COLOR_DODGE: c_int = 13;
pub const UFBX_BLEND_LINEAR_DODGE: c_int = 14;
pub const UFBX_BLEND_LIGHTER_COLOR: c_int = 15;
pub const UFBX_BLEND_SOFT_LIGHT: c_int = 16;
pub const UFBX_BLEND_HARD_LIGHT: c_int = 17;
pub const UFBX_BLEND_VIVID_LIGHT: c_int = 18;
pub const UFBX_BLEND_LINEAR_LIGHT: c_int = 19;
pub const UFBX_BLEND_PIN_LIGHT: c_int = 20;
pub const UFBX_BLEND_HARD_MIX: c_int = 21;
pub const UFBX_BLEND_DIFFERENCE: c_int = 22;
pub const UFBX_BLEND_EXCLUSION: c_int = 23;
pub const UFBX_BLEND_SUBTRACT: c_int = 24;
pub const UFBX_BLEND_DIVIDE: c_int = 25;
pub const UFBX_BLEND_HUE: c_int = 26;
pub const UFBX_BLEND_SATURATION: c_int = 27;
pub const UFBX_BLEND_COLOR: c_int = 28;
pub const UFBX_BLEND_LUMINOSITY: c_int = 29;
pub const UFBX_BLEND_OVERLAY: c_int = 30;
pub const UFBX_BLEND_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_blend_mode = c_uint;
pub const ufbx_blend_mode = enum_ufbx_blend_mode;
pub const struct_ufbx_texture_layer = extern struct {
    texture: [*c]ufbx_texture = @import("std").mem.zeroes([*c]ufbx_texture),
    blend_mode: ufbx_blend_mode = @import("std").mem.zeroes(ufbx_blend_mode),
    alpha: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_texture_layer = struct_ufbx_texture_layer;
pub const struct_ufbx_texture_layer_list = extern struct {
    data: [*c]ufbx_texture_layer = @import("std").mem.zeroes([*c]ufbx_texture_layer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_texture_layer_list = struct_ufbx_texture_layer_list;
pub const UFBX_SHADER_TEXTURE_UNKNOWN: c_int = 0;
pub const UFBX_SHADER_TEXTURE_SELECT_OUTPUT: c_int = 1;
pub const UFBX_SHADER_TEXTURE_OSL: c_int = 2;
pub const UFBX_SHADER_TEXTURE_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_shader_texture_type = c_uint;
pub const ufbx_shader_texture_type = enum_ufbx_shader_texture_type;
const union_unnamed_30 = extern union {
    value_real: ufbx_real,
    value_vec2: ufbx_vec2,
    value_vec3: ufbx_vec3,
    value_vec4: ufbx_vec4,
};
pub const struct_ufbx_shader_texture_input = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    unnamed_0: union_unnamed_30 = @import("std").mem.zeroes(union_unnamed_30),
    value_int: i64 = @import("std").mem.zeroes(i64),
    value_str: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value_blob: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    texture: [*c]ufbx_texture = @import("std").mem.zeroes([*c]ufbx_texture),
    texture_output_index: i64 = @import("std").mem.zeroes(i64),
    texture_enabled: bool = @import("std").mem.zeroes(bool),
    prop: [*c]ufbx_prop = @import("std").mem.zeroes([*c]ufbx_prop),
    texture_prop: [*c]ufbx_prop = @import("std").mem.zeroes([*c]ufbx_prop),
    texture_enabled_prop: [*c]ufbx_prop = @import("std").mem.zeroes([*c]ufbx_prop),
};
pub const ufbx_shader_texture_input = struct_ufbx_shader_texture_input;
pub const struct_ufbx_shader_texture_input_list = extern struct {
    data: [*c]ufbx_shader_texture_input = @import("std").mem.zeroes([*c]ufbx_shader_texture_input),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_shader_texture_input_list = struct_ufbx_shader_texture_input_list;
pub const struct_ufbx_shader_texture = extern struct {
    type: ufbx_shader_texture_type = @import("std").mem.zeroes(ufbx_shader_texture_type),
    shader_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    shader_type_id: u64 = @import("std").mem.zeroes(u64),
    inputs: ufbx_shader_texture_input_list = @import("std").mem.zeroes(ufbx_shader_texture_input_list),
    shader_source: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_shader_source: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    main_texture: [*c]ufbx_texture = @import("std").mem.zeroes([*c]ufbx_texture),
    main_texture_output_index: i64 = @import("std").mem.zeroes(i64),
    prop_prefix: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_shader_texture = struct_ufbx_shader_texture;
pub const struct_ufbx_texture_list = extern struct {
    data: [*c][*c]ufbx_texture = @import("std").mem.zeroes([*c][*c]ufbx_texture),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_texture_list = struct_ufbx_texture_list;
pub const UFBX_WRAP_REPEAT: c_int = 0;
pub const UFBX_WRAP_CLAMP: c_int = 1;
pub const UFBX_WRAP_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_wrap_mode = c_uint;
pub const ufbx_wrap_mode = enum_ufbx_wrap_mode;
pub const struct_ufbx_texture = extern struct {
    unnamed_0: union_unnamed_26 = @import("std").mem.zeroes(union_unnamed_26),
    type: ufbx_texture_type = @import("std").mem.zeroes(ufbx_texture_type),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    absolute_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    relative_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_absolute_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_relative_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    content: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    video: [*c]ufbx_video = @import("std").mem.zeroes([*c]ufbx_video),
    file_index: u32 = @import("std").mem.zeroes(u32),
    has_file: bool = @import("std").mem.zeroes(bool),
    layers: ufbx_texture_layer_list = @import("std").mem.zeroes(ufbx_texture_layer_list),
    shader: [*c]ufbx_shader_texture = @import("std").mem.zeroes([*c]ufbx_shader_texture),
    file_textures: ufbx_texture_list = @import("std").mem.zeroes(ufbx_texture_list),
    uv_set: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    wrap_u: ufbx_wrap_mode = @import("std").mem.zeroes(ufbx_wrap_mode),
    wrap_v: ufbx_wrap_mode = @import("std").mem.zeroes(ufbx_wrap_mode),
    has_uv_transform: bool = @import("std").mem.zeroes(bool),
    uv_transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    texture_to_uv: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    uv_to_texture: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
};
pub const ufbx_texture = struct_ufbx_texture;
pub const struct_ufbx_material_map = extern struct {
    unnamed_0: union_unnamed_25 = @import("std").mem.zeroes(union_unnamed_25),
    value_int: i64 = @import("std").mem.zeroes(i64),
    texture: [*c]ufbx_texture = @import("std").mem.zeroes([*c]ufbx_texture),
    has_value: bool = @import("std").mem.zeroes(bool),
    texture_enabled: bool = @import("std").mem.zeroes(bool),
    feature_disabled: bool = @import("std").mem.zeroes(bool),
    value_components: u8 = @import("std").mem.zeroes(u8),
};
pub const ufbx_material_map = struct_ufbx_material_map;
const struct_unnamed_31 = extern struct {
    diffuse_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    diffuse_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_exponent: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    reflection_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    reflection_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transparency_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transparency_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    emission_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    emission_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    ambient_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    ambient_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    normal_map: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    bump: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    bump_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    displacement_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    displacement: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    vector_displacement_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    vector_displacement: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
};
const union_unnamed_24 = extern union {
    maps: [20]ufbx_material_map,
    unnamed_0: struct_unnamed_31,
};
pub const struct_ufbx_material_fbx_maps = extern struct {
    unnamed_0: union_unnamed_24 = @import("std").mem.zeroes(union_unnamed_24),
};
pub const ufbx_material_fbx_maps = struct_ufbx_material_fbx_maps;
const struct_unnamed_33 = extern struct {
    base_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    base_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    metalness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    diffuse_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_ior: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_anisotropy: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    specular_rotation: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_depth: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_scatter: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_scatter_anisotropy: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_dispersion: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_extra_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_priority: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_enable_in_aov: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_radius: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_scale: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_anisotropy: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_tint_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    subsurface_type: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    sheen_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    sheen_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    sheen_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_ior: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_anisotropy: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_rotation: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_normal: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_affect_base_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_affect_base_roughness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    thin_film_thickness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    thin_film_ior: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    emission_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    emission_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    opacity: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    indirect_diffuse: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    indirect_specular: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    normal_map: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    tangent_map: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    displacement_map: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    matte_factor: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    matte_color: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    ambient_occlusion: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    glossiness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    coat_glossiness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
    transmission_glossiness: ufbx_material_map = @import("std").mem.zeroes(ufbx_material_map),
};
const union_unnamed_32 = extern union {
    maps: [55]ufbx_material_map,
    unnamed_0: struct_unnamed_33,
};
pub const struct_ufbx_material_pbr_maps = extern struct {
    unnamed_0: union_unnamed_32 = @import("std").mem.zeroes(union_unnamed_32),
};
pub const ufbx_material_pbr_maps = struct_ufbx_material_pbr_maps;
pub const struct_ufbx_material_feature_info = extern struct {
    enabled: bool = @import("std").mem.zeroes(bool),
    is_explicit: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_material_feature_info = struct_ufbx_material_feature_info;
const struct_unnamed_35 = extern struct {
    pbr: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    metalness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    diffuse: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    specular: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    emission: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    transmission: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    coat: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    sheen: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    opacity: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    ambient_occlusion: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    matte: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    unlit: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    ior: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    diffuse_roughness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    transmission_roughness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    thin_walled: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    caustics: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    exit_to_background: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    internal_reflections: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    double_sided: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    roughness_as_glossiness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    coat_roughness_as_glossiness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
    transmission_roughness_as_glossiness: ufbx_material_feature_info = @import("std").mem.zeroes(ufbx_material_feature_info),
};
const union_unnamed_34 = extern union {
    features: [23]ufbx_material_feature_info,
    unnamed_0: struct_unnamed_35,
};
pub const struct_ufbx_material_features = extern struct {
    unnamed_0: union_unnamed_34 = @import("std").mem.zeroes(union_unnamed_34),
};
pub const ufbx_material_features = struct_ufbx_material_features;
pub const UFBX_SHADER_UNKNOWN: c_int = 0;
pub const UFBX_SHADER_FBX_LAMBERT: c_int = 1;
pub const UFBX_SHADER_FBX_PHONG: c_int = 2;
pub const UFBX_SHADER_OSL_STANDARD_SURFACE: c_int = 3;
pub const UFBX_SHADER_ARNOLD_STANDARD_SURFACE: c_int = 4;
pub const UFBX_SHADER_3DS_MAX_PHYSICAL_MATERIAL: c_int = 5;
pub const UFBX_SHADER_3DS_MAX_PBR_METAL_ROUGH: c_int = 6;
pub const UFBX_SHADER_3DS_MAX_PBR_SPEC_GLOSS: c_int = 7;
pub const UFBX_SHADER_GLTF_MATERIAL: c_int = 8;
pub const UFBX_SHADER_SHADERFX_GRAPH: c_int = 9;
pub const UFBX_SHADER_BLENDER_PHONG: c_int = 10;
pub const UFBX_SHADER_WAVEFRONT_MTL: c_int = 11;
pub const UFBX_SHADER_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_shader_type = c_uint;
pub const ufbx_shader_type = enum_ufbx_shader_type;
const struct_unnamed_37 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_36 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_37,
};
const struct_unnamed_39 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_38 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_39,
};
pub const struct_ufbx_shader_prop_binding = extern struct {
    shader_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    material_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_shader_prop_binding = struct_ufbx_shader_prop_binding;
pub const struct_ufbx_shader_prop_binding_list = extern struct {
    data: [*c]ufbx_shader_prop_binding = @import("std").mem.zeroes([*c]ufbx_shader_prop_binding),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_shader_prop_binding_list = struct_ufbx_shader_prop_binding_list;
pub const struct_ufbx_shader_binding = extern struct {
    unnamed_0: union_unnamed_38 = @import("std").mem.zeroes(union_unnamed_38),
    prop_bindings: ufbx_shader_prop_binding_list = @import("std").mem.zeroes(ufbx_shader_prop_binding_list),
};
pub const ufbx_shader_binding = struct_ufbx_shader_binding;
pub const struct_ufbx_shader_binding_list = extern struct {
    data: [*c][*c]ufbx_shader_binding = @import("std").mem.zeroes([*c][*c]ufbx_shader_binding),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_shader_binding_list = struct_ufbx_shader_binding_list;
pub const struct_ufbx_shader = extern struct {
    unnamed_0: union_unnamed_36 = @import("std").mem.zeroes(union_unnamed_36),
    type: ufbx_shader_type = @import("std").mem.zeroes(ufbx_shader_type),
    bindings: ufbx_shader_binding_list = @import("std").mem.zeroes(ufbx_shader_binding_list),
};
pub const ufbx_shader = struct_ufbx_shader;
pub const struct_ufbx_material_texture = extern struct {
    material_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    shader_prop: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    texture: [*c]ufbx_texture = @import("std").mem.zeroes([*c]ufbx_texture),
};
pub const ufbx_material_texture = struct_ufbx_material_texture;
pub const struct_ufbx_material_texture_list = extern struct {
    data: [*c]ufbx_material_texture = @import("std").mem.zeroes([*c]ufbx_material_texture),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_material_texture_list = struct_ufbx_material_texture_list;
pub const struct_ufbx_material = extern struct {
    unnamed_0: union_unnamed_22 = @import("std").mem.zeroes(union_unnamed_22),
    fbx: ufbx_material_fbx_maps = @import("std").mem.zeroes(ufbx_material_fbx_maps),
    pbr: ufbx_material_pbr_maps = @import("std").mem.zeroes(ufbx_material_pbr_maps),
    features: ufbx_material_features = @import("std").mem.zeroes(ufbx_material_features),
    shader_type: ufbx_shader_type = @import("std").mem.zeroes(ufbx_shader_type),
    shader: [*c]ufbx_shader = @import("std").mem.zeroes([*c]ufbx_shader),
    shading_model_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    shader_prop_prefix: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    textures: ufbx_material_texture_list = @import("std").mem.zeroes(ufbx_material_texture_list),
};
pub const ufbx_material = struct_ufbx_material;
pub const struct_ufbx_material_list = extern struct {
    data: [*c][*c]ufbx_material = @import("std").mem.zeroes([*c][*c]ufbx_material),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_material_list = struct_ufbx_material_list;
pub const struct_ufbx_face_group = extern struct {
    id: i32 = @import("std").mem.zeroes(i32),
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_face_group = struct_ufbx_face_group;
pub const struct_ufbx_face_group_list = extern struct {
    data: [*c]ufbx_face_group = @import("std").mem.zeroes([*c]ufbx_face_group),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_face_group_list = struct_ufbx_face_group_list;
pub const struct_ufbx_mesh_part = extern struct {
    index: u32 = @import("std").mem.zeroes(u32),
    num_faces: usize = @import("std").mem.zeroes(usize),
    num_triangles: usize = @import("std").mem.zeroes(usize),
    num_empty_faces: usize = @import("std").mem.zeroes(usize),
    num_point_faces: usize = @import("std").mem.zeroes(usize),
    num_line_faces: usize = @import("std").mem.zeroes(usize),
    face_indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
};
pub const ufbx_mesh_part = struct_ufbx_mesh_part;
pub const struct_ufbx_mesh_part_list = extern struct {
    data: [*c]ufbx_mesh_part = @import("std").mem.zeroes([*c]ufbx_mesh_part),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_mesh_part_list = struct_ufbx_mesh_part_list;
const struct_unnamed_41 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_40 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_41,
};
pub const UFBX_SKINNING_METHOD_LINEAR: c_int = 0;
pub const UFBX_SKINNING_METHOD_RIGID: c_int = 1;
pub const UFBX_SKINNING_METHOD_DUAL_QUATERNION: c_int = 2;
pub const UFBX_SKINNING_METHOD_BLENDED_DQ_LINEAR: c_int = 3;
pub const UFBX_SKINNING_METHOD_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_skinning_method = c_uint;
pub const ufbx_skinning_method = enum_ufbx_skinning_method;
const struct_unnamed_43 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_42 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_43,
};
pub const struct_ufbx_skin_cluster = extern struct {
    unnamed_0: union_unnamed_42 = @import("std").mem.zeroes(union_unnamed_42),
    bone_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    geometry_to_bone: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    mesh_node_to_bone: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    bind_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    geometry_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    geometry_to_world_transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    num_weights: usize = @import("std").mem.zeroes(usize),
    vertices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    weights: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
};
pub const ufbx_skin_cluster = struct_ufbx_skin_cluster;
pub const struct_ufbx_skin_cluster_list = extern struct {
    data: [*c][*c]ufbx_skin_cluster = @import("std").mem.zeroes([*c][*c]ufbx_skin_cluster),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_skin_cluster_list = struct_ufbx_skin_cluster_list;
pub const struct_ufbx_skin_vertex = extern struct {
    weight_begin: u32 = @import("std").mem.zeroes(u32),
    num_weights: u32 = @import("std").mem.zeroes(u32),
    dq_weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_skin_vertex = struct_ufbx_skin_vertex;
pub const struct_ufbx_skin_vertex_list = extern struct {
    data: [*c]ufbx_skin_vertex = @import("std").mem.zeroes([*c]ufbx_skin_vertex),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_skin_vertex_list = struct_ufbx_skin_vertex_list;
pub const struct_ufbx_skin_weight = extern struct {
    cluster_index: u32 = @import("std").mem.zeroes(u32),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_skin_weight = struct_ufbx_skin_weight;
pub const struct_ufbx_skin_weight_list = extern struct {
    data: [*c]ufbx_skin_weight = @import("std").mem.zeroes([*c]ufbx_skin_weight),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_skin_weight_list = struct_ufbx_skin_weight_list;
pub const struct_ufbx_skin_deformer = extern struct {
    unnamed_0: union_unnamed_40 = @import("std").mem.zeroes(union_unnamed_40),
    skinning_method: ufbx_skinning_method = @import("std").mem.zeroes(ufbx_skinning_method),
    clusters: ufbx_skin_cluster_list = @import("std").mem.zeroes(ufbx_skin_cluster_list),
    vertices: ufbx_skin_vertex_list = @import("std").mem.zeroes(ufbx_skin_vertex_list),
    weights: ufbx_skin_weight_list = @import("std").mem.zeroes(ufbx_skin_weight_list),
    max_weights_per_vertex: usize = @import("std").mem.zeroes(usize),
    num_dq_weights: usize = @import("std").mem.zeroes(usize),
    dq_vertices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    dq_weights: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
};
pub const ufbx_skin_deformer = struct_ufbx_skin_deformer;
pub const struct_ufbx_skin_deformer_list = extern struct {
    data: [*c][*c]ufbx_skin_deformer = @import("std").mem.zeroes([*c][*c]ufbx_skin_deformer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_skin_deformer_list = struct_ufbx_skin_deformer_list;
const struct_unnamed_45 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_44 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_45,
};
const struct_unnamed_47 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_46 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_47,
};
const struct_unnamed_49 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_48 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_49,
};
pub const struct_ufbx_blend_shape = extern struct {
    unnamed_0: union_unnamed_48 = @import("std").mem.zeroes(union_unnamed_48),
    num_offsets: usize = @import("std").mem.zeroes(usize),
    offset_vertices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    position_offsets: ufbx_vec3_list = @import("std").mem.zeroes(ufbx_vec3_list),
    normal_offsets: ufbx_vec3_list = @import("std").mem.zeroes(ufbx_vec3_list),
};
pub const ufbx_blend_shape = struct_ufbx_blend_shape;
pub const struct_ufbx_blend_keyframe = extern struct {
    shape: [*c]ufbx_blend_shape = @import("std").mem.zeroes([*c]ufbx_blend_shape),
    target_weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    effective_weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_blend_keyframe = struct_ufbx_blend_keyframe;
pub const struct_ufbx_blend_keyframe_list = extern struct {
    data: [*c]ufbx_blend_keyframe = @import("std").mem.zeroes([*c]ufbx_blend_keyframe),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_blend_keyframe_list = struct_ufbx_blend_keyframe_list;
pub const struct_ufbx_blend_channel = extern struct {
    unnamed_0: union_unnamed_46 = @import("std").mem.zeroes(union_unnamed_46),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    keyframes: ufbx_blend_keyframe_list = @import("std").mem.zeroes(ufbx_blend_keyframe_list),
    target_shape: [*c]ufbx_blend_shape = @import("std").mem.zeroes([*c]ufbx_blend_shape),
};
pub const ufbx_blend_channel = struct_ufbx_blend_channel;
pub const struct_ufbx_blend_channel_list = extern struct {
    data: [*c][*c]ufbx_blend_channel = @import("std").mem.zeroes([*c][*c]ufbx_blend_channel),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_blend_channel_list = struct_ufbx_blend_channel_list;
pub const struct_ufbx_blend_deformer = extern struct {
    unnamed_0: union_unnamed_44 = @import("std").mem.zeroes(union_unnamed_44),
    channels: ufbx_blend_channel_list = @import("std").mem.zeroes(ufbx_blend_channel_list),
};
pub const ufbx_blend_deformer = struct_ufbx_blend_deformer;
pub const struct_ufbx_blend_deformer_list = extern struct {
    data: [*c][*c]ufbx_blend_deformer = @import("std").mem.zeroes([*c][*c]ufbx_blend_deformer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_blend_deformer_list = struct_ufbx_blend_deformer_list;
const struct_unnamed_51 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_50 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_51,
};
const struct_unnamed_53 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_52 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_53,
};
pub const UFBX_CACHE_FILE_FORMAT_UNKNOWN: c_int = 0;
pub const UFBX_CACHE_FILE_FORMAT_PC2: c_int = 1;
pub const UFBX_CACHE_FILE_FORMAT_MC: c_int = 2;
pub const UFBX_CACHE_FILE_FORMAT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_cache_file_format = c_uint;
pub const ufbx_cache_file_format = enum_ufbx_cache_file_format;
pub const UFBX_CACHE_INTERPRETATION_UNKNOWN: c_int = 0;
pub const UFBX_CACHE_INTERPRETATION_POINTS: c_int = 1;
pub const UFBX_CACHE_INTERPRETATION_VERTEX_POSITION: c_int = 2;
pub const UFBX_CACHE_INTERPRETATION_VERTEX_NORMAL: c_int = 3;
pub const UFBX_CACHE_INTERPRETATION_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_cache_interpretation = c_uint;
pub const ufbx_cache_interpretation = enum_ufbx_cache_interpretation;
pub const UFBX_CACHE_DATA_FORMAT_UNKNOWN: c_int = 0;
pub const UFBX_CACHE_DATA_FORMAT_REAL_FLOAT: c_int = 1;
pub const UFBX_CACHE_DATA_FORMAT_VEC3_FLOAT: c_int = 2;
pub const UFBX_CACHE_DATA_FORMAT_REAL_DOUBLE: c_int = 3;
pub const UFBX_CACHE_DATA_FORMAT_VEC3_DOUBLE: c_int = 4;
pub const UFBX_CACHE_DATA_FORMAT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_cache_data_format = c_uint;
pub const ufbx_cache_data_format = enum_ufbx_cache_data_format;
pub const UFBX_CACHE_DATA_ENCODING_UNKNOWN: c_int = 0;
pub const UFBX_CACHE_DATA_ENCODING_LITTLE_ENDIAN: c_int = 1;
pub const UFBX_CACHE_DATA_ENCODING_BIG_ENDIAN: c_int = 2;
pub const UFBX_CACHE_DATA_ENCODING_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_cache_data_encoding = c_uint;
pub const ufbx_cache_data_encoding = enum_ufbx_cache_data_encoding;
pub const struct_ufbx_cache_frame = extern struct {
    channel: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    time: f64 = @import("std").mem.zeroes(f64),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    file_format: ufbx_cache_file_format = @import("std").mem.zeroes(ufbx_cache_file_format),
    mirror_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    scale_factor: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    data_format: ufbx_cache_data_format = @import("std").mem.zeroes(ufbx_cache_data_format),
    data_encoding: ufbx_cache_data_encoding = @import("std").mem.zeroes(ufbx_cache_data_encoding),
    data_offset: u64 = @import("std").mem.zeroes(u64),
    data_count: u32 = @import("std").mem.zeroes(u32),
    data_element_bytes: u32 = @import("std").mem.zeroes(u32),
    data_total_bytes: u64 = @import("std").mem.zeroes(u64),
};
pub const ufbx_cache_frame = struct_ufbx_cache_frame;
pub const struct_ufbx_cache_frame_list = extern struct {
    data: [*c]ufbx_cache_frame = @import("std").mem.zeroes([*c]ufbx_cache_frame),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_cache_frame_list = struct_ufbx_cache_frame_list;
pub const struct_ufbx_cache_channel = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    interpretation: ufbx_cache_interpretation = @import("std").mem.zeroes(ufbx_cache_interpretation),
    interpretation_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    frames: ufbx_cache_frame_list = @import("std").mem.zeroes(ufbx_cache_frame_list),
    mirror_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    scale_factor: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_cache_channel = struct_ufbx_cache_channel;
pub const struct_ufbx_cache_channel_list = extern struct {
    data: [*c]ufbx_cache_channel = @import("std").mem.zeroes([*c]ufbx_cache_channel),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_cache_channel_list = struct_ufbx_cache_channel_list;
pub const struct_ufbx_geometry_cache = extern struct {
    root_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    channels: ufbx_cache_channel_list = @import("std").mem.zeroes(ufbx_cache_channel_list),
    frames: ufbx_cache_frame_list = @import("std").mem.zeroes(ufbx_cache_frame_list),
    extra_info: ufbx_string_list = @import("std").mem.zeroes(ufbx_string_list),
};
pub const ufbx_geometry_cache = struct_ufbx_geometry_cache;
pub const struct_ufbx_cache_file = extern struct {
    unnamed_0: union_unnamed_52 = @import("std").mem.zeroes(union_unnamed_52),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    absolute_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    relative_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_absolute_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_relative_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    format: ufbx_cache_file_format = @import("std").mem.zeroes(ufbx_cache_file_format),
    external_cache: [*c]ufbx_geometry_cache = @import("std").mem.zeroes([*c]ufbx_geometry_cache),
};
pub const ufbx_cache_file = struct_ufbx_cache_file;
pub const struct_ufbx_cache_deformer = extern struct {
    unnamed_0: union_unnamed_50 = @import("std").mem.zeroes(union_unnamed_50),
    channel: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    file: [*c]ufbx_cache_file = @import("std").mem.zeroes([*c]ufbx_cache_file),
    external_cache: [*c]ufbx_geometry_cache = @import("std").mem.zeroes([*c]ufbx_geometry_cache),
    external_channel: [*c]ufbx_cache_channel = @import("std").mem.zeroes([*c]ufbx_cache_channel),
};
pub const ufbx_cache_deformer = struct_ufbx_cache_deformer;
pub const struct_ufbx_cache_deformer_list = extern struct {
    data: [*c][*c]ufbx_cache_deformer = @import("std").mem.zeroes([*c][*c]ufbx_cache_deformer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_cache_deformer_list = struct_ufbx_cache_deformer_list;
pub const struct_ufbx_element_list = extern struct {
    data: [*c][*c]ufbx_element = @import("std").mem.zeroes([*c][*c]ufbx_element),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_element_list = struct_ufbx_element_list;
pub const UFBX_SUBDIVISION_DISPLAY_DISABLED: c_int = 0;
pub const UFBX_SUBDIVISION_DISPLAY_HULL: c_int = 1;
pub const UFBX_SUBDIVISION_DISPLAY_HULL_AND_SMOOTH: c_int = 2;
pub const UFBX_SUBDIVISION_DISPLAY_SMOOTH: c_int = 3;
pub const UFBX_SUBDIVISION_DISPLAY_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_subdivision_display_mode = c_uint;
pub const ufbx_subdivision_display_mode = enum_ufbx_subdivision_display_mode;
pub const UFBX_SUBDIVISION_BOUNDARY_DEFAULT: c_int = 0;
pub const UFBX_SUBDIVISION_BOUNDARY_LEGACY: c_int = 1;
pub const UFBX_SUBDIVISION_BOUNDARY_SHARP_CORNERS: c_int = 2;
pub const UFBX_SUBDIVISION_BOUNDARY_SHARP_NONE: c_int = 3;
pub const UFBX_SUBDIVISION_BOUNDARY_SHARP_BOUNDARY: c_int = 4;
pub const UFBX_SUBDIVISION_BOUNDARY_SHARP_INTERIOR: c_int = 5;
pub const UFBX_SUBDIVISION_BOUNDARY_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_subdivision_boundary = c_uint;
pub const ufbx_subdivision_boundary = enum_ufbx_subdivision_boundary;
pub const struct_ufbx_subdivision_weight_range = extern struct {
    weight_begin: u32 = @import("std").mem.zeroes(u32),
    num_weights: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_subdivision_weight_range = struct_ufbx_subdivision_weight_range;
pub const struct_ufbx_subdivision_weight_range_list = extern struct {
    data: [*c]ufbx_subdivision_weight_range = @import("std").mem.zeroes([*c]ufbx_subdivision_weight_range),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_subdivision_weight_range_list = struct_ufbx_subdivision_weight_range_list;
pub const struct_ufbx_subdivision_weight = extern struct {
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    index: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_subdivision_weight = struct_ufbx_subdivision_weight;
pub const struct_ufbx_subdivision_weight_list = extern struct {
    data: [*c]ufbx_subdivision_weight = @import("std").mem.zeroes([*c]ufbx_subdivision_weight),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_subdivision_weight_list = struct_ufbx_subdivision_weight_list;
pub const struct_ufbx_subdivision_result = extern struct {
    result_memory_used: usize = @import("std").mem.zeroes(usize),
    temp_memory_used: usize = @import("std").mem.zeroes(usize),
    result_allocs: usize = @import("std").mem.zeroes(usize),
    temp_allocs: usize = @import("std").mem.zeroes(usize),
    source_vertex_ranges: ufbx_subdivision_weight_range_list = @import("std").mem.zeroes(ufbx_subdivision_weight_range_list),
    source_vertex_weights: ufbx_subdivision_weight_list = @import("std").mem.zeroes(ufbx_subdivision_weight_list),
    skin_cluster_ranges: ufbx_subdivision_weight_range_list = @import("std").mem.zeroes(ufbx_subdivision_weight_range_list),
    skin_cluster_weights: ufbx_subdivision_weight_list = @import("std").mem.zeroes(ufbx_subdivision_weight_list),
};
pub const ufbx_subdivision_result = struct_ufbx_subdivision_result;
pub const struct_ufbx_mesh = extern struct {
    unnamed_0: union_unnamed_18 = @import("std").mem.zeroes(union_unnamed_18),
    num_vertices: usize = @import("std").mem.zeroes(usize),
    num_indices: usize = @import("std").mem.zeroes(usize),
    num_faces: usize = @import("std").mem.zeroes(usize),
    num_triangles: usize = @import("std").mem.zeroes(usize),
    num_edges: usize = @import("std").mem.zeroes(usize),
    max_face_triangles: usize = @import("std").mem.zeroes(usize),
    num_empty_faces: usize = @import("std").mem.zeroes(usize),
    num_point_faces: usize = @import("std").mem.zeroes(usize),
    num_line_faces: usize = @import("std").mem.zeroes(usize),
    faces: ufbx_face_list = @import("std").mem.zeroes(ufbx_face_list),
    face_smoothing: ufbx_bool_list = @import("std").mem.zeroes(ufbx_bool_list),
    face_material: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    face_group: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    face_hole: ufbx_bool_list = @import("std").mem.zeroes(ufbx_bool_list),
    edges: ufbx_edge_list = @import("std").mem.zeroes(ufbx_edge_list),
    edge_smoothing: ufbx_bool_list = @import("std").mem.zeroes(ufbx_bool_list),
    edge_crease: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
    edge_visibility: ufbx_bool_list = @import("std").mem.zeroes(ufbx_bool_list),
    vertex_indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    vertices: ufbx_vec3_list = @import("std").mem.zeroes(ufbx_vec3_list),
    vertex_first_index: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    vertex_position: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    vertex_normal: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    vertex_uv: ufbx_vertex_vec2 = @import("std").mem.zeroes(ufbx_vertex_vec2),
    vertex_tangent: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    vertex_bitangent: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    vertex_color: ufbx_vertex_vec4 = @import("std").mem.zeroes(ufbx_vertex_vec4),
    vertex_crease: ufbx_vertex_real = @import("std").mem.zeroes(ufbx_vertex_real),
    uv_sets: ufbx_uv_set_list = @import("std").mem.zeroes(ufbx_uv_set_list),
    color_sets: ufbx_color_set_list = @import("std").mem.zeroes(ufbx_color_set_list),
    materials: ufbx_material_list = @import("std").mem.zeroes(ufbx_material_list),
    face_groups: ufbx_face_group_list = @import("std").mem.zeroes(ufbx_face_group_list),
    material_parts: ufbx_mesh_part_list = @import("std").mem.zeroes(ufbx_mesh_part_list),
    face_group_parts: ufbx_mesh_part_list = @import("std").mem.zeroes(ufbx_mesh_part_list),
    skinned_is_local: bool = @import("std").mem.zeroes(bool),
    skinned_position: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    skinned_normal: ufbx_vertex_vec3 = @import("std").mem.zeroes(ufbx_vertex_vec3),
    skin_deformers: ufbx_skin_deformer_list = @import("std").mem.zeroes(ufbx_skin_deformer_list),
    blend_deformers: ufbx_blend_deformer_list = @import("std").mem.zeroes(ufbx_blend_deformer_list),
    cache_deformers: ufbx_cache_deformer_list = @import("std").mem.zeroes(ufbx_cache_deformer_list),
    all_deformers: ufbx_element_list = @import("std").mem.zeroes(ufbx_element_list),
    subdivision_preview_levels: u32 = @import("std").mem.zeroes(u32),
    subdivision_render_levels: u32 = @import("std").mem.zeroes(u32),
    subdivision_display_mode: ufbx_subdivision_display_mode = @import("std").mem.zeroes(ufbx_subdivision_display_mode),
    subdivision_boundary: ufbx_subdivision_boundary = @import("std").mem.zeroes(ufbx_subdivision_boundary),
    subdivision_uv_boundary: ufbx_subdivision_boundary = @import("std").mem.zeroes(ufbx_subdivision_boundary),
    reversed_winding: bool = @import("std").mem.zeroes(bool),
    generated_normals: bool = @import("std").mem.zeroes(bool),
    subdivision_evaluated: bool = @import("std").mem.zeroes(bool),
    subdivision_result: [*c]ufbx_subdivision_result = @import("std").mem.zeroes([*c]ufbx_subdivision_result),
    from_tessellated_nurbs: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_mesh = struct_ufbx_mesh;
const struct_unnamed_55 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_54 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_55,
};
pub const UFBX_LIGHT_POINT: c_int = 0;
pub const UFBX_LIGHT_DIRECTIONAL: c_int = 1;
pub const UFBX_LIGHT_SPOT: c_int = 2;
pub const UFBX_LIGHT_AREA: c_int = 3;
pub const UFBX_LIGHT_VOLUME: c_int = 4;
pub const UFBX_LIGHT_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_light_type = c_uint;
pub const ufbx_light_type = enum_ufbx_light_type;
pub const UFBX_LIGHT_DECAY_NONE: c_int = 0;
pub const UFBX_LIGHT_DECAY_LINEAR: c_int = 1;
pub const UFBX_LIGHT_DECAY_QUADRATIC: c_int = 2;
pub const UFBX_LIGHT_DECAY_CUBIC: c_int = 3;
pub const UFBX_LIGHT_DECAY_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_light_decay = c_uint;
pub const ufbx_light_decay = enum_ufbx_light_decay;
pub const UFBX_LIGHT_AREA_SHAPE_RECTANGLE: c_int = 0;
pub const UFBX_LIGHT_AREA_SHAPE_SPHERE: c_int = 1;
pub const UFBX_LIGHT_AREA_SHAPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_light_area_shape = c_uint;
pub const ufbx_light_area_shape = enum_ufbx_light_area_shape;
pub const struct_ufbx_light = extern struct {
    unnamed_0: union_unnamed_54 = @import("std").mem.zeroes(union_unnamed_54),
    color: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    intensity: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    local_direction: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    type: ufbx_light_type = @import("std").mem.zeroes(ufbx_light_type),
    decay: ufbx_light_decay = @import("std").mem.zeroes(ufbx_light_decay),
    area_shape: ufbx_light_area_shape = @import("std").mem.zeroes(ufbx_light_area_shape),
    inner_angle: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    outer_angle: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    cast_light: bool = @import("std").mem.zeroes(bool),
    cast_shadows: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_light = struct_ufbx_light;
const struct_unnamed_57 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_56 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_57,
};
pub const UFBX_PROJECTION_MODE_PERSPECTIVE: c_int = 0;
pub const UFBX_PROJECTION_MODE_ORTHOGRAPHIC: c_int = 1;
pub const UFBX_PROJECTION_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_projection_mode = c_uint;
pub const ufbx_projection_mode = enum_ufbx_projection_mode;
pub const UFBX_ASPECT_MODE_WINDOW_SIZE: c_int = 0;
pub const UFBX_ASPECT_MODE_FIXED_RATIO: c_int = 1;
pub const UFBX_ASPECT_MODE_FIXED_RESOLUTION: c_int = 2;
pub const UFBX_ASPECT_MODE_FIXED_WIDTH: c_int = 3;
pub const UFBX_ASPECT_MODE_FIXED_HEIGHT: c_int = 4;
pub const UFBX_ASPECT_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_aspect_mode = c_uint;
pub const ufbx_aspect_mode = enum_ufbx_aspect_mode;
pub const UFBX_APERTURE_MODE_HORIZONTAL_AND_VERTICAL: c_int = 0;
pub const UFBX_APERTURE_MODE_HORIZONTAL: c_int = 1;
pub const UFBX_APERTURE_MODE_VERTICAL: c_int = 2;
pub const UFBX_APERTURE_MODE_FOCAL_LENGTH: c_int = 3;
pub const UFBX_APERTURE_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_aperture_mode = c_uint;
pub const ufbx_aperture_mode = enum_ufbx_aperture_mode;
pub const UFBX_GATE_FIT_NONE: c_int = 0;
pub const UFBX_GATE_FIT_VERTICAL: c_int = 1;
pub const UFBX_GATE_FIT_HORIZONTAL: c_int = 2;
pub const UFBX_GATE_FIT_FILL: c_int = 3;
pub const UFBX_GATE_FIT_OVERSCAN: c_int = 4;
pub const UFBX_GATE_FIT_STRETCH: c_int = 5;
pub const UFBX_GATE_FIT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_gate_fit = c_uint;
pub const ufbx_gate_fit = enum_ufbx_gate_fit;
pub const UFBX_APERTURE_FORMAT_CUSTOM: c_int = 0;
pub const UFBX_APERTURE_FORMAT_16MM_THEATRICAL: c_int = 1;
pub const UFBX_APERTURE_FORMAT_SUPER_16MM: c_int = 2;
pub const UFBX_APERTURE_FORMAT_35MM_ACADEMY: c_int = 3;
pub const UFBX_APERTURE_FORMAT_35MM_TV_PROJECTION: c_int = 4;
pub const UFBX_APERTURE_FORMAT_35MM_FULL_APERTURE: c_int = 5;
pub const UFBX_APERTURE_FORMAT_35MM_185_PROJECTION: c_int = 6;
pub const UFBX_APERTURE_FORMAT_35MM_ANAMORPHIC: c_int = 7;
pub const UFBX_APERTURE_FORMAT_70MM_PROJECTION: c_int = 8;
pub const UFBX_APERTURE_FORMAT_VISTAVISION: c_int = 9;
pub const UFBX_APERTURE_FORMAT_DYNAVISION: c_int = 10;
pub const UFBX_APERTURE_FORMAT_IMAX: c_int = 11;
pub const UFBX_APERTURE_FORMAT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_aperture_format = c_uint;
pub const ufbx_aperture_format = enum_ufbx_aperture_format;
pub const struct_ufbx_camera = extern struct {
    unnamed_0: union_unnamed_56 = @import("std").mem.zeroes(union_unnamed_56),
    projection_mode: ufbx_projection_mode = @import("std").mem.zeroes(ufbx_projection_mode),
    resolution_is_pixels: bool = @import("std").mem.zeroes(bool),
    resolution: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    field_of_view_deg: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    field_of_view_tan: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    orthographic_extent: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    orthographic_size: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    projection_plane: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    aspect_ratio: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    near_plane: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    far_plane: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    projection_axes: ufbx_coordinate_axes = @import("std").mem.zeroes(ufbx_coordinate_axes),
    aspect_mode: ufbx_aspect_mode = @import("std").mem.zeroes(ufbx_aspect_mode),
    aperture_mode: ufbx_aperture_mode = @import("std").mem.zeroes(ufbx_aperture_mode),
    gate_fit: ufbx_gate_fit = @import("std").mem.zeroes(ufbx_gate_fit),
    aperture_format: ufbx_aperture_format = @import("std").mem.zeroes(ufbx_aperture_format),
    focal_length_mm: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    film_size_inch: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    aperture_size_inch: ufbx_vec2 = @import("std").mem.zeroes(ufbx_vec2),
    squeeze_ratio: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_camera = struct_ufbx_camera;
pub const UFBX_INHERIT_MODE_NORMAL: c_int = 0;
pub const UFBX_INHERIT_MODE_IGNORE_PARENT_SCALE: c_int = 1;
pub const UFBX_INHERIT_MODE_COMPONENTWISE_SCALE: c_int = 2;
pub const UFBX_INHERIT_MODE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_inherit_mode = c_uint;
pub const ufbx_inherit_mode = enum_ufbx_inherit_mode;
pub const struct_ufbx_node = extern struct {
    unnamed_0: union_unnamed_16 = @import("std").mem.zeroes(union_unnamed_16),
    parent: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    children: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
    mesh: [*c]ufbx_mesh = @import("std").mem.zeroes([*c]ufbx_mesh),
    light: [*c]ufbx_light = @import("std").mem.zeroes([*c]ufbx_light),
    camera: [*c]ufbx_camera = @import("std").mem.zeroes([*c]ufbx_camera),
    attrib: [*c]ufbx_element = @import("std").mem.zeroes([*c]ufbx_element),
    geometry_transform_helper: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    scale_helper: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    attrib_type: ufbx_element_type = @import("std").mem.zeroes(ufbx_element_type),
    all_attribs: ufbx_element_list = @import("std").mem.zeroes(ufbx_element_list),
    inherit_mode: ufbx_inherit_mode = @import("std").mem.zeroes(ufbx_inherit_mode),
    original_inherit_mode: ufbx_inherit_mode = @import("std").mem.zeroes(ufbx_inherit_mode),
    local_transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    geometry_transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    inherit_scale: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    inherit_scale_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    rotation_order: ufbx_rotation_order = @import("std").mem.zeroes(ufbx_rotation_order),
    euler_rotation: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    node_to_parent: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    node_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    geometry_to_node: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    geometry_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    unscaled_node_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
    adjust_pre_rotation: ufbx_quat = @import("std").mem.zeroes(ufbx_quat),
    adjust_pre_scale: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    adjust_post_rotation: ufbx_quat = @import("std").mem.zeroes(ufbx_quat),
    adjust_post_scale: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    adjust_translation_scale: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    adjust_mirror_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    materials: ufbx_material_list = @import("std").mem.zeroes(ufbx_material_list),
    visible: bool = @import("std").mem.zeroes(bool),
    is_root: bool = @import("std").mem.zeroes(bool),
    has_geometry_transform: bool = @import("std").mem.zeroes(bool),
    has_adjust_transform: bool = @import("std").mem.zeroes(bool),
    has_root_adjust_transform: bool = @import("std").mem.zeroes(bool),
    is_geometry_transform_helper: bool = @import("std").mem.zeroes(bool),
    is_scale_helper: bool = @import("std").mem.zeroes(bool),
    is_scale_compensate_parent: bool = @import("std").mem.zeroes(bool),
    node_depth: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_node = struct_ufbx_node;
const struct_unnamed_59 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_58 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_59,
};
const struct_unnamed_61 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_60 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_61,
};
const struct_unnamed_63 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_62 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_63,
};
pub const UFBX_INTERPOLATION_CONSTANT_PREV: c_int = 0;
pub const UFBX_INTERPOLATION_CONSTANT_NEXT: c_int = 1;
pub const UFBX_INTERPOLATION_LINEAR: c_int = 2;
pub const UFBX_INTERPOLATION_CUBIC: c_int = 3;
pub const UFBX_INTERPOLATION_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_interpolation = c_uint;
pub const ufbx_interpolation = enum_ufbx_interpolation;
pub const struct_ufbx_tangent = extern struct {
    dx: f32 = @import("std").mem.zeroes(f32),
    dy: f32 = @import("std").mem.zeroes(f32),
};
pub const ufbx_tangent = struct_ufbx_tangent;
pub const struct_ufbx_keyframe = extern struct {
    time: f64 = @import("std").mem.zeroes(f64),
    value: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    interpolation: ufbx_interpolation = @import("std").mem.zeroes(ufbx_interpolation),
    left: ufbx_tangent = @import("std").mem.zeroes(ufbx_tangent),
    right: ufbx_tangent = @import("std").mem.zeroes(ufbx_tangent),
};
pub const ufbx_keyframe = struct_ufbx_keyframe;
pub const struct_ufbx_keyframe_list = extern struct {
    data: [*c]ufbx_keyframe = @import("std").mem.zeroes([*c]ufbx_keyframe),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_keyframe_list = struct_ufbx_keyframe_list;
pub const struct_ufbx_anim_curve = extern struct {
    unnamed_0: union_unnamed_62 = @import("std").mem.zeroes(union_unnamed_62),
    keyframes: ufbx_keyframe_list = @import("std").mem.zeroes(ufbx_keyframe_list),
    min_value: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    max_value: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_anim_curve = struct_ufbx_anim_curve;
pub const struct_ufbx_anim_value = extern struct {
    unnamed_0: union_unnamed_60 = @import("std").mem.zeroes(union_unnamed_60),
    default_value: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    curves: [3][*c]ufbx_anim_curve = @import("std").mem.zeroes([3][*c]ufbx_anim_curve),
};
pub const ufbx_anim_value = struct_ufbx_anim_value;
pub const struct_ufbx_anim_value_list = extern struct {
    data: [*c][*c]ufbx_anim_value = @import("std").mem.zeroes([*c][*c]ufbx_anim_value),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_anim_value_list = struct_ufbx_anim_value_list;
pub const struct_ufbx_anim_prop = extern struct {
    element: [*c]ufbx_element = @import("std").mem.zeroes([*c]ufbx_element),
    _internal_key: u32 = @import("std").mem.zeroes(u32),
    prop_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    anim_value: [*c]ufbx_anim_value = @import("std").mem.zeroes([*c]ufbx_anim_value),
};
pub const ufbx_anim_prop = struct_ufbx_anim_prop;
pub const struct_ufbx_anim_prop_list = extern struct {
    data: [*c]ufbx_anim_prop = @import("std").mem.zeroes([*c]ufbx_anim_prop),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_anim_prop_list = struct_ufbx_anim_prop_list;
pub const struct_ufbx_anim_layer = extern struct {
    unnamed_0: union_unnamed_58 = @import("std").mem.zeroes(union_unnamed_58),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    weight_is_animated: bool = @import("std").mem.zeroes(bool),
    blended: bool = @import("std").mem.zeroes(bool),
    additive: bool = @import("std").mem.zeroes(bool),
    compose_rotation: bool = @import("std").mem.zeroes(bool),
    compose_scale: bool = @import("std").mem.zeroes(bool),
    anim_values: ufbx_anim_value_list = @import("std").mem.zeroes(ufbx_anim_value_list),
    anim_props: ufbx_anim_prop_list = @import("std").mem.zeroes(ufbx_anim_prop_list),
    anim: [*c]ufbx_anim = @import("std").mem.zeroes([*c]ufbx_anim),
    _min_element_id: u32 = @import("std").mem.zeroes(u32),
    _max_element_id: u32 = @import("std").mem.zeroes(u32),
    _element_id_bitmask: [4]u32 = @import("std").mem.zeroes([4]u32),
};
pub const ufbx_anim_layer = struct_ufbx_anim_layer;
pub const struct_ufbx_anim_layer_list = extern struct {
    data: [*c][*c]ufbx_anim_layer = @import("std").mem.zeroes([*c][*c]ufbx_anim_layer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_anim_layer_list = struct_ufbx_anim_layer_list;
pub const struct_ufbx_prop_override = extern struct {
    element_id: u32 = @import("std").mem.zeroes(u32),
    _internal_key: u32 = @import("std").mem.zeroes(u32),
    prop_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value: ufbx_vec4 = @import("std").mem.zeroes(ufbx_vec4),
    value_str: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value_int: i64 = @import("std").mem.zeroes(i64),
};
pub const ufbx_prop_override = struct_ufbx_prop_override;
pub const struct_ufbx_prop_override_list = extern struct {
    data: [*c]ufbx_prop_override = @import("std").mem.zeroes([*c]ufbx_prop_override),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_prop_override_list = struct_ufbx_prop_override_list;
pub const struct_ufbx_transform_override = extern struct {
    node_id: u32 = @import("std").mem.zeroes(u32),
    transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
};
pub const ufbx_transform_override = struct_ufbx_transform_override;
pub const struct_ufbx_transform_override_list = extern struct {
    data: [*c]ufbx_transform_override = @import("std").mem.zeroes([*c]ufbx_transform_override),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_transform_override_list = struct_ufbx_transform_override_list;
pub const struct_ufbx_anim = extern struct {
    time_begin: f64 = @import("std").mem.zeroes(f64),
    time_end: f64 = @import("std").mem.zeroes(f64),
    layers: ufbx_anim_layer_list = @import("std").mem.zeroes(ufbx_anim_layer_list),
    override_layer_weights: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
    prop_overrides: ufbx_prop_override_list = @import("std").mem.zeroes(ufbx_prop_override_list),
    transform_overrides: ufbx_transform_override_list = @import("std").mem.zeroes(ufbx_transform_override_list),
    ignore_connections: bool = @import("std").mem.zeroes(bool),
    custom: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_anim = struct_ufbx_anim;
const struct_unnamed_67 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_66 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_67,
};
pub const struct_ufbx_unknown = extern struct {
    unnamed_0: union_unnamed_66 = @import("std").mem.zeroes(union_unnamed_66),
    type: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    super_type: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    sub_type: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_unknown = struct_ufbx_unknown;
pub const struct_ufbx_unknown_list = extern struct {
    data: [*c][*c]ufbx_unknown = @import("std").mem.zeroes([*c][*c]ufbx_unknown),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_unknown_list = struct_ufbx_unknown_list;
pub const struct_ufbx_mesh_list = extern struct {
    data: [*c][*c]ufbx_mesh = @import("std").mem.zeroes([*c][*c]ufbx_mesh),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_mesh_list = struct_ufbx_mesh_list;
pub const struct_ufbx_light_list = extern struct {
    data: [*c][*c]ufbx_light = @import("std").mem.zeroes([*c][*c]ufbx_light),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_light_list = struct_ufbx_light_list;
pub const struct_ufbx_camera_list = extern struct {
    data: [*c][*c]ufbx_camera = @import("std").mem.zeroes([*c][*c]ufbx_camera),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_camera_list = struct_ufbx_camera_list;
const struct_unnamed_69 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_68 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_69,
};
pub const struct_ufbx_bone = extern struct {
    unnamed_0: union_unnamed_68 = @import("std").mem.zeroes(union_unnamed_68),
    radius: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    relative_length: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    is_root: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_bone = struct_ufbx_bone;
pub const struct_ufbx_bone_list = extern struct {
    data: [*c][*c]ufbx_bone = @import("std").mem.zeroes([*c][*c]ufbx_bone),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_bone_list = struct_ufbx_bone_list;
const struct_unnamed_71 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_70 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_71,
};
pub const struct_ufbx_empty = extern struct {
    unnamed_0: union_unnamed_70 = @import("std").mem.zeroes(union_unnamed_70),
};
pub const ufbx_empty = struct_ufbx_empty;
pub const struct_ufbx_empty_list = extern struct {
    data: [*c][*c]ufbx_empty = @import("std").mem.zeroes([*c][*c]ufbx_empty),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_empty_list = struct_ufbx_empty_list;
const struct_unnamed_73 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_72 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_73,
};
pub const struct_ufbx_line_segment = extern struct {
    index_begin: u32 = @import("std").mem.zeroes(u32),
    num_indices: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_line_segment = struct_ufbx_line_segment;
pub const struct_ufbx_line_segment_list = extern struct {
    data: [*c]ufbx_line_segment = @import("std").mem.zeroes([*c]ufbx_line_segment),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_line_segment_list = struct_ufbx_line_segment_list;
pub const struct_ufbx_line_curve = extern struct {
    unnamed_0: union_unnamed_72 = @import("std").mem.zeroes(union_unnamed_72),
    color: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    control_points: ufbx_vec3_list = @import("std").mem.zeroes(ufbx_vec3_list),
    point_indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    segments: ufbx_line_segment_list = @import("std").mem.zeroes(ufbx_line_segment_list),
    from_tessellated_nurbs: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_line_curve = struct_ufbx_line_curve;
pub const struct_ufbx_line_curve_list = extern struct {
    data: [*c][*c]ufbx_line_curve = @import("std").mem.zeroes([*c][*c]ufbx_line_curve),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_line_curve_list = struct_ufbx_line_curve_list;
const struct_unnamed_75 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_74 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_75,
};
pub const UFBX_NURBS_TOPOLOGY_OPEN: c_int = 0;
pub const UFBX_NURBS_TOPOLOGY_PERIODIC: c_int = 1;
pub const UFBX_NURBS_TOPOLOGY_CLOSED: c_int = 2;
pub const UFBX_NURBS_TOPOLOGY_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_nurbs_topology = c_uint;
pub const ufbx_nurbs_topology = enum_ufbx_nurbs_topology;
pub const struct_ufbx_nurbs_basis = extern struct {
    order: u32 = @import("std").mem.zeroes(u32),
    topology: ufbx_nurbs_topology = @import("std").mem.zeroes(ufbx_nurbs_topology),
    knot_vector: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
    t_min: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    t_max: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    spans: ufbx_real_list = @import("std").mem.zeroes(ufbx_real_list),
    is_2d: bool = @import("std").mem.zeroes(bool),
    num_wrap_control_points: usize = @import("std").mem.zeroes(usize),
    valid: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_nurbs_basis = struct_ufbx_nurbs_basis;
pub const struct_ufbx_nurbs_curve = extern struct {
    unnamed_0: union_unnamed_74 = @import("std").mem.zeroes(union_unnamed_74),
    basis: ufbx_nurbs_basis = @import("std").mem.zeroes(ufbx_nurbs_basis),
    control_points: ufbx_vec4_list = @import("std").mem.zeroes(ufbx_vec4_list),
};
pub const ufbx_nurbs_curve = struct_ufbx_nurbs_curve;
pub const struct_ufbx_nurbs_curve_list = extern struct {
    data: [*c][*c]ufbx_nurbs_curve = @import("std").mem.zeroes([*c][*c]ufbx_nurbs_curve),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_nurbs_curve_list = struct_ufbx_nurbs_curve_list;
const struct_unnamed_77 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_76 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_77,
};
pub const struct_ufbx_nurbs_surface = extern struct {
    unnamed_0: union_unnamed_76 = @import("std").mem.zeroes(union_unnamed_76),
    basis_u: ufbx_nurbs_basis = @import("std").mem.zeroes(ufbx_nurbs_basis),
    basis_v: ufbx_nurbs_basis = @import("std").mem.zeroes(ufbx_nurbs_basis),
    num_control_points_u: usize = @import("std").mem.zeroes(usize),
    num_control_points_v: usize = @import("std").mem.zeroes(usize),
    control_points: ufbx_vec4_list = @import("std").mem.zeroes(ufbx_vec4_list),
    span_subdivision_u: u32 = @import("std").mem.zeroes(u32),
    span_subdivision_v: u32 = @import("std").mem.zeroes(u32),
    flip_normals: bool = @import("std").mem.zeroes(bool),
    material: [*c]ufbx_material = @import("std").mem.zeroes([*c]ufbx_material),
};
pub const ufbx_nurbs_surface = struct_ufbx_nurbs_surface;
pub const struct_ufbx_nurbs_surface_list = extern struct {
    data: [*c][*c]ufbx_nurbs_surface = @import("std").mem.zeroes([*c][*c]ufbx_nurbs_surface),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_nurbs_surface_list = struct_ufbx_nurbs_surface_list;
const struct_unnamed_79 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_78 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_79,
};
pub const struct_ufbx_nurbs_trim_surface = extern struct {
    unnamed_0: union_unnamed_78 = @import("std").mem.zeroes(union_unnamed_78),
};
pub const ufbx_nurbs_trim_surface = struct_ufbx_nurbs_trim_surface;
pub const struct_ufbx_nurbs_trim_surface_list = extern struct {
    data: [*c][*c]ufbx_nurbs_trim_surface = @import("std").mem.zeroes([*c][*c]ufbx_nurbs_trim_surface),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_nurbs_trim_surface_list = struct_ufbx_nurbs_trim_surface_list;
const struct_unnamed_81 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_80 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_81,
};
pub const struct_ufbx_nurbs_trim_boundary = extern struct {
    unnamed_0: union_unnamed_80 = @import("std").mem.zeroes(union_unnamed_80),
};
pub const ufbx_nurbs_trim_boundary = struct_ufbx_nurbs_trim_boundary;
pub const struct_ufbx_nurbs_trim_boundary_list = extern struct {
    data: [*c][*c]ufbx_nurbs_trim_boundary = @import("std").mem.zeroes([*c][*c]ufbx_nurbs_trim_boundary),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_nurbs_trim_boundary_list = struct_ufbx_nurbs_trim_boundary_list;
const struct_unnamed_83 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_82 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_83,
};
pub const struct_ufbx_procedural_geometry = extern struct {
    unnamed_0: union_unnamed_82 = @import("std").mem.zeroes(union_unnamed_82),
};
pub const ufbx_procedural_geometry = struct_ufbx_procedural_geometry;
pub const struct_ufbx_procedural_geometry_list = extern struct {
    data: [*c][*c]ufbx_procedural_geometry = @import("std").mem.zeroes([*c][*c]ufbx_procedural_geometry),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_procedural_geometry_list = struct_ufbx_procedural_geometry_list;
const struct_unnamed_85 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_84 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_85,
};
pub const struct_ufbx_stereo_camera = extern struct {
    unnamed_0: union_unnamed_84 = @import("std").mem.zeroes(union_unnamed_84),
    left: [*c]ufbx_camera = @import("std").mem.zeroes([*c]ufbx_camera),
    right: [*c]ufbx_camera = @import("std").mem.zeroes([*c]ufbx_camera),
};
pub const ufbx_stereo_camera = struct_ufbx_stereo_camera;
pub const struct_ufbx_stereo_camera_list = extern struct {
    data: [*c][*c]ufbx_stereo_camera = @import("std").mem.zeroes([*c][*c]ufbx_stereo_camera),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_stereo_camera_list = struct_ufbx_stereo_camera_list;
const struct_unnamed_87 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_86 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_87,
};
pub const struct_ufbx_camera_switcher = extern struct {
    unnamed_0: union_unnamed_86 = @import("std").mem.zeroes(union_unnamed_86),
};
pub const ufbx_camera_switcher = struct_ufbx_camera_switcher;
pub const struct_ufbx_camera_switcher_list = extern struct {
    data: [*c][*c]ufbx_camera_switcher = @import("std").mem.zeroes([*c][*c]ufbx_camera_switcher),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_camera_switcher_list = struct_ufbx_camera_switcher_list;
const struct_unnamed_89 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_88 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_89,
};
pub const UFBX_MARKER_UNKNOWN: c_int = 0;
pub const UFBX_MARKER_FK_EFFECTOR: c_int = 1;
pub const UFBX_MARKER_IK_EFFECTOR: c_int = 2;
pub const UFBX_MARKER_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_marker_type = c_uint;
pub const ufbx_marker_type = enum_ufbx_marker_type;
pub const struct_ufbx_marker = extern struct {
    unnamed_0: union_unnamed_88 = @import("std").mem.zeroes(union_unnamed_88),
    type: ufbx_marker_type = @import("std").mem.zeroes(ufbx_marker_type),
};
pub const ufbx_marker = struct_ufbx_marker;
pub const struct_ufbx_marker_list = extern struct {
    data: [*c][*c]ufbx_marker = @import("std").mem.zeroes([*c][*c]ufbx_marker),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_marker_list = struct_ufbx_marker_list;
const struct_unnamed_91 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
    instances: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
};
const union_unnamed_90 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_91,
};
pub const UFBX_LOD_DISPLAY_USE_LOD: c_int = 0;
pub const UFBX_LOD_DISPLAY_SHOW: c_int = 1;
pub const UFBX_LOD_DISPLAY_HIDE: c_int = 2;
pub const UFBX_LOD_DISPLAY_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_lod_display = c_uint;
pub const ufbx_lod_display = enum_ufbx_lod_display;
pub const struct_ufbx_lod_level = extern struct {
    distance: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    display: ufbx_lod_display = @import("std").mem.zeroes(ufbx_lod_display),
};
pub const ufbx_lod_level = struct_ufbx_lod_level;
pub const struct_ufbx_lod_level_list = extern struct {
    data: [*c]ufbx_lod_level = @import("std").mem.zeroes([*c]ufbx_lod_level),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_lod_level_list = struct_ufbx_lod_level_list;
pub const struct_ufbx_lod_group = extern struct {
    unnamed_0: union_unnamed_90 = @import("std").mem.zeroes(union_unnamed_90),
    relative_distances: bool = @import("std").mem.zeroes(bool),
    lod_levels: ufbx_lod_level_list = @import("std").mem.zeroes(ufbx_lod_level_list),
    ignore_parent_transform: bool = @import("std").mem.zeroes(bool),
    use_distance_limit: bool = @import("std").mem.zeroes(bool),
    distance_limit_min: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    distance_limit_max: ufbx_real = @import("std").mem.zeroes(ufbx_real),
};
pub const ufbx_lod_group = struct_ufbx_lod_group;
pub const struct_ufbx_lod_group_list = extern struct {
    data: [*c][*c]ufbx_lod_group = @import("std").mem.zeroes([*c][*c]ufbx_lod_group),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_lod_group_list = struct_ufbx_lod_group_list;
pub const struct_ufbx_blend_shape_list = extern struct {
    data: [*c][*c]ufbx_blend_shape = @import("std").mem.zeroes([*c][*c]ufbx_blend_shape),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_blend_shape_list = struct_ufbx_blend_shape_list;
pub const struct_ufbx_cache_file_list = extern struct {
    data: [*c][*c]ufbx_cache_file = @import("std").mem.zeroes([*c][*c]ufbx_cache_file),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_cache_file_list = struct_ufbx_cache_file_list;
pub const struct_ufbx_video_list = extern struct {
    data: [*c][*c]ufbx_video = @import("std").mem.zeroes([*c][*c]ufbx_video),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_video_list = struct_ufbx_video_list;
pub const struct_ufbx_shader_list = extern struct {
    data: [*c][*c]ufbx_shader = @import("std").mem.zeroes([*c][*c]ufbx_shader),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_shader_list = struct_ufbx_shader_list;
const struct_unnamed_93 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_92 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_93,
};
pub const struct_ufbx_anim_stack = extern struct {
    unnamed_0: union_unnamed_92 = @import("std").mem.zeroes(union_unnamed_92),
    time_begin: f64 = @import("std").mem.zeroes(f64),
    time_end: f64 = @import("std").mem.zeroes(f64),
    layers: ufbx_anim_layer_list = @import("std").mem.zeroes(ufbx_anim_layer_list),
    anim: [*c]ufbx_anim = @import("std").mem.zeroes([*c]ufbx_anim),
};
pub const ufbx_anim_stack = struct_ufbx_anim_stack;
pub const struct_ufbx_anim_stack_list = extern struct {
    data: [*c][*c]ufbx_anim_stack = @import("std").mem.zeroes([*c][*c]ufbx_anim_stack),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_anim_stack_list = struct_ufbx_anim_stack_list;
pub const struct_ufbx_anim_curve_list = extern struct {
    data: [*c][*c]ufbx_anim_curve = @import("std").mem.zeroes([*c][*c]ufbx_anim_curve),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_anim_curve_list = struct_ufbx_anim_curve_list;
const struct_unnamed_95 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_94 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_95,
};
pub const struct_ufbx_display_layer = extern struct {
    unnamed_0: union_unnamed_94 = @import("std").mem.zeroes(union_unnamed_94),
    nodes: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
    visible: bool = @import("std").mem.zeroes(bool),
    frozen: bool = @import("std").mem.zeroes(bool),
    ui_color: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_display_layer = struct_ufbx_display_layer;
pub const struct_ufbx_display_layer_list = extern struct {
    data: [*c][*c]ufbx_display_layer = @import("std").mem.zeroes([*c][*c]ufbx_display_layer),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_display_layer_list = struct_ufbx_display_layer_list;
const struct_unnamed_97 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_96 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_97,
};
const struct_unnamed_99 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_98 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_99,
};
pub const struct_ufbx_selection_node = extern struct {
    unnamed_0: union_unnamed_98 = @import("std").mem.zeroes(union_unnamed_98),
    target_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    target_mesh: [*c]ufbx_mesh = @import("std").mem.zeroes([*c]ufbx_mesh),
    include_node: bool = @import("std").mem.zeroes(bool),
    vertices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    edges: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    faces: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
};
pub const ufbx_selection_node = struct_ufbx_selection_node;
pub const struct_ufbx_selection_node_list = extern struct {
    data: [*c][*c]ufbx_selection_node = @import("std").mem.zeroes([*c][*c]ufbx_selection_node),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_selection_node_list = struct_ufbx_selection_node_list;
pub const struct_ufbx_selection_set = extern struct {
    unnamed_0: union_unnamed_96 = @import("std").mem.zeroes(union_unnamed_96),
    nodes: ufbx_selection_node_list = @import("std").mem.zeroes(ufbx_selection_node_list),
};
pub const ufbx_selection_set = struct_ufbx_selection_set;
pub const struct_ufbx_selection_set_list = extern struct {
    data: [*c][*c]ufbx_selection_set = @import("std").mem.zeroes([*c][*c]ufbx_selection_set),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_selection_set_list = struct_ufbx_selection_set_list;
const struct_unnamed_101 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_100 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_101,
};
pub const struct_ufbx_character = extern struct {
    unnamed_0: union_unnamed_100 = @import("std").mem.zeroes(union_unnamed_100),
};
pub const ufbx_character = struct_ufbx_character;
pub const struct_ufbx_character_list = extern struct {
    data: [*c][*c]ufbx_character = @import("std").mem.zeroes([*c][*c]ufbx_character),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_character_list = struct_ufbx_character_list;
const struct_unnamed_103 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_102 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_103,
};
pub const UFBX_CONSTRAINT_UNKNOWN: c_int = 0;
pub const UFBX_CONSTRAINT_AIM: c_int = 1;
pub const UFBX_CONSTRAINT_PARENT: c_int = 2;
pub const UFBX_CONSTRAINT_POSITION: c_int = 3;
pub const UFBX_CONSTRAINT_ROTATION: c_int = 4;
pub const UFBX_CONSTRAINT_SCALE: c_int = 5;
pub const UFBX_CONSTRAINT_SINGLE_CHAIN_IK: c_int = 6;
pub const UFBX_CONSTRAINT_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_constraint_type = c_uint;
pub const ufbx_constraint_type = enum_ufbx_constraint_type;
pub const struct_ufbx_constraint_target = extern struct {
    node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
};
pub const ufbx_constraint_target = struct_ufbx_constraint_target;
pub const struct_ufbx_constraint_target_list = extern struct {
    data: [*c]ufbx_constraint_target = @import("std").mem.zeroes([*c]ufbx_constraint_target),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_constraint_target_list = struct_ufbx_constraint_target_list;
pub const UFBX_CONSTRAINT_AIM_UP_SCENE: c_int = 0;
pub const UFBX_CONSTRAINT_AIM_UP_TO_NODE: c_int = 1;
pub const UFBX_CONSTRAINT_AIM_UP_ALIGN_NODE: c_int = 2;
pub const UFBX_CONSTRAINT_AIM_UP_VECTOR: c_int = 3;
pub const UFBX_CONSTRAINT_AIM_UP_NONE: c_int = 4;
pub const UFBX_CONSTRAINT_AIM_UP_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_constraint_aim_up_type = c_uint;
pub const ufbx_constraint_aim_up_type = enum_ufbx_constraint_aim_up_type;
pub const struct_ufbx_constraint = extern struct {
    unnamed_0: union_unnamed_102 = @import("std").mem.zeroes(union_unnamed_102),
    type: ufbx_constraint_type = @import("std").mem.zeroes(ufbx_constraint_type),
    type_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    targets: ufbx_constraint_target_list = @import("std").mem.zeroes(ufbx_constraint_target_list),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    active: bool = @import("std").mem.zeroes(bool),
    constrain_translation: [3]bool = @import("std").mem.zeroes([3]bool),
    constrain_rotation: [3]bool = @import("std").mem.zeroes([3]bool),
    constrain_scale: [3]bool = @import("std").mem.zeroes([3]bool),
    transform_offset: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    aim_vector: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    aim_up_type: ufbx_constraint_aim_up_type = @import("std").mem.zeroes(ufbx_constraint_aim_up_type),
    aim_up_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    aim_up_vector: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    ik_effector: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    ik_end_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    ik_pole_vector: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_constraint = struct_ufbx_constraint;
pub const struct_ufbx_constraint_list = extern struct {
    data: [*c][*c]ufbx_constraint = @import("std").mem.zeroes([*c][*c]ufbx_constraint),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_constraint_list = struct_ufbx_constraint_list;
const struct_unnamed_105 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_104 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_105,
};
pub const struct_ufbx_bone_pose = extern struct {
    bone_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    bone_to_world: ufbx_matrix = @import("std").mem.zeroes(ufbx_matrix),
};
pub const ufbx_bone_pose = struct_ufbx_bone_pose;
pub const struct_ufbx_bone_pose_list = extern struct {
    data: [*c]ufbx_bone_pose = @import("std").mem.zeroes([*c]ufbx_bone_pose),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_bone_pose_list = struct_ufbx_bone_pose_list;
pub const struct_ufbx_pose = extern struct {
    unnamed_0: union_unnamed_104 = @import("std").mem.zeroes(union_unnamed_104),
    is_bind_pose: bool = @import("std").mem.zeroes(bool),
    bone_poses: ufbx_bone_pose_list = @import("std").mem.zeroes(ufbx_bone_pose_list),
};
pub const ufbx_pose = struct_ufbx_pose;
pub const struct_ufbx_pose_list = extern struct {
    data: [*c][*c]ufbx_pose = @import("std").mem.zeroes([*c][*c]ufbx_pose),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_pose_list = struct_ufbx_pose_list;
const struct_unnamed_107 = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    props: ufbx_props = @import("std").mem.zeroes(ufbx_props),
    element_id: u32 = @import("std").mem.zeroes(u32),
    typed_id: u32 = @import("std").mem.zeroes(u32),
};
const union_unnamed_106 = extern union {
    element: ufbx_element,
    unnamed_0: struct_unnamed_107,
};
pub const struct_ufbx_metadata_object = extern struct {
    unnamed_0: union_unnamed_106 = @import("std").mem.zeroes(union_unnamed_106),
};
pub const ufbx_metadata_object = struct_ufbx_metadata_object;
pub const struct_ufbx_metadata_object_list = extern struct {
    data: [*c][*c]ufbx_metadata_object = @import("std").mem.zeroes([*c][*c]ufbx_metadata_object),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_metadata_object_list = struct_ufbx_metadata_object_list;
const struct_unnamed_65 = extern struct {
    unknowns: ufbx_unknown_list = @import("std").mem.zeroes(ufbx_unknown_list),
    nodes: ufbx_node_list = @import("std").mem.zeroes(ufbx_node_list),
    meshes: ufbx_mesh_list = @import("std").mem.zeroes(ufbx_mesh_list),
    lights: ufbx_light_list = @import("std").mem.zeroes(ufbx_light_list),
    cameras: ufbx_camera_list = @import("std").mem.zeroes(ufbx_camera_list),
    bones: ufbx_bone_list = @import("std").mem.zeroes(ufbx_bone_list),
    empties: ufbx_empty_list = @import("std").mem.zeroes(ufbx_empty_list),
    line_curves: ufbx_line_curve_list = @import("std").mem.zeroes(ufbx_line_curve_list),
    nurbs_curves: ufbx_nurbs_curve_list = @import("std").mem.zeroes(ufbx_nurbs_curve_list),
    nurbs_surfaces: ufbx_nurbs_surface_list = @import("std").mem.zeroes(ufbx_nurbs_surface_list),
    nurbs_trim_surfaces: ufbx_nurbs_trim_surface_list = @import("std").mem.zeroes(ufbx_nurbs_trim_surface_list),
    nurbs_trim_boundaries: ufbx_nurbs_trim_boundary_list = @import("std").mem.zeroes(ufbx_nurbs_trim_boundary_list),
    procedural_geometries: ufbx_procedural_geometry_list = @import("std").mem.zeroes(ufbx_procedural_geometry_list),
    stereo_cameras: ufbx_stereo_camera_list = @import("std").mem.zeroes(ufbx_stereo_camera_list),
    camera_switchers: ufbx_camera_switcher_list = @import("std").mem.zeroes(ufbx_camera_switcher_list),
    markers: ufbx_marker_list = @import("std").mem.zeroes(ufbx_marker_list),
    lod_groups: ufbx_lod_group_list = @import("std").mem.zeroes(ufbx_lod_group_list),
    skin_deformers: ufbx_skin_deformer_list = @import("std").mem.zeroes(ufbx_skin_deformer_list),
    skin_clusters: ufbx_skin_cluster_list = @import("std").mem.zeroes(ufbx_skin_cluster_list),
    blend_deformers: ufbx_blend_deformer_list = @import("std").mem.zeroes(ufbx_blend_deformer_list),
    blend_channels: ufbx_blend_channel_list = @import("std").mem.zeroes(ufbx_blend_channel_list),
    blend_shapes: ufbx_blend_shape_list = @import("std").mem.zeroes(ufbx_blend_shape_list),
    cache_deformers: ufbx_cache_deformer_list = @import("std").mem.zeroes(ufbx_cache_deformer_list),
    cache_files: ufbx_cache_file_list = @import("std").mem.zeroes(ufbx_cache_file_list),
    materials: ufbx_material_list = @import("std").mem.zeroes(ufbx_material_list),
    textures: ufbx_texture_list = @import("std").mem.zeroes(ufbx_texture_list),
    videos: ufbx_video_list = @import("std").mem.zeroes(ufbx_video_list),
    shaders: ufbx_shader_list = @import("std").mem.zeroes(ufbx_shader_list),
    shader_bindings: ufbx_shader_binding_list = @import("std").mem.zeroes(ufbx_shader_binding_list),
    anim_stacks: ufbx_anim_stack_list = @import("std").mem.zeroes(ufbx_anim_stack_list),
    anim_layers: ufbx_anim_layer_list = @import("std").mem.zeroes(ufbx_anim_layer_list),
    anim_values: ufbx_anim_value_list = @import("std").mem.zeroes(ufbx_anim_value_list),
    anim_curves: ufbx_anim_curve_list = @import("std").mem.zeroes(ufbx_anim_curve_list),
    display_layers: ufbx_display_layer_list = @import("std").mem.zeroes(ufbx_display_layer_list),
    selection_sets: ufbx_selection_set_list = @import("std").mem.zeroes(ufbx_selection_set_list),
    selection_nodes: ufbx_selection_node_list = @import("std").mem.zeroes(ufbx_selection_node_list),
    characters: ufbx_character_list = @import("std").mem.zeroes(ufbx_character_list),
    constraints: ufbx_constraint_list = @import("std").mem.zeroes(ufbx_constraint_list),
    poses: ufbx_pose_list = @import("std").mem.zeroes(ufbx_pose_list),
    metadata_objects: ufbx_metadata_object_list = @import("std").mem.zeroes(ufbx_metadata_object_list),
};
const union_unnamed_64 = extern union {
    unnamed_0: struct_unnamed_65,
    elements_by_type: [40]ufbx_element_list,
};
pub const struct_ufbx_texture_file = extern struct {
    index: u32 = @import("std").mem.zeroes(u32),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    absolute_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    relative_filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_absolute_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    raw_relative_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    content: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
};
pub const ufbx_texture_file = struct_ufbx_texture_file;
pub const struct_ufbx_texture_file_list = extern struct {
    data: [*c]ufbx_texture_file = @import("std").mem.zeroes([*c]ufbx_texture_file),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_texture_file_list = struct_ufbx_texture_file_list;
pub const struct_ufbx_name_element = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    type: ufbx_element_type = @import("std").mem.zeroes(ufbx_element_type),
    _internal_key: u32 = @import("std").mem.zeroes(u32),
    element: [*c]ufbx_element = @import("std").mem.zeroes([*c]ufbx_element),
};
pub const ufbx_name_element = struct_ufbx_name_element;
pub const struct_ufbx_name_element_list = extern struct {
    data: [*c]ufbx_name_element = @import("std").mem.zeroes([*c]ufbx_name_element),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_name_element_list = struct_ufbx_name_element_list;
pub const struct_ufbx_scene = extern struct {
    metadata: ufbx_metadata = @import("std").mem.zeroes(ufbx_metadata),
    settings: ufbx_scene_settings = @import("std").mem.zeroes(ufbx_scene_settings),
    root_node: [*c]ufbx_node = @import("std").mem.zeroes([*c]ufbx_node),
    anim: [*c]ufbx_anim = @import("std").mem.zeroes([*c]ufbx_anim),
    unnamed_0: union_unnamed_64 = @import("std").mem.zeroes(union_unnamed_64),
    texture_files: ufbx_texture_file_list = @import("std").mem.zeroes(ufbx_texture_file_list),
    elements: ufbx_element_list = @import("std").mem.zeroes(ufbx_element_list),
    connections_src: ufbx_connection_list = @import("std").mem.zeroes(ufbx_connection_list),
    connections_dst: ufbx_connection_list = @import("std").mem.zeroes(ufbx_connection_list),
    elements_by_name: ufbx_name_element_list = @import("std").mem.zeroes(ufbx_name_element_list),
    dom_root: [*c]ufbx_dom_node = @import("std").mem.zeroes([*c]ufbx_dom_node),
};
pub const UFBX_ELEMENT_TYPE_COUNT: c_int = 40;
const enum_unnamed_108 = c_uint;
pub const UFBX_INHERIT_MODE_COUNT: c_int = 3;
const enum_unnamed_109 = c_uint;
pub const UFBX_MIRROR_AXIS_COUNT: c_int = 4;
const enum_unnamed_110 = c_uint;
pub const struct_ufbx_vertex_attrib = extern struct {
    exists: bool = @import("std").mem.zeroes(bool),
    values: ufbx_void_list = @import("std").mem.zeroes(ufbx_void_list),
    indices: ufbx_uint32_list = @import("std").mem.zeroes(ufbx_uint32_list),
    value_reals: usize = @import("std").mem.zeroes(usize),
    unique_per_vertex: bool = @import("std").mem.zeroes(bool),
};
pub const ufbx_vertex_attrib = struct_ufbx_vertex_attrib;
pub const UFBX_SUBDIVISION_DISPLAY_MODE_COUNT: c_int = 4;
const enum_unnamed_111 = c_uint;
pub const UFBX_SUBDIVISION_BOUNDARY_COUNT: c_int = 6;
const enum_unnamed_112 = c_uint;
pub const UFBX_LIGHT_TYPE_COUNT: c_int = 5;
const enum_unnamed_113 = c_uint;
pub const UFBX_LIGHT_DECAY_COUNT: c_int = 4;
const enum_unnamed_114 = c_uint;
pub const UFBX_LIGHT_AREA_SHAPE_COUNT: c_int = 2;
const enum_unnamed_115 = c_uint;
pub const UFBX_PROJECTION_MODE_COUNT: c_int = 2;
const enum_unnamed_116 = c_uint;
pub const UFBX_ASPECT_MODE_COUNT: c_int = 5;
const enum_unnamed_117 = c_uint;
pub const UFBX_APERTURE_MODE_COUNT: c_int = 4;
const enum_unnamed_118 = c_uint;
pub const UFBX_GATE_FIT_COUNT: c_int = 6;
const enum_unnamed_119 = c_uint;
pub const UFBX_APERTURE_FORMAT_COUNT: c_int = 12;
const enum_unnamed_120 = c_uint;
pub const UFBX_COORDINATE_AXIS_COUNT: c_int = 7;
const enum_unnamed_121 = c_uint;
pub const UFBX_NURBS_TOPOLOGY_COUNT: c_int = 3;
const enum_unnamed_122 = c_uint;
pub const UFBX_MARKER_TYPE_COUNT: c_int = 3;
const enum_unnamed_123 = c_uint;
pub const UFBX_LOD_DISPLAY_COUNT: c_int = 3;
const enum_unnamed_124 = c_uint;
pub const UFBX_SKINNING_METHOD_COUNT: c_int = 4;
const enum_unnamed_125 = c_uint;
pub const UFBX_CACHE_FILE_FORMAT_COUNT: c_int = 3;
const enum_unnamed_126 = c_uint;
pub const UFBX_CACHE_DATA_FORMAT_COUNT: c_int = 5;
const enum_unnamed_127 = c_uint;
pub const UFBX_CACHE_DATA_ENCODING_COUNT: c_int = 3;
const enum_unnamed_128 = c_uint;
pub const UFBX_CACHE_INTERPRETATION_COUNT: c_int = 4;
const enum_unnamed_129 = c_uint;
pub const UFBX_SHADER_TYPE_COUNT: c_int = 12;
const enum_unnamed_130 = c_uint;
pub const UFBX_MATERIAL_FBX_DIFFUSE_FACTOR: c_int = 0;
pub const UFBX_MATERIAL_FBX_DIFFUSE_COLOR: c_int = 1;
pub const UFBX_MATERIAL_FBX_SPECULAR_FACTOR: c_int = 2;
pub const UFBX_MATERIAL_FBX_SPECULAR_COLOR: c_int = 3;
pub const UFBX_MATERIAL_FBX_SPECULAR_EXPONENT: c_int = 4;
pub const UFBX_MATERIAL_FBX_REFLECTION_FACTOR: c_int = 5;
pub const UFBX_MATERIAL_FBX_REFLECTION_COLOR: c_int = 6;
pub const UFBX_MATERIAL_FBX_TRANSPARENCY_FACTOR: c_int = 7;
pub const UFBX_MATERIAL_FBX_TRANSPARENCY_COLOR: c_int = 8;
pub const UFBX_MATERIAL_FBX_EMISSION_FACTOR: c_int = 9;
pub const UFBX_MATERIAL_FBX_EMISSION_COLOR: c_int = 10;
pub const UFBX_MATERIAL_FBX_AMBIENT_FACTOR: c_int = 11;
pub const UFBX_MATERIAL_FBX_AMBIENT_COLOR: c_int = 12;
pub const UFBX_MATERIAL_FBX_NORMAL_MAP: c_int = 13;
pub const UFBX_MATERIAL_FBX_BUMP: c_int = 14;
pub const UFBX_MATERIAL_FBX_BUMP_FACTOR: c_int = 15;
pub const UFBX_MATERIAL_FBX_DISPLACEMENT_FACTOR: c_int = 16;
pub const UFBX_MATERIAL_FBX_DISPLACEMENT: c_int = 17;
pub const UFBX_MATERIAL_FBX_VECTOR_DISPLACEMENT_FACTOR: c_int = 18;
pub const UFBX_MATERIAL_FBX_VECTOR_DISPLACEMENT: c_int = 19;
pub const UFBX_MATERIAL_FBX_MAP_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_material_fbx_map = c_uint;
pub const ufbx_material_fbx_map = enum_ufbx_material_fbx_map;
pub const UFBX_MATERIAL_FBX_MAP_COUNT: c_int = 20;
const enum_unnamed_131 = c_uint;
pub const UFBX_MATERIAL_PBR_BASE_FACTOR: c_int = 0;
pub const UFBX_MATERIAL_PBR_BASE_COLOR: c_int = 1;
pub const UFBX_MATERIAL_PBR_ROUGHNESS: c_int = 2;
pub const UFBX_MATERIAL_PBR_METALNESS: c_int = 3;
pub const UFBX_MATERIAL_PBR_DIFFUSE_ROUGHNESS: c_int = 4;
pub const UFBX_MATERIAL_PBR_SPECULAR_FACTOR: c_int = 5;
pub const UFBX_MATERIAL_PBR_SPECULAR_COLOR: c_int = 6;
pub const UFBX_MATERIAL_PBR_SPECULAR_IOR: c_int = 7;
pub const UFBX_MATERIAL_PBR_SPECULAR_ANISOTROPY: c_int = 8;
pub const UFBX_MATERIAL_PBR_SPECULAR_ROTATION: c_int = 9;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_FACTOR: c_int = 10;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_COLOR: c_int = 11;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_DEPTH: c_int = 12;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_SCATTER: c_int = 13;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_SCATTER_ANISOTROPY: c_int = 14;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_DISPERSION: c_int = 15;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_ROUGHNESS: c_int = 16;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_EXTRA_ROUGHNESS: c_int = 17;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_PRIORITY: c_int = 18;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_ENABLE_IN_AOV: c_int = 19;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_FACTOR: c_int = 20;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_COLOR: c_int = 21;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_RADIUS: c_int = 22;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_SCALE: c_int = 23;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_ANISOTROPY: c_int = 24;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_TINT_COLOR: c_int = 25;
pub const UFBX_MATERIAL_PBR_SUBSURFACE_TYPE: c_int = 26;
pub const UFBX_MATERIAL_PBR_SHEEN_FACTOR: c_int = 27;
pub const UFBX_MATERIAL_PBR_SHEEN_COLOR: c_int = 28;
pub const UFBX_MATERIAL_PBR_SHEEN_ROUGHNESS: c_int = 29;
pub const UFBX_MATERIAL_PBR_COAT_FACTOR: c_int = 30;
pub const UFBX_MATERIAL_PBR_COAT_COLOR: c_int = 31;
pub const UFBX_MATERIAL_PBR_COAT_ROUGHNESS: c_int = 32;
pub const UFBX_MATERIAL_PBR_COAT_IOR: c_int = 33;
pub const UFBX_MATERIAL_PBR_COAT_ANISOTROPY: c_int = 34;
pub const UFBX_MATERIAL_PBR_COAT_ROTATION: c_int = 35;
pub const UFBX_MATERIAL_PBR_COAT_NORMAL: c_int = 36;
pub const UFBX_MATERIAL_PBR_COAT_AFFECT_BASE_COLOR: c_int = 37;
pub const UFBX_MATERIAL_PBR_COAT_AFFECT_BASE_ROUGHNESS: c_int = 38;
pub const UFBX_MATERIAL_PBR_THIN_FILM_THICKNESS: c_int = 39;
pub const UFBX_MATERIAL_PBR_THIN_FILM_IOR: c_int = 40;
pub const UFBX_MATERIAL_PBR_EMISSION_FACTOR: c_int = 41;
pub const UFBX_MATERIAL_PBR_EMISSION_COLOR: c_int = 42;
pub const UFBX_MATERIAL_PBR_OPACITY: c_int = 43;
pub const UFBX_MATERIAL_PBR_INDIRECT_DIFFUSE: c_int = 44;
pub const UFBX_MATERIAL_PBR_INDIRECT_SPECULAR: c_int = 45;
pub const UFBX_MATERIAL_PBR_NORMAL_MAP: c_int = 46;
pub const UFBX_MATERIAL_PBR_TANGENT_MAP: c_int = 47;
pub const UFBX_MATERIAL_PBR_DISPLACEMENT_MAP: c_int = 48;
pub const UFBX_MATERIAL_PBR_MATTE_FACTOR: c_int = 49;
pub const UFBX_MATERIAL_PBR_MATTE_COLOR: c_int = 50;
pub const UFBX_MATERIAL_PBR_AMBIENT_OCCLUSION: c_int = 51;
pub const UFBX_MATERIAL_PBR_GLOSSINESS: c_int = 52;
pub const UFBX_MATERIAL_PBR_COAT_GLOSSINESS: c_int = 53;
pub const UFBX_MATERIAL_PBR_TRANSMISSION_GLOSSINESS: c_int = 54;
pub const UFBX_MATERIAL_PBR_MAP_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_material_pbr_map = c_uint;
pub const ufbx_material_pbr_map = enum_ufbx_material_pbr_map;
pub const UFBX_MATERIAL_PBR_MAP_COUNT: c_int = 55;
const enum_unnamed_132 = c_uint;
pub const UFBX_MATERIAL_FEATURE_PBR: c_int = 0;
pub const UFBX_MATERIAL_FEATURE_METALNESS: c_int = 1;
pub const UFBX_MATERIAL_FEATURE_DIFFUSE: c_int = 2;
pub const UFBX_MATERIAL_FEATURE_SPECULAR: c_int = 3;
pub const UFBX_MATERIAL_FEATURE_EMISSION: c_int = 4;
pub const UFBX_MATERIAL_FEATURE_TRANSMISSION: c_int = 5;
pub const UFBX_MATERIAL_FEATURE_COAT: c_int = 6;
pub const UFBX_MATERIAL_FEATURE_SHEEN: c_int = 7;
pub const UFBX_MATERIAL_FEATURE_OPACITY: c_int = 8;
pub const UFBX_MATERIAL_FEATURE_AMBIENT_OCCLUSION: c_int = 9;
pub const UFBX_MATERIAL_FEATURE_MATTE: c_int = 10;
pub const UFBX_MATERIAL_FEATURE_UNLIT: c_int = 11;
pub const UFBX_MATERIAL_FEATURE_IOR: c_int = 12;
pub const UFBX_MATERIAL_FEATURE_DIFFUSE_ROUGHNESS: c_int = 13;
pub const UFBX_MATERIAL_FEATURE_TRANSMISSION_ROUGHNESS: c_int = 14;
pub const UFBX_MATERIAL_FEATURE_THIN_WALLED: c_int = 15;
pub const UFBX_MATERIAL_FEATURE_CAUSTICS: c_int = 16;
pub const UFBX_MATERIAL_FEATURE_EXIT_TO_BACKGROUND: c_int = 17;
pub const UFBX_MATERIAL_FEATURE_INTERNAL_REFLECTIONS: c_int = 18;
pub const UFBX_MATERIAL_FEATURE_DOUBLE_SIDED: c_int = 19;
pub const UFBX_MATERIAL_FEATURE_ROUGHNESS_AS_GLOSSINESS: c_int = 20;
pub const UFBX_MATERIAL_FEATURE_COAT_ROUGHNESS_AS_GLOSSINESS: c_int = 21;
pub const UFBX_MATERIAL_FEATURE_TRANSMISSION_ROUGHNESS_AS_GLOSSINESS: c_int = 22;
pub const UFBX_MATERIAL_FEATURE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_material_feature = c_uint;
pub const ufbx_material_feature = enum_ufbx_material_feature;
pub const UFBX_MATERIAL_FEATURE_COUNT: c_int = 23;
const enum_unnamed_133 = c_uint;
pub const UFBX_TEXTURE_TYPE_COUNT: c_int = 4;
const enum_unnamed_134 = c_uint;
pub const UFBX_BLEND_MODE_COUNT: c_int = 31;
const enum_unnamed_135 = c_uint;
pub const UFBX_WRAP_MODE_COUNT: c_int = 2;
const enum_unnamed_136 = c_uint;
pub const UFBX_SHADER_TEXTURE_TYPE_COUNT: c_int = 3;
const enum_unnamed_137 = c_uint;
pub const UFBX_INTERPOLATION_COUNT: c_int = 4;
const enum_unnamed_138 = c_uint;
pub const UFBX_CONSTRAINT_TYPE_COUNT: c_int = 7;
const enum_unnamed_139 = c_uint;
pub const UFBX_CONSTRAINT_AIM_UP_TYPE_COUNT: c_int = 5;
const enum_unnamed_140 = c_uint;
pub const UFBX_CONSTRAINT_IK_POLE_VECTOR: c_int = 0;
pub const UFBX_CONSTRAINT_IK_POLE_NODE: c_int = 1;
pub const UFBX_CONSTRAINT_IK_POLE_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_constraint_ik_pole_type = c_uint;
pub const ufbx_constraint_ik_pole_type = enum_ufbx_constraint_ik_pole_type;
pub const UFBX_CONSTRAINT_IK_POLE_TYPE_COUNT: c_int = 2;
const enum_unnamed_141 = c_uint;
pub const UFBX_EXPORTER_COUNT: c_int = 6;
const enum_unnamed_142 = c_uint;
pub const UFBX_FILE_FORMAT_COUNT: c_int = 4;
const enum_unnamed_143 = c_uint;
pub const UFBX_WARNING_TYPE_COUNT: c_int = 11;
const enum_unnamed_144 = c_uint;
pub const UFBX_THUMBNAIL_FORMAT_COUNT: c_int = 3;
const enum_unnamed_145 = c_uint;
pub const UFBX_SPACE_CONVERSION_COUNT: c_int = 3;
const enum_unnamed_146 = c_uint;
pub const UFBX_TIME_MODE_COUNT: c_int = 18;
const enum_unnamed_147 = c_uint;
pub const UFBX_TIME_PROTOCOL_COUNT: c_int = 3;
const enum_unnamed_148 = c_uint;
pub const UFBX_SNAP_MODE_COUNT: c_int = 4;
const enum_unnamed_149 = c_uint;
pub const struct_ufbx_curve_point = extern struct {
    valid: bool = @import("std").mem.zeroes(bool),
    position: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    derivative: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_curve_point = struct_ufbx_curve_point;
pub const struct_ufbx_surface_point = extern struct {
    valid: bool = @import("std").mem.zeroes(bool),
    position: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    derivative_u: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
    derivative_v: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_surface_point = struct_ufbx_surface_point;
pub const UFBX_TOPO_NON_MANIFOLD: c_int = 1;
pub const UFBX_TOPO_FLAGS_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_topo_flags = c_uint;
pub const ufbx_topo_flags = enum_ufbx_topo_flags;
pub const struct_ufbx_topo_edge = extern struct {
    index: u32 = @import("std").mem.zeroes(u32),
    next: u32 = @import("std").mem.zeroes(u32),
    prev: u32 = @import("std").mem.zeroes(u32),
    twin: u32 = @import("std").mem.zeroes(u32),
    face: u32 = @import("std").mem.zeroes(u32),
    edge: u32 = @import("std").mem.zeroes(u32),
    flags: ufbx_topo_flags = @import("std").mem.zeroes(ufbx_topo_flags),
};
pub const ufbx_topo_edge = struct_ufbx_topo_edge;
pub const struct_ufbx_vertex_stream = extern struct {
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    vertex_count: usize = @import("std").mem.zeroes(usize),
    vertex_size: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_vertex_stream = struct_ufbx_vertex_stream;
pub const ufbx_alloc_fn = fn (?*anyopaque, usize) callconv(.C) ?*anyopaque;
pub const ufbx_realloc_fn = fn (?*anyopaque, ?*anyopaque, usize, usize) callconv(.C) ?*anyopaque;
pub const ufbx_free_fn = fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) void;
pub const ufbx_free_allocator_fn = fn (?*anyopaque) callconv(.C) void;
pub const struct_ufbx_allocator = extern struct {
    alloc_fn: ?*const ufbx_alloc_fn = @import("std").mem.zeroes(?*const ufbx_alloc_fn),
    realloc_fn: ?*const ufbx_realloc_fn = @import("std").mem.zeroes(?*const ufbx_realloc_fn),
    free_fn: ?*const ufbx_free_fn = @import("std").mem.zeroes(?*const ufbx_free_fn),
    free_allocator_fn: ?*const ufbx_free_allocator_fn = @import("std").mem.zeroes(?*const ufbx_free_allocator_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_allocator = struct_ufbx_allocator;
pub const struct_ufbx_allocator_opts = extern struct {
    allocator: ufbx_allocator = @import("std").mem.zeroes(ufbx_allocator),
    memory_limit: usize = @import("std").mem.zeroes(usize),
    allocation_limit: usize = @import("std").mem.zeroes(usize),
    huge_threshold: usize = @import("std").mem.zeroes(usize),
    max_chunk_size: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_allocator_opts = struct_ufbx_allocator_opts;
pub const ufbx_read_fn = fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) usize;
pub const ufbx_skip_fn = fn (?*anyopaque, usize) callconv(.C) bool;
pub const ufbx_close_fn = fn (?*anyopaque) callconv(.C) void;
pub const struct_ufbx_stream = extern struct {
    read_fn: ?*const ufbx_read_fn = @import("std").mem.zeroes(?*const ufbx_read_fn),
    skip_fn: ?*const ufbx_skip_fn = @import("std").mem.zeroes(?*const ufbx_skip_fn),
    close_fn: ?*const ufbx_close_fn = @import("std").mem.zeroes(?*const ufbx_close_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_stream = struct_ufbx_stream;
pub const UFBX_OPEN_FILE_MAIN_MODEL: c_int = 0;
pub const UFBX_OPEN_FILE_GEOMETRY_CACHE: c_int = 1;
pub const UFBX_OPEN_FILE_OBJ_MTL: c_int = 2;
pub const UFBX_OPEN_FILE_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_open_file_type = c_uint;
pub const ufbx_open_file_type = enum_ufbx_open_file_type;
pub const UFBX_OPEN_FILE_TYPE_COUNT: c_int = 3;
const enum_unnamed_150 = c_uint;
pub const struct_ufbx_open_file_info = extern struct {
    type: ufbx_open_file_type = @import("std").mem.zeroes(ufbx_open_file_type),
    temp_allocator: ufbx_allocator = @import("std").mem.zeroes(ufbx_allocator),
    original_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
};
pub const ufbx_open_file_info = struct_ufbx_open_file_info;
pub const ufbx_open_file_fn = fn (?*anyopaque, [*c]ufbx_stream, [*c]const u8, usize, [*c]const ufbx_open_file_info) callconv(.C) bool;
pub const struct_ufbx_open_file_cb = extern struct {
    @"fn": ?*const ufbx_open_file_fn = @import("std").mem.zeroes(?*const ufbx_open_file_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_open_file_cb = struct_ufbx_open_file_cb;
pub const ufbx_close_memory_fn = fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) void;
pub const struct_ufbx_close_memory_cb = extern struct {
    @"fn": ?*const ufbx_close_memory_fn = @import("std").mem.zeroes(?*const ufbx_close_memory_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_close_memory_cb = struct_ufbx_close_memory_cb;
pub const struct_ufbx_open_memory_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    no_copy: bool = @import("std").mem.zeroes(bool),
    close_cb: ufbx_close_memory_cb = @import("std").mem.zeroes(ufbx_close_memory_cb),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_open_memory_opts = struct_ufbx_open_memory_opts;
pub const struct_ufbx_error_frame = extern struct {
    source_line: u32 = @import("std").mem.zeroes(u32),
    function: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    description: ufbx_string = @import("std").mem.zeroes(ufbx_string),
};
pub const ufbx_error_frame = struct_ufbx_error_frame;
pub const UFBX_ERROR_NONE: c_int = 0;
pub const UFBX_ERROR_UNKNOWN: c_int = 1;
pub const UFBX_ERROR_FILE_NOT_FOUND: c_int = 2;
pub const UFBX_ERROR_EXTERNAL_FILE_NOT_FOUND: c_int = 3;
pub const UFBX_ERROR_OUT_OF_MEMORY: c_int = 4;
pub const UFBX_ERROR_MEMORY_LIMIT: c_int = 5;
pub const UFBX_ERROR_ALLOCATION_LIMIT: c_int = 6;
pub const UFBX_ERROR_TRUNCATED_FILE: c_int = 7;
pub const UFBX_ERROR_IO: c_int = 8;
pub const UFBX_ERROR_CANCELLED: c_int = 9;
pub const UFBX_ERROR_UNRECOGNIZED_FILE_FORMAT: c_int = 10;
pub const UFBX_ERROR_UNINITIALIZED_OPTIONS: c_int = 11;
pub const UFBX_ERROR_ZERO_VERTEX_SIZE: c_int = 12;
pub const UFBX_ERROR_TRUNCATED_VERTEX_STREAM: c_int = 13;
pub const UFBX_ERROR_INVALID_UTF8: c_int = 14;
pub const UFBX_ERROR_FEATURE_DISABLED: c_int = 15;
pub const UFBX_ERROR_BAD_NURBS: c_int = 16;
pub const UFBX_ERROR_BAD_INDEX: c_int = 17;
pub const UFBX_ERROR_NODE_DEPTH_LIMIT: c_int = 18;
pub const UFBX_ERROR_THREADED_ASCII_PARSE: c_int = 19;
pub const UFBX_ERROR_UNSAFE_OPTIONS: c_int = 20;
pub const UFBX_ERROR_DUPLICATE_OVERRIDE: c_int = 21;
pub const UFBX_ERROR_TYPE_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_error_type = c_uint;
pub const ufbx_error_type = enum_ufbx_error_type;
pub const UFBX_ERROR_TYPE_COUNT: c_int = 22;
const enum_unnamed_151 = c_uint;
pub const struct_ufbx_error = extern struct {
    type: ufbx_error_type = @import("std").mem.zeroes(ufbx_error_type),
    description: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    stack_size: u32 = @import("std").mem.zeroes(u32),
    stack: [8]ufbx_error_frame = @import("std").mem.zeroes([8]ufbx_error_frame),
    info_length: usize = @import("std").mem.zeroes(usize),
    info: [256]u8 = @import("std").mem.zeroes([256]u8),
};
pub const ufbx_error = struct_ufbx_error;
pub const struct_ufbx_progress = extern struct {
    bytes_read: u64 = @import("std").mem.zeroes(u64),
    bytes_total: u64 = @import("std").mem.zeroes(u64),
};
pub const ufbx_progress = struct_ufbx_progress;
pub const UFBX_PROGRESS_CONTINUE: c_int = 256;
pub const UFBX_PROGRESS_CANCEL: c_int = 512;
pub const UFBX_PROGRESS_RESULT_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_progress_result = c_uint;
pub const ufbx_progress_result = enum_ufbx_progress_result;
pub const ufbx_progress_fn = fn (?*anyopaque, [*c]const ufbx_progress) callconv(.C) ufbx_progress_result;
pub const struct_ufbx_progress_cb = extern struct {
    @"fn": ?*const ufbx_progress_fn = @import("std").mem.zeroes(?*const ufbx_progress_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_progress_cb = struct_ufbx_progress_cb;
pub const struct_ufbx_inflate_input = extern struct {
    total_size: usize = @import("std").mem.zeroes(usize),
    data: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
    data_size: usize = @import("std").mem.zeroes(usize),
    buffer: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    buffer_size: usize = @import("std").mem.zeroes(usize),
    read_fn: ?*const ufbx_read_fn = @import("std").mem.zeroes(?*const ufbx_read_fn),
    read_user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    progress_cb: ufbx_progress_cb = @import("std").mem.zeroes(ufbx_progress_cb),
    progress_interval_hint: u64 = @import("std").mem.zeroes(u64),
    progress_size_before: u64 = @import("std").mem.zeroes(u64),
    progress_size_after: u64 = @import("std").mem.zeroes(u64),
    no_header: bool = @import("std").mem.zeroes(bool),
    no_checksum: bool = @import("std").mem.zeroes(bool),
    internal_fast_bits: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_inflate_input = struct_ufbx_inflate_input;
pub const struct_ufbx_inflate_retain = extern struct {
    initialized: bool = @import("std").mem.zeroes(bool),
    data: [1024]u64 = @import("std").mem.zeroes([1024]u64),
};
pub const ufbx_inflate_retain = struct_ufbx_inflate_retain;
pub const UFBX_INDEX_ERROR_HANDLING_CLAMP: c_int = 0;
pub const UFBX_INDEX_ERROR_HANDLING_NO_INDEX: c_int = 1;
pub const UFBX_INDEX_ERROR_HANDLING_ABORT_LOADING: c_int = 2;
pub const UFBX_INDEX_ERROR_HANDLING_UNSAFE_IGNORE: c_int = 3;
pub const UFBX_INDEX_ERROR_HANDLING_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_index_error_handling = c_uint;
pub const ufbx_index_error_handling = enum_ufbx_index_error_handling;
pub const UFBX_INDEX_ERROR_HANDLING_COUNT: c_int = 4;
const enum_unnamed_152 = c_uint;
pub const UFBX_UNICODE_ERROR_HANDLING_REPLACEMENT_CHARACTER: c_int = 0;
pub const UFBX_UNICODE_ERROR_HANDLING_UNDERSCORE: c_int = 1;
pub const UFBX_UNICODE_ERROR_HANDLING_QUESTION_MARK: c_int = 2;
pub const UFBX_UNICODE_ERROR_HANDLING_REMOVE: c_int = 3;
pub const UFBX_UNICODE_ERROR_HANDLING_ABORT_LOADING: c_int = 4;
pub const UFBX_UNICODE_ERROR_HANDLING_UNSAFE_IGNORE: c_int = 5;
pub const UFBX_UNICODE_ERROR_HANDLING_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_unicode_error_handling = c_uint;
pub const ufbx_unicode_error_handling = enum_ufbx_unicode_error_handling;
pub const UFBX_UNICODE_ERROR_HANDLING_COUNT: c_int = 6;
const enum_unnamed_153 = c_uint;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_PRESERVE: c_int = 0;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_HELPER_NODES: c_int = 1;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_MODIFY_GEOMETRY: c_int = 2;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_MODIFY_GEOMETRY_NO_FALLBACK: c_int = 3;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_geometry_transform_handling = c_uint;
pub const ufbx_geometry_transform_handling = enum_ufbx_geometry_transform_handling;
pub const UFBX_GEOMETRY_TRANSFORM_HANDLING_COUNT: c_int = 4;
const enum_unnamed_154 = c_uint;
pub const UFBX_INHERIT_MODE_HANDLING_PRESERVE: c_int = 0;
pub const UFBX_INHERIT_MODE_HANDLING_HELPER_NODES: c_int = 1;
pub const UFBX_INHERIT_MODE_HANDLING_COMPENSATE: c_int = 2;
pub const UFBX_INHERIT_MODE_HANDLING_IGNORE: c_int = 3;
pub const UFBX_INHERIT_MODE_HANDLING_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_inherit_mode_handling = c_uint;
pub const ufbx_inherit_mode_handling = enum_ufbx_inherit_mode_handling;
pub const UFBX_INHERIT_MODE_HANDLING_COUNT: c_int = 4;
const enum_unnamed_155 = c_uint;
pub const struct_ufbx_baked_vec3 = extern struct {
    time: f64 = @import("std").mem.zeroes(f64),
    value: ufbx_vec3 = @import("std").mem.zeroes(ufbx_vec3),
};
pub const ufbx_baked_vec3 = struct_ufbx_baked_vec3;
pub const struct_ufbx_baked_vec3_list = extern struct {
    data: [*c]ufbx_baked_vec3 = @import("std").mem.zeroes([*c]ufbx_baked_vec3),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_baked_vec3_list = struct_ufbx_baked_vec3_list;
pub const struct_ufbx_baked_quat = extern struct {
    time: f64 = @import("std").mem.zeroes(f64),
    value: ufbx_quat = @import("std").mem.zeroes(ufbx_quat),
};
pub const ufbx_baked_quat = struct_ufbx_baked_quat;
pub const struct_ufbx_baked_quat_list = extern struct {
    data: [*c]ufbx_baked_quat = @import("std").mem.zeroes([*c]ufbx_baked_quat),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_baked_quat_list = struct_ufbx_baked_quat_list;
pub const struct_ufbx_baked_node = extern struct {
    typed_id: u32 = @import("std").mem.zeroes(u32),
    element_id: u32 = @import("std").mem.zeroes(u32),
    constant_translation: bool = @import("std").mem.zeroes(bool),
    constant_rotation: bool = @import("std").mem.zeroes(bool),
    constant_scale: bool = @import("std").mem.zeroes(bool),
    translation_keys: ufbx_baked_vec3_list = @import("std").mem.zeroes(ufbx_baked_vec3_list),
    rotation_keys: ufbx_baked_quat_list = @import("std").mem.zeroes(ufbx_baked_quat_list),
    scale_keys: ufbx_baked_vec3_list = @import("std").mem.zeroes(ufbx_baked_vec3_list),
};
pub const ufbx_baked_node = struct_ufbx_baked_node;
pub const struct_ufbx_baked_node_list = extern struct {
    data: [*c]ufbx_baked_node = @import("std").mem.zeroes([*c]ufbx_baked_node),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_baked_node_list = struct_ufbx_baked_node_list;
pub const struct_ufbx_baked_prop = extern struct {
    name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    constant_value: bool = @import("std").mem.zeroes(bool),
    keys: ufbx_baked_vec3_list = @import("std").mem.zeroes(ufbx_baked_vec3_list),
};
pub const ufbx_baked_prop = struct_ufbx_baked_prop;
pub const struct_ufbx_baked_prop_list = extern struct {
    data: [*c]ufbx_baked_prop = @import("std").mem.zeroes([*c]ufbx_baked_prop),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_baked_prop_list = struct_ufbx_baked_prop_list;
pub const struct_ufbx_baked_element = extern struct {
    element_id: u32 = @import("std").mem.zeroes(u32),
    props: ufbx_baked_prop_list = @import("std").mem.zeroes(ufbx_baked_prop_list),
};
pub const ufbx_baked_element = struct_ufbx_baked_element;
pub const struct_ufbx_baked_element_list = extern struct {
    data: [*c]ufbx_baked_element = @import("std").mem.zeroes([*c]ufbx_baked_element),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_baked_element_list = struct_ufbx_baked_element_list;
pub const struct_ufbx_baked_anim = extern struct {
    nodes: ufbx_baked_node_list = @import("std").mem.zeroes(ufbx_baked_node_list),
    elements: ufbx_baked_element_list = @import("std").mem.zeroes(ufbx_baked_element_list),
};
pub const ufbx_baked_anim = struct_ufbx_baked_anim;
pub const ufbx_thread_pool_context = usize;
pub const struct_ufbx_thread_pool_info = extern struct {
    max_concurrent_tasks: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_thread_pool_info = struct_ufbx_thread_pool_info;
pub const ufbx_thread_pool_init_fn = fn (?*anyopaque, ufbx_thread_pool_context, [*c]const ufbx_thread_pool_info) callconv(.C) bool;
pub const ufbx_thread_pool_run_fn = fn (?*anyopaque, ufbx_thread_pool_context, u32, u32, u32) callconv(.C) bool;
pub const ufbx_thread_pool_wait_fn = fn (?*anyopaque, ufbx_thread_pool_context, u32, u32) callconv(.C) bool;
pub const ufbx_thread_pool_free_fn = fn (?*anyopaque, ufbx_thread_pool_context) callconv(.C) void;
pub const struct_ufbx_thread_pool = extern struct {
    init_fn: ?*const ufbx_thread_pool_init_fn = @import("std").mem.zeroes(?*const ufbx_thread_pool_init_fn),
    run_fn: ?*const ufbx_thread_pool_run_fn = @import("std").mem.zeroes(?*const ufbx_thread_pool_run_fn),
    wait_fn: ?*const ufbx_thread_pool_wait_fn = @import("std").mem.zeroes(?*const ufbx_thread_pool_wait_fn),
    free_fn: ?*const ufbx_thread_pool_free_fn = @import("std").mem.zeroes(?*const ufbx_thread_pool_free_fn),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const ufbx_thread_pool = struct_ufbx_thread_pool;
pub const struct_ufbx_thread_opts = extern struct {
    pool: ufbx_thread_pool = @import("std").mem.zeroes(ufbx_thread_pool),
    num_tasks: usize = @import("std").mem.zeroes(usize),
    memory_limit: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_thread_opts = struct_ufbx_thread_opts;
pub const struct_ufbx_load_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    thread_opts: ufbx_thread_opts = @import("std").mem.zeroes(ufbx_thread_opts),
    ignore_geometry: bool = @import("std").mem.zeroes(bool),
    ignore_animation: bool = @import("std").mem.zeroes(bool),
    ignore_embedded: bool = @import("std").mem.zeroes(bool),
    ignore_all_content: bool = @import("std").mem.zeroes(bool),
    evaluate_skinning: bool = @import("std").mem.zeroes(bool),
    evaluate_caches: bool = @import("std").mem.zeroes(bool),
    load_external_files: bool = @import("std").mem.zeroes(bool),
    ignore_missing_external_files: bool = @import("std").mem.zeroes(bool),
    skip_skin_vertices: bool = @import("std").mem.zeroes(bool),
    skip_mesh_parts: bool = @import("std").mem.zeroes(bool),
    clean_skin_weights: bool = @import("std").mem.zeroes(bool),
    disable_quirks: bool = @import("std").mem.zeroes(bool),
    strict: bool = @import("std").mem.zeroes(bool),
    force_single_thread_ascii_parsing: bool = @import("std").mem.zeroes(bool),
    allow_unsafe: bool = @import("std").mem.zeroes(bool),
    index_error_handling: ufbx_index_error_handling = @import("std").mem.zeroes(ufbx_index_error_handling),
    connect_broken_elements: bool = @import("std").mem.zeroes(bool),
    allow_nodes_out_of_root: bool = @import("std").mem.zeroes(bool),
    allow_missing_vertex_position: bool = @import("std").mem.zeroes(bool),
    allow_empty_faces: bool = @import("std").mem.zeroes(bool),
    generate_missing_normals: bool = @import("std").mem.zeroes(bool),
    open_main_file_with_default: bool = @import("std").mem.zeroes(bool),
    path_separator: u8 = @import("std").mem.zeroes(u8),
    node_depth_limit: u32 = @import("std").mem.zeroes(u32),
    file_size_estimate: u64 = @import("std").mem.zeroes(u64),
    read_buffer_size: usize = @import("std").mem.zeroes(usize),
    filename: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    raw_filename: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    progress_cb: ufbx_progress_cb = @import("std").mem.zeroes(ufbx_progress_cb),
    progress_interval_hint: u64 = @import("std").mem.zeroes(u64),
    open_file_cb: ufbx_open_file_cb = @import("std").mem.zeroes(ufbx_open_file_cb),
    geometry_transform_handling: ufbx_geometry_transform_handling = @import("std").mem.zeroes(ufbx_geometry_transform_handling),
    inherit_mode_handling: ufbx_inherit_mode_handling = @import("std").mem.zeroes(ufbx_inherit_mode_handling),
    space_conversion: ufbx_space_conversion = @import("std").mem.zeroes(ufbx_space_conversion),
    handedness_conversion_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    handedness_conversion_retain_winding: bool = @import("std").mem.zeroes(bool),
    reverse_winding: bool = @import("std").mem.zeroes(bool),
    target_axes: ufbx_coordinate_axes = @import("std").mem.zeroes(ufbx_coordinate_axes),
    target_unit_meters: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    target_camera_axes: ufbx_coordinate_axes = @import("std").mem.zeroes(ufbx_coordinate_axes),
    target_light_axes: ufbx_coordinate_axes = @import("std").mem.zeroes(ufbx_coordinate_axes),
    geometry_transform_helper_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    scale_helper_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    normalize_normals: bool = @import("std").mem.zeroes(bool),
    normalize_tangents: bool = @import("std").mem.zeroes(bool),
    use_root_transform: bool = @import("std").mem.zeroes(bool),
    root_transform: ufbx_transform = @import("std").mem.zeroes(ufbx_transform),
    key_clamp_threshold: f64 = @import("std").mem.zeroes(f64),
    unicode_error_handling: ufbx_unicode_error_handling = @import("std").mem.zeroes(ufbx_unicode_error_handling),
    retain_dom: bool = @import("std").mem.zeroes(bool),
    file_format: ufbx_file_format = @import("std").mem.zeroes(ufbx_file_format),
    file_format_lookahead: usize = @import("std").mem.zeroes(usize),
    no_format_from_content: bool = @import("std").mem.zeroes(bool),
    no_format_from_extension: bool = @import("std").mem.zeroes(bool),
    obj_search_mtl_by_filename: bool = @import("std").mem.zeroes(bool),
    obj_merge_objects: bool = @import("std").mem.zeroes(bool),
    obj_merge_groups: bool = @import("std").mem.zeroes(bool),
    obj_split_groups: bool = @import("std").mem.zeroes(bool),
    obj_mtl_path: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    obj_mtl_data: ufbx_blob = @import("std").mem.zeroes(ufbx_blob),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_load_opts = struct_ufbx_load_opts;
pub const struct_ufbx_evaluate_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    evaluate_skinning: bool = @import("std").mem.zeroes(bool),
    evaluate_caches: bool = @import("std").mem.zeroes(bool),
    load_external_files: bool = @import("std").mem.zeroes(bool),
    open_file_cb: ufbx_open_file_cb = @import("std").mem.zeroes(ufbx_open_file_cb),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_evaluate_opts = struct_ufbx_evaluate_opts;
pub const struct_ufbx_const_uint32_list = extern struct {
    data: [*c]const u32 = @import("std").mem.zeroes([*c]const u32),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_const_uint32_list = struct_ufbx_const_uint32_list;
pub const struct_ufbx_const_real_list = extern struct {
    data: [*c]const ufbx_real = @import("std").mem.zeroes([*c]const ufbx_real),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_const_real_list = struct_ufbx_const_real_list;
pub const struct_ufbx_prop_override_desc = extern struct {
    element_id: u32 = @import("std").mem.zeroes(u32),
    prop_name: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value: ufbx_vec4 = @import("std").mem.zeroes(ufbx_vec4),
    value_str: ufbx_string = @import("std").mem.zeroes(ufbx_string),
    value_int: i64 = @import("std").mem.zeroes(i64),
};
pub const ufbx_prop_override_desc = struct_ufbx_prop_override_desc;
pub const struct_ufbx_const_prop_override_desc_list = extern struct {
    data: [*c]const ufbx_prop_override_desc = @import("std").mem.zeroes([*c]const ufbx_prop_override_desc),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_const_prop_override_desc_list = struct_ufbx_const_prop_override_desc_list;
pub const struct_ufbx_const_transform_override_list = extern struct {
    data: [*c]const ufbx_transform_override = @import("std").mem.zeroes([*c]const ufbx_transform_override),
    count: usize = @import("std").mem.zeroes(usize),
};
pub const ufbx_const_transform_override_list = struct_ufbx_const_transform_override_list;
pub const struct_ufbx_anim_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    layer_ids: ufbx_const_uint32_list = @import("std").mem.zeroes(ufbx_const_uint32_list),
    override_layer_weights: ufbx_const_real_list = @import("std").mem.zeroes(ufbx_const_real_list),
    prop_overrides: ufbx_const_prop_override_desc_list = @import("std").mem.zeroes(ufbx_const_prop_override_desc_list),
    transform_overrides: ufbx_const_transform_override_list = @import("std").mem.zeroes(ufbx_const_transform_override_list),
    ignore_connections: bool = @import("std").mem.zeroes(bool),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_anim_opts = struct_ufbx_anim_opts;
pub const struct_ufbx_bake_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    time_start_offset: f64 = @import("std").mem.zeroes(f64),
    resample_rate: f64 = @import("std").mem.zeroes(f64),
    minimum_sample_rate: f64 = @import("std").mem.zeroes(f64),
    bake_transform_props: bool = @import("std").mem.zeroes(bool),
    skip_node_transforms: bool = @import("std").mem.zeroes(bool),
    no_resample_rotation: bool = @import("std").mem.zeroes(bool),
    ignore_layer_weight_animation: bool = @import("std").mem.zeroes(bool),
    max_keyframe_segments: usize = @import("std").mem.zeroes(usize),
    constant_timestep: f64 = @import("std").mem.zeroes(f64),
    key_reduction_enabled: bool = @import("std").mem.zeroes(bool),
    key_reduction_rotation: bool = @import("std").mem.zeroes(bool),
    key_reduction_threshold: f64 = @import("std").mem.zeroes(f64),
    key_reduction_passes: usize = @import("std").mem.zeroes(usize),
    compensate_inherit_no_scale: bool = @import("std").mem.zeroes(bool),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_bake_opts = struct_ufbx_bake_opts;
pub const struct_ufbx_tessellate_curve_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    span_subdivision: u32 = @import("std").mem.zeroes(u32),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_tessellate_curve_opts = struct_ufbx_tessellate_curve_opts;
pub const struct_ufbx_tessellate_surface_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    span_subdivision_u: u32 = @import("std").mem.zeroes(u32),
    span_subdivision_v: u32 = @import("std").mem.zeroes(u32),
    skip_mesh_parts: bool = @import("std").mem.zeroes(bool),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_tessellate_surface_opts = struct_ufbx_tessellate_surface_opts;
pub const struct_ufbx_subdivide_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    boundary: ufbx_subdivision_boundary = @import("std").mem.zeroes(ufbx_subdivision_boundary),
    uv_boundary: ufbx_subdivision_boundary = @import("std").mem.zeroes(ufbx_subdivision_boundary),
    ignore_normals: bool = @import("std").mem.zeroes(bool),
    interpolate_normals: bool = @import("std").mem.zeroes(bool),
    interpolate_tangents: bool = @import("std").mem.zeroes(bool),
    evaluate_source_vertices: bool = @import("std").mem.zeroes(bool),
    max_source_vertices: usize = @import("std").mem.zeroes(usize),
    evaluate_skin_weights: bool = @import("std").mem.zeroes(bool),
    max_skin_weights: usize = @import("std").mem.zeroes(usize),
    skin_deformer_index: usize = @import("std").mem.zeroes(usize),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_subdivide_opts = struct_ufbx_subdivide_opts;
pub const struct_ufbx_geometry_cache_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    temp_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    result_allocator: ufbx_allocator_opts = @import("std").mem.zeroes(ufbx_allocator_opts),
    open_file_cb: ufbx_open_file_cb = @import("std").mem.zeroes(ufbx_open_file_cb),
    frames_per_second: f64 = @import("std").mem.zeroes(f64),
    mirror_axis: ufbx_mirror_axis = @import("std").mem.zeroes(ufbx_mirror_axis),
    use_scale_factor: bool = @import("std").mem.zeroes(bool),
    scale_factor: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_geometry_cache_opts = struct_ufbx_geometry_cache_opts;
pub const struct_ufbx_geometry_cache_data_opts = extern struct {
    _begin_zero: u32 = @import("std").mem.zeroes(u32),
    open_file_cb: ufbx_open_file_cb = @import("std").mem.zeroes(ufbx_open_file_cb),
    additive: bool = @import("std").mem.zeroes(bool),
    use_weight: bool = @import("std").mem.zeroes(bool),
    weight: ufbx_real = @import("std").mem.zeroes(ufbx_real),
    ignore_transform: bool = @import("std").mem.zeroes(bool),
    _end_zero: u32 = @import("std").mem.zeroes(u32),
};
pub const ufbx_geometry_cache_data_opts = struct_ufbx_geometry_cache_data_opts;
pub const struct_ufbx_panic = extern struct {
    did_panic: bool = @import("std").mem.zeroes(bool),
    message_length: usize = @import("std").mem.zeroes(usize),
    message: [128]u8 = @import("std").mem.zeroes([128]u8),
};
pub const ufbx_panic = struct_ufbx_panic;
pub extern const ufbx_empty_string: ufbx_string;
pub extern const ufbx_empty_blob: ufbx_blob;
pub extern const ufbx_identity_matrix: ufbx_matrix;
pub extern const ufbx_identity_transform: ufbx_transform;
pub extern const ufbx_zero_vec2: ufbx_vec2;
pub extern const ufbx_zero_vec3: ufbx_vec3;
pub extern const ufbx_zero_vec4: ufbx_vec4;
pub extern const ufbx_identity_quat: ufbx_quat;
pub extern const ufbx_axes_right_handed_y_up: ufbx_coordinate_axes;
pub extern const ufbx_axes_right_handed_z_up: ufbx_coordinate_axes;
pub extern const ufbx_axes_left_handed_y_up: ufbx_coordinate_axes;
pub extern const ufbx_axes_left_handed_z_up: ufbx_coordinate_axes;
pub extern const ufbx_element_type_size: [40]usize;
pub extern const ufbx_source_version: u32;
pub extern fn ufbx_is_thread_safe() bool;
pub extern fn ufbx_load_memory(data: ?*const anyopaque, data_size: usize, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_file(filename: [*c]const u8, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_file_len(filename: [*c]const u8, filename_len: usize, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_stdio(file: ?*anyopaque, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_stdio_prefix(file: ?*anyopaque, prefix: ?*const anyopaque, prefix_size: usize, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_stream(stream: [*c]const ufbx_stream, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_load_stream_prefix(stream: [*c]const ufbx_stream, prefix: ?*const anyopaque, prefix_size: usize, opts: [*c]const ufbx_load_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_free_scene(scene: [*c]ufbx_scene) void;
pub extern fn ufbx_retain_scene(scene: [*c]ufbx_scene) void;
pub extern fn ufbx_format_error(dst: [*c]u8, dst_size: usize, @"error": [*c]const ufbx_error) usize;
pub extern fn ufbx_find_prop_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize) [*c]ufbx_prop;
pub inline fn ufbx_find_prop(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8) [*c]ufbx_prop {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    return ufbx_find_prop_len(props, name, strlen(name));
}
pub extern fn ufbx_find_real_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: ufbx_real) ufbx_real;
pub inline fn ufbx_find_real(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: ufbx_real) ufbx_real {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_real_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_vec3_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: ufbx_vec3) ufbx_vec3;
pub inline fn ufbx_find_vec3(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: ufbx_vec3) ufbx_vec3 {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_vec3_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_int_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: i64) i64;
pub inline fn ufbx_find_int(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: i64) i64 {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_int_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_bool_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: bool) bool;
pub inline fn ufbx_find_bool(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: bool) bool {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_bool_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_string_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: ufbx_string) ufbx_string;
pub inline fn ufbx_find_string(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: ufbx_string) ufbx_string {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_string_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_blob_len(props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: ufbx_blob) ufbx_blob;
pub inline fn ufbx_find_blob(arg_props: [*c]const ufbx_props, arg_name: [*c]const u8, arg_def: ufbx_blob) ufbx_blob {
    var props = arg_props;
    _ = &props;
    var name = arg_name;
    _ = &name;
    var def = arg_def;
    _ = &def;
    return ufbx_find_blob_len(props, name, strlen(name), def);
}
pub extern fn ufbx_find_prop_concat(props: [*c]const ufbx_props, parts: [*c]const ufbx_string, num_parts: usize) [*c]ufbx_prop;
pub extern fn ufbx_get_prop_element(element: [*c]const ufbx_element, prop: [*c]const ufbx_prop, @"type": ufbx_element_type) [*c]ufbx_element;
pub extern fn ufbx_find_prop_element_len(element: [*c]const ufbx_element, name: [*c]const u8, name_len: usize, @"type": ufbx_element_type) [*c]ufbx_element;
pub inline fn ufbx_find_prop_element(arg_element: [*c]const ufbx_element, arg_name: [*c]const u8, arg_type: ufbx_element_type) [*c]ufbx_element {
    var element = arg_element;
    _ = &element;
    var name = arg_name;
    _ = &name;
    var @"type" = arg_type;
    _ = &@"type";
    return ufbx_find_prop_element_len(element, name, strlen(name), @"type");
}
pub extern fn ufbx_find_element_len(scene: [*c]const ufbx_scene, @"type": ufbx_element_type, name: [*c]const u8, name_len: usize) [*c]ufbx_element;
pub inline fn ufbx_find_element(arg_scene: [*c]const ufbx_scene, arg_type: ufbx_element_type, arg_name: [*c]const u8) [*c]ufbx_element {
    var scene = arg_scene;
    _ = &scene;
    var @"type" = arg_type;
    _ = &@"type";
    var name = arg_name;
    _ = &name;
    return ufbx_find_element_len(scene, @"type", name, strlen(name));
}
pub extern fn ufbx_find_node_len(scene: [*c]const ufbx_scene, name: [*c]const u8, name_len: usize) [*c]ufbx_node;
pub inline fn ufbx_find_node(arg_scene: [*c]const ufbx_scene, arg_name: [*c]const u8) [*c]ufbx_node {
    var scene = arg_scene;
    _ = &scene;
    var name = arg_name;
    _ = &name;
    return ufbx_find_node_len(scene, name, strlen(name));
}
pub extern fn ufbx_find_anim_stack_len(scene: [*c]const ufbx_scene, name: [*c]const u8, name_len: usize) [*c]ufbx_anim_stack;
pub inline fn ufbx_find_anim_stack(arg_scene: [*c]const ufbx_scene, arg_name: [*c]const u8) [*c]ufbx_anim_stack {
    var scene = arg_scene;
    _ = &scene;
    var name = arg_name;
    _ = &name;
    return ufbx_find_anim_stack_len(scene, name, strlen(name));
}
pub extern fn ufbx_find_material_len(scene: [*c]const ufbx_scene, name: [*c]const u8, name_len: usize) [*c]ufbx_material;
pub inline fn ufbx_find_material(arg_scene: [*c]const ufbx_scene, arg_name: [*c]const u8) [*c]ufbx_material {
    var scene = arg_scene;
    _ = &scene;
    var name = arg_name;
    _ = &name;
    return ufbx_find_material_len(scene, name, strlen(name));
}
pub extern fn ufbx_find_anim_prop_len(layer: [*c]const ufbx_anim_layer, element: [*c]const ufbx_element, prop: [*c]const u8, prop_len: usize) [*c]ufbx_anim_prop;
pub inline fn ufbx_find_anim_prop(arg_layer: [*c]const ufbx_anim_layer, arg_element: [*c]const ufbx_element, arg_prop: [*c]const u8) [*c]ufbx_anim_prop {
    var layer = arg_layer;
    _ = &layer;
    var element = arg_element;
    _ = &element;
    var prop = arg_prop;
    _ = &prop;
    return ufbx_find_anim_prop_len(layer, element, prop, strlen(prop));
}
pub extern fn ufbx_find_anim_props(layer: [*c]const ufbx_anim_layer, element: [*c]const ufbx_element) ufbx_anim_prop_list;
pub extern fn ufbx_get_compatible_matrix_for_normals(node: [*c]const ufbx_node) ufbx_matrix;
pub extern fn ufbx_inflate(dst: ?*anyopaque, dst_size: usize, input: [*c]const ufbx_inflate_input, retain: [*c]ufbx_inflate_retain) ptrdiff_t;
pub extern fn ufbx_open_file(stream: [*c]ufbx_stream, path: [*c]const u8, path_len: usize) bool;
pub extern fn ufbx_default_open_file(user: ?*anyopaque, stream: [*c]ufbx_stream, path: [*c]const u8, path_len: usize, info: [*c]const ufbx_open_file_info) bool;
pub extern fn ufbx_open_memory(stream: [*c]ufbx_stream, data: ?*const anyopaque, data_size: usize, opts: [*c]const ufbx_open_memory_opts, @"error": [*c]ufbx_error) bool;
pub extern fn ufbx_evaluate_curve(curve: [*c]const ufbx_anim_curve, time: f64, default_value: ufbx_real) ufbx_real;
pub extern fn ufbx_evaluate_anim_value_real(anim_value: [*c]const ufbx_anim_value, time: f64) ufbx_real;
pub extern fn ufbx_evaluate_anim_value_vec2(anim_value: [*c]const ufbx_anim_value, time: f64) ufbx_vec2;
pub extern fn ufbx_evaluate_anim_value_vec3(anim_value: [*c]const ufbx_anim_value, time: f64) ufbx_vec3;
pub extern fn ufbx_evaluate_prop_len(anim: [*c]const ufbx_anim, element: [*c]const ufbx_element, name: [*c]const u8, name_len: usize, time: f64) ufbx_prop;
pub inline fn ufbx_evaluate_prop(arg_anim: [*c]const ufbx_anim, arg_element: [*c]const ufbx_element, arg_name: [*c]const u8, arg_time: f64) ufbx_prop {
    var anim = arg_anim;
    _ = &anim;
    var element = arg_element;
    _ = &element;
    var name = arg_name;
    _ = &name;
    var time = arg_time;
    _ = &time;
    return ufbx_evaluate_prop_len(anim, element, name, strlen(name), time);
}
pub extern fn ufbx_evaluate_props(anim: [*c]const ufbx_anim, element: [*c]const ufbx_element, time: f64, buffer: [*c]ufbx_prop, buffer_size: usize) ufbx_props;
pub const UFBX_TRANSFORM_FLAG_IGNORE_SCALE_HELPER: c_int = 1;
pub const UFBX_TRANSFORM_FLAG_IGNORE_COMPONENTWISE_SCALE: c_int = 2;
pub const UFBX_TRANSFORM_FLAG_EXPLICIT_INCLUDES: c_int = 4;
pub const UFBX_TRANSFORM_FLAG_INCLUDE_TRANSLATION: c_int = 16;
pub const UFBX_TRANSFORM_FLAG_INCLUDE_ROTATION: c_int = 32;
pub const UFBX_TRANSFORM_FLAG_INCLUDE_SCALE: c_int = 64;
pub const UFBX_TRANSFORM_FLAGS_FORCE_32BIT: c_int = 2147483647;
pub const enum_ufbx_transform_flags = c_uint;
pub const ufbx_transform_flags = enum_ufbx_transform_flags;
pub extern fn ufbx_evaluate_transform(anim: [*c]const ufbx_anim, node: [*c]const ufbx_node, time: f64) ufbx_transform;
pub extern fn ufbx_evaluate_transform_flags(anim: [*c]const ufbx_anim, node: [*c]const ufbx_node, time: f64, flags: u32) ufbx_transform;
pub extern fn ufbx_evaluate_blend_weight(anim: [*c]const ufbx_anim, channel: [*c]const ufbx_blend_channel, time: f64) ufbx_real;
pub extern fn ufbx_evaluate_scene(scene: [*c]const ufbx_scene, anim: [*c]const ufbx_anim, time: f64, opts: [*c]const ufbx_evaluate_opts, @"error": [*c]ufbx_error) [*c]ufbx_scene;
pub extern fn ufbx_create_anim(scene: [*c]const ufbx_scene, opts: [*c]const ufbx_anim_opts, @"error": [*c]ufbx_error) [*c]ufbx_anim;
pub extern fn ufbx_retain_anim(anim: [*c]ufbx_anim) void;
pub extern fn ufbx_free_anim(anim: [*c]ufbx_anim) void;
pub extern fn ufbx_bake_anim(scene: [*c]const ufbx_scene, anim: [*c]const ufbx_anim, opts: [*c]const ufbx_bake_opts, @"error": [*c]ufbx_error) [*c]ufbx_baked_anim;
pub extern fn ufbx_retain_baked_anim(bake: [*c]ufbx_baked_anim) void;
pub extern fn ufbx_free_baked_anim(bake: [*c]ufbx_baked_anim) void;
pub extern fn ufbx_evaluate_baked_vec3(keyframes: ufbx_baked_vec3_list, time: f64) ufbx_vec3;
pub extern fn ufbx_evaluate_baked_quat(keyframes: ufbx_baked_quat_list, time: f64) ufbx_quat;
pub extern fn ufbx_find_prop_texture_len(material: [*c]const ufbx_material, name: [*c]const u8, name_len: usize) [*c]ufbx_texture;
pub inline fn ufbx_find_prop_texture(arg_material: [*c]const ufbx_material, arg_name: [*c]const u8) [*c]ufbx_texture {
    var material = arg_material;
    _ = &material;
    var name = arg_name;
    _ = &name;
    return ufbx_find_prop_texture_len(material, name, strlen(name));
}
pub extern fn ufbx_find_shader_prop_len(shader: [*c]const ufbx_shader, name: [*c]const u8, name_len: usize) ufbx_string;
pub inline fn ufbx_find_shader_prop(arg_shader: [*c]const ufbx_shader, arg_name: [*c]const u8) ufbx_string {
    var shader = arg_shader;
    _ = &shader;
    var name = arg_name;
    _ = &name;
    return ufbx_find_shader_prop_len(shader, name, strlen(name));
}
pub extern fn ufbx_find_shader_prop_bindings_len(shader: [*c]const ufbx_shader, name: [*c]const u8, name_len: usize) ufbx_shader_prop_binding_list;
pub inline fn ufbx_find_shader_prop_bindings(arg_shader: [*c]const ufbx_shader, arg_name: [*c]const u8) ufbx_shader_prop_binding_list {
    var shader = arg_shader;
    _ = &shader;
    var name = arg_name;
    _ = &name;
    return ufbx_find_shader_prop_bindings_len(shader, name, strlen(name));
}
pub extern fn ufbx_find_shader_texture_input_len(shader: [*c]const ufbx_shader_texture, name: [*c]const u8, name_len: usize) [*c]ufbx_shader_texture_input;
pub inline fn ufbx_find_shader_texture_input(arg_shader: [*c]const ufbx_shader_texture, arg_name: [*c]const u8) [*c]ufbx_shader_texture_input {
    var shader = arg_shader;
    _ = &shader;
    var name = arg_name;
    _ = &name;
    return ufbx_find_shader_texture_input_len(shader, name, strlen(name));
}
pub extern fn ufbx_coordinate_axes_valid(axes: ufbx_coordinate_axes) bool;
pub extern fn ufbx_quat_dot(a: ufbx_quat, b: ufbx_quat) ufbx_real;
pub extern fn ufbx_quat_mul(a: ufbx_quat, b: ufbx_quat) ufbx_quat;
pub extern fn ufbx_quat_normalize(q: ufbx_quat) ufbx_quat;
pub extern fn ufbx_quat_fix_antipodal(q: ufbx_quat, reference: ufbx_quat) ufbx_quat;
pub extern fn ufbx_quat_slerp(a: ufbx_quat, b: ufbx_quat, t: ufbx_real) ufbx_quat;
pub extern fn ufbx_quat_rotate_vec3(q: ufbx_quat, v: ufbx_vec3) ufbx_vec3;
pub extern fn ufbx_quat_to_euler(q: ufbx_quat, order: ufbx_rotation_order) ufbx_vec3;
pub extern fn ufbx_euler_to_quat(v: ufbx_vec3, order: ufbx_rotation_order) ufbx_quat;
pub extern fn ufbx_matrix_mul(a: [*c]const ufbx_matrix, b: [*c]const ufbx_matrix) ufbx_matrix;
pub extern fn ufbx_matrix_determinant(m: [*c]const ufbx_matrix) ufbx_real;
pub extern fn ufbx_matrix_invert(m: [*c]const ufbx_matrix) ufbx_matrix;
pub extern fn ufbx_matrix_for_normals(m: [*c]const ufbx_matrix) ufbx_matrix;
pub extern fn ufbx_transform_position(m: [*c]const ufbx_matrix, v: ufbx_vec3) ufbx_vec3;
pub extern fn ufbx_transform_direction(m: [*c]const ufbx_matrix, v: ufbx_vec3) ufbx_vec3;
pub extern fn ufbx_transform_to_matrix(t: [*c]const ufbx_transform) ufbx_matrix;
pub extern fn ufbx_matrix_to_transform(m: [*c]const ufbx_matrix) ufbx_transform;
pub extern fn ufbx_catch_get_skin_vertex_matrix(panic: [*c]ufbx_panic, skin: [*c]const ufbx_skin_deformer, vertex: usize, fallback: [*c]const ufbx_matrix) ufbx_matrix;
pub inline fn ufbx_get_skin_vertex_matrix(arg_skin: [*c]const ufbx_skin_deformer, arg_vertex: usize, arg_fallback: [*c]const ufbx_matrix) ufbx_matrix {
    var skin = arg_skin;
    _ = &skin;
    var vertex = arg_vertex;
    _ = &vertex;
    var fallback = arg_fallback;
    _ = &fallback;
    return ufbx_catch_get_skin_vertex_matrix(null, skin, vertex, fallback);
}
pub extern fn ufbx_get_blend_shape_offset_index(shape: [*c]const ufbx_blend_shape, vertex: usize) u32;
pub extern fn ufbx_get_blend_shape_vertex_offset(shape: [*c]const ufbx_blend_shape, vertex: usize) ufbx_vec3;
pub extern fn ufbx_get_blend_vertex_offset(blend: [*c]const ufbx_blend_deformer, vertex: usize) ufbx_vec3;
pub extern fn ufbx_add_blend_shape_vertex_offsets(shape: [*c]const ufbx_blend_shape, vertices: [*c]ufbx_vec3, num_vertices: usize, weight: ufbx_real) void;
pub extern fn ufbx_add_blend_vertex_offsets(blend: [*c]const ufbx_blend_deformer, vertices: [*c]ufbx_vec3, num_vertices: usize, weight: ufbx_real) void;
pub extern fn ufbx_evaluate_nurbs_basis(basis: [*c]const ufbx_nurbs_basis, u: ufbx_real, weights: [*c]ufbx_real, num_weights: usize, derivatives: [*c]ufbx_real, num_derivatives: usize) usize;
pub extern fn ufbx_evaluate_nurbs_curve(curve: [*c]const ufbx_nurbs_curve, u: ufbx_real) ufbx_curve_point;
pub extern fn ufbx_evaluate_nurbs_surface(surface: [*c]const ufbx_nurbs_surface, u: ufbx_real, v: ufbx_real) ufbx_surface_point;
pub extern fn ufbx_tessellate_nurbs_curve(curve: [*c]const ufbx_nurbs_curve, opts: [*c]const ufbx_tessellate_curve_opts, @"error": [*c]ufbx_error) [*c]ufbx_line_curve;
pub extern fn ufbx_tessellate_nurbs_surface(surface: [*c]const ufbx_nurbs_surface, opts: [*c]const ufbx_tessellate_surface_opts, @"error": [*c]ufbx_error) [*c]ufbx_mesh;
pub extern fn ufbx_free_line_curve(curve: [*c]ufbx_line_curve) void;
pub extern fn ufbx_retain_line_curve(curve: [*c]ufbx_line_curve) void;
pub extern fn ufbx_find_face_index(mesh: [*c]ufbx_mesh, index: usize) u32;
pub extern fn ufbx_catch_triangulate_face(panic: [*c]ufbx_panic, indices: [*c]u32, num_indices: usize, mesh: [*c]const ufbx_mesh, face: ufbx_face) u32;
pub inline fn ufbx_triangulate_face(arg_indices: [*c]u32, arg_num_indices: usize, arg_mesh: [*c]const ufbx_mesh, arg_face: ufbx_face) u32 {
    var indices = arg_indices;
    _ = &indices;
    var num_indices = arg_num_indices;
    _ = &num_indices;
    var mesh = arg_mesh;
    _ = &mesh;
    var face = arg_face;
    _ = &face;
    return ufbx_catch_triangulate_face(null, indices, num_indices, mesh, face);
}
pub extern fn ufbx_catch_compute_topology(panic: [*c]ufbx_panic, mesh: [*c]const ufbx_mesh, topo: [*c]ufbx_topo_edge, num_topo: usize) void;
pub inline fn ufbx_compute_topology(arg_mesh: [*c]const ufbx_mesh, arg_topo: [*c]ufbx_topo_edge, arg_num_topo: usize) void {
    var mesh = arg_mesh;
    _ = &mesh;
    var topo = arg_topo;
    _ = &topo;
    var num_topo = arg_num_topo;
    _ = &num_topo;
    ufbx_catch_compute_topology(null, mesh, topo, num_topo);
}
pub extern fn ufbx_catch_topo_next_vertex_edge(panic: [*c]ufbx_panic, topo: [*c]const ufbx_topo_edge, num_topo: usize, index: u32) u32;
pub inline fn ufbx_topo_next_vertex_edge(arg_topo: [*c]const ufbx_topo_edge, arg_num_topo: usize, arg_index_1: u32) u32 {
    var topo = arg_topo;
    _ = &topo;
    var num_topo = arg_num_topo;
    _ = &num_topo;
    var index_1 = arg_index_1;
    _ = &index_1;
    return ufbx_catch_topo_next_vertex_edge(null, topo, num_topo, index_1);
}
pub extern fn ufbx_catch_topo_prev_vertex_edge(panic: [*c]ufbx_panic, topo: [*c]const ufbx_topo_edge, num_topo: usize, index: u32) u32;
pub inline fn ufbx_topo_prev_vertex_edge(arg_topo: [*c]const ufbx_topo_edge, arg_num_topo: usize, arg_index_1: u32) u32 {
    var topo = arg_topo;
    _ = &topo;
    var num_topo = arg_num_topo;
    _ = &num_topo;
    var index_1 = arg_index_1;
    _ = &index_1;
    return ufbx_catch_topo_prev_vertex_edge(null, topo, num_topo, index_1);
}
pub extern fn ufbx_catch_get_weighted_face_normal(panic: [*c]ufbx_panic, positions: [*c]const ufbx_vertex_vec3, face: ufbx_face) ufbx_vec3;
pub inline fn ufbx_get_weighted_face_normal(arg_positions: [*c]const ufbx_vertex_vec3, arg_face: ufbx_face) ufbx_vec3 {
    var positions = arg_positions;
    _ = &positions;
    var face = arg_face;
    _ = &face;
    return ufbx_catch_get_weighted_face_normal(null, positions, face);
}
pub extern fn ufbx_catch_generate_normal_mapping(panic: [*c]ufbx_panic, mesh: [*c]const ufbx_mesh, topo: [*c]const ufbx_topo_edge, num_topo: usize, normal_indices: [*c]u32, num_normal_indices: usize, assume_smooth: bool) usize;
pub extern fn ufbx_generate_normal_mapping(mesh: [*c]const ufbx_mesh, topo: [*c]const ufbx_topo_edge, num_topo: usize, normal_indices: [*c]u32, num_normal_indices: usize, assume_smooth: bool) usize;
pub extern fn ufbx_catch_compute_normals(panic: [*c]ufbx_panic, mesh: [*c]const ufbx_mesh, positions: [*c]const ufbx_vertex_vec3, normal_indices: [*c]const u32, num_normal_indices: usize, normals: [*c]ufbx_vec3, num_normals: usize) void;
pub extern fn ufbx_compute_normals(mesh: [*c]const ufbx_mesh, positions: [*c]const ufbx_vertex_vec3, normal_indices: [*c]const u32, num_normal_indices: usize, normals: [*c]ufbx_vec3, num_normals: usize) void;
pub extern fn ufbx_subdivide_mesh(mesh: [*c]const ufbx_mesh, level: usize, opts: [*c]const ufbx_subdivide_opts, @"error": [*c]ufbx_error) [*c]ufbx_mesh;
pub extern fn ufbx_free_mesh(mesh: [*c]ufbx_mesh) void;
pub extern fn ufbx_retain_mesh(mesh: [*c]ufbx_mesh) void;
pub extern fn ufbx_load_geometry_cache(filename: [*c]const u8, opts: [*c]const ufbx_geometry_cache_opts, @"error": [*c]ufbx_error) [*c]ufbx_geometry_cache;
pub extern fn ufbx_load_geometry_cache_len(filename: [*c]const u8, filename_len: usize, opts: [*c]const ufbx_geometry_cache_opts, @"error": [*c]ufbx_error) [*c]ufbx_geometry_cache;
pub extern fn ufbx_free_geometry_cache(cache: [*c]ufbx_geometry_cache) void;
pub extern fn ufbx_retain_geometry_cache(cache: [*c]ufbx_geometry_cache) void;
pub extern fn ufbx_read_geometry_cache_real(frame: [*c]const ufbx_cache_frame, data: [*c]ufbx_real, num_data: usize, opts: [*c]const ufbx_geometry_cache_data_opts) usize;
pub extern fn ufbx_sample_geometry_cache_real(channel: [*c]const ufbx_cache_channel, time: f64, data: [*c]ufbx_real, num_data: usize, opts: [*c]const ufbx_geometry_cache_data_opts) usize;
pub extern fn ufbx_read_geometry_cache_vec3(frame: [*c]const ufbx_cache_frame, data: [*c]ufbx_vec3, num_data: usize, opts: [*c]const ufbx_geometry_cache_data_opts) usize;
pub extern fn ufbx_sample_geometry_cache_vec3(channel: [*c]const ufbx_cache_channel, time: f64, data: [*c]ufbx_vec3, num_data: usize, opts: [*c]const ufbx_geometry_cache_data_opts) usize;
pub extern fn ufbx_dom_find_len(parent: [*c]const ufbx_dom_node, name: [*c]const u8, name_len: usize) [*c]ufbx_dom_node;
pub inline fn ufbx_dom_find(arg_parent: [*c]const ufbx_dom_node, arg_name: [*c]const u8) [*c]ufbx_dom_node {
    var parent = arg_parent;
    _ = &parent;
    var name = arg_name;
    _ = &name;
    return ufbx_dom_find_len(parent, name, strlen(name));
}
pub extern fn ufbx_generate_indices(streams: [*c]const ufbx_vertex_stream, num_streams: usize, indices: [*c]u32, num_indices: usize, allocator: [*c]const ufbx_allocator_opts, @"error": [*c]ufbx_error) usize;
pub extern fn ufbx_thread_pool_run_task(ctx: ufbx_thread_pool_context, index: u32) void;
pub extern fn ufbx_thread_pool_set_user_ptr(ctx: ufbx_thread_pool_context, user_ptr: ?*anyopaque) void;
pub extern fn ufbx_thread_pool_get_user_ptr(ctx: ufbx_thread_pool_context) ?*anyopaque;
pub extern fn ufbx_catch_get_vertex_real(panic: [*c]ufbx_panic, v: [*c]const ufbx_vertex_real, index: usize) ufbx_real;
pub extern fn ufbx_catch_get_vertex_vec2(panic: [*c]ufbx_panic, v: [*c]const ufbx_vertex_vec2, index: usize) ufbx_vec2;
pub extern fn ufbx_catch_get_vertex_vec3(panic: [*c]ufbx_panic, v: [*c]const ufbx_vertex_vec3, index: usize) ufbx_vec3;
pub extern fn ufbx_catch_get_vertex_vec4(panic: [*c]ufbx_panic, v: [*c]const ufbx_vertex_vec4, index: usize) ufbx_vec4;
pub inline fn ufbx_get_vertex_real(arg_v: [*c]const ufbx_vertex_real, arg_index_1: usize) ufbx_real {
    var v = arg_v;
    _ = &v;
    var index_1 = arg_index_1;
    _ = &index_1;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (index_1 < v.*.indices.count) {} else {
                __assert_fail("index < v->indices.count", "zig-out/include/ubfx.h", @as(c_uint, @bitCast(@as(c_int, 5096))), "ufbx_real ufbx_get_vertex_real(const ufbx_vertex_real *, size_t)");
            };
        };
    };
    return (blk: {
        const tmp = @as(i32, @bitCast(v.*.indices.data[index_1]));
        if (tmp >= 0) break :blk v.*.values.data + @as(usize, @intCast(tmp)) else break :blk v.*.values.data - ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
    }).*;
}
pub inline fn ufbx_get_vertex_vec2(arg_v: [*c]const ufbx_vertex_vec2, arg_index_1: usize) ufbx_vec2 {
    var v = arg_v;
    _ = &v;
    var index_1 = arg_index_1;
    _ = &index_1;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (index_1 < v.*.indices.count) {} else {
                __assert_fail("index < v->indices.count", "zig-out/include/ubfx.h", @as(c_uint, @bitCast(@as(c_int, 5097))), "ufbx_vec2 ufbx_get_vertex_vec2(const ufbx_vertex_vec2 *, size_t)");
            };
        };
    };
    return (blk: {
        const tmp = @as(i32, @bitCast(v.*.indices.data[index_1]));
        if (tmp >= 0) break :blk v.*.values.data + @as(usize, @intCast(tmp)) else break :blk v.*.values.data - ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
    }).*;
}
pub inline fn ufbx_get_vertex_vec3(arg_v: [*c]const ufbx_vertex_vec3, arg_index_1: usize) ufbx_vec3 {
    var v = arg_v;
    _ = &v;
    var index_1 = arg_index_1;
    _ = &index_1;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (index_1 < v.*.indices.count) {} else {
                __assert_fail("index < v->indices.count", "zig-out/include/ubfx.h", @as(c_uint, @bitCast(@as(c_int, 5098))), "ufbx_vec3 ufbx_get_vertex_vec3(const ufbx_vertex_vec3 *, size_t)");
            };
        };
    };
    return (blk: {
        const tmp = @as(i32, @bitCast(v.*.indices.data[index_1]));
        if (tmp >= 0) break :blk v.*.values.data + @as(usize, @intCast(tmp)) else break :blk v.*.values.data - ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
    }).*;
}
pub inline fn ufbx_get_vertex_vec4(arg_v: [*c]const ufbx_vertex_vec4, arg_index_1: usize) ufbx_vec4 {
    var v = arg_v;
    _ = &v;
    var index_1 = arg_index_1;
    _ = &index_1;
    _ = blk: {
        _ = @sizeOf(c_int);
        break :blk blk_1: {
            break :blk_1 if (index_1 < v.*.indices.count) {} else {
                __assert_fail("index < v->indices.count", "zig-out/include/ubfx.h", @as(c_uint, @bitCast(@as(c_int, 5099))), "ufbx_vec4 ufbx_get_vertex_vec4(const ufbx_vertex_vec4 *, size_t)");
            };
        };
    };
    return (blk: {
        const tmp = @as(i32, @bitCast(v.*.indices.data[index_1]));
        if (tmp >= 0) break :blk v.*.values.data + @as(usize, @intCast(tmp)) else break :blk v.*.values.data - ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
    }).*;
}
pub extern fn ufbx_get_triangulate_face_num_indices(face: ufbx_face) usize;
pub extern fn ufbx_as_unknown(element: [*c]const ufbx_element) [*c]ufbx_unknown;
pub extern fn ufbx_as_node(element: [*c]const ufbx_element) [*c]ufbx_node;
pub extern fn ufbx_as_mesh(element: [*c]const ufbx_element) [*c]ufbx_mesh;
pub extern fn ufbx_as_light(element: [*c]const ufbx_element) [*c]ufbx_light;
pub extern fn ufbx_as_camera(element: [*c]const ufbx_element) [*c]ufbx_camera;
pub extern fn ufbx_as_bone(element: [*c]const ufbx_element) [*c]ufbx_bone;
pub extern fn ufbx_as_empty(element: [*c]const ufbx_element) [*c]ufbx_empty;
pub extern fn ufbx_as_line_curve(element: [*c]const ufbx_element) [*c]ufbx_line_curve;
pub extern fn ufbx_as_nurbs_curve(element: [*c]const ufbx_element) [*c]ufbx_nurbs_curve;
pub extern fn ufbx_as_nurbs_surface(element: [*c]const ufbx_element) [*c]ufbx_nurbs_surface;
pub extern fn ufbx_as_nurbs_trim_surface(element: [*c]const ufbx_element) [*c]ufbx_nurbs_trim_surface;
pub extern fn ufbx_as_nurbs_trim_boundary(element: [*c]const ufbx_element) [*c]ufbx_nurbs_trim_boundary;
pub extern fn ufbx_as_procedural_geometry(element: [*c]const ufbx_element) [*c]ufbx_procedural_geometry;
pub extern fn ufbx_as_stereo_camera(element: [*c]const ufbx_element) [*c]ufbx_stereo_camera;
pub extern fn ufbx_as_camera_switcher(element: [*c]const ufbx_element) [*c]ufbx_camera_switcher;
pub extern fn ufbx_as_marker(element: [*c]const ufbx_element) [*c]ufbx_marker;
pub extern fn ufbx_as_lod_group(element: [*c]const ufbx_element) [*c]ufbx_lod_group;
pub extern fn ufbx_as_skin_deformer(element: [*c]const ufbx_element) [*c]ufbx_skin_deformer;
pub extern fn ufbx_as_skin_cluster(element: [*c]const ufbx_element) [*c]ufbx_skin_cluster;
pub extern fn ufbx_as_blend_deformer(element: [*c]const ufbx_element) [*c]ufbx_blend_deformer;
pub extern fn ufbx_as_blend_channel(element: [*c]const ufbx_element) [*c]ufbx_blend_channel;
pub extern fn ufbx_as_blend_shape(element: [*c]const ufbx_element) [*c]ufbx_blend_shape;
pub extern fn ufbx_as_cache_deformer(element: [*c]const ufbx_element) [*c]ufbx_cache_deformer;
pub extern fn ufbx_as_cache_file(element: [*c]const ufbx_element) [*c]ufbx_cache_file;
pub extern fn ufbx_as_material(element: [*c]const ufbx_element) [*c]ufbx_material;
pub extern fn ufbx_as_texture(element: [*c]const ufbx_element) [*c]ufbx_texture;
pub extern fn ufbx_as_video(element: [*c]const ufbx_element) [*c]ufbx_video;
pub extern fn ufbx_as_shader(element: [*c]const ufbx_element) [*c]ufbx_shader;
pub extern fn ufbx_as_shader_binding(element: [*c]const ufbx_element) [*c]ufbx_shader_binding;
pub extern fn ufbx_as_anim_stack(element: [*c]const ufbx_element) [*c]ufbx_anim_stack;
pub extern fn ufbx_as_anim_layer(element: [*c]const ufbx_element) [*c]ufbx_anim_layer;
pub extern fn ufbx_as_anim_value(element: [*c]const ufbx_element) [*c]ufbx_anim_value;
pub extern fn ufbx_as_anim_curve(element: [*c]const ufbx_element) [*c]ufbx_anim_curve;
pub extern fn ufbx_as_display_layer(element: [*c]const ufbx_element) [*c]ufbx_display_layer;
pub extern fn ufbx_as_selection_set(element: [*c]const ufbx_element) [*c]ufbx_selection_set;
pub extern fn ufbx_as_selection_node(element: [*c]const ufbx_element) [*c]ufbx_selection_node;
pub extern fn ufbx_as_character(element: [*c]const ufbx_element) [*c]ufbx_character;
pub extern fn ufbx_as_constraint(element: [*c]const ufbx_element) [*c]ufbx_constraint;
pub extern fn ufbx_as_pose(element: [*c]const ufbx_element) [*c]ufbx_pose;
pub extern fn ufbx_as_metadata_object(element: [*c]const ufbx_element) [*c]ufbx_metadata_object;
pub extern fn ufbx_ffi_find_int_len(retval: [*c]i64, props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: [*c]const i64) void;
pub extern fn ufbx_ffi_find_vec3_len(retval: [*c]ufbx_vec3, props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: [*c]const ufbx_vec3) void;
pub extern fn ufbx_ffi_find_string_len(retval: [*c]ufbx_string, props: [*c]const ufbx_props, name: [*c]const u8, name_len: usize, def: [*c]const ufbx_string) void;
pub extern fn ufbx_ffi_find_anim_props(retval: [*c]ufbx_anim_prop_list, layer: [*c]const ufbx_anim_layer, element: [*c]const ufbx_element) void;
pub extern fn ufbx_ffi_get_compatible_matrix_for_normals(retval: [*c]ufbx_matrix, node: [*c]const ufbx_node) void;
pub extern fn ufbx_ffi_evaluate_anim_value_vec2(retval: [*c]ufbx_vec2, anim_value: [*c]const ufbx_anim_value, time: f64) void;
pub extern fn ufbx_ffi_evaluate_anim_value_vec3(retval: [*c]ufbx_vec3, anim_value: [*c]const ufbx_anim_value, time: f64) void;
pub extern fn ufbx_ffi_evaluate_prop_len(retval: [*c]ufbx_prop, anim: [*c]const ufbx_anim, element: [*c]const ufbx_element, name: [*c]const u8, name_len: usize, time: f64) void;
pub extern fn ufbx_ffi_evaluate_props(retval: [*c]ufbx_props, anim: [*c]const ufbx_anim, element: [*c]ufbx_element, time: f64, buffer: [*c]ufbx_prop, buffer_size: usize) void;
pub extern fn ufbx_ffi_evaluate_transform(retval: [*c]ufbx_transform, anim: [*c]const ufbx_anim, node: [*c]const ufbx_node, time: f64) void;
pub extern fn ufbx_ffi_evaluate_blend_weight(anim: [*c]const ufbx_anim, channel: [*c]const ufbx_blend_channel, time: f64) ufbx_real;
pub extern fn ufbx_ffi_quat_mul(retval: [*c]ufbx_quat, a: [*c]const ufbx_quat, b: [*c]const ufbx_quat) void;
pub extern fn ufbx_ffi_quat_normalize(retval: [*c]ufbx_quat, q: [*c]const ufbx_quat) void;
pub extern fn ufbx_ffi_quat_fix_antipodal(retval: [*c]ufbx_quat, q: [*c]const ufbx_quat, reference: [*c]const ufbx_quat) void;
pub extern fn ufbx_ffi_quat_slerp(retval: [*c]ufbx_quat, a: [*c]const ufbx_quat, b: [*c]const ufbx_quat, t: ufbx_real) void;
pub extern fn ufbx_ffi_quat_rotate_vec3(retval: [*c]ufbx_vec3, q: [*c]const ufbx_quat, v: [*c]const ufbx_vec3) void;
pub extern fn ufbx_ffi_quat_to_euler(retval: [*c]ufbx_vec3, q: [*c]const ufbx_quat, order: ufbx_rotation_order) void;
pub extern fn ufbx_ffi_euler_to_quat(retval: [*c]ufbx_quat, v: [*c]const ufbx_vec3, order: ufbx_rotation_order) void;
pub extern fn ufbx_ffi_matrix_mul(retval: [*c]ufbx_matrix, a: [*c]const ufbx_matrix, b: [*c]const ufbx_matrix) void;
pub extern fn ufbx_ffi_matrix_invert(retval: [*c]ufbx_matrix, m: [*c]const ufbx_matrix) void;
pub extern fn ufbx_ffi_matrix_for_normals(retval: [*c]ufbx_matrix, m: [*c]const ufbx_matrix) void;
pub extern fn ufbx_ffi_transform_position(retval: [*c]ufbx_vec3, m: [*c]const ufbx_matrix, v: [*c]const ufbx_vec3) void;
pub extern fn ufbx_ffi_transform_direction(retval: [*c]ufbx_vec3, m: [*c]const ufbx_matrix, v: [*c]const ufbx_vec3) void;
pub extern fn ufbx_ffi_transform_to_matrix(retval: [*c]ufbx_matrix, t: [*c]const ufbx_transform) void;
pub extern fn ufbx_ffi_matrix_to_transform(retval: [*c]ufbx_transform, m: [*c]const ufbx_matrix) void;
pub extern fn ufbx_ffi_get_skin_vertex_matrix(retval: [*c]ufbx_matrix, skin: [*c]const ufbx_skin_deformer, vertex: usize, fallback: [*c]const ufbx_matrix) void;
pub extern fn ufbx_ffi_get_blend_shape_vertex_offset(retval: [*c]ufbx_vec3, shape: [*c]const ufbx_blend_shape, vertex: usize) void;
pub extern fn ufbx_ffi_get_blend_vertex_offset(retval: [*c]ufbx_vec3, blend: [*c]const ufbx_blend_deformer, vertex: usize) void;
pub extern fn ufbx_ffi_evaluate_nurbs_curve(retval: [*c]ufbx_curve_point, curve: [*c]const ufbx_nurbs_curve, u: ufbx_real) void;
pub extern fn ufbx_ffi_evaluate_nurbs_surface(retval: [*c]ufbx_surface_point, surface: [*c]const ufbx_nurbs_surface, u: ufbx_real, v: ufbx_real) void;
pub extern fn ufbx_ffi_get_weighted_face_normal(retval: [*c]ufbx_vec3, positions: [*c]const ufbx_vertex_vec3, face: [*c]const ufbx_face) void;
pub extern fn ufbx_ffi_get_triangulate_face_num_indices(face: [*c]const ufbx_face) usize;
pub extern fn ufbx_ffi_triangulate_face(indices: [*c]u32, num_indices: usize, mesh: [*c]const ufbx_mesh, face: [*c]const ufbx_face) u32;
pub extern fn ufbx_ffi_evaluate_baked_vec3(keyframes: [*c]const ufbx_baked_vec3, num_keyframes: usize, time: f64) ufbx_vec3;
pub extern fn ufbx_ffi_evaluate_baked_quat(keyframes: [*c]const ufbx_baked_quat, num_keyframes: usize, time: f64) ufbx_quat;
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):90:9
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):96:9
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):193:9
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // (no file):215:9
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):223:9
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`"); // (no file):353:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`"); // (no file):354:9
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`"); // /usr/include/features.h:188:9
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`"); // /usr/include/sys/cdefs.h:45:10
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`"); // /usr/include/sys/cdefs.h:55:10
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`"); // /usr/include/sys/cdefs.h:102:11
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'"); // /usr/include/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token '#'"); // /usr/include/sys/cdefs.h:132:9
pub const __warnattr = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:216:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/sys/cdefs.h:217:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['"); // /usr/include/sys/cdefs.h:225:10
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/sys/cdefs.h:256:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/sys/cdefs.h:263:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/sys/cdefs.h:265:11
pub const __ASMNAME = @compileError("unable to translate C expr: unexpected token ','"); // /usr/include/sys/cdefs.h:268:10
pub const __ASMNAME2 = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // /usr/include/sys/cdefs.h:269:10
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`"); // /usr/include/sys/cdefs.h:298:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:309:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`"); // /usr/include/sys/cdefs.h:315:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`"); // /usr/include/sys/cdefs.h:325:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // /usr/include/sys/cdefs.h:332:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`"); // /usr/include/sys/cdefs.h:338:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`"); // /usr/include/sys/cdefs.h:347:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`"); // /usr/include/sys/cdefs.h:348:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/sys/cdefs.h:356:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/sys/cdefs.h:366:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`"); // /usr/include/sys/cdefs.h:379:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`"); // /usr/include/sys/cdefs.h:389:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`"); // /usr/include/sys/cdefs.h:401:11
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`"); // /usr/include/sys/cdefs.h:414:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`"); // /usr/include/sys/cdefs.h:423:10
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`"); // /usr/include/sys/cdefs.h:441:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`"); // /usr/include/sys/cdefs.h:450:10
pub const __extern_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`"); // /usr/include/sys/cdefs.h:468:11
pub const __extern_always_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`"); // /usr/include/sys/cdefs.h:469:11
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'"); // /usr/include/sys/cdefs.h:512:10
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:561:10
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:638:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:639:10
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`"); // /usr/include/sys/cdefs.h:653:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`"); // /usr/include/sys/cdefs.h:654:10
pub const __fortified_attr_access = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:699:11
pub const __attr_access = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:700:11
pub const __attr_access_none = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:701:11
pub const __attr_dealloc = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/sys/cdefs.h:711:10
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`"); // /usr/include/sys/cdefs.h:718:10
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token 'typedef'"); // /usr/include/bits/types.h:137:10
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`"); // /usr/include/bits/typesizes.h:73:9
pub const offsetof = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // /home/ali/clone/zig/lib/include/stddef.h:116:9
pub const ufbx_inline = @compileError("unable to translate macro: undefined identifier `always_inline`"); // zig-out/include/ubfx.h:92:10
pub const __ASSERT_VOID_CAST = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/assert.h:40:10
pub const assert = @compileError("unable to translate macro: undefined identifier `__FILE__`"); // /usr/include/assert.h:115:11
pub const __ASSERT_FUNCTION = @compileError("unable to translate C expr: unexpected token '__extension__'"); // /usr/include/assert.h:137:12
pub const static_assert = @compileError("unable to translate C expr: unexpected token '_Static_assert'"); // /usr/include/assert.h:155:10
pub const UFBX_CONVERSION_IMPL = @compileError("unable to translate C expr: unexpected token ''"); // zig-out/include/ubfx.h:161:9
pub const UFBX_CONVERSION_TO_IMPL = @compileError("unable to translate C expr: unexpected token ''"); // zig-out/include/ubfx.h:162:9
pub const UFBX_CONVERSION_LIST_IMPL = @compileError("unable to translate C expr: unexpected token ''"); // zig-out/include/ubfx.h:163:9
pub const UFBX_LIST_TYPE = @compileError("unable to translate macro: untranslatable usage of arg `p_name`"); // zig-out/include/ubfx.h:175:10
pub const UFBX_ENUM_FORCE_WIDTH = @compileError("unable to translate macro: undefined identifier `_FORCE_32BIT`"); // zig-out/include/ubfx.h:189:10
pub const UFBX_FLAG_FORCE_WIDTH = @compileError("unable to translate macro: undefined identifier `_FORCE_32BIT`"); // zig-out/include/ubfx.h:191:10
pub const UFBX_ENUM_TYPE = @compileError("unable to translate macro: undefined identifier `_COUNT`"); // zig-out/include/ubfx.h:195:9
pub const UFBX_VERTEX_ATTRIB_IMPL = @compileError("unable to translate C expr: unexpected token ''"); // zig-out/include/ubfx.h:202:10
pub const UFBX_CALLBACK_IMPL = @compileError("unable to translate C expr: unexpected token ''"); // zig-out/include/ubfx.h:212:10
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 17);
pub const __clang_minor__ = @as(c_int, 0);
pub const __clang_patchlevel__ = @as(c_int, 6);
pub const __clang_version__ = "17.0.6 (https://github.com/ziglang/zig-bootstrap fb6231bb12648dc4a54a8afcd16eeebd6657ff4a)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 17.0.6 (https://github.com/ziglang/zig-bootstrap fb6231bb12648dc4a54a8afcd16eeebd6657ff4a)";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __SSP_STRONG__ = @as(c_int, 2);
pub const __ELF__ = @as(c_int, 1);
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __k8 = @as(c_int, 1);
pub const __k8__ = @as(c_int, 1);
pub const __tune_k8__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __VAES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __VPCLMULQDQ__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __GFNI__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __PKU__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __SHSTK__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __WAITPKG__ = @as(c_int, 1);
pub const __MOVDIRI__ = @as(c_int, 1);
pub const __MOVDIR64B__ = @as(c_int, 1);
pub const __PTWRITE__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const __GLIBC_MINOR__ = @as(c_int, 38);
pub const _DEBUG = @as(c_int, 1);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const UFBX_UFBX_H_INCLUDED = "";
pub const __CLANG_STDINT_H = "";
pub const _STDINT_H = @as(c_int, 1);
pub const __GLIBC_INTERNAL_STARTING_HEADER_IMPLEMENTATION = "";
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2X = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C2X_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__has_builtin(name)) {
    _ = &name;
    return __has_builtin(name);
}
pub const __LEAF = "";
pub const __LEAF_ATTR = "";
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin_object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __wur = "";
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub const __attr_dealloc_free = "";
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _BITS_WCHAR_H = @as(c_int, 1);
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __WCHAR_MIN = -__WCHAR_MAX - @as(c_int, 1);
pub const _BITS_STDINT_INTN_H = @as(c_int, 1);
pub const _BITS_STDINT_UINTN_H = @as(c_int, 1);
pub const __intptr_t_defined = "";
pub const __INT64_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __UINT64_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_LEAST8_MIN = -@as(c_int, 128);
pub const INT_LEAST16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT_LEAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT_LEAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_LEAST8_MAX = @as(c_int, 127);
pub const INT_LEAST16_MAX = @as(c_int, 32767);
pub const INT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_LEAST8_MAX = @as(c_int, 255);
pub const UINT_LEAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_FAST8_MIN = -@as(c_int, 128);
pub const INT_FAST16_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_FAST8_MAX = @as(c_int, 127);
pub const INT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_FAST8_MAX = @as(c_int, 255);
pub const UINT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INTPTR_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const UINTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const INTMAX_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INTMAX_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINTMAX_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const PTRDIFF_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const PTRDIFF_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const SIG_ATOMIC_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const SIG_ATOMIC_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SIZE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const WCHAR_MIN = __WCHAR_MIN;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const INT64_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const UINT32_C = @import("std").zig.c_translation.Macros.U_SUFFIX;
pub const UINT64_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const INTMAX_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const UINTMAX_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const __STDDEF_H = "";
pub const __need_ptrdiff_t = "";
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const __need_STDDEF_H_misc = "";
pub const _PTRDIFF_T = "";
pub const _SIZE_T = "";
pub const _WCHAR_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __CLANG_MAX_ALIGN_T_DEFINED = "";
pub const __STDBOOL_H = "";
pub const __bool_true_false_are_defined = @as(c_int, 1);
pub const @"bool" = bool;
pub const @"true" = @as(c_int, 1);
pub const @"false" = @as(c_int, 0);
pub const _STRING_H = @as(c_int, 1);
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const _STRINGS_H = @as(c_int, 1);
pub const UFBX_STDC = __STDC_VERSION__;
pub const UFBX_CPP = @as(c_int, 0);
pub const UFBX_PLATFORM_MSC = @as(c_int, 0);
pub const UFBX_PLATFORM_GNUC = __GNUC__;
pub const UFBX_CPP11 = @as(c_int, 0);
pub const _ASSERT_H = @as(c_int, 1);
pub inline fn ufbx_assert(cond: anytype) @TypeOf(assert(cond)) {
    _ = &cond;
    return assert(cond);
}
pub const ufbx_nullable = "";
pub const ufbx_unsafe = "";
pub const ufbx_abi = "";
pub const UFBX_ERROR_STACK_MAX_DEPTH = @as(c_int, 8);
pub const UFBX_PANIC_MESSAGE_LENGTH = @as(c_int, 128);
pub const UFBX_ERROR_INFO_LENGTH = @as(c_int, 256);
pub const UFBX_THREAD_GROUP_COUNT = @as(c_int, 4);
pub const UFBX_ENUM_REPR = "";
pub const UFBX_FLAG_REPR = "";
pub const UFBX_HAS_FORCE_32BIT = @as(c_int, 1);
pub inline fn ufbx_pack_version(major: anytype, minor: anytype, patch: anytype) @TypeOf(((@import("std").zig.c_translation.cast(u32, major) * @import("std").zig.c_translation.promoteIntLiteral(c_uint, 1000000, .decimal)) + (@import("std").zig.c_translation.cast(u32, minor) * @as(c_uint, 1000))) + @import("std").zig.c_translation.cast(u32, patch)) {
    _ = &major;
    _ = &minor;
    _ = &patch;
    return ((@import("std").zig.c_translation.cast(u32, major) * @import("std").zig.c_translation.promoteIntLiteral(c_uint, 1000000, .decimal)) + (@import("std").zig.c_translation.cast(u32, minor) * @as(c_uint, 1000))) + @import("std").zig.c_translation.cast(u32, patch);
}
pub inline fn ufbx_version_major(version: anytype) @TypeOf(@import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.MacroArithmetic.div(@import("std").zig.c_translation.cast(u32, version), @import("std").zig.c_translation.promoteIntLiteral(c_uint, 1000000, .decimal)), @as(c_uint, 1000))) {
    _ = &version;
    return @import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.MacroArithmetic.div(@import("std").zig.c_translation.cast(u32, version), @import("std").zig.c_translation.promoteIntLiteral(c_uint, 1000000, .decimal)), @as(c_uint, 1000));
}
pub inline fn ufbx_version_minor(version: anytype) @TypeOf(@import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.MacroArithmetic.div(@import("std").zig.c_translation.cast(u32, version), @as(c_uint, 1000)), @as(c_uint, 1000))) {
    _ = &version;
    return @import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.MacroArithmetic.div(@import("std").zig.c_translation.cast(u32, version), @as(c_uint, 1000)), @as(c_uint, 1000));
}
pub inline fn ufbx_version_patch(version: anytype) @TypeOf(@import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.cast(u32, version), @as(c_uint, 1000))) {
    _ = &version;
    return @import("std").zig.c_translation.MacroArithmetic.rem(@import("std").zig.c_translation.cast(u32, version), @as(c_uint, 1000));
}
pub const UFBX_HEADER_VERSION = ufbx_pack_version(@as(c_int, 0), @as(c_int, 10), @as(c_int, 0));
pub const UFBX_VERSION = UFBX_HEADER_VERSION;
pub const UFBX_NO_INDEX = @import("std").zig.c_translation.cast(u32, ~@as(c_uint, 0));
pub const UFBX_Lcl_Translation = "Lcl Translation";
pub const UFBX_Lcl_Rotation = "Lcl Rotation";
pub const UFBX_Lcl_Scaling = "Lcl Scaling";
pub const UFBX_RotationOrder = "RotationOrder";
pub const UFBX_ScalingPivot = "ScalingPivot";
pub const UFBX_RotationPivot = "RotationPivot";
pub const UFBX_ScalingOffset = "ScalingOffset";
pub const UFBX_RotationOffset = "RotationOffset";
pub const UFBX_PreRotation = "PreRotation";
pub const UFBX_PostRotation = "PostRotation";
pub const UFBX_Visibility = "Visibility";
pub const UFBX_Weight = "Weight";
pub const UFBX_DeformPercent = "DeformPercent";
pub const __locale_struct = struct___locale_struct;
