library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity truncador_kernel is
    port (
        input: in signed(13 downto 0);
        filter_selector: in integer range 0 to 3;
        output: out Pixel -- Assumindo que Pixel é unsigned(7 downto 0) no utils
    );
end entity truncador_kernel;

architecture arch of truncador_kernel is
    signal shifted: signed(13 downto 0);
    signal under_limit: std_logic;
    signal above_limit: std_logic;
    signal limit_logic: std_logic_vector(1 downto 0);
begin
    -- CORREÇÃO AQUI: uso de shift_right
    with filter_selector select shifted <=
        shift_right(input, 4) when 2, -- Divide por 16 (shift aritmético)
        input when others; 

    under_limit <= shifted(13);
    
    -- Lógica para verificar se estourou 255 (bits superiores não podem ser 1 se for positivo)
    above_limit <= (not under_limit) and (shifted(12) or shifted(11) or shifted(10) or shifted(9) or shifted(8));
    
    limit_logic <= under_limit & above_limit;

    with limit_logic select output <=
        x"00" when "10", -- Se under_limit (negativo), trava em 0
        x"FF" when "01", -- Se above_limit (estourou), trava em 255
        unsigned(shifted(7 downto 0)) when others; -- Caso normal
        
end architecture arch;