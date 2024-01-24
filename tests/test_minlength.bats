#!/usr/bin/env bats

@test "test_simple" {
    numbers=(1 2 3)
    min_length=62 # length of DEFAULT_ALPHABET
    id_str="86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM"

    run ./src/sqids -l $min_length -e "${numbers[@]}"
    [ $status -eq 0 ]
    [[ $output == $id_str ]]

    run ./src/sqids -d "$id_str"
    [ $status -eq 0 ]
    [[ "${output[@]}" == "${numbers[@]}" ]]
}

@test "test_incremental" {
    numbers=(1 2 3)
    min_lengths=(6 7 8 9 10 11 12 13 $((62 + 0)) $((62 + 1)) $((62 + 2)) $((62 + 3)))
    ids=(
        "86Rf07"
        "86Rf07x"
        "86Rf07xd"
        "86Rf07xd4"
        "86Rf07xd4z"
        "86Rf07xd4zB"
        "86Rf07xd4zBm"
        "86Rf07xd4zBmi"
        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM"
        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMy"
        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf"
        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf1"
    )
    for i in {0..11}; do
        run ./src/sqids -l ${min_lengths[$i]} -e ${numbers[@]}
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        [[ ${#output} == ${min_lengths[$i]} ]]
        run ./src/sqids -l ${min_lengths[$i]} -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]
    done
}

@test "test_incremental_numbers" {
    numbers=(0 1 2 3 4 5 6 7 8 9)
    min_length=62 # length of DEFAULT_ALPHABET
    ids=(
        "SvIzsqYMyQwI3GWgJAe17URxX8V924Co0DaTZLtFjHriEn5bPhcSkfmvOslpBu"
        "n3qafPOLKdfHpuNw3M61r95svbeJGk7aAEgYn4WlSjXURmF8IDqZBy0CT2VxQc"
        "tryFJbWcFMiYPg8sASm51uIV93GXTnvRzyfLleh06CpodJD42B7OraKtkQNxUZ"
        "eg6ql0A3XmvPoCzMlB6DraNGcWSIy5VR8iYup2Qk4tjZFKe1hbwfgHdUTsnLqE"
        "rSCFlp0rB2inEljaRdxKt7FkIbODSf8wYgTsZM1HL9JzN35cyoqueUvVWCm4hX"
        "sR8xjC8WQkOwo74PnglH1YFdTI0eaf56RGVSitzbjuZ3shNUXBrqLxEJyAmKv2"
        "uY2MYFqCLpgx5XQcjdtZK286AwWV7IBGEfuS9yTmbJvkzoUPeYRHr4iDs3naN0"
        "74dID7X28VLQhBlnGmjZrec5wTA1fqpWtK4YkaoEIM9SRNiC3gUJH0OFvsPDdy"
        "30WXpesPhgKiEI5RHTY7xbB1GnytJvXOl2p0AcUjdF6waZDo9Qk8VLzMuWrqCS"
        "moxr3HqLAK0GsTND6jowfZz3SUx7cQ8aC54Pl1RbIvFXmEJuBMYVeW9yrdOtin"
    )

    for i in {0..9}; do
        run ./src/sqids -l $min_length -e 0 "${numbers[$i]}"
        [ $status -eq 0 ]
        [[ $output == "${ids[$i]}" ]]
        run ./src/sqids -l $min_length -d "${ids[$i]}"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "0 ${numbers[$i]}" ]]
    done
}

@test "test_min_lengths" {
    numbers=()
    min_lengths=(0 1 5 10 62)

    for i in {0..4}; do
        numbers=(0)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=(0 0 0 0 0)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=(1 2 3 4 5 6 7 8 9 10)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=(100 200 300)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=(1000 2000 3000)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=(1000000)
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]

        numbers=($(((1 << 63) - 1)))
        run ./src/sqids -l ${min_lengths[$i]} -e "${numbers[@]}"
        [ $status -eq 0 ]
        [[ ${#output} -ge ${min_lengths[$i]} ]]
        run ./src/sqids -d "$output"
        [ $status -eq 0 ]
        [[ "${output[@]}" == "${numbers[@]}" ]]
    done
}

@test "test_out_of_range_invalid_min_length" {
    min_lengths=(-1 256)
    for i in {0..1}; do
        run ./src/sqids -l ${min_lengths[$i]} -e 1 2 3
        [ $status -eq 1 ]
        [[ "${lines[0]}" = "ERROR: Minimum length has to be between 0 and 255" ]]
    done
}
