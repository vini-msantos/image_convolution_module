-- Objetivo: executa todas as operações para calcular o pixel final a partir
-- de uma matrix de pixels e do filtro selecionado
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity calculador_pixel is
    port (
        input: PixelMatrix3x3;
        filter_selector: in integer range 0 to 3;
        output: out Pixel
    );
end entity calculador_pixel;

architecture arch of calculador_pixel is
    signal mult_out: ExtendedPixelMatrix3x3;
    signal adder_out: signed(13 downto 0);
begin
    -- Multiplica cada pixel por seu respectivo peso a depender do filtro
    Multiplicador: entity work.multiplicador_kernel(arch) port map (
        input => input,
        filter_selector => filter_selector,
        output => mult_out
    );

    -- Soma todos os valores da matriz
    Somador: entity work.somador_kernel(arch) port map (
        input => mult_out,
        output => adder_out
    );

    -- Executa uma divisão caso necessário e por fim limita o valor entre 0 e 255
    Truncador: entity work.truncador_kernel(arch) port map (
        input => adder_out,
        filter_selector => filter_selector,
        output => output
    );
end architecture arch;