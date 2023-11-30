----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2021 10:13:59 PM
-- Design Name: 
-- Module Name: BUFF_MASUKAN_CONV_CUST - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BUFF_MASUKAN is
  generic (n : integer :=7);
  Port (
    Data_in : in std_logic_vector(n downto 0);
    RX_DATA_VALID : in STD_LOGIC;
    Clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Buff_masukan_Active : in STD_LOGIC;
    Input_complete : out std_logic := '0';
    Data_Out : out STD_LOGIC_VECTOR(n downto 0) := (others => '0')
  );
end BUFF_MASUKAN;

architecture Behavioral of BUFF_MASUKAN is
--Signal UART ke masukan--
--type t_Input is array (0 to 8) of std_logic_vector(n downto 0);
signal Masukan : std_logic_vector(n downto 0);
--signal Data_out_buff : std_logic_vector(n downto 0) := (Others=>'0');
--signal kendali

--signal luaran
--signal s_Input_Conv_0 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_1 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_2 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_3 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_4 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_5 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_6 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_7 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');
--signal s_Input_Conv_8 : STD_LOGIC_VECTOR (n downto 0) := (Others=>'0');

begin

Masukan_ke_memori : process(Clk, reset)
variable i : integer range 0 to 1 := 0;
begin
if reset = '1' then i:=0; Input_complete <= '0'; Masukan <= (others =>'0');
else
if(rising_edge(Clk) AND Buff_masukan_Active = '1' AND RX_DATA_VALID = '1') then
        if(i<1) then
            masukan <= DATA_IN;
            i := i+1;
            if(i=1) then 
                Input_complete <= '1';
            else end if;
         else end if;
    else end if;
end if;
end process;

Data_Out <= Masukan;

end Behavioral;
