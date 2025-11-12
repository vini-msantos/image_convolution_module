library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity registrador is
    generic (
        N: integer := 8
    );
    port (
        input: in unsigned(N-1 downto 0);
        enable, clock, reset: in std_logic;
        output: out unsigned(N-1 downto 0)
    );
end entity registrador;

architecture arch of registrador is
    
begin
    
    process(clock, reset)
    begin
        if reset = '1' then
            output <= (others => '0');
        elsif rising_edge(clock) and (enable = '1') then
            output <= input;
        end if;
    end process;
    
end architecture arch;