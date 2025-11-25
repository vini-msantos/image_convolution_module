library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity memoria_saida is
    port (
        address: in unsigned(15 downto 0);
        input: in Pixel;
        enable, clock, reset: in std_logic; -- Reset mantido na porta, mas ignorado na lógica interna
        output: out Pixel
    );
end entity memoria_saida;

architecture arch of memoria_saida is
    -- Inicializa com 0. Isso funciona para o power-up do FPGA.
    signal mem: Memory(0 to 65535) := (others => x"00");
begin

    process(clock)
    begin
        -- IMPORTANTE: Removemos o "if reset..." para permitir uso de Block RAM
        if rising_edge(clock) then
            -- Escrita (Write)
            if (enable = '1') then
                mem(to_integer(address)) <= input;
            end if;
            
            -- Leitura (Read) Síncrona
            -- Movida para dentro do clock para garantir inferência de RAM
            output <= mem(to_integer(address));
        end if;
    end process;

end architecture arch;