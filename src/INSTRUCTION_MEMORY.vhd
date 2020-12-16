LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY INSTRUCTION_MEMORY IS
PORT(
 ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 		 						
 DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE BEH OF INSTRUCTION_MEMORY IS


--TYPE im_array IS ARRAY (4194304 TO 4194391) OF STD_LOGIC_VECTOR (7 DOWNTO 0); PRIMA DELLE NOP INSERTION
TYPE im_array IS ARRAY (4194304 TO 4194423) OF STD_LOGIC_VECTOR (7 DOWNTO 0);

SIGNAL B0_OUT, B1_OUT, B2_OUT, B3_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL im: im_array :=(
	x"00",x"70",x"08",x"13",
	x"0f",x"c1",x"02",x"17",
	x"ff",x"c2",x"02",x"13",
	x"0f",x"c1",x"02",x"97",
	x"01",x"02",x"82",x"93",
	x"40",x"00",x"06",x"b7",
	x"ff",x"f6",x"86",x"93",
	x"04",x"08",x"04",x"63",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"02",x"24",x"03",
	x"00",x"04",x"55",x"33",
	x"00",x"42",x"02",x"13",
	x"ff",x"f8",x"08",x"13",
	x"00",x"d5",x"25",x"b3",
	x"fc",x"05",x"8e",x"e3",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"05",x"06",x"b3",
	x"fc",x"9f",x"f0",x"ef",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"d2",x"a0",x"23",
	x"00",x"00",x"00",x"ef",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13",
	x"00",x"00",x"00",x"13"

);



BEGIN

	IM_check: process(ADDR)	--Controlla che il PC punti a locazioni consentite
	begin
		if (unsigned(ADDR)>4194303 AND unsigned(ADDR)< 4194424)  then
				B0_OUT <= im(TO_INTEGER(UNSIGNED(ADDR)));
				B1_OUT <= im(TO_INTEGER(UNSIGNED(ADDR))+1);
				B2_OUT <= im(TO_INTEGER(UNSIGNED(ADDR))+2);
				B3_OUT <= im(TO_INTEGER(UNSIGNED(ADDR))+3);
		else
				B0_OUT <= (others=>'0');
				B1_OUT <= (others=>'0');
				B2_OUT <= (others=>'0');
				B3_OUT <= (others=>'0');
		end if;
	end process;


 DATA_OUT <= B0_OUT & B1_OUT & B2_OUT & B3_OUT; 
 
END BEH;
