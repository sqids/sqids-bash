#!/usr/bin/env bats

# Test simple case
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

# Test short alphabet
@test "test_short_alphabet" {
    alphabet="abc"
    numbers=(1 2 3)

    run ./src/sqids -a $alphabet -e "${numbers[@]}"
    run ./src/sqids -a $alphabet -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

# Test long alphabet
@test "test_long_alphabet" {
    alphabet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_+|{}[];:'\"/?.>,<\`\\~"
    numbers=(1 2 3)

    run ./src/sqids -a $alphabet -e "${numbers[@]}"
    run ./src/sqids -a $alphabet -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

# Test multibyte alphabet
@test "test_multibyte_alphabet" {
    run sqids=$(./sqids/sqids "ë1092")
    [ "$status" -eq 1 ]
}

# Test repeating alphabet characters
@test "test_repeating_alphabet_characters" {
    run sqids=$(./sqids/sqids "aabcdefg")
    [ "$status" -eq 1 ]
}

# Test too short alphabet
@test "test_too_short_alphabet" {
    run sqids=$(./sqids/sqids "ab")
    [ "$status" -eq 1 ]
}
