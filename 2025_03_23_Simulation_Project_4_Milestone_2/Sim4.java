/*
 * Author: Andy Siegel
 * Date: 3/11/2025
 * Description: This class implements a single-cycle CPU. 
 * Milestone 1 implements a function that extracts fields from an instruction 
 * and sets the CPU control signals. 
 * 
 * Milestone 2 enhances the CPU by implementing the execution phase, which includes:
 * - Fetching the instruction from memory.
 * - Executing ALU operations (addition, subtraction, logical operations, shifts).
 * - Performing memory read/write operations.
 * - Updating the register file with results from the ALU or memory.
 * 
 * Functions included in this milestone are: getInstruction, getALUinput1, getALUinput2, 
 * executeALU, executeMEM, getNextPC, and executeUpdateRegs.
 * 
 * My extra instructions are: ori, lui, srl.
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

			// srl
			if (fields.funct == 2) {
				controlOut.ALU.op = 5;
				return 1;
			}

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
			// ori
			else if(fields.opcode == 13) {
				controlOut.ALUsrc = 1;
				controlOut.ALU.op = 1;
				controlOut.ALU.bNegate = 0;
				controlOut.memRead = 0;
				controlOut.memWrite = 0;
				controlOut.memToReg = 0;
				controlOut.regDst = 0;
				controlOut.regWrite = 1;
				controlOut.branch = 0;
				controlOut.jump = 0;
				controlOut.extra1 = 1;
				return 1;
			}
			// lui
			else if(fields.opcode == 15) {
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
				controlOut.extra2 = 1;
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
    
    /*
	 * Retrieves the instruction from the instruction memory based on the current program counter (PC).
	 * The instruction is accessed using the address calculated by dividing the current PC by 4,
	 * as MIPS instructions are 4 bytes in size.
	 *
	 * curPC = The current program counter value, which indicates the address of the instruction to fetch.
	 * instructionMemory = An array representing the instruction memory, where each element is a 32-bit instruction.
	 * 
	 * returns: The 32-bit instruction fetched from memory at the address specified by curPC.
	 */
	public int getInstruction(int curPC, int[] instructionMemory) {
        return instructionMemory[curPC/4];
	}

	/*
	 * Determines the first input to the ALU based on the control signals and the provided instruction fields.
	 * This function accounts for special cases, such as when the operation is a shift right logical (srl),
	 * where the shift amount (shamt) is used as the input instead of the value from the source register.
	 *
	 * controlIn = The CPUControl object containing the control signals that dictate the ALU operation.
	 * fieldsIn = The InstructionFields object containing the decoded instruction fields, including shamt.
	 * rsVal = The value from the source register specified by the instruction.
	 * rtVal = The value from the target register specified by the instruction (not used in this function).
	 * reg32 = The value from register 32 (not used in this function).
	 * reg33 = The value from register 33 (not used in this function).
	 * oldPC = The value of the previous program counter (not used in this function).
	 * 
	 * returns: The value to be used as the first input to the ALU. This will be either the value from the 
	 * source register (rsVal) or the shift amount (shamt) if the operation is a shift right logical.
	 */
	public int getALUinput1(CPUControl controlIn, InstructionFields fieldsIn,
                                   int rsVal, int rtVal, int reg32, int reg33, int oldPC) {
        // srl special case
		if(controlIn.ALU.op == 5) {
			return fieldsIn.shamt;
		}
		return rsVal;
	}

	/*
	 * Determines the second input to the ALU based on the control signals and the provided instruction fields.
	 * This function differentiates between R-format and I-format instructions to select the appropriate input.
	 * It also handles special cases for certain I-format instructions, such as `ori` and `lui`, 
	 * which require different treatments of the immediate value.
	 *
	 * controlIn = The CPUControl object containing the control signals that dictate the ALU operation.
	 * fieldsIn = The InstructionFields object containing the decoded instruction fields, including imm16 and imm32.
	 * rsVal = The value from the source register specified by the instruction (not used in this function).
	 * rtVal = The value from the target register specified by the instruction, used for R-format instructions.
	 * reg32 = The value from register 32 (not used in this function).
	 * reg33 = The value from register 33 (not used in this function).
	 * oldPC = The value of the previous program counter (not used in this function).
	 * 
	 * returns: The value to be used as the second input to the ALU. This will be either the value from the 
	 * target register (rtVal) for R-format instructions, the zero-extended immediate value for `ori`, 
	 * the left-shifted immediate value for `lui`, or the immediate value (imm32) for other I-format instructions.
	 */
	public int getALUinput2(CPUControl controlIn, InstructionFields fieldsIn,
                                   int rsVal, int rtVal, int reg32, int reg33, int oldPC) {
		// R-Format Instruction
		if (controlIn.ALUsrc == 0) {
			return rtVal;
		// I-Format Instruction
		} else {
			// System.out.println(controlIn.ALU.op);
			// ori special case - zero extended imm16
			if(controlIn.extra1 == 1) {
				return fieldsIn.imm16 & 0x0000FFFF;
			}
			// lui special case
			else if (controlIn.extra2 == 1) {
				return fieldsIn.imm16 << 16;
			}
			// if all special checks fail, return the immediate value imm32
			return fieldsIn.imm32;
		}
	}

	/*
	 * Executes the arithmetic and logic operations of the ALU based on the control signals and the provided inputs.
	 * This function performs various operations such as AND, OR, ADD, SUBTRACT, SET LESS THAN, XOR, and SHIFT RIGHT LOGICAL.
	 * The result of the operation is stored in the ALUResult object, which also tracks if the result is zero.
	 *
	 * controlIn = The CPUControl object containing the control signals that dictate the ALU operation and whether to negate the result.
	 * input1 = The first input value to the ALU, typically from the first ALU input.
	 * input2 = The second input value to the ALU, typically from the second ALU input.
	 * aluResultOut = The ALUResult object to be populated with the result of the ALU operation and the zero flag.
	 * 
	 * The ALU operations are defined as follows:
	 * 0 - AND
	 * 1 - OR
	 * 2 - ADD / SUBTRACT
	 * 3 - SET LESS THAN 
	 * 4 - XOR
	 * 5 - SHIFT RIGHT LOGICAL (SRL)
	 *
	 * After performing the operation, the zero flag in aluResultOut is set to 1 if the result is zero, otherwise it is set to 0.
	 */
	public void executeALU(CPUControl controlIn, int input1, int input2, ALUResult aluResultOut) {
		if(controlIn.ALU.op == 0) {
			aluResultOut.result = input1 & input2;
		}
		else if(controlIn.ALU.op == 1) {
			aluResultOut.result = input1 | input2;
		}
		else if(controlIn.ALU.op == 2) {
			if(controlIn.ALU.bNegate == 1) {
				aluResultOut.result = input1 - input2;
			} else {
				aluResultOut.result = input1 + input2;
			}
		}
		else if(controlIn.ALU.op == 3) {
			if(input1 < input2) {
				aluResultOut.result = 1;
			} else {
				aluResultOut.result = 0;
			}
		}
		else if(controlIn.ALU.op == 4) {
			aluResultOut.result = input1 ^ input2;
		}
		else if(controlIn.ALU.op == 5) {
			aluResultOut.result = input2 >>> input1;
		}
		aluResultOut.zero = aluResultOut.result == 0 ? 1 : 0;
	}

	/*
	 * Executes memory operations based on the control signals and the result of the ALU operation.
	 * This function handles both reading from and writing to memory, depending on the control signals.
	 * If a memory read operation is requested, the value at the calculated address is retrieved.
	 * If a memory write operation is requested, the value from the target register is stored at the calculated address.
	 *
	 * controlIn = The CPUControl object containing the control signals that dictate whether to perform a memory read or write.
	 * aluResultIn = The ALUResult object containing the result of the ALU operation, which is used to calculate the memory address.
	 * rsVal = The value from the source register specified by the instruction (not used in this function).
	 * rtVal = The value from the target register specified by the instruction, used for memory writing.
	 * memory = An array representing the memory, where each element is a 32-bit word.
	 * resultOut = The MemResult object to be populated with the value read from memory (if applicable).
	 * 
	 * The memory operations are as follows:
	 * - If memRead is set to 1, the function reads a value from memory at the address specified by the ALU result (immediate)
	 *   divided by 4 (to convert byte address to word address) and stores it in resultOut.readVal.
	 * - If memWrite is set to 1, the function writes the value from rtVal to memory at the same address.
	 *
	 */
	public void executeMEM(CPUControl controlIn, ALUResult aluResultIn,
                                  int rsVal, int rtVal, int[] memory, MemResult resultOut) {
		int immediate = aluResultIn.result;
		if(controlIn.memRead == 1) {
			resultOut.readVal = memory[immediate / 4];
		} 
		if(controlIn.memWrite == 1) {
			memory[immediate / 4] = rtVal;
		}

	}

	/*
	 * Calculates the address of the next instruction to be executed based on the current program counter (oldPC),
	 * control signals, and the results of the ALU operation. This function handles both branching and jumping 
	 * scenarios to determine the appropriate next PC value.
	 *
	 * fields = The InstructionFields object containing the decoded instruction fields, including immediate and address values.
	 * controlIn = The CPUControl object containing the control signals that dictate whether to branch or jump.
	 * aluZero = A flag indicating whether the result of the ALU operation was zero, used for conditional branching.
	 * rsVal = The value from the source register specified by the instruction (not used in this function).
	 * rtVal = The value from the target register specified by the instruction (not used in this function).
	 * oldPC = The value of the previous program counter, used as the base for calculating the next PC.
	 * 
	 * returns: The calculated address of the next instruction. The next PC is determined as follows:
	 * - By default, the next PC is set to oldPC + 4 (the address of the next sequential instruction).
	 * - If a branch is taken (branch == 1 and aluZero == 1), the next PC is updated to include the offset specified
	 *   by the immediate value (imm32), shifted left by 2 bits to account for word addressing.
	 * - If a jump is taken (jump == 1), the next PC is calculated using the jump address, which is combined with the 
	 *   upper bits of oldPC to form the full address.
	 */
	public int getNextPC(InstructionFields fields, CPUControl controlIn, int aluZero,
                                int rsVal, int rtVal, int oldPC) {
		int nextPC = oldPC + 4;
		if(controlIn.branch == 1 && aluZero == 1) {
            nextPC += (fields.imm32 << 2); 
		} else if (controlIn.jump == 1) {
			nextPC = oldPC & 0xF0000000 | fields.address << 2;
		}
		return nextPC;
	}

	/*
	 * Updates the register file based on the results of the ALU operation or memory access, as dictated by the control signals.
	 * This function writes the appropriate value to the destination register specified by the instruction fields.
	 * It handles both R-format and I-format instructions and determines whether to write the ALU result or the memory read value.
	 *
	 * fields = The InstructionFields object containing the decoded instruction fields, including the destination register (rd or rt).
	 * controlIn = The CPUControl object containing the control signals that dictate whether to write to the register file 
	 *              and which register to write to.
	 * aluResultIn = The ALUResult object containing the result of the ALU operation, which may be written to the register.
	 * memResultIn = The MemResult object containing the value read from memory, which may be written to the register.
	 * regs = An array representing the register file, where each element is a 32-bit register.
	 * 
	 * The register update process is as follows:
	 * - If regWrite is set to 1, the function proceeds to update the register.
	 * - The destination register is determined based on the regDst control signal:
	 *   - If regDst is 1, the destination is set to rd (the destination register field).
	 *   - If regDst is 0, the destination is set to rt (the target register field).
	 * - The value to be written to the register is determined based on the memToReg control signal:
	 *   - If memToReg is 1, the value read from memory (memResultIn.readVal) is used.
	 *   - If memToReg is 0, the ALU result (aluResultIn.result) is used.
	 * - Finally, the determined value is written to the specified register in the register file.
	 */
	public void executeUpdateRegs(InstructionFields fields, CPUControl controlIn,
                                         ALUResult aluResultIn, MemResult memResultIn, int[] regs) {
		if(controlIn.regWrite == 1) {
			int regDestination;
			if(controlIn.regDst == 1) {
				regDestination = fields.rd;
			} else {
				regDestination = fields.rt;
			}
			int returnValue;
			if(controlIn.memToReg == 1) {
				returnValue = memResultIn.readVal;
			} else {
				returnValue = aluResultIn.result;
			}
			regs[regDestination] = returnValue;
		}
	}
}