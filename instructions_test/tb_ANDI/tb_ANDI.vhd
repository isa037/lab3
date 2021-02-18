--ATTENZIONE, L'INDIRIZZO DI PARTENZA DELLA MEMORIA DATI E' CAMBIATO. QUESTO PROGRAMMA NON PESCA PIU'
--LA PENULTIMA RIGA DELLA MEMORIA, MA L'ULTIMA (che è fatta di soli zeri)
--In questo testbench carico la penultima della memoria in R1 e la metto in AND con "110110011101" (con 20 uni all'inizio)
--il risultato lo memorizzo in R20

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity tb_ANDI is
end entity;

architecture tb of tb_ANDI is
  
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
	
	component DATA_MEMORY_PER_ANDI is
	port(
	 ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	 DATA_IN: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	 RD, WR: IN STD_LOGIC; 						 
	 clk: IN STD_LOGIC; 						
	 DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	end component;


	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	signal read_data_test, PC_OUT_test, mem_address_test,data_to_write_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test: std_logic;
	
	constant Tc: time := 2 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test, data_to_write_test);
	
	dm_test: DATA_MEMORY_PER_ANDI
		port map (mem_address_test, data_to_write_test, MemRead_test, MemWrite_test, clk_test, read_data_test);


	clk_test<=not clk_test after Tc/2;
	
	stimuli: process
	begin
		wait for 4 ns;
		rst_n_test<='0';
		wait for 2 ns;
		rst_n_test<='1';
		wait for 2 ns;
		--LUI carica base per lettura dalla memoria
		INSTRUCTION_test(31 downto 12)<= "00010000000000010000" ;		--imm field
		
		INSTRUCTION_test(11 downto 7)<="01110";  --rd:R14
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE: LUI
		wait for 12 ns; --DATA DEPENDENCY wait
		--LW R1, R14, offset
		INSTRUCTION_test(31 downto 20)<="000000011100"; --offset (28)
		INSTRUCTION_test(19 downto 15)<="01110";  --rs1 (base):R14
		INSTRUCTION_test(14 downto 12)<="010"; --funct3: LW
		INSTRUCTION_test(11 downto 7)<="00001"; --rd: R1
		INSTRUCTION_test(6 downto 0)<="0000011"; --OPCODE: LW
		wait for 12 ns;	--ATTENZIONE ALLA DATA DEPENDECY
		--ANDI R20, R1, "110110011101"
		INSTRUCTION_test(31 downto 20)<="010110011101"; --imm[11:0]
		INSTRUCTION_test(19 downto 15)<="00001"; --rs1: R1
		INSTRUCTION_test(14 downto 12)<="111"; --funct3
		INSTRUCTION_test(11 downto 7)<="10100"; --rd: R20
		INSTRUCTION_test(6 downto 0)<="0010011"; --OPCODE: OP_IMM (ANDI)
		wait for 2 ns;
		--NOP: ADDI x0,x0,0
		INSTRUCTION_test(31 downto 7)<= (others=> '0'); -- x0,x0,0
		INSTRUCTION_test(6 downto 0)<= "0010011"; -- ADDI OPCODE (NOP)
		wait;
		
	end process;
	
end tb;