#!/usr/bin/env bats

@test "test_default_blocklist" {
    run ./src/sqids -d "aho1e"
    [ $status -eq 0 ]
    [[ "${output[@]}" == 4572721 ]]

    run ./src/sqids -b "aho1e" -e 4572721
    [ $status -eq 0 ]
    [[ $output == "JExTR" ]]
}

@test "test_empty_blocklist" {
    run ./src/sqids -b "" -e 4572721
    [ $status -eq 0 ]
    [[ $output == "aho1e" ]]
}

@test "test_custom_blocklist" {
    run ./src/sqids -b "ArUO" -e 4572721
    [ $status -eq 0 ]
    [[ $output == "aho1e" ]]

    run ./src/sqids -b "ArUO" -d "ArUO"
    [ $status -eq 0 ]
    [[ ${output[@]} == 100000 ]]

    run ./src/sqids -b "ArUO" -e 100000
    [ $status -eq 0 ]
    [[ $output == "QyG4" ]]
}

@test "test_blocklist" {
    block_list=(
        "JSwXFaosAN" # normal result of 1st encoding, block that word on purpose
        "OCjV9JK64o" # result of 2nd encoding
        "rBHf"       # result of 3rd encoding is `4rBHfOiqd3`, let's block a substring
        "79SM"       # result of 4th encoding is `dyhgw479SM`, let's block the postfix
        "7tE6"       # result of 4th encoding is `7tE6jdAHLe`, let's block the prefix
    )

    run ./src/sqids -b "${block_list[*]}" -d "1aYeB7bRUt"
    [ $status -eq 0 ]
    [[ ${output[@]} == "1000000 2000000" ]]

    run ./src/sqids -b "${block_list[*]}" -e 1000000 2000000
    [ $status -eq 0 ]
    [[ $output == "1aYeB7bRUt" ]]
}

@test "test_decoding_blocklist_words" {
    block_list="86Rf07 se8ojk ARsz1p Q8AI49 5sQRZO"

    run ./src/sqids -b "$block_list" -d "86Rf07"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1 2 3" ]]

    run ./src/sqids -b "$block_list" -d "se8ojk"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1 2 3" ]]

    run ./src/sqids -b "$block_list" -d "ARsz1p"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1 2 3" ]]

    run ./src/sqids -b "$block_list" -d "Q8AI49"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1 2 3" ]]

    run ./src/sqids -b "$block_list" -d "5sQRZO"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1 2 3" ]]
}

@test "test_match_against_short_blocklist_word" {
    block_list="pnd"

    run ./src/sqids -b $block_list -e 1000
    run ./src/sqids -b $block_list -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "1000" ]]
}

@test "test_blocklist_filtering_in_constructor" {
    alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    block_list="sxnzkl"

    run ./src/sqids -a "$alphabet" -b "$block_list" -e 1 2 3
    [ $status -eq 0 ]
    [[ $output == "IBSHOZ" ]]

    run ./src/sqids -a "$alphabet" -b "$block_list" -d "IBSHOZ"
    [ $status -eq 0 ]
    [[ ${output[@]} == "1 2 3" ]]
}

@test "test_max_encoding_attempts" {
    alphabet="abc"
    min_length=3
    block_list="cab abc bca"

    run ./src/sqids -a "$alphabet" -m "$min_length" -b "$block_list" -e 0
    [ $status -eq 1 ]
}
