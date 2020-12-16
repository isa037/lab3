LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library work;
use work.riscv_pkg.all;

ENTITY PIPE4_REG IS
	PORT (	R : IN pipe4_signal;
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			Q :	OUT pipe4_signal);
END PIPE4_REG;

ARCHITECTURE BEHAVIOR OF PIPE4_REG IS
BEGIN
	PROCESS (CLOCK, RESETN)
	BEGIN
		IF (RESETN = '0') THEN
			Q.BRANCH_ADDRESS	<= (others => '0');
			Q.ALU_RESULT		<= (others => '0');
			Q.PC_next			<= (others => '0');
			Q.read_data 	<= (others => '0');
			Q.WDataMux		<= (others => '0');
			Q.muxALU		<= (others => '0');
			Q.RD				<= (others => '0');

			Q.RegWrite		<= '0';
		ELSIF rising_edge(CLOCK) THEN
			IF ENABLE='1' THEN
				Q.PC_next			<= R.PC_next;
				Q.RD				<= R.RD;
				Q.muxALU			<= R.muxALU;
				Q.BRANCH_ADDRESS	<= R.BRANCH_ADDRESS;
				Q.ALU_RESULT 		<= R.ALU_RESULT;
				Q.read_data 		<= R.read_data;
				Q.WDataMux 			<= R.WDataMux;
				Q.RegWrite 			<= R.RegWrite;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;
