----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/11/2020 07:14:09 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
    generic (g_CLKS_PER_BIT : integer := 10417);
    Port ( CLK : in STD_LOGIC;
           CLR : in STD_LOGIC;
           TX_DATA_VALID : in STD_LOGIC;
           TX_DATA : in STD_LOGIC_VECTOR(7 downto 0);
           TX_LINE : out STD_LOGIC;
           TX_ACTIVE : out STD_LOGIC;
           TX_DONE : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
type STATEMACHINE is ( s_idle, s_startBit, s_dataBits, s_stopBit); --, s_Cleanup);
signal state : STATEMACHINE := s_idle;
signal clkCount  : integer range 0 to g_CLKS_PER_BIT - 1 := 0;
signal dataIndex : integer range 0 to 7 := 0;
signal data      : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal done      : std_logic := '0';

begin
TX_DONE <= done;
process(CLK, CLR)
    begin
        if clr ='1' then
           state <= s_idle;    
                elsif (rising_edge(CLK)) then
                      case state is
                            when s_idle =>
                                 TX_LINE <= '1';
                                 TX_ACTIVE <= '0'; 
                                 done <= '0'; 
                                 clkCount <= 0;  
                                 dataIndex <= 0;
                                    if TX_DATA_VALID = '1' then
                                       data <= TX_DATA; 
                                       state <= s_startBit;
                                       else state <= s_idle;
                                    end if;
                            when s_startBit =>
                                 TX_ACTIVE <= '1';  
                                 TX_LINE <= '0';  
                                     if clkCount < g_CLKS_PER_BIT - 1 then
                                        clkCount <= clkCount + 1;  
                                        state <= s_startBit;
                                        else                
                                            clkCount <= 0; 
                                            state <= s_dataBits;
                                     end if;
                            when s_dataBits =>
                                 TX_LINE <= data(dataIndex); 
                                     if clkCount < g_CLKS_PER_BIT - 1 then
                                         clkCount <= clkCount + 1;  
                                         state <= s_dataBits;
                                            else                
                                                clkCount <= 0;
                                            if dataIndex < 7 then
                                                dataIndex <= dataIndex + 1;  
                                                state <= s_dataBits;
                                                else
                                                    dataIndex <= 0;  
                                                    state <= s_stopBit;
                                             end if;
                                      end if;
                            when s_stopBit =>
                                 TX_LINE <= '1';  
                                     if clkCount < g_CLKS_PER_BIT - 1 then
                                        clkCount <= clkCount + 1; 
                                        state <= s_stopBit;
                                          else
                                            clkCount <= 0; 
                                            TX_ACTIVE <= '0'; 
                                            done <= '1'; 
                                            state <= s_stopBit;
                                     end if;
--                            when s_Cleanup =>
--                               TX_ACTIVE <= '0';
--                               done <= '1';
--                               state <= s_Idle;
                            when others =>
                                 state <= s_idle;
                     end case;
               end if;
end process;
end Behavioral;
