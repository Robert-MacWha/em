package main

import (
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/Robert-MacWha/em/cmd/assembler/opcodes"
)

func main() {
	detailed := flag.Bool("d", false, "Generate a details file")
	flag.Parse()

	args := flag.Args()

	if len(args) != 1 {
		fmt.Println("Usage: assembler [-d] <asm file>")
		os.Exit(1)
	}

	asmFile := args[0]
	hexFile := strings.Split(asmFile, ".")[0] + ".hex"
	detailsFile := strings.Split(asmFile, ".")[0] + "_details.txt"

	instructions, err := loadInstructions(asmFile)
	if err != nil {
		panic(err)
	}

	err = writeInstructions(hexFile, instructions)
	if err != nil {
		panic(err)
	}

	if *detailed {
		err = writeDetails(detailsFile, instructions)
		if err != nil {
			panic(err)
		}
	}
}

// assemble assembles a list of assembly instructions into a list of machine
// code instructions. The output instructions should be stringified and written
// to a verilog memory initialization file.
func loadInstructions(path string) ([]opcodes.Instruction, error) {
	content, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("ReadFile: %w", err)
	}

	strs := strings.Split(string(content), "\n")

	instructions := make([]opcodes.Instruction, 0, len(strs))

	// First pass to remove comments
	n := 0
	for _, s := range strs {
		if !strings.HasPrefix(s, "//") {
			strs[n] = s
			n++
		}
	}
	strs = strs[:n]

	// Second pass to parse instructions
	for _, s := range strs {
		instr, err := opcodes.ParseInstruction(s)
		if err != nil {
			return nil, fmt.Errorf("parseInstruction: %w", err)
		}
		instructions = append(instructions, instr)
	}

	return instructions, nil
}

// writeInstructions writes a list of machine code instructions to a .txt file, each on a new line
func writeInstructions(path string, instructions []opcodes.Instruction) error {
	file, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("Create: %w", err)
	}
	defer file.Close()

	for _, instr := range instructions {
		_, err := file.WriteString(instr.String() + "\n")
		if err != nil {
			return fmt.Errorf("WriteString: %w", err)
		}
	}

	return nil
}

func writeDetails(path string, instructions []opcodes.Instruction) error {
	file, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("Create: %w", err)
	}
	defer file.Close()

	for i, instr := range instructions {
		_, err := file.WriteString(fmt.Sprintf("%v %s\n", i, instr.InfoStr()))
		if err != nil {
			return fmt.Errorf("WriteString: %w", err)
		}
	}

	return nil
}
