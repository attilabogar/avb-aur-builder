# avb-aur-builder

Attila Bogár's AUR build scripts

[![Build Status][1]][2]

[1]: https://travis-ci.org/attilabogar/avb-aur-builder.svg?branch=master
[2]: https://travis-ci.org/attilabogar/avb-aur-builder


## Description

This project can be used to build AUR packages in docker containers using `docker-compose`.

It's precedes my own AUR override packages description from
[avb-aur](https://github.com/attilabogar/avb-aur) over any official'
[AUR](https://aur.archlinux.org).

The order of the packages passed to the `build-pipeline.sh` is relevant, as
packages down the list may depend on packages built first.  Figuring out and
flattening the dependency order is the user's responsibility.

The list of package names can be passed as args or as a simple textfile, where
each line is a package name.  Moreover, the two methods can be mixed.

The precedence for `build-pipeline.sh` resolving ARGV as follows:

  1. first looks for a directory named as ARGV (useful for debugging builds)
  2. non-empty text file (containing list of packages)
  3. downloads the AUR (precedence as described above)

## Requirements

  - docker
  - docker-compose

The setup of specific repositories, such as `multilib` is your responsibility.

# Structure

  - `build-pipeline.sh` (the main script)
  - `repo/` (the local repository - packages end up here)
  - `build/` (the build workspace)

## Example

To build [Google Chrome](https://aur.archlinux.org/packages/google-chrome), run
`./build-pipeline.sh google-chrome`

To build a more complicated flow, such as imapsync, put the packages into `aur-imapsync.txt`
```
perl-par
perl-par-packer
perl-test-mock-guard
perl-json-webtoken
perl-mail-imapclient
perl-ntlm
perl-sys-meminfo
perl-unicode-string
imapsync
```

Then run `./build-pipeline.sh aur-imapsync.txt`

## LICENSE

    MIT License

    Copyright (c) 2019 Attila Bogár

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

**NOTE**: This software depends on other packages that may be licensed under
different open source licenses.
