# E~~V~~M

## Architecture
1. Program Counter
2. Opcode Decoder
3. Stack
4. Memory
5. State Manager
    1. Storage
    2. Transient Storage
    3. Account Data
        1. Contract ROM
        2. Eth Balance
        3. Nonce
    4. Reverts
6. Opcode Executor
7. Scope Manager
8. Logger

### 1. Program Counter
The program counter increments for each 32-byte opcode "word" in the program ROM.  Since smart contracts are limited in size to 24KB, the PC can be represented by a single 15-bit number.

The PC is incremented by 1 for normal opcodes or by (2-33) for `PUSH*` opcodes.  It can also be set using the `JUMP` or `JUMPI` opcodes.  When entering a new contract scope, the program counter is always reset to 0.

### 2. Opcode Decoder
The EVM has a maximum of 255 (0x00 - 0xFF) opcodes each represented by 32 bits. `PUSH*` opcodes are a special case where the program ROM will contain not just the opcode but also the data being pushed to stack.

While in theory you could compress the opcodes using something like huffman encoding, in practice compressing newly `CREATE`d contracts on the fly would be... challenging.

### 3. Stack
The EVM stack size is 1024 items where each item is a 256-bit word.  The stack is a last-in first-out data structure where only the 17 most recent stack items are accessible at any given point (using `SWAP`).

### 4. Memory
In the EVM memory is stored as a single, continuous array of bytes that can be accessed in continuous 32-byte words.  Each memory operation defines a memory "offset" which is the **number of bytes** from the start of memory to perform the operation.  Given a memory array `[]byte mem`, a single opcode will at most impact `mem[offset:offset+32]`. 

In theory, the EVM is capable of storing arbitrary 32-byte words at any 32-byte address within memory.  In practice, the addressable amount of memory is capped by the gas limits of the transaction and the ever-increasing cost of accessing memory given by the equation:
$$
\begin{align}
g(x)=\frac{s(x)^2}{512}+(3*s(x)) \\
s(x)=\frac{x+31}{32}
\end{align}
$$

This limits the EVM, at 30 MGas, to accessing the offset `3.9 * 10e6`  or, at 240 MGas, to accessing offset `3.6 * 10e7`.  The limits will cap out at a few tens of megabytes - large enough to require dedicated hardware but not terribly challenging.

In practice the amount of memory used is far lower. Instead of storing memory contiguously, using a hashing function to reduce the memory address space may prove just as viable.  This might make on-chip memory possible.

TODO: Find maximum memory access distribution.

### 5.1. Storage
In the EVM storage is stored as a mapping of independent 32-byte key-value pairs.

Gas costs depend on various factors but, most importantly, they do not depend on the key's magnitude.  Ergo accessing larger storage slots does not cost extra and it is unwise to try and represent storage linearly.