# [Sqids Bash](https://sqids.org/bash)

![GitHub Release](https://img.shields.io/github/v/release/sqids/sqids-bash)
[![Tests](https://github.com/sqids/sqids-bash/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/sqids/sqids-bash/actions/workflows/tests.yml)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sqids/sqids-bash/total)

[Sqids](https://sqids.org/bash) (*pronounced "squids"*) is a small library that lets you **generate unique IDs from numbers**. It's good for link shortening, fast & URL-safe ID generation and decoding back into numbers for quicker database lookups.

Features:

- **Encode multiple numbers** - generate short IDs from one or several non-negative numbers
- **Quick decoding** - easily decode IDs back into numbers
- **Unique IDs** - generate unique IDs by shuffling the alphabet once
- **ID padding** - provide minimum length to make IDs more uniform
- **URL safe** - auto-generated IDs do not contain common profanity
- **Randomized output** - Sequential input provides nonconsecutive IDs
- **Many implementations** - Support for [40+ programming languages](https://sqids.org/)

## 🧰 Use-cases

Good for:

- Generating IDs for public URLs (eg: link shortening)
- Generating IDs for internal systems (eg: event tracking)
- Decoding for quicker database lookups (eg: by primary keys)

Not good for:

- Sensitive data (this is not an encryption library)
- User IDs (can be decoded revealing user count)

## 🚀 Getting started

If your bash version is not 4.0 or higher, please upgrade your bash. (You can check with `$ bash --version`.)

Once you have verified the version of bash, run

```bash
git clone https://github.com/sqids/sqids-bash.git
chmod +x sqids-bash/src/sqids
cp sqids-bash/src/sqids /usr/local/bin
```

You may need to add `sudo` before the command to run the commands as root.

## 👩‍💻 Examples

Simple encode & decode:

```bash
$ sqids -e 1 2 3
86Rf07
$ sqids -d 86Rf07
1 2 3
```

> **Note**
> 🚧 Because of the algorithm's design, **multiple IDs can decode back into the same sequence of numbers**. If it's important to your design that IDs are canonical, you have to manually re-encode decoded numbers and check that the generated ID matches.

Enforce a *minimum* length for IDs:

```bash
$ sqids -l 10 -e 1 2 3
86Rf07xd4z
$ sqids -d "86Rf07xd4z"
1 2 3
```

Randomize IDs by providing a custom alphabet:

```bash
$ sqids -a "FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE" -e 1 2 3
B4aajs
$ sqids -a "FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE" -d B4aajs
1 2 3
```

Prevent specific words from appearing anywhere in the auto-generated IDs:

```bash
$ sqids -b "86Rf07" -e 1 2 3
se8ojk
$ sqids -d se8ojk
1 2 3
```

## 📝 License

[MIT](LICENSE)
