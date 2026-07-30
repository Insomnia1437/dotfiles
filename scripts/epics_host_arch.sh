#!/bin/bash

os_type=$(uname -s)
arch_type=$(uname -m)

case $os_type in
Linux)
  case $arch_type in
  x86_64)
    echo "linux-x86_64"
    ;;
  i*86) # Matches i386, i486, etc.
    echo "linux-x86"
    ;;
  arm*)
    echo "linux-arm"
    ;;
  aarch64*)
    echo "linux-aarch64"
    ;;
  *)
    echo "Unknown Linux architecture: $arch_type" >&2
    exit 1
    ;;
  esac
  ;;
Darwin)
  case $arch_type in
  x86_64 | i386)
    echo "darwin-x86"
    ;;
  arm*)
    echo "darwin-aarch64"
    ;;
  *) # Handle PowerPC or other future architectures
    echo "Unknown macOS architecture: $arch_type" >&2
    exit 1
    ;;
  esac
  ;;
*)
  echo "Unsupported operating system: $os_type" >&2
  exit 1
  ;;
esac
