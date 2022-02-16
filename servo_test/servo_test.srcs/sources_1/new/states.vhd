----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 12:57:11 AM
-- Design Name: 
-- Module Name: states - Behavioral
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


library ieee;
use ieee.std_logic_1164.all; 

entity states is
    port(
        clk, reset : in std_logic;
        servopos_a, servopos_b : out STD_LOGIC_VECTOR (9 downto 0);
        touch, lever : in STD_LOGIC;
        curr_state : out STD_LOGIC_VECTOR ( 7 downto 0);
        led : out STD_LOGIC_VECTOR ( 2 downto 0 );
        touch_enable : in STD_LOGIC
    );
end states;

architecture arch of states is 
    type state_box is (zero, edge, one, zeroToEdge, edgeToZero, anger, waitForTouch, doNotTouch );
    signal boxReg, boxNext : state_box;
    signal counter : integer range 0 to 49999; --0.5 ms for mclk
    signal ms : integer range 0 to 2000 := 750;
    signal ms_t, ms_a, ms_r, ms_ang, ms_wft, ms_dnt, ms_on : integer range 0 to 10000;
    signal ms_not_on, ms_ar : integer range 0 to 10000 := 10000;
    signal check : STD_LOGIC_VECTOR ( 1 downto 0 ); --lever counter
    signal mclk : STD_LOGIC; --ms clock
    signal touch_reg : STD_LOGIC;
    
    
    
begin     
    process(clk, reset) --state register with the rising edge
    begin   
        if (reset = '1') then
            boxReg <= zero;
        elsif (clk'event and clk = '1') then
            boxReg <= boxNext;
        else
            null;
        end if; 
    end process;
    
    process(clk, reset) --ms clock
    begin
        if reset = '1' then
            counter <= 0;
            mclk <= '0';
        elsif rising_edge(clk) then
            if counter = 49999 then
                counter <= 0;
                mclk <= not mclk;
            else
                counter <= counter +1;
            end if;
        end if;
    end process;   
           
    process(mclk, reset, lever, touch_reg) --touch and lever are not active for ... counter
    begin
        if reset = '1' or (touch_reg = '1' or lever = '1') then
            ms <= 0;
        elsif rising_edge(mclk) then
            if ms = 10000 then
                ms <= 10000;
            else
                ms <= ms +1;
            end if;
        end if;
    end process;
           
    process(mclk, reset, lever, touch_reg, boxReg) --touch and lever are active for ... counter
    begin
        if reset = '1' or (touch_reg = '0' or lever = '0' or not (boxReg = edge) ) then
            ms_dnt <= 0;
        elsif rising_edge(mclk) then
            if ms_dnt = 10000 then
                ms_dnt <= 10000;
            else
                ms_dnt <= ms_dnt +1;
            end if;
        end if;
    end process;
    
    process(mclk, reset, boxReg) --touch or lever is active for ... counter
    begin
        if reset = '1' or not ( boxReg = zeroToEdge ) then
            ms_a <= 0;
        elsif rising_edge(mclk) then
            if ms_a = 10000 then
                ms_a <= 10000;
            else
                ms_a <= ms_a + 1;
            end if;
        end if;
     end process;
     
    process(mclk, reset, lever) --lever is off for ... counter es
    begin
        if reset = '1' or lever = '1' then
            ms_ar <= 0;
        elsif rising_edge(mclk) then
            if ms_ar = 10000 then
                ms_ar <= 10000;
            else
                ms_ar <= ms_ar + 1;
            end if;
        end if;
     end process;
     
    process(mclk, reset, lever, touch_reg) --lever is on and touch is off for ... counter es
    begin
        if reset = '1' or ( lever = '0' or touch = '1' ) then
            ms_r <= 0;
        elsif rising_edge(mclk) then
            if ms_r = 10000 then
                ms_r <= 10000;
            else
                ms_r <= ms_r + 1;
            end if;
        end if;
     end process;

    process(mclk, reset, lever) --state is DNT for ... counter n
    begin
        if reset = '1' or not (boxReg = doNotTouch) then
            ms_on <= 0;
        elsif rising_edge(mclk) then
            if ms_on = 10000 then
                ms_on <= 10000;
            else
                ms_on <= ms_on + 1;
            end if;
        end if;
     end process;

    process(mclk, reset, lever) --state is not DNT for ... counter n
    begin
        if reset = '1' or boxReg = doNotTouch then
            ms_not_on <= 0;
        elsif rising_edge(mclk) then
            if ms_not_on = 10000 then
                ms_not_on <= 10000;
            else
                ms_not_on <= ms_not_on + 1;
            end if;
        end if;
     end process;

    process(mclk, reset, boxReg) --state is anger for ... counter n
    begin
        if reset = '1' or not ( boxReg = anger ) then
            ms_ang <= 0;
        elsif rising_edge(mclk) then
            if ms_ang = 10000 then
                ms_ang <= 10000;
            else
                ms_ang <= ms_ang + 1;
            end if;
        end if;
     end process;

    process(mclk, reset, boxReg) --state is waitForTouch for ... counter n
    begin
        if reset = '1' or not ( boxReg = waitForTouch ) then
            ms_wft <= 0;
        elsif rising_edge(mclk) then
            if ms_wft = 10000 then
                ms_wft <= 10000;
            else
                ms_wft <= ms_wft + 1;
            end if;
        end if;
     end process;
    
    led(2) <= '1' when check = "11" else '0'; --debugging LEDs, not a part of the design
    led(1) <= '1' when touch_reg = '1' else '0';
    led(0) <= '1' when lever = '1' else '0';
    
    touch_reg <= '0' when (ms_ar > 9999 and not ( boxReg = waitForTouch )) or touch_enable = '0' else
                 touch when ( ms_ar < 10000 or boxReg = waitForTouch ) and touch_enable = '1'; --snooze fcn
    
    process( boxReg, touch_reg, lever, mclk )
    begin
        if boxReg = zero or boxReg = doNotTouch then
            check <= "00";
        elsif ms_r = 10 and boxReg = one and rising_edge(mclk) then
            if check = "00" then
                check <= "01";
            elsif check = "01" then
                check <= "10";
            elsif check = "10" then
                check <= "11";
            end if;
        end if;
    end process;
    
    process(boxReg, touch_reg, lever, check) --moore FSM
    begin
        boxNext <= boxReg;
        case boxReg is 
            when zero =>
                curr_state <= "00010000";
                servopos_a <= "1111100000";
                servopos_b <= "0000000100";
                if lever = '1' or touch_reg = '1' then
                    boxNext <= zeroToEdge;
                end if;
            when edge =>
                curr_state <= "00000010";
                servopos_a <= "0001001110";
                servopos_b <= "0000111111";
                if touch_reg = '0' then
                    if lever = '1' then
                        boxNext <= one;
                    else
                        boxNext <= edgeToZero;
                    end if;
                elsif ms_dnt > 5000 or ms_not_on < 750 then
                        boxNext <= doNotTouch;
                end if;
            when one =>
                curr_state <= "00000001";
                servopos_a <= "0001101100";
                servopos_b <= "0000111111";
                if touch_reg = '1' or lever = '0' then
                    boxNext <= edge;
                end if;
            when zeroToEdge =>
                curr_state <= "00001000";
                servopos_a <= "1111100000";
                servopos_b <= "0000111111";
                if lever = '1' or touch_reg = '1' then
                    if (ms_a > 300) then 
                        boxNext <= edge;
                    end if; 
                else
                    boxNext <= zero;
                end if;
            when edgeToZero =>
                curr_state <= "00000100";
                servopos_a <= "1111100000";
                servopos_b <= "0000111111";
                if check = "11" then
                    boxNext <= anger;
                elsif ms < 750 then
                    if ( lever = '1' or touch_reg = '1' ) and not ( check = "11" ) then
                        boxNext <= edge;
                    end if;
                else
                    boxNext <= zero;
                end if;
            when anger =>
                curr_state <= "01000000";
                servopos_a <= "1111100000";
                if ms_ang < 751 then
                    servopos_b <= "0000111111";
                elsif ms_ang > 750 and ms_ang < 1001 then
                    servopos_b <= "0000000100";
                elsif ms_ang > 1250 and ms_ang < 1501 then
                    servopos_b <= "0000111111";
                elsif ms_ang > 1500 and ms_ang < 1751 then
                    servopos_b <= "0000000100";
                elsif ms_ang > 1750 and ms_ang < 2001 then
                    servopos_b <= "0000111111";
                elsif ms_ang > 2000 then
                    servopos_b <= "0000000100";
                    if lever = '1' then
                        boxNext <= waitForTouch;
                    end if;
                end if;
            when waitForTouch =>
                curr_state <= "00100000";
                servopos_a <= "1111100000";
                servopos_b <= "0000000100";
                if ms_wft > 750 and touch_reg = '1' then
                    boxNext <= zero;
                end if;
            when doNotTouch =>
                curr_state <= "10000000";
                servopos_a <= "1111100000";
                if ms_on < 751 then
                    servopos_b <= "0000111111";
                elsif ms_on > 750 then
                    servopos_b <= "0000000100";
                    if ms_on > 1750 and touch_reg = '0' then
                        boxNext <= zero;
                    end if;
                end if;
        end case; 
    end process;  
end arch; 
