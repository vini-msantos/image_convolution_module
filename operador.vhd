-- Objetivo: executar multiplicações por constantes já pré-especificadas 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity operador is
    port (
        input: in Pixel;
        operation: in std_logic_vector(2 downto 0);
        output: out signed(13 downto 0)
    );
end entity operador;


architecture arch of operador is
    -- Codificação das operações:
    -- 000: a_ij x 0
    -- 001: a_ij x 1
    -- 010: a_ij x -1
    -- 011: a_ij x 2
    -- 100: a_ij x 4
    -- 101: a_ij x 5
begin
    with operation select output <=
        (others => '0') when "000",
        signed(resize(input, 14)) when "001",
        -signed(resize(input, 14)) when "010",
        signed(shift_left(resize(input, 14), 1)) when "011",
        signed(shift_left(resize(input, 14), 2)) when "100",
        signed(shift_left(resize(input, 14), 2) + input) when others; 
end architecture arch;