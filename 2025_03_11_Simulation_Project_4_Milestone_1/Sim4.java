/*
 * Author: Andy Siegel
 * Date: 3/11/2025
 * Description: This class implements a single-cycle CPU. 
 * Milestone 1 implements a function that extracts fields from an instruction 
 * and sets the CPU control signals. Milestone 2 does ...
 */

public class Sim4 {

    /* HELPER FUNCTIONS THAT YOU CAN CALL */
	public int signExtend16to32(int val16) {
		if ((val16 & 0x8000) != 0)
			return val16 | 0xFFFF0000;
		else
			return val16;

	}

	/*
	 * Decodes a 32-bit MIPS instruction into its component fields.
	 * instruction = The 32-bit instruction to decode.
	 * fieldsOut = The object to populate with decoded fields: opcode, rs, rt, rd, shamt, funct, imm16, imm32, and address.
	 */
	public void extractInstructionFields(int instruction, InstructionFields fieldsOut) {
		fieldsOut.opcode = (instruction >> 26) & 0x3F;
		fieldsOut.rs = (instruction >> 21) & 0x1F;
		fieldsOut.rt = (instruction >> 16) & 0x1F;
		fieldsOut.rd = (instruction >> 11) & 0x1F;
		fieldsOut.shamt = (instruction >> 6) & 0x1F;
		fieldsOut.funct = instruction & 0x3F;
		fieldsOut.imm16 = instruction & 0xffff;
		fieldsOut.imm32 = signExtend16to32(fieldsOut.imm16);
		fieldsOut.address = (instruction & 0x3ffffff);
	}

	/*
	 * Configures the CPU control signals based on the given instruction fields.
	 * This function sets the control signals for R-format and I-format MIPS instructions.
	 * It determines the appropriate ALU operation, memory access, register destination, and other control signals.
	 *
	 * fields = The decoded instruction fields containing opcode and funct values.
	 * controlOut = The CPUControl object to be populated with control signals.
	 * returns 1 if the instruction is valid and control signals are successfully set, otherwise 0.
	 */
	public int fillCPUControl(InstructionFields fields, CPUControl controlOut) {
		/*
		ALU operations:
		0 - AND
		1 - OR
		2 - ADD
		3 - LESS
		4 - XOR
		*/
		if(fields.opcode == 0) {
			// R format instruction, check funct
			// for all R-format instructions, these values are correct - they are overridden to 0 in the final else.
			controlOut.ALUsrc = 0;
			controlOut.memRead = 0;
			controlOut.memWrite = 0;
			controlOut.memToReg = 0;
			controlOut.regDst = 1;
			controlOut.regWrite = 1;
			controlOut.branch = 0;
			controlOut.jump = 0;
			//add & addu
			if(fields.funct == 32 || fields.funct == 33) {
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 0;
				return 1;
			}
			//sub & subu
			else if(fields.funct == 34 || fields.funct == 35) {
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 1;
				return 1;
			}
			//and
			else if(fields.funct == 36) {
				controlOut.ALU.op = 0;
				controlOut.ALU.bNegate = 0;
				return 1;
			}
			//or
			else if(fields.funct == 37) {
				controlOut.ALU.op = 1;
				controlOut.ALU.bNegate = 0;
				return 1;
			}
			//xor
			else if(fields.funct == 38) {
				controlOut.ALU.op = 4;
				controlOut.ALU.bNegate = 0;
				return 1;
			}
			//slt
			else if(fields.funct == 42) {
				controlOut.ALU.op = 3;
				controlOut.ALU.bNegate = 1;
				return 1;

			}
			else {
				// if the funct field is invalid, set all vals to 0 and return 0.
				controlOut.ALUsrc = 0;
				controlOut.ALU.op = 0;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 0;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 0;
			}
		} else {
			// op code is not 0, therefore its an I format instruction

			//j
			if(fields.opcode == 2) {
				controlOut.ALUsrc = 0;
				controlOut.ALU.op = 0;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 0;
				controlOut.branch = 0;
				controlOut.jump = 1;
				return 1;
			}
			//beq
			else if(fields.opcode == 4) {
				controlOut.ALUsrc = 0;
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 1;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 0;
				controlOut.branch = 1;
				return 1;
			}
			//addi & addiu
			else if(fields.opcode == 8 || fields.opcode == 9) {
				controlOut.ALUsrc = 1;
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 1;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 1;
			}
			//slti
			else if(fields.opcode == 10) {
				controlOut.ALUsrc = 1;
				controlOut.ALU.op = 3;
				controlOut.ALU.bNegate = 1;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 1;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 1;
			}
			//lw
			else if(fields.opcode == 35) {
				controlOut.ALUsrc = 1;
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 1;
				controlOut.memWrite = 0;
				controlOut.memToReg = 1;
				controlOut.regDst = 0;
				controlOut.regWrite = 1;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 1;
			}
			//sw
			else if(fields.opcode == 43) {
				controlOut.ALUsrc = 1;
				controlOut.ALU.op = 2;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 1;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 0;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 1;
			}
			else {
				controlOut.ALUsrc = 0;
				controlOut.ALU.op = 0;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 0;
				controlOut.branch = 0;
				controlOut.jump = 0;
				return 0;
			}
		}
	}
    
    
    // Method signatures corresponding to function prototypes in sim4.h
	public int getInstruction(int curPC, int[] instructionMemory) {
		// TODO on milestone 2: Your code goes here
        
        return 0;
	}

	public int getALUinput1(CPUControl controlIn, InstructionFields fieldsIn,
                                   int rsVal, int rtVal, int reg32, int reg33, int oldPC) {
		// TODO on milestone 2: Your code goes here
        return 0;
	}

	public int getALUinput2(CPUControl controlIn, InstructionFields fieldsIn,
                                   int rsVal, int rtVal, int reg32, int reg33, int oldPC) {
		// TODO on milestone 2: Your code goes here
        return 0;
	}

	public void executeALU(CPUControl controlIn, int input1, int input2, ALUResult aluResultOut) {
		// TODO on milestone 2: Your code goes here

	}

	public void executeMEM(CPUControl controlIn, ALUResult aluResultIn,
                                  int rsVal, int rtVal, int[] memory, MemResult resultOut) {
		// TODO on milestone 2: Your code goes here

	}

	public int getNextPC(InstructionFields fields, CPUControl controlIn, int aluZero,
                                int rsVal, int rtVal, int oldPC) {
		// TODO on milestone 2: Your code goes here
        return 0;
	}

	public void executeUpdateRegs(InstructionFields fields, CPUControl controlIn,
                                         ALUResult aluResultIn, MemResult memResultIn, int[] regs) {
		// TODO on milestone 2: Your code goes here

	}
}