-- Objetivo: dividir o número a depender do filtro selecionado
-- e depois truncar o valor caso exceda o limite

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity truncador_kernel is
    port (
        input: in signed(13 downto 0);
        filter_selector: in integer range 0 to 3;
        output: out Pixel
    );
end entity truncador_kernel;

architecture arch of truncador_kernel is
    signal shifted: signed(13 downto 0);
    signal under_limit: std_logic; -- Caso o número < 0
    signal above_limit: std_logic; -- Caso o número > 255
    signal limit_logic: std_logic_vector(1 downto 0); -- Junta os dois sinais para usar no select
begin
    with filter_selector select shifted <=
        input sra 4 when 2, -- Divide por 16 quando o filtro é o blur
        input when others; 

    under_limit <= shifted(13);
    above_limit <= (not under_limit) and (shifted(12) or shifted(11) or shifted(10) or shifted(9) or shifted(8));
    limit_logic <= under_limit & above_limit;

    with limit_logic select output <=
        x"00" when "10",
        x"FF" when "01",
        unsigned(shifted(7 downto 0)) when others;
end architecture arch;