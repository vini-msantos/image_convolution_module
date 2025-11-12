-- Objetivo: permitir a leitura simultânea de 3 pixels

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity memoria_entrada is
    port (
        in_b: in Pixel; -- A memória salva apenas um pixel por vez, que é dado pela entrada do meio
        end_a, end_b, end_c: in unsigned(15 downto 0);
        clock, reset: in std_logic;
        enable: in std_logic; -- Habilita o salvamento da entrada in_b no endereço end_b
        out_a, out_b, out_c: out Pixel
    );
end entity memoria_entrada;

architecture arch of memoria_entrada is
    signal mem: Memory(0 to 65535);
begin

    out_a <= mem(to_integer(end_a));
    out_b <= mem(to_integer(end_b));
    out_c <= mem(to_integer(end_c));

    process(clock, reset)
    begin
        if reset = '1' then
            mem <= (others => x"00");
        elsif rising_edge(clock) and (enable = '1') then
            mem(to_integer(end_b)) <= in_b;
        end if;
    end process;
end architecture arch;