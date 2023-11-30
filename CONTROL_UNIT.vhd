library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Input_complete : in std_logic; 
        LED_TRUE : in std_logic;
        Buff_masukan_Active : out STD_LOGIC; -- masuk case
        Send_Active : out STD_LOGIC; -- masuk case
        TX_Data_Valid : out STD_LOGIC; -- masuk case
        Sys_Reset : out STD_LOGIC -- masuk case
--        TX_DONE : out STD_LOGIC
    );
end control_unit;

architecture Behavioral of control_unit is
--membuat state 
subtype jalankan_state is natural range 1 to 4; 
signal state : jalankan_state := 1;

begin
    process(clk, reset, state)
        begin
            case state is 
                    when 1 => -- Key in UART_RX from IPC STECHOQ
                            Buff_masukan_Active <= '1';
                            Send_Active <= '0';
                            TX_Data_Valid <= '0';
                            Sys_Reset <= '0';
--                            TX_DONE <= '0';
                            
                    when 2 => -- Input kombinasi button
                            Buff_masukan_Active <= '0';
                            Send_Active <= '1';
                            TX_Data_Valid <= '0';
                            Sys_Reset <= '0';
--                            TX_DONE <= '0';
                            
                    when 3 => -- Key out UART TX to JETSON NANO
                            Buff_masukan_Active <= '0';
                            Send_Active <= '0';
                            TX_Data_Valid <= '1';
                            Sys_Reset <= '0';
--                            TX_DONE <= '1';
                            
                    when 4 => -- RESET
                            Buff_masukan_Active <= '0';
                            Send_Active <= '0';
                            TX_Data_Valid <= '0';
                            Sys_Reset <= '1';   
--                            TX_DONE <= '0';                         
            end case; 
        
        if (Reset = '1') then state <= 4;
        elsif clk'event and clk = '1' then
            case state is 
                when 1 => if Input_complete = '1' then state  <= 2; else state <= 1; end if;
                when 2 => if LED_TRUE = '1' then state <= 3; else state <= 2; end if;
                when 3 => state <= 3;
                when 4 => state <= 1;
            end case;
       else
       end if;
    end process;
end Behavioral;