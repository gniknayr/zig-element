const std = @import("std");

/// holds a tree-style location state for stylesheet and formatting
pub const Branch = struct {
    bread: []const u8,
    child: usize,
    depth: usize,
    pub const empty: Branch = .{
        .bread = "",
        .child = 0,
        .depth = 0,
    };
    /// bread: body>main>article>header>h1
    /// child*: :nth-child(0..)
    /// depth*: 0:<a>1:<b>2:<c>3</c></b></a>
    /// TODO (gniknayr): * = unimplemented;
    pub fn init(comptime bread: []const u8, comptime child: usize, comptime depth: usize) Branch {
        return .{
            .bread = bread,
            .child = child,
            .depth = depth,
        };
    }
    inline fn next(this: Branch, comptime crumb: []const u8, comptime child: comptime_int) Branch {
        const crumbs = if (this.bread.len > 0) this.bread ++ ">" ++ crumb else crumb;
        return init(crumbs, child, this.depth + 1);
    }
};

/// either a length of bytes to read; or the name of the field to look up
pub const Block = union(enum) {
    unused: void,
    block: comptime_int,
    field: struct {
        name: []const u8,
        branch: Branch,
    },

    pub fn add(this: *Block, length: comptime_int) void {
        switch (this.*) {
            .unused => {
                this.* = .{
                    .block = length,
                };
            },
            .block => {
                this.block += length;
            },
            .field => @compileError("cannot add to field"),
        }
    }
    pub fn len(this: *Block) ?comptime_int {
        return switch (this.*) {
            .unused => null,
            .block => |blk| blk,
            .field => null,
        };
    }
};

fn structFields(comptime unk: anytype) []const std.builtin.Type.StructField {
    const Type = @TypeOf(unk);
    return switch (@typeInfo(Type)) {
        .@"struct" => |type_struct| type_struct.fields,
        .pointer => |ptr_struct| &[1]std.builtin.Type.StructField{
            .{
                .name = "pointer",
                .type = Type,
                .alignment = ptr_struct.alignment,
                .default_value_ptr = @ptrCast(&unk),
                .is_comptime = false,
            },
        },
        .array => &[1]std.builtin.Type.StructField{
            .{
                .name = "+template",
                .type = Type,
                .alignment = @alignOf(Type),
                .default_value_ptr = @ptrCast(&unk),
                .is_comptime = false,
            },
        },
        else => |T| @compileError(@tagName(T)), // unreachable
    };
}

pub fn Element(comptime tag_name: []const u8, comptime attr: anytype, style: anytype, comptime tags: anytype) type {
    return struct {
        const This = @This();

        pub const tag = tag_name;

        pub const stylesheet = structFields(style);
        pub const attributes = structFields(attr);
        pub const elements = structFields(tags);

        pub const singleton = if (elements.len == 0) true else false;

        /// count number of dynamic elements
        pub const counts = field_count: {
            var dynamic_count: comptime_int = 0;

            for (attributes) |field| {
                // if (field.defaultValue()) |_| {
                switch (@typeInfo(field.type)) {
                    .pointer => {},
                    .array => dynamic_count += 1,
                    else => |T| {
                        @compileLog(field.name);
                        @compileLog(T);
                    }, // unreachable
                }
                // }
            }

            for (elements) |field| {
                if (field.defaultValue()) |element| {
                    switch (@typeInfo(@TypeOf(element))) {
                        .type => {
                            if (@hasDecl(element, "dynamic")) {
                                dynamic_count += element.dynamic;
                            }
                        },
                        .pointer => {
                            switch (field.name[0]) {
                                'p' => dynamic_count += 1,
                                else => {},
                            }
                        },
                        .array => dynamic_count += 1,
                        else => |T| {
                            @compileLog(field.name);
                            @compileLog(T);
                        }, // unreachable
                    }
                } else {
                    @compileLog(field);
                }
            }
            break :field_count .{
                .dynamic = dynamic_count,
            };
        };
        pub const dynamic = counts.dynamic;

        /// (dynamic * 2 + 1) is the maxium number of blocks needed
        // worse case: {static} {field} {static} {field} {static} = 2 * 2 + 1
        pub const block_length = (dynamic << 1) | 1;

        ///
        pub const dom = build(Branch.init(tag_name, 0, 0));

        inline fn copy(buf: []u8, data: []const u8) void {
            std.debug.assert(data.len <= buf.len);
            @memcpy(buf[0..data.len], data[0..data.len]);
        }

        /// write compiled template into provided buffer
        pub fn root(buf: []u8, data: anytype) usize {
            return format(buf[0..], dom, data);
        }

        pub const Model = struct {
            blocks: [block_length]Block,
            inner: []const u8,
        };

        /// write compiled template into provided buffer
        /// format this element's template by calling root()
        pub fn format(buf: []u8, model: Model, data: anytype) usize {
            var buffer_offset: usize = 0;
            comptime var inner_offset: comptime_int = 0;
            inline for (model.blocks) |blk| {
                switch (blk) {
                    .unused => break,
                    .field => |template| {
                        const field = @field(data, template.name);
                        switch (@typeInfo(@TypeOf(field))) {
                            // field is []const u8
                            .pointer => {
                                copy(buf[buffer_offset..], field);
                                buffer_offset += field.len;
                            },
                            // tuple of elements
                            .@"struct" => |type_struct| {
                                inline for (type_struct.fields) |inner_field| {
                                    if (inner_field.defaultValue()) |element| {
                                        const inner_tpl = element.build(template.branch);
                                        const add = element.format(buf[buffer_offset..], inner_tpl, data);
                                        buffer_offset += add;
                                    } else {
                                        @compileLog(inner_field); // unreachable
                                    }
                                }
                            },
                            // single element
                            .type => {
                                const inner_tpl = field.build(template.branch);
                                const add = field.format(buf[buffer_offset..], inner_tpl, data);
                                buffer_offset += add;
                            },
                            else => |T| {
                                @compileLog(template.name);
                                @compileLog(T);
                            }, // unreachable
                        }
                    },
                    .block => |len| {
                        copy(buf[buffer_offset..], model.inner[inner_offset..][0..len]);
                        buffer_offset += len;
                        inner_offset += len;
                    },
                }
            }
            return buffer_offset;
        }

        /// adds inline style element
        pub fn Style(styles: anytype) type {
            return Element(tag_name, attr, styles, tags);
        }

        /// add tag attributes
        pub fn Attr(attrs: anytype) type {
            return Element(tag_name, attrs, style, tags);
        }

        /// internal
        /// passthrough bytes if condition is true (write if)
        inline fn wif(condition: bool, bytes: []const u8) []const u8 {
            return if (condition) bytes else "";
        }

        /// internal
        /// "compiles" slices known at comptime
        pub fn build(comptime tree: Branch) Model {
            const open = "<" ++ tag_name;
            const start = wif(singleton, " /") ++ ">";
            const close = wif(!singleton, "</" ++ tag_name ++ ">");

            comptime var blocks: [block_length]Block = [_]Block{.{ .unused = void{} }} ** block_length;
            comptime var block: comptime_int = 0;

            comptime var literal: []const u8 = "";
            if (stylesheet.len > 0) {
                {
                    const string = "<style>" ++ tree.bread ++ "{";
                    literal = literal ++ string;
                    blocks[block].add(string.len);
                }
                inline for (stylesheet) |field| {
                    const style_name = field.name ++ ":";
                    literal = literal ++ style_name;
                    blocks[block].add(style_name.len);
                    if (field.defaultValue()) |css| {
                        const string = css ++ ";";
                        literal = literal ++ string;
                        blocks[block].add(string.len);
                    }
                }
                {
                    const string = "}</style>";
                    literal = literal ++ string;
                    blocks[block].add(string.len);
                }
            }

            literal = literal ++ open;
            blocks[block].add(open.len);

            inline for (attributes) |field| {
                if (field.defaultValue()) |attribute| {
                    switch (@typeInfo(field.type)) {
                        .pointer => {
                            const attrstr = std.fmt.comptimePrint(" {s}=\"{s}\"", .{ field.name, attribute });
                            literal = literal ++ attrstr;
                            blocks[block].add(attrstr.len);
                        },
                        .array => {
                            const first = " " ++ field.name ++ "=\"";
                            literal = literal ++ first;
                            blocks[block].add(first.len);
                            {
                                block += 1;
                                blocks[block] = .{
                                    .field = .{
                                        .name = attribute[0..],
                                        .branch = tree,
                                    },
                                };
                                defer block += 1;
                            }
                            const last = "\"";
                            literal = literal ++ last;
                            blocks[block].add(last.len);
                        },
                        else => |t| @compileLog(t),
                    }
                }
            }

            literal = literal ++ start;
            blocks[block].add(start.len);

            inline for (elements, 0..) |field, index| {
                if (field.defaultValue()) |element| {
                    switch (@typeInfo(@TypeOf(element))) {
                        .type => {
                            const tpl = element.build(tree.next(element.tag, index));

                            literal = literal ++ tpl.inner;
                            inline for (tpl.blocks) |inner_block| {
                                switch (inner_block) {
                                    .unused => break,
                                    .block => |len| blocks[block].add(len),
                                    .field => {
                                        block += 1;
                                        blocks[block] = inner_block;
                                        defer block += 1;
                                    },
                                }
                            }
                        },
                        .array => {
                            block += 1;
                            blocks[block] = .{
                                .field = .{
                                    .name = element[0..],
                                    .branch = tree,
                                },
                            };
                            defer block += 1;
                        },
                        .pointer => {
                            literal = literal ++ element;
                            blocks[block].add(element.len);
                        },
                        else => |t| @compileLog(t),
                    }
                } else {
                    @compileLog(field);
                }
            }

            literal = literal ++ close;
            blocks[block].add(close.len);

            return .{
                .blocks = blocks,
                .inner = literal,
            };
        }
    };
}
