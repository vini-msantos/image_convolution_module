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
    -- Inicializa com zeros para evitar lixo de memória na simulação
    signal memory: PixelMatrix3x3 := (others => (others => (others => '0')));
begin
    output <= memory;

    process(clock, reset)
    begin
        -- Reset Assíncrono (Opicional: Se não usar, pode remover este IF)
        if reset = '1' then
             memory <= (others => (others => (others => '0')));
             
        elsif rising_edge(clock) then
            -- Mudei o ENABLE para cá (Síncrono). Isso remove o Warning.
            if (enable = '1') then
                -- Shift Register (Janela Deslizante)
                -- Coluna 0 recebe Coluna 1
                memory(0, 0) <= memory(0, 1);
                memory(1, 0) <= memory(1, 1);
                memory(2, 0) <= memory(2, 1);

                -- Coluna 1 recebe Coluna 2
                memory(0, 1) <= memory(0, 2);
                memory(1, 1) <= memory(1, 2);
                memory(2, 1) <= memory(2, 2);

                -- Coluna 2 recebe novos dados
                memory(0, 2) <= in_a;
                memory(1, 2) <= in_b;
                memory(2, 2) <= in_c;
            end if;
        end if;
    end process;
    
end architecture arch;