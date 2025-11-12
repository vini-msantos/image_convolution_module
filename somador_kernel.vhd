-- Objetivo: somar os valores resultantes do multiplicador, e limitar o valor entre 0 e 255

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity somador_kernel is
    port (
        input: in ExtendedPixelMatrix3x3;
        output: out signed(13 downto 0)
    );
end entity somador_kernel;

architecture arch of somador_kernel is
begin
    output <= 
        input(0, 0) + input(0, 1) + input(0, 2) + 
        input(1, 0) + input(1, 1) + input(1, 2) + 
        input(2, 0) + input(2, 1) + input(2, 2);

end architecture arch;

    -- signed(input(0, 0)) + signed(input(0, 1)) + signed(input(0, 2)) + 
    -- signed(input(1, 0)) + signed(input(1, 1)) + signed(input(1, 2)) + 
    -- signed(input(2, 0)) + signed(input(2, 1)) + signed(input(2, 2));
