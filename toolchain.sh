#!/usr/bin/env bash

# Check if the RISC-V GCC prebuilt binary archive already exists
if [ -f /tmp/riscv32-unknown-elf.gcc-13.2.0.tar.gz ]; then
    echo "riscv-gcc-prebuilt existed, please check the file manually"
else
    # Download the file using wget
    wget -O /tmp/riscv32-unknown-elf.gcc-13.2.0.tar.gz https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz
    # Check if wget succeeded
    if [ $? -ne 0 ]; then
        echo "Failed to download riscv-gcc-prebuilt"
        exit 1
    fi
    # Create the directory if it doesn't exist
    if [ ! -d /opt/riscv ]; then
        mkdir /opt/riscv
    fi
    # Extract the downloaded archive
    tar -xzf /tmp/riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv/
    # Check if tar succeeded
    if [ $? -ne 0 ]; then
        echo "Failed to extract riscv-gcc-prebuilt"
        exit 1
    fi
fi

if [ "$1" == "native" ]; then
	echo "Skip toolchain modification"
elif [ "$1" == "sgx" ]; then
	cp provers/sgx/prover/rust-toolchain.toml ./
	echo "rust-toolchain.toml has been copied from SGX prover to the workspace root."
elif [ "$1" == "risc0" ]; then
    cp provers/risc0/driver/rust-toolchain.toml ./
    echo "rust-toolchain.toml has been copied from Risc0 prover to the workspace root."
elif [ "$1" == "sp1" ]; then
    cp provers/sp1/driver/rust-toolchain.toml ./
    echo "rust-toolchain.toml has been copied from Sp1 prover to the workspace root."
else
	echo "Skip toolchain modification"
	exit 1
fi

# Check if the file exists
if [ -f "rust-toolchain" ]; then
    # If the file exists, remove it
    rm "rust-toolchain"
    echo "File removed successfully."
fi