LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library work;
use work.riscv_pkg.all;

ENTITY PIPE2_REG IS
	PORT (	R : IN pipe2_signal;
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			Q :	OUT pipe2_signal);
END PIPE2_REG;

ARCHITECTURE BEHAVIOR OF PIPE2_REG IS
BEGIN
	PROCESS (CLOCK, RESETN)
	BEGIN
		IF (RESETN = '0') THEN
			Q.PC			<= (OTHERS => '0');
			Q.RD			<= (OTHERS => '0');
			Q.PC_next		<= (OTHERS => '0');
			Q.read_data_1	<= (OTHERS => '0');
			Q.read_data_2	<= (OTHERS => '0');
			Q.immediate		<= (OTHERS => '0');
			Q.funct3 		<= (OTHERS => '0');
			--CONTROL SIGNALS
			Q.AluSrc			<= '0';
			Q.Branch			<= '0';
			Q.WDataMux		<= (OTHERS => '0');
			Q.RegWrite			<= '0';
			Q.AluOp			<= idle;
			Q.MemRead		<= '0';
			Q.MemWrite			<= '0';
			
		ELSIF rising_edge(CLOCK) THEN
			IF ENABLE='1' THEN
				Q.PC				<= R.PC;
				Q.RD				<= R.RD;
				Q.PC_next		<= R.PC_next;
				Q.read_data_1	<= R.read_data_1;
				Q.read_data_2	<= R.read_data_2;
				Q.immediate		<= R.immediate;
				Q.funct3 		<= R.funct3;
				--CONTROL SIGNALS
				Q.AluOp			<= R.AluOp;
				Q.AluSrc			<= R.AluSrc;
				Q.Branch			<= R.Branch;
				Q.WDataMux		<= R.WDataMux;
				Q.RegWrite		<= R.RegWrite;
				Q.MemWrite		<= R.MemWrite;
				Q.MemRead		<= R.MemRead;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;
