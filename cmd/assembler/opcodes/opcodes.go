package opcodes

import (
	"encoding/hex"
	"fmt"
	"strings"
)

type OP byte

type Instruction interface {
	String() string
	InfoStr() string
}

type BasicInstruction struct {
	OP
	comment string
}

type PushInstruction struct {
	OP
	value   []byte
	comment string
}

const (
	STOP   OP = 0x00
	ADD    OP = 0x01
	MUL    OP = 0x02
	LT     OP = 0x10
	EQ     OP = 0x14
	ISZERO OP = 0x15
	POP    OP = 0x50
	JUMPI  OP = 0x57
	PUSH0  OP = 0x5F
	PUSH1  OP = 0x60
	DUP1   OP = 0x80
)

var OpNames = map[OP]string{
	STOP:   "stop",
	ADD:    "add",
	MUL:    "mul",
	LT:     "lt",
	EQ:     "eq",
	ISZERO: "iszero",
	POP:    "pop",
	JUMPI:  "jumpi",
	PUSH0:  "push0",
	PUSH1:  "push1",
	DUP1:   "dup1",
}

func (o OP) String() string {
	return hex.EncodeToString([]byte{byte(o)})
}

func (i BasicInstruction) String() string {
	return i.OP.String()
}

func (i BasicInstruction) InfoStr() string {
	return fmt.Sprintf("%s // %s", OpNames[i.OP], i.comment)
}

func (i PushInstruction) String() string {
	s := i.OP.String()
	for _, b := range i.value {
		s += "\n" + hex.EncodeToString([]byte{b}) //? Gives me 2 chars for each byte regardless of the value
	}

	return s
}

func (i PushInstruction) InfoStr() string {
	return fmt.Sprintf("%s h%x // %s", OpNames[i.OP], i.value, i.comment)
}

func ParseInstruction(str string) (Instruction, error) {
	splitStr := strings.Split(str, " ")
	if len(splitStr) == 0 {
		return nil, fmt.Errorf("empty instruction")
	}

	op, err := parseOp(splitStr[0])
	if err != nil {
		return nil, fmt.Errorf("parse: %w", err)
	}

	switch op {
	case PUSH1:
		if len(splitStr) < 2 {
			return nil, fmt.Errorf("not enough arguments")
		}

		value, err := parseHex(1, splitStr[1])
		if err != nil {
			return nil, fmt.Errorf("parseBits(%v): %w", value, err)
		}

		instruction := PushInstruction{
			OP:      op,
			value:   value,
			comment: strings.Join(splitStr[2:], " "),
		}
		return instruction, nil
	default:
		instruction := BasicInstruction{
			OP:      op,
			comment: strings.Join(splitStr[1:], " "),
		}

		return instruction, nil
	}
}

func parseOp(s string) (OP, error) {
	for op, name := range OpNames {
		if strings.EqualFold(name, strings.TrimSpace(s)) {
			return op, nil
		}
	}
	return 0, fmt.Errorf("unknown opcode: %v", s)
}

// parseHex parses an incoming string as a hexadecimal value, pre-padding it
// with zeros to the specified length number of bytes.
func parseHex(n int, s string) ([]byte, error) {
	var hexBytes []byte

	switch s[0] {
	case 'h': // Hexadecimal
		var err error
		hexBytes, err = hex.DecodeString(s[1:])
		if err != nil {
			return hexBytes, fmt.Errorf("DecodeString: %w", err)
		}
	default:
		return hexBytes, fmt.Errorf("invalid prefix: %x, 'h' for hex", s[0])
	}

	// Length assertion
	if len(hexBytes) > n {
		return hexBytes, fmt.Errorf("value %s exceeds %d bytes", hexBytes, n)
	}

	// Zero padding
	for len(hexBytes) < n {
		hexBytes = append([]byte{0}, hexBytes...)
	}

	return hexBytes, nil
}
