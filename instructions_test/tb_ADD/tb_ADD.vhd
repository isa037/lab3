--In questo testbench carico "11011001110100100110" (con 12 zeri alla fine) in R5 poi carico "00110110101101001101" (con 12 zeri alla fine) in R10
--poi faccio R11=R5+R10

--R5+R10=R11
--11011001110100100110000000000000+00110110101101001101000000000000=100010000100001110011000000000000
--3654443008+917819392=4572262400
--ATTENZIONE, il RISC scarta il carry out (overflow is ignored) quindi il risultato corretto è
--100010000100001110011000000000000=277295104

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity tb_ADD is
end entity;

architecture tb of tb_ADD is
  
 	component RISCV_PROCESSOR is
	port (	INSTRUCTION		: in std_logic_vector(31 downto 0);--Instrucion memory output
			read_data		: in std_logic_vector(31 downto 0);--Data memory output
			
			clk,rst_n		: in 	std_logic;
			
			PC_OUT			: out std_logic_vector(31 downto 0);--Points to instruction memory
			
			MemWrite		: out std_logic;	--DM control signal (write)
			MemRead			: out std_logic;		--DM control signal (read)
			mem_address		: out std_logic_vector(31 downto 0);	--Points to DM
			data_to_write	: out std_logic_vector(31 downto 0)		--Data to be written in DM
	);
	end component;

	--Meaningful
	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	
	--MeaningLESS
	signal read_data_test, PC_OUT_test, mem_address_test,data_to_write_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test: std_logic;
	
	constant Tc: time := 2 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test, data_to_write_test);
	
	
	clk_test<=not clk_test after Tc/2;
	
	stimuli: process
	begin
		wait for 4 ns;
		rst_n_test<='0';
		wait for 2 ns;
		rst_n_test<='1';
		wait for 2 ns;
		--LUI "11011001110100100110", R5
		INSTRUCTION_test(31 downto 12)<= "11011001110100100110";		--imm field
		
		INSTRUCTION_test(11 downto 7)<="00101";  --rd: R5
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE : LUI
		wait for 2 ns;
		--LUI "00110110101101001101", R10
		INSTRUCTION_test(31 downto 12)<= "00110110101101001101";		--imm field
		
		INSTRUCTION_test(11 downto 7)<="01010";  --rd: R10
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE :LUI
		wait for 12 ns;	--ATTENZIONE ALLA DATA DEPENDECY: se aspetto 5 colpi di clock sono sicuro 100% che non ho problemi
		--ADD R11, R5, R10
		INSTRUCTION_test(31 downto 25)<=(others =>'0'); --funct7
		INSTRUCTION_test(24 downto 20)<="01010"; --rs2: R10
		INSTRUCTION_test(19 downto 15)<="00101"; --rs1: R5
		INSTRUCTION_test(14 downto 12)<="000"; --funct3
		INSTRUCTION_test(11 downto 7)<="01011"; --rd: R11
		INSTRUCTION_test(6 downto 0)<="0110011"; --OPCODE: OP (ADD) 
		wait for 2 ns;
		--NOP: ADDI x0,x0,0
		INSTRUCTION_test(31 downto 7)<= (others=> '0'); -- x0,x0,0
		INSTRUCTION_test(6 downto 0)<= "0010011"; -- ADDI OPCODE (NOP)
		wait;
		
	end process;
	
end tb;