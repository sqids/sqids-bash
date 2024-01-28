#!/usr/bin/env bats

@test "test_simple" {
    numbers=(1 2 3)
    id_str="86Rf07"

    run ./src/sqids -e "${numbers[@]}"
    [ $status -eq 0 ]
    [[ $output == $id_str ]]

    run ./src/sqids -d "$id_str"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_different_inputs" {
    numbers=(0 0 0 1 2 3 100 1000 100000 1000000 $(((1 << 63) - 1)))

    run ./src/sqids -e "${numbers[@]}"
    run ./src/sqids -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_incremental_numbers" {
    numbers=(0 1 2 3 4 5 6 7 8 9)
    ids=("bM" "Uk" "gb" "Ef" "Vq" "uw" "OI" "AX" "p6" "nJ")

    for i in {0..9}; do
        run ./src/sqids -e "${numbers[$i]}"
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        run ./src/sqids -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[$i]}" ]]
    done
}

@test "test_incremental_numbers_same_index_0" {
    numbers=(0 1 2 3 4 5 6 7 8 9)
    ids=("SvIz" "n3qa" "tryF" "eg6q" "rSCF" "sR8x" "uY2M" "74dI" "30WX" "moxr")

    for i in {0..9}; do
        run ./src/sqids -e 0 "${numbers[$i]}"
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        run ./src/sqids -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "0 ${numbers[$i]}" ]]
    done
}

@test "test_incremental_numbers_same_index_1" {
    numbers=(0 1 2 3 4 5 6 7 8 9)
    ids=("SvIz" "nWqP" "tSyw" "eX68" "rxCY" "sV8a" "uf2K" "7Cdk" "3aWP" "m2xn")

    for i in {0..9}; do
        run ./src/sqids -e "${numbers[$i]}" 0
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        run ./src/sqids -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[$i]} 0" ]]
    done
}

@test "test_multi_input" {
    numbers=()
    for i in {0..99}; do
        numbers+=($i)
    done

    run ./src/sqids -e "${numbers[@]}"
    run ./src/sqids -d "$output"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_encoding_no_numbers" {
    run ./src/sqids -e ""
    [ $status -eq 0 ]
    [[ -z $output ]]
}

@test "test_decoding_empty_string" {
    run ./src/sqids -d ""
    [ $status -eq 0 ]
    [[ -z "${output[@]}" ]]
}

@test "test_decoding_invalid_character" {
    run ./src/sqids -d "*"
    [ $status -eq 0 ]
    [[ -z "${output[@]}" ]]
}

@test "test_encode_out_of_range_numbers" {
    run ./src/sqids -e -1
    [ $status -eq 1 ]
    [[ "${lines[0]}" == "ERROR: Invalid option -1" ]]

    # no need since bash can't handle numbers larger than 2^63-1
    # run ./src/sqids -e $((1 << 63))
    # [ $status -eq 1 ]
}

@test "test_zero_padding" {
    numbers=(0 1 2 3 4 5 6 7 8 9)
    ids=("bM" "Uk" "gb" "Ef" "Vq" "uw" "OI" "AX" "p6" "nJ")

    for i in {0..9}; do
        run ./src/sqids -e "0${numbers[$i]}"
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        run ./src/sqids -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[$i]}" ]]
    done
}
