#!/usr/bin/env bats

@test "test_usage" {
    run ./src/sqids -h
    [ "$status" -eq 0 ]
}

@test "test_version" {
    run ./src/sqids -v
    [ "$status" -eq 0 ]
}
