# 16-bit RISC Processor

Technical Documentation and Architecture Specification

## 1\. Overview

This project implements a 16-bit RISC processor with a fixed instruction format and a multi-cycle execution model. The architecture is designed for clarity, simplicity of RTL implementation, and ease of extension.

Key characteristics:

* Word width: 16 bits
* Register file: 8 general-purpose registers (R0–R7)
* Opcode width: 7 bits
* Instruction size: 16 bits
* Immediate-type instructions use two consecutive memory words
* Control implemented as a finite-state machine without pipelining

## 2\. Instruction Format

All instructions have a unified 16-bit layout:

```
    [15:9]   opcode (7 bits)
    [ 8:6]   rd     (3 bits)
    [ 5:3]   rs     (3 bits)
    [ 2:0]   rt     (3 bits)
```

Immediate-type instructions fetch the full 16-bit operand from the next memory word located at `PC + 1`.

## 3\. Instruction Set

### 3.1. R-type Instructions (Single 16-bit Word)

Format:

```
    opcode | rd | rs | rt
```

#### Arithmetic

* ADD  rd, rs, rt
* SUB  rd, rs, rt
* ADC  rd, rs, rt
* SBB  rd, rs, rt
* MUL  rd, rs, rt
* UML  rd, rs, rt
* INC  rd, rs
* DEC  rd, rs

#### Logic

* AND  rd, rs, rt
* ORR  rd, rs, rt
* XOR  rd, rs, rt
* NOT  rd, rs
* TCP  rd, rs

#### Shifts

* SLL  rd, rs, rt
* SRL  rd, rs, rt
* SRA  rd, rs, rt

#### Half-word operations

* MHL rd, rs, rt
* MLH rd, rs, rt
* MLL rd, rs, rt
* MHH rd, rs, rt

#### Data movement

* MOV rd, rs
* LWD rd, rs
* SWD rt, rs
* LPC rd

#### Jumps and branches

* JPR rd
* JRL rd, rs
* JGZ rd, rs
* JLZ rd, rs
* JEZ rd, rs
* JNZ rd, rs
* JPC rd
* JOV rd
* JEQ rd, rs, rt
* JNQ rd, rs, rt
* JPG rd, rs, rt
* JPL rd, rs, rt

### 3.2. Immediate-Type Instructions (Two Words)

#### LWI rd, imm

The first word contains opcode and rd; the second word contains a full 16-bit immediate.

Semantics:

```
    rd = imm
    PC = PC + 2
```

#### JMP imm

Performs an unconditional jump to the address stored in the next memory word.

#### NOP

No operation.

#### HLT

Halts the processor.

## 4\. Processor State Machine

The multi-cycle execution flow consists of:

1. FETCH
2. DECODE
3. EXECUTE
4. WRITE\_BACK
5. HALTED

Memory access is synchronized via a hold signal for slow memory.

## 5\. Control Signals

* Jump
* MemRead
* MemWrite
* RegWrite
* LinkToRF
* Immediate
* Movement
* Halt
* Nop

## 6\. Project Structure

* cpu.v — main processor module
* control.v — instruction decoding and control logic
* rf.v — register file
* alu.v — arithmetic and logic unit
* opcode.v — opcode definitions
* aluop.v — ALU operation codes
* common.v — shared parameters

## 7\. Example Program

```
    LWI R1, 0x1234
    ADD R2, R1, R1
    JEZ R3, R2
    LWD R4, R3
    HLT
```

