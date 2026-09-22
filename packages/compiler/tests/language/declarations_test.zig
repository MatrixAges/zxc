const h = @import("../helpers.zig");

test "declarations negative: empty enum" {
    try h.analyzeCase("export enum Mode {}", .type_mismatch);
}

test "declarations negative: duplicate enum member" {
    try h.analyzeCase("export enum Mode { Ready, Ready }", .name);
}

test "declarations negative: duplicate object type field" {
    try h.analyzeCase("export type State = { value: u64; value: bool; };", .name);
}

test "declarations negative: void object field" {
    try h.analyzeCase("export type State = { value: void; };", .type_mismatch);
}

test "declarations negative: void list element" {
    try h.analyzeCase("export type Values = void[];", .type_mismatch);
}

test "declarations negative: unknown type" {
    try h.analyzeCase("export type Value = Missing;", .name);
}

test "declarations negative: duplicate alias" {
    try h.analyzeCase("export type Value = u64; export type Value = bool;", .name);
}

test "declarations negative: distinct enum identities" {
    try h.analyzeCase("export enum First { Ready } export enum Second { Ready } export type Input = First; export type Output = Second; export default function (in: Input): Output { return in; }", .type_mismatch);
}
