LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY DATA_MEMORY_PER_ANDI IS
PORT(
 ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
 DATA_IN: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
 RD, WR: IN STD_LOGIC; 						 
 clk: IN STD_LOGIC; 						
 DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE BEH OF DATA_MEMORY_PER_ANDI IS


SIGNAL B0_IN, B1_IN, B2_IN, B3_IN : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B0_OUT, B1_OUT, B2_OUT, B3_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);


TYPE dm_array IS ARRAY (268500992 TO 268501023) OF STD_LOGIC_VECTOR (7 DOWNTO 0);


SIGNAL dm: dm_array :=(
   x"0A", x"00", x"00", x"00", --v[0]= 10   
   x"D1", x"FF", x"FF", x"FF", --v[1]= -47
   x"16", x"00", x"00", x"00", --v[2]= 22
   x"FD", x"FF", x"FF", x"FF", --v[3]= -3
   x"0F", x"00", x"00", x"00", --v[4]= 15
   x"1B", x"00", x"00", x"00", --v[5]= 27
   x"FC", x"FF", x"FF", x"FF", --v[6]= -4
   x"01", x"F0", x"AA", x"0F"); --m;

BEGIN

 B0_IN <= DATA_IN(7 DOWNTO 0);
 B1_IN <= DATA_IN(15 DOWNTO 8);
 B2_IN <= DATA_IN(23 DOWNTO 16);
 B3_IN <= DATA_IN(31 DOWNTO 24);

	PROCESS(clk, WR, RD)
	BEGIN
		IF unsigned(ADDR)>268500991 AND unsigned(ADDR)<268501024	--Se l'indirizzo è corretto
		THEN	--Accesso consentito
			 IF(clk'EVENT AND clk = '1') THEN
				IF(WR = '1') THEN 
				dm(TO_INTEGER(UNSIGNED(ADDR))) <= B0_IN;  
				dm(TO_INTEGER(UNSIGNED(ADDR))+1) <= B1_IN;
				dm(TO_INTEGER(UNSIGNED(ADDR))+2) <= B2_IN;
				dm(TO_INTEGER(UNSIGNED(ADDR))+3) <= B3_IN;
				END IF;
			 END IF;

			IF(RD = '1') THEN
			B0_OUT <= dm(TO_INTEGER(UNSIGNED(ADDR)));
			B1_OUT <= dm(TO_INTEGER(UNSIGNED(ADDR))+1);
			B2_OUT <= dm(TO_INTEGER(UNSIGNED(ADDR))+2);
			B3_OUT <= dm(TO_INTEGER(UNSIGNED(ADDR))+3);
			END IF;
		ELSE
			--Non scrivo, leggo "0"
			IF(RD = '1') THEN
			B0_OUT <= (others=>'0');
			B1_OUT <= (others=>'0');
			B2_OUT <= (others=>'0');
			B3_OUT <= (others=>'0');
			END IF;
		END IF;
	END PROCESS;

 DATA_OUT <= B3_OUT & B2_OUT & B1_OUT & B0_OUT; 
 
END BEH;
