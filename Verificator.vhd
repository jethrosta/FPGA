library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity Verificator is
    Port ( 
        Clk: in std_logic;
        Reset: in std_logic;
        Button1: in std_logic := '0';
        Button2: in std_logic := '0';
        Send_Active : in std_logic; 
        LED_TRUE: out std_logic := '0';
        LED_FALSE: out std_logic := '0'
--        Input_complete : out std_logic := '0'
    ); 
end Verificator;

architecture Behavioral of Verificator is
    type state_type is (idle, wait_btn_1, wait_btn_2, result_true, result_false);
    signal state : state_type := idle;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= idle;
            led_true <= '0';
            led_false <= '0';
        elsif rising_edge(clk) and Send_Active = '1' then
            case state is
                when idle =>
                    if Button1 = '1' then
                        state <= wait_btn_1;
                    elsif Button2 = '1' then
                        state <= wait_btn_2;
                    end if;
                    
                when wait_btn_1 =>
                    if Button2 = '1' then
                        state <= result_true;
                    elsif Button1 = '0' then
                        state <= idle;
                    end if;
                    
                when wait_btn_2 =>
                    if Button1 = '1' then
                        state <= result_false;
                    elsif Button2 = '0' then
                        state <= idle;
                    end if;
                    
                when result_true =>
                    led_true <= '1';
                    led_false <= '0';
--                    Input_complete <= '1';
                    if Button1 = '0' and Button2 = '0' then
                        state <= idle;
                    end if;
                    
                when result_false =>
                    led_true <= '0';
                    led_false <= '1';
--                    Input_complete <= '0';
                    if Button1 = '0' and Button2 = '0' then
                        state <= idle;
                    end if;
                    
                when others =>
                    state <= idle;
            end case;
        end if;
    end process;

end Behavioral;