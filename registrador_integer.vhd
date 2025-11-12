library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity registrador_integer is
    generic (
        N: integer := 8
    );
    port (
        input: in integer range 0 to (2**N)-1;
        enable, clock, reset: in std_logic;
        output: out integer range 0 to (2**N)-1
    );
end entity registrador_integer;

architecture arch of registrador_integer is
    
begin
    
    process(clock, reset)
    begin
        if reset = '1' then
            output <= 0;
        elsif rising_edge(clock) and (enable = '1') then
            output <= input;
        end if;
    end process;
    
end architecture arch;