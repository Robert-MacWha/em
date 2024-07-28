# Instruction Set

EVM instruction set

## Opcode List
| Opcode | Name   | Stack                  | Description                           |
|--------|--------|------------------------|---------------------------------------|
| 00     | STOP   |                        | Stop execution                        |
| 01     | ADD    | a, b => a+b            | uint256 addition                      |
| 02     | MUL    | a, b => a * b          | uint256 multiplication                |
| 10     | LT     | a, b => a < b          | uint256 less-than                     |
| 14     | EQ     | a, b => a == b         | uint256 equality                      |
| 15     | ISZERO | a => a == 0            | Is-zero equality                      |
| 50     | POP    | a => _                 | Removes top stack element             |
| 57     | JUMPI  | dst, condition => _, _ | Jump to destination if condition != 0 |
| 5F     | PUSH0  | _ => 0, _              | Push 0 to stack                       |
| 60     | PUSH1  | _ => x, _              | Push 1-byte to stack                  |
| 80     | DUP1   | a => a, a              | Duplicate first stack element         |