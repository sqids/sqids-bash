#!/usr/bin/env bats

source ./src/sqids

@test "test_ord" {
    ord "a"
    [[ "$retval" = 97 ]]

    ord "A"
    [[ "$retval" = 65 ]]

    ord "1"
    [[ "$retval" = 49 ]]
}

@test "test_splitstr" {
    splitstr "abcde"
    [[ "$retval" = "a b c d e" ]]

    splitstr "ab"
    [[ "$retval" = "a b" ]]

    splitstr "a"
    [[ "$retval" = "a" ]]
}

@test "test_joinchars" {
    joinchars "" "a" "b" "c" "d" "e"
    [[ "$retval" = "abcde" ]]

    joinchars "" "a" "b"
    [[ "$retval" = "ab" ]]

    joinchars "" "a"
    [[ "$retval" = "a" ]]

    joinchars "," "a" "b" "c" "d" "e"
    [[ "$retval" = "a,b,c,d,e" ]]

    joinchars "," "a" "b"
    [[ "$retval" = "a,b" ]]

    joinchars "," "a"
    [[ "$retval" = "a" ]]
}

@test "test_lower" {
    lower "ABC"
    [[ "$retval" = "abc" ]]

    lower "AbC"
    [[ "$retval" = "abc" ]]

    lower "abc"
    [[ "$retval" = "abc" ]]
}

@test "test_shuffle" {
    shuffle "abcdefg"
    [[ "$retval" = "bcefgad" ]]

    shuffle "cd"
    [[ "$retval" = "dc" ]]

    shuffle "a"
    [[ "$retval" = "a" ]]
}

@test "test_to_id" {
    to_id 4 "abcde"
    [[ "$retval" = "e" ]]

    to_id 10 "abcde"
    [[ "$retval" = "ca" ]]

    to_id 99999 "abcdefghijklmnopqrstuvwxyz"
    [[ "$retval" = "fryd" ]]
}

@test "test_to_number" {
    to_number "abc" "abcdefghijklmnopqrstuvwxyz"
    [[ "$retval" = 28 ]]

    to_number "cba" "abcdefghijklmnopqrstuvwxyz"
    [[ "$retval" = 1378 ]]

    to_number "a" "abcdefghijklmnopqrstuvwxyz"
    [[ "$retval" = 0 ]]
}

@test "test_is_blocked_id" {
    is_blocked_id "word1 word2 word3" "word2"
    [[ "$retval" = true ]]

    is_blocked_id "word1 word2 word3" "word4"
    [[ "$retval" = false ]]

    is_blocked_id "word1" "word1"
    [[ "$retval" = true ]]

    is_blocked_id "word1" "word2"
    [[ "$retval" = false ]]

    is_blocked_id "" "word1"
    [[ "$retval" = false ]]
}
