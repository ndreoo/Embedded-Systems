#!/bin/bash

#!/bin/bash

# Configurazioni
INSTALL_DIR="$HOME/riscv-tools"
SPIKE_DIR="/opt/spike"
OPENOCD_DIR="/opt/openocd"
TOOLCHAIN_DIR="$HOME/riscv"
GCC32="$INSTALL_DIR/bin/riscv32-unknown-elf-gcc"
GDB32="$INSTALL_DIR/bin/riscv32-unknown-elf-gdb"
GCC64="$INSTALL_DIR/bin/riscv64-unknown-elf-gcc"
GDB64="$INSTALL_DIR/bin/riscv64-unknown-elf-gdb"

# Funzione per installare toolchain GNU
install_toolchain() {
  echo ">> Installazione toolchain GNU RISC-V..."
  sudo apt update
  sudo apt install -y \
    autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev \
    libgmp-dev gawk build-essential bison flex texinfo gperf \
    libtool patchutils bc zlib1g-dev libexpat-dev git libusb-1.0-0-dev \
    ninja-build cmake libglib2.0-dev

  mkdir -p "$TOOLCHAIN_DIR"
  cd "$TOOLCHAIN_DIR" || exit
  git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain
  cd riscv-gnu-toolchain || exit

  ./configure --prefix="$INSTALL_DIR"
  make newlib -j"$(nproc)"
  echo 'export PATH="$HOME/riscv-tools/bin:$PATH"' >> ~/.bashrc
  export PATH="$HOME/riscv-tools/bin:$PATH"
}

# Funzione per installare Spike
install_spike() {
  echo ">> Installazione Spike..."
  sudo apt install -y device-tree-compiler
  sudo apt update
  sudo apt install -y git autoconf automake autotools-dev curl python3 \
    libmpc-dev libmpfr-dev libgmp-dev g++ build-essential

  git clone https://github.com/riscv-software-src/riscv-isa-sim.git
  cd riscv-isa-sim || exit
  mkdir build && cd build || exit
  ../configure --prefix="$SPIKE_DIR"
  make -j"$(nproc)"
  sudo make install
  echo "export PATH=\"$SPIKE_DIR/bin:\$PATH\"" >> ~/.bashrc
}

# Funzione per installare OpenOCD
install_openocd() {
  echo ">> Installazione OpenOCD..."
  sudo apt update
  sudo apt install -y git make libtool pkg-config autoconf automake texinfo \
    libusb-1.0-0-dev libudev-dev libjim-dev

  git clone --recursive https://github.com/riscv/riscv-openocd.git
  cd riscv-openocd || exit
  ./bootstrap
  ./configure --enable-ftdi --prefix="$OPENOCD_DIR"
  make -j"$(nproc)"
  sudo make install
  echo "export PATH=\"$OPENOCD_DIR/bin:\$PATH\"" >> ~/.bashrc
}

# Controllo Toolchain
if [[ -x "$GCC32" && -x "$GDB32" && -x "$GCC64" && -x "$GDB64" ]]; then
  echo "Toolchain RISC-V già presente."
else
  install_toolchain
fi

# Controllo Spike
if command -v spike &> /dev/null; then
  echo "Spike già installato."
else
  install_spike
fi

# Controllo OpenOCD
if command -v openocd &> /dev/null; then
  echo "OpenOCD già installato."
else
  install_openocd
fi

echo "Ambiente RISC-V pronto!"





#installa estensioni

code --install-extension ms-vscode.cpptools-extension-pack --force
code --install-extension hm.riscv-venus --force
code --install-extension zhwu95.riscv --force
code --install-extension ms-vscode.hexeditor --force
