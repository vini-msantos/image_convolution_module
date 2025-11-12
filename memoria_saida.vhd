library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity memoria_saida is
    port (
        address: in unsigned(15 downto 0);
        input: in Pixel;
        enable, clock, reset: in std_logic;
        output: out Pixel
    );
end entity memoria_saida;

architecture arch of memoria_saida is
    signal mem: Memory(0 to 65535);
begin
    output <= mem(to_integer(address));

    process(clock, reset)
    begin
        if reset = '1' then
            mem <= (others => x"00");
        elsif rising_edge(clock) and (enable = '1') then
            mem(to_integer(address)) <= input;
        end if;
    end process;
end architecture arch;