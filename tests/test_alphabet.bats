#!/usr/bin/env bats

@test "test_simple" {
    alphabet="0123456789abcdef"
    numbers=(1 2 3)
    id="489158"

    run ./src/sqids -a $alphabet -e "${numbers[@]}"
    [ $status -eq 0 ]
    [[ $output == $id ]]

    run ./src/sqids -a $alphabet -d "$id"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_short_alphabet" {
    alphabet="abc"
    numbers=(1 2 3)

    run ./src/sqids -a $alphabet -e "${numbers[@]}"
    run ./src/sqids -a $alphabet -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_long_alphabet" {
    alphabet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"'!'"@#\$%^&*()-_+|{}[];:'\"/?.>,<\`\\~"
    numbers=(1 2 3)

    run ./src/sqids -a "$alphabet" -e "${numbers[@]}"
    run ./src/sqids -a "$alphabet" -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_multibyte_alphabet" {
    run ./src/sqids -a "ë1092" -d "0192"
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" = "ERROR: Alphabet cannot contain multibyte characters" ]]
}

@test "test_repeating_alphabet_characters" {
    run ./src/sqids -a "aabcdefg" -d "abc"
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" = "ERROR: Alphabet cannot contain duplicate characters" ]]
}

@test "test_too_short_alphabet" {
    run ./src/sqids -a "ab" -d "ababa"
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" = "ERROR: Alphabet length must be at least 3" ]]
}
