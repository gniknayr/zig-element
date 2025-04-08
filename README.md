
I wrote this to better understand comptime and Zig's type system

Uses Zig's comptime to generate semi-static XML-style templates from zig syntax.

Fields that are de-referenced are used to indicate a @field from the passed data struct.

All other bytes are concatenated at comptime to minimize @memcopy calls when formatting output

Nested templates are compiled and formatted separately.

```
const template = ht.Hypertext(.{
    ht.Head(.{
        ht.Title("page_title".*),
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

// Nested template
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

```

Will output 

```
<html><head><title>this can be runtime</title></head><style>html>body{background-color:#222222;color:#ffffff;}</style><body><header><nav><a href="#home">home</a></nav></header><main><section><p>hello</p></section></main><footer><nav><a href="#home">home</a></nav><p>&copy; 2025</p></footer></body></html>
```

TODO:
    Refactor as library