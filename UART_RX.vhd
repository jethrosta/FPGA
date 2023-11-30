----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2020 09:32:46 PM
-- Design Name: 
-- Module Name: uartrxtx - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_rx is
    generic (g_CLKS_PER_BIT : integer := 10417; --100Mhz/9600 = 10417
             g_CLKS_PER_HALF_BIT : integer := 5208 ); -- 10417/2
    Port ( CLK : in STD_LOGIC;
           CLR : in STD_LOGIC;
           RX_LINE : in STD_LOGIC;
           RX_DATA_VALID : out  STD_LOGIC;
           RX_DATA : out  STD_LOGIC_VECTOR(7 downto 0));
end uart_rx;

architecture Behavioral of uart_rx is
type STATEMACHINE is (s_idle, s_startBit, s_dataBits, s_stopBit);--, s_Cleanup);
signal state : STATEMACHINE := s_idle;
signal clkCount  : integer range 0 to g_CLKS_PER_BIT - 1 := 0;
signal dataIndex : integer range 0 to 7 := 0;
signal data      : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal dataValid : std_logic := '0';

begin
process(CLK, CLR)
begin
    if CLR = '1' then state <=  s_idle;
        elsif (rising_edge(CLK)) then
            case state is
                when s_idle => dataValid <= '0';
                     clkCount <= 0;
                     dataIndex <= 0;
                     if RX_LINE = '0' then state <= s_startBit;
                        else state <= s_idle;
                     end if;
                when s_startBit =>
                     if clkCount = g_CLKS_PER_HALF_BIT then
                        if RX_LINE = '0' then
                            clkCount <= 0;
                            state <= s_dataBits;
                            else state <= s_idle;
                            end if;
                        else 
                            clkCount <= clkCount + 1;
                            state <= s_startBit;
                        end if;
                when s_dataBits =>
                    if clkCount < g_CLKS_PER_BIT - 1 then
                        clkCount <= clkCount + 1; 
                        state <= s_dataBits;
                        else clkCount <= 0; 
                             data(dataIndex) <= RX_LINE;
                             if dataIndex < 7 then 
                                dataIndex <= dataIndex + 1;
                                state <= s_dataBits;
                                else dataIndex <= 0; 
                                     state <= s_stopBit;
                                end if;
                             end if;
                when s_stopBit =>
                    if clkCount < g_CLKS_PER_BIT - 1 then
                        clkCount <= clkCount + 1; 
                        state <= s_stopBit;
                        else dataValid <= '1'; 
                             clkCount <= 0; 
                             state <= s_idle;
                    end if;
--                when s_Cleanup =>
--                    state <= s_idle;
--                    dataValid <= '0';
                when others => 
                    state <= s_idle;
           end case;
     end if;
end process; 
RX_DATA_VALID <= dataValid;
RX_DATA <= data;       
end Behavioral;

