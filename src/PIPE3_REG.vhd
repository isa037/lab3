LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library work;
use work.riscv_pkg.all;

ENTITY PIPE3_REG IS
	PORT (	R : IN pipe3_signal;
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			Q :	OUT pipe3_signal);
END PIPE3_REG;

ARCHITECTURE BEHAVIOR OF PIPE3_REG IS
BEGIN
	PROCESS (CLOCK, RESETN)
	BEGIN
		IF (RESETN = '0') THEN
			Q.BRANCH_ADDRESS	<= (OTHERS => '0');
			Q.PC_next			<= (OTHERS => '0');
			Q.ZERO				<= '0';
			Q.ALU_RESULT		<= (OTHERS => '0');
			Q.READ_DATA_2		<= (OTHERS => '0');
			--CONTROL SIGNALS
			Q.Branch					<= '0';
			Q.WDataMux		<= (others => '0');
			Q.muxALU			<= (others => '0');
			Q.RegWrite		<= '0';
			Q.MemWrite		<= '0';
			Q.MemRead		<= '0';
			Q.RD				<= (others => '0');
			
		ELSIF rising_edge(CLOCK) THEN
			IF ENABLE='1' THEN
				Q.PC_next		<= R.PC_next;
				Q.RD				<= R.RD;
				Q.BRANCH_ADDRESS	<= R.BRANCH_ADDRESS	;
				Q.ZERO				<= R.ZERO;
				Q.ALU_RESULT		<= R.ALU_RESULT;
				Q.READ_DATA_2		<= R.READ_DATA_2;
				Q.muxALU				<= R.muxALU;
				--CONTROL SIGNALS
				Q.Branch			<= R.Branch;
				Q.WDataMux		<= R.WDataMux;
				Q.RegWrite		<= R.RegWrite;
				Q.MemWrite		<= R.MemWrite;
				Q.MemRead		<= R.MemRead;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;
