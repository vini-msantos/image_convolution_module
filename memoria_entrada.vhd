library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity memoria_entrada is
    port (
        in_b: in Pixel; 
        end_a, end_b, end_c: in unsigned(15 downto 0);
        clock, reset: in std_logic;
        enable: in std_logic; 
        out_a, out_b, out_c: out Pixel
    );
end entity memoria_entrada;

architecture arch of memoria_entrada is
    -- Definimos o tamanho explicitamente aqui para garantir
    -- Se sua placa for pequena (ex: DE0-Nano), reduza 65535 para 4096 para testar!
    type Memory_Array is array(0 to 65535) of Pixel;
    
    -- CRIAMOS 3 BANCOS DE MEMÓRIA (CÓPIAS)
    -- Isso permite ler 3 endereços diferentes ao mesmo tempo
    signal mem_bank_a : Memory_Array := (others => (others => '0'));
    signal mem_bank_b : Memory_Array := (others => (others => '0'));
    signal mem_bank_c : Memory_Array := (others => (others => '0'));
    
begin

    process(clock)
    begin
        if rising_edge(clock) then
            -- ESCRITA: Escrevemos o MESMO dado nos 3 bancos
            if (enable = '1') then
                mem_bank_a(to_integer(end_b)) <= in_b;
                mem_bank_b(to_integer(end_b)) <= in_b;
                mem_bank_c(to_integer(end_b)) <= in_b;
            end if;

            -- LEITURA SÍNCRONA (Essencial para Block RAM)
            -- Cada saída lê de seu próprio banco exclusivo
            out_a <= mem_bank_a(to_integer(end_a));
            out_b <= mem_bank_b(to_integer(end_b));
            out_c <= mem_bank_c(to_integer(end_c));
        end if;
    end process;
    
end architecture arch;