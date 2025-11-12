library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity memoria_cache is
    port (
        enable, clock, reset: in std_logic;
        in_a, in_b, in_c: in Pixel;
        output: out PixelMatrix3x3
    );
end entity memoria_cache;

architecture arch of memoria_cache is
    signal memory: PixelMatrix3x3;
begin
    output <= memory;

    process(clock, reset)
    begin
        if reset = '1' then
            
        elsif rising_edge(clock) and (enable = '1') then
            memory(0, 0) <= memory(0, 1);
            memory(1, 0) <= memory(1, 1);
            memory(2, 0) <= memory(2, 1);

            memory(0, 1) <= memory(0, 2);
            memory(1, 1) <= memory(1, 2);
            memory(2, 1) <= memory(2, 2);

            memory(0, 2) <= in_a;
            memory(1, 2) <= in_b;
            memory(2, 2) <= in_c;
        end if;
    end process;
    
end architecture arch;