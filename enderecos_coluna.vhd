library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enderecos_coluna is
    port (
        col: in unsigned(7 downto 0);
        row: in unsigned(7 downto 0);
        end_a, end_b, end_c: out unsigned(15 downto 0)
    );
end entity enderecos_coluna;

architecture arch of enderecos_coluna is
begin
    end_a <= (row-1) & col;
    end_b <= row & col;
    end_c <= (row+1) & col;
end architecture arch;