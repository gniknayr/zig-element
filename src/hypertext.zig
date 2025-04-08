const std = @import("std");

const Element = @import("element.zig").Element;

pub fn Hypertext(tags: anytype) type {
    return Element("html", .{}, .{}, tags);
}
pub fn Head(tags: anytype) type {
    return Element("head", .{}, .{}, tags);
}
pub fn Base(tags: anytype) type {
    return Element("base", .{}, .{}, tags);
}
pub fn Title(tags: anytype) type {
    return Element("title", .{}, .{}, tags);
}
pub fn Link(tags: anytype) type {
    return Element("link", .{}, .{}, tags);
}
pub fn Meta(tags: anytype) type {
    return Element("meta", .{}, .{}, tags);
}
pub fn Style(tags: anytype) type {
    return Element("style", .{}, .{}, tags);
}
pub fn Body(tags: anytype) type {
    return Element("body", .{}, .{}, tags);
}

//
pub fn Form(tags: anytype) type {
    return Element("form", .{}, .{}, tags);
}
pub fn Input(tags: anytype) type {
    return Element("input", .{}, .{}, tags);
}
pub fn Button(tags: anytype) type {
    return Element("button", .{}, .{}, tags);
}
pub fn Address(tags: anytype) type {
    return Element("address", .{}, .{}, tags);
}
pub fn Search(tags: anytype) type {
    return Element("search", .{}, .{}, tags);
}
pub fn Datalist(tags: anytype) type {
    return Element("datalist", .{}, .{}, tags);
}
pub fn Fieldset(tags: anytype) type {
    return Element("fieldset", .{}, .{}, tags);
}
pub fn Label(tags: anytype) type {
    return Element("label", .{}, .{}, tags);
}
pub fn Legend(tags: anytype) type {
    return Element("legend", .{}, .{}, tags);
}
pub fn Meter(tags: anytype) type {
    return Element("meter", .{}, .{}, tags);
}
pub fn Option(tags: anytype) type {
    return Element("option", .{}, .{}, tags);
}
pub fn Output(tags: anytype) type {
    return Element("output", .{}, .{}, tags);
}
pub fn Progress(tags: anytype) type {
    return Element("progress", .{}, .{}, tags);
}
pub fn Select(tags: anytype) type {
    return Element("select", .{}, .{}, tags);
}
pub fn Textarea(tags: anytype) type {
    return Element("textarea", .{}, .{}, tags);
}

/// Keyboard input
pub fn Kbd(tags: anytype) type {
    return Element("kbd", .{}, .{}, tags);
}
pub fn Keyboard(tags: anytype) type {
    return Element("kbd", .{}, .{}, tags);
}

pub fn Optgroup(tags: anytype) type {
    return Element("optgroup", .{}, .{}, tags);
}
pub fn Hgroup(tags: anytype) type {
    return Element("hgroup", .{}, .{}, tags);
}

pub fn Details(tags: anytype) type {
    return Element("details", .{}, .{}, tags);
}
pub fn Dialog(tags: anytype) type {
    return Element("dialog", .{}, .{}, tags);
}
pub fn Summary(tags: anytype) type {
    return Element("summary", .{}, .{}, tags);
}

pub fn Figure(tags: anytype) type {
    return Element("figure", .{}, .{}, tags);
}
pub fn Figcap(tags: anytype) type {
    return Element("figcaption", .{}, .{}, tags);
}
/// horizontal rule
pub fn Hr(tags: anytype) type {
    return Element("hr", .{}, .{}, tags);
}
/// break
pub fn Br(tags: anytype) type {
    return Element("br", .{}, .{}, tags);
}
/// description list
pub fn Dl(tags: anytype) type {
    return Element("dl", .{}, .{}, tags);
}
/// description term
pub fn Dt(tags: anytype) type {
    return Element("dt", .{}, .{}, tags);
}
/// description definition
pub fn Dd(tags: anytype) type {
    return Element("dd", .{}, .{}, tags);
}
/// defined: nearest context [ dt/dd | section > p ]
pub fn dfn(tags: anytype) type {
    return Element("dd", .{}, .{}, tags);
}
/// ordered list
pub fn Ol(tags: anytype) type {
    return Element("ol", .{}, .{}, tags);
}
/// unordered list
pub fn Ul(tags: anytype) type {
    return Element("ul", .{}, .{}, tags);
}
/// list item
pub fn Li(tags: anytype) type {
    return Element("li", .{}, .{}, tags);
}
/// sample
pub fn Samp(tags: anytype) type {
    return Element("samp", .{}, .{}, tags);
}
pub fn Data(tags: anytype) type {
    return Element("data", .{}, .{}, tags);
}
pub fn Code(tags: anytype) type {
    return Element("code", .{}, .{}, tags);
}
pub fn Blockquote(tags: anytype) type {
    return Element("blockquote", .{}, .{}, tags);
}
/// abbreviation
pub fn Abbr(tags: anytype) type {
    return Element("abbr", .{}, .{}, tags);
}
pub fn Pre(tags: anytype) type {
    return Element("pre", .{}, .{}, tags);
}

pub fn Section(tags: anytype) type {
    return Element("section", .{}, .{}, tags);
}
/// header
pub fn H1(tags: anytype) type {
    return Element("h1", .{}, .{}, tags);
}
pub fn H2(tags: anytype) type {
    return Element("h2", .{}, .{}, tags);
}
pub fn H3(tags: anytype) type {
    return Element("h3", .{}, .{}, tags);
}
pub fn H4(tags: anytype) type {
    return Element("h4", .{}, .{}, tags);
}
pub fn H5(tags: anytype) type {
    return Element("h5", .{}, .{}, tags);
}
pub fn H6(tags: anytype) type {
    return Element("h6", .{}, .{}, tags);
}
pub fn Aside(tags: anytype) type {
    return Element("aside", .{}, .{}, tags);
}
pub fn Article(tags: anytype) type {
    return Element("article", .{}, .{}, tags);
}
pub fn Span(tags: anytype) type {
    return Element("span", .{}, .{}, tags);
}
pub fn Nav(tags: anytype) type {
    return Element("nav", .{}, .{}, tags);
}
pub fn Footer(tags: anytype) type {
    return Element("footer", .{}, .{}, tags);
}
pub fn Header(tags: anytype) type {
    return Element("header", .{}, .{}, tags);
}
pub fn Main(tags: anytype) type {
    return Element("main", .{}, .{}, tags);
}

pub fn Table(tags: anytype) type {
    return Element("table", .{}, .{}, tags);
}
/// table caption
pub fn Caption(tags: anytype) type {
    return Element("caption", .{}, .{}, tags);
}
pub fn Thead(tags: anytype) type {
    return Element("thead", .{}, .{}, tags);
}
pub fn Tbody(tags: anytype) type {
    return Element("tbody", .{}, .{}, tags);
}
pub fn Tfoot(tags: anytype) type {
    return Element("tfoot", .{}, .{}, tags);
}
/// table row
pub fn Tr(tags: anytype) type {
    return Element("tr", .{}, .{}, tags);
}
/// table row
pub fn Row(tags: anytype) type {
    return Element("tr", .{}, .{}, tags);
}
/// table data cell
pub fn Td(tags: anytype) type {
    return Element("td", .{}, .{}, tags);
}
/// table cell
pub fn Cell(tags: anytype) type {
    return Element("td", .{}, .{}, tags);
}
/// table column
pub fn Col(tags: anytype) type {
    return Element("col", .{}, .{}, tags);
}

/// paragraph
pub fn P(tags: anytype) type {
    return Element("p", .{}, .{}, tags);
}
/// quotation
pub fn Q(tags: anytype) type {
    return Element("q", .{}, .{}, tags);
}
/// anchor
pub fn A(tags: anytype) type {
    return Element("a", .{}, .{}, tags);
}
/// bold
pub fn B(tags: anytype) type {
    return Element("b", .{}, .{}, tags);
}
/// idiomatic / italicized
pub fn I(tags: anytype) type {
    return Element("i", .{}, .{}, tags);
}
/// underscore
pub fn U(tags: anytype) type {
    return Element("u", .{}, .{}, tags);
}
/// strikethrough
pub fn S(tags: anytype) type {
    return Element("s", .{}, .{}, tags);
}
pub fn Small(tags: anytype) type {
    return Element("small", .{}, .{}, tags);
}
pub fn Strong(tags: anytype) type {
    return Element("strong", .{}, .{}, tags);
}
/// superscript
pub fn Sup(tags: anytype) type {
    return Element("sup", .{}, .{}, tags);
}
/// subscript
pub fn Sub(tags: anytype) type {
    return Element("sub", .{}, .{}, tags);
}
/// variable
pub fn Var(tags: anytype) type {
    return Element("var", .{}, .{}, tags);
}
/// word wrap
pub fn Wbr(tags: anytype) type {
    return Element("wbr", .{}, .{}, tags);
}
/// word wrap
pub fn Wrap(tags: anytype) type {
    return Element("wbr", .{}, .{}, tags);
}
/// emphasis: nestable
pub fn Em(tags: anytype) type {
    return Element("em", .{}, .{}, tags);
}
/// bidirectional insert
pub fn Bdi(tags: anytype) type {
    return Element("bdi", .{}, .{}, tags);
}
/// bidirectional override
pub fn Bdo(tags: anytype) type {
    return Element("bdo", .{}, .{}, tags);
}
/// citation
pub fn Cite(tags: anytype) type {
    return Element("cite", .{}, .{}, tags);
}
pub fn Mark(tags: anytype) type {
    return Element("mark", .{}, .{}, tags);
}

pub fn Slot(tags: anytype) type {
    return Element("slot", .{}, .{}, tags);
}
pub fn Template(tags: anytype) type {
    return Element("template", .{}, .{}, tags);
}
