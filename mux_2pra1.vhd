library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_2pra1 is
    generic (
        N: integer := 8
    );
    port (
        in_0, in_1: in unsigned(N-1 downto 0);
        sel: in std_logic;
        output: out unsigned(N-1 downto 0)
    );
end entity mux_2pra1;

architecture arch of mux_2pra1 is
    
begin
    with sel select output <=
        in_0 when '0',
        in_1 when others;
end architecture arch;