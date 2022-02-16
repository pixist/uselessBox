library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_pwm is
    PORT (
        clk   : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        pos   : IN  STD_LOGIC_VECTOR(9 downto 0);
        servo : OUT STD_LOGIC
    );
end servo_pwm;

architecture Behavioral of servo_pwm is
    signal cnt : unsigned(10 downto 0);
    signal pwmi: unsigned(9 downto 0);
begin
    pwmi <= unsigned(pos) + 64; --1ms
    counter: process (reset, clk) begin
        if (reset = '1') then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if (cnt = 1279) then --20ms
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    servo <= '1' when (cnt < pwmi) else '0';
end Behavioral;