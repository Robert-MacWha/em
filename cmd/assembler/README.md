# Assembler
A very basic assembler used to generate an initial memory file for the processor ROM.

## Structure
The opcodes are defined by line-seperated instructions.

## Code
Code lines are lines which begin with an [opcode](./opcodes/opcodes.go).  The are structured as | Opcode | Value (for push opcodes) | // Comment |.

## Comments
Comments are lines with start with `//` followed by the comment.  They are ignored by the assembler.

https://projectf.io/posts/initialize-memory-in-verilog/