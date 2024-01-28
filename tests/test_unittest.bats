#!/usr/bin/env bats

source ./src/sqids

@test "test_ord" {
    ord "a"
    [[ "$__RETURN" = 97 ]]

    ord "A"
    [[ "$__RETURN" = 65 ]]

    ord "1"
    [[ "$__RETURN" = 49 ]]
}

@test "test_splitstr" {
    splitstr "abcde"
    [[ "$__RETURN" = "a b c d e" ]]

    splitstr "ab"
    [[ "$__RETURN" = "a b" ]]

    splitstr "a"
    [[ "$__RETURN" = "a" ]]
}

@test "test_joinchars" {
    joinchars "" "a" "b" "c" "d" "e"
    [[ "$__RETURN" = "abcde" ]]

    joinchars "" "a" "b"
    [[ "$__RETURN" = "ab" ]]

    joinchars "" "a"
    [[ "$__RETURN" = "a" ]]

    joinchars "," "a" "b" "c" "d" "e"
    [[ "$__RETURN" = "a,b,c,d,e" ]]

    joinchars "," "a" "b"
    [[ "$__RETURN" = "a,b" ]]

    joinchars "," "a"
    [[ "$__RETURN" = "a" ]]
}

@test "test_lower" {
    lower "ABC"
    [[ "$__RETURN" = "abc" ]]

    lower "AbC"
    [[ "$__RETURN" = "abc" ]]

    lower "abc"
    [[ "$__RETURN" = "abc" ]]
}

@test "test_shuffle" {
    shuffle "abcdefg"
    [[ "$__RETURN" = "bcefgad" ]]

    shuffle "cd"
    [[ "$__RETURN" = "dc" ]]

    shuffle "a"
    [[ "$__RETURN" = "a" ]]
}

@test "test_to_id" {
    to_id 4 "abcde"
    [[ "$__RETURN" = "e" ]]

    to_id 10 "abcde"
    [[ "$__RETURN" = "ca" ]]

    to_id 99999 "abcdefghijklmnopqrstuvwxyz"
    [[ "$__RETURN" = "fryd" ]]
}

@test "test_to_number" {
    to_number "abc" "abcdefghijklmnopqrstuvwxyz"
    [[ "$__RETURN" = 28 ]]

    to_number "cba" "abcdefghijklmnopqrstuvwxyz"
    [[ "$__RETURN" = 1378 ]]

    to_number "a" "abcdefghijklmnopqrstuvwxyz"
    [[ "$__RETURN" = 0 ]]
}

@test "test_is_blocked_id" {
    is_blocked_id "word1 word2 word3" "word2"
    [[ "$__RETURN" = true ]]

    is_blocked_id "word1 word2 word3" "word4"
    [[ "$__RETURN" = false ]]

    is_blocked_id "word1" "word1"
    [[ "$__RETURN" = true ]]

    is_blocked_id "word1" "word2"
    [[ "$__RETURN" = false ]]

    is_blocked_id "" "word1"
    [[ "$__RETURN" = false ]]
}
