LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity FORWARDING_UNIT is
port(	Rs1, Rs2: in   std_logic_vector(4 downto 0);
	rd_EX_MEM:in   std_logic_vector(4 downto 0);
	rd_MEM_WB:in   std_logic_vector(4 downto 0);
	RegWrite_EX_MEM, RegWrite_MEM_WB: in std_logic;
	AluOp_EX_MEM: ALU_OPERATION;
	ForwardA, ForwardB: out std_logic_vector(2 downto 0));
end entity;

architecture beh of FORWARDING_UNIT is

begin

	A_forward: process(Rs1, Rs2, rd_EX_MEM, RegWrite_MEM_WB,RegWrite_EX_MEM,rd_MEM_WB,AluOP_EX_MEM)
	begin
		if Rs1=rd_EX_MEM and RegWrite_EX_MEM='1' and  unsigned(rd_EX_MEM) /= 0	--Se è un hazard nella EX
		then
			case AluOP_EX_MEM is
				when LUI =>
							ForwardA<="011";	--From sum_input2 (sampled by pipe 3)
				when AUIPC=>
							ForwardA<="100";		--From AddSum
				when others=>
							ForwardA<="010";	--From ALU
			end case;
		elsif Rs1=rd_MEM_WB and RegWrite_MEM_WB='1' and  unsigned(rd_MEM_WB) /= 0	--Se è un hazard nella MEM
		then
			ForwardA<="001";	--Form MEM
		else
			ForwardA<="000";	--Normal operation (from RF)
		end if;
	end process;
	
	B_forward: process(Rs1, Rs2, rd_EX_MEM, RegWrite_MEM_WB,RegWrite_EX_MEM,rd_MEM_WB,AluOP_EX_MEM)
	begin
		if Rs2=rd_EX_MEM and RegWrite_EX_MEM='1' and  unsigned(rd_EX_MEM) /= 0
		then
			case AluOP_EX_MEM is
				when LUI =>
							ForwardB<="011";	--From sum_input2 (sampled by pipe 3)
				when AUIPC=>
							ForwardB<="100";		--From AddSum
				when others=>
							ForwardB<="010";	--From ALU
			end case;
		elsif Rs2=rd_MEM_WB and RegWrite_MEM_WB='1' and  unsigned(rd_MEM_WB) /= 0
		then
			ForwardB<="001";	--Form MEM
		else
			ForwardB<="000";	--Normal operation (from RF)
		end if;
	end process;

end beh;