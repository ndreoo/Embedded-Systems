#!/bin/bash

# Script per collegare ELF solo se tutti i .o esistono

missing=0

# Controllo file .c
for f in ./*.c; do
  [ -f "${f%.c}.o" ] || missing=1
done

# Controllo file .s
for f in ./*.s; do
  [ -f "${f%.s}.o" ] || missing=1
done

# Se tutti i .o esistono
if [ $missing -eq 0 ]; then
  echo "Tutti i file .o trovati."
else
  echo "Mancano uno o più file .o, eseguo compilazione..."

  # Assembla .s
  for file in ./*.s; do
    ${1} -g -march=${2} -mabi=${3} -o "${file%.s}.o" "$file"
  done

  # Compila .c
  for file in ./*.c; do
    ${4} -c -g -O0 -ffreestanding -march=${2} -mabi=${3} -o "${file%.c}.o" "$file"
  done
fi

# Richiedi il nome dell'ELF
read -p "Inserisci il nome del file ELF (senza estensione): " elfName

# Link
${5} -Tbaremetal.ld -m elf32lriscv -o "$elfName.elf" ./*.o

echo "ELF creato: $elfName.elf"
