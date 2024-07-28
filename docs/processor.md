# Processor

The processor needs to imlpement a basic fetch-execute cycle.  To simplify and optimize my execution (allowing for opcodes that take multiple clock cycles to execute) this state machine will need to be a little more complex but, in general this will suffice.

I'll do this using two program counters.  The first keeps track of what opcode is currently selected, while the second keeps track of what "microcode" is being executed.  The microcodes are what define the different steps within the fetch-execute cycle, as well as any non-cyclical steps required for multi-cycle opcodes.