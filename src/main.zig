const std = @import("std");

const ht = @import("hypertext.zig");

pub fn main() !void {
    const template = ht.Hypertext(.{
        ht.Head(.{
            ht.Title("page_title".*),
            // ht.Style(":root{}"),
        }),
        ht.Body(.{
            ht.Header(.{
                "page_nav".*,
            }),
            ht.Main(.{
                ht.Section(.{
                    ht.P("hello"),
                }),
            }),
            ht.Footer(.{
                "page_nav".*,
                ht.P("&copy; 2025"),
            }),
        }).Style(.{
            .@"background-color" = "#222222",
            .color = "#ffffff",
        }),
    });

    const nav = ht.Nav(.{
        ht.A("home").Attr(.{
            .href = "#home",
        }),
    });

    var buf: [4096]u8 = undefined;

    const data = struct {
        page_title: []const u8 = "Hello World!",
        page_nav: type = nav,
    };

    const bytes = template.root(&buf, data{
        .page_title = "this can be runtime",
    });

    std.log.debug("{s}", .{buf[0..bytes]});
}
