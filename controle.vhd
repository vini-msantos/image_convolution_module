library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity controle is
    port (
        reset, start, clock, write_mem: in std_logic;
        
        -- Sinais de controle:
        i_254, j_254: in std_logic;
        mi, mj, ci, cj, mjm1, cmem, ccache, cout, mread, cfilter: out std_logic;

        done, pixel_out: out std_logic := '0'
    );
end entity controle;

architecture arch of controle is
    type States is (
        S0, -- Estado inicial, inicializa o circuito
        S1, -- Permite a edição da memória, iniciar os registradores de i e j para 0, muda quando start for ativado
        S2, -- Muda j para 0, soma 1 ao i, checa se i = 254 (se sim pula para S7)
        S3, -- Ler a primeira coluna, soma 1 ao j
        S4, -- Ler a segunda coluna
        S5, -- Ler a coluna a frente do j
        S6, -- Calcula e salva na memória o resultado, soma 1 ao j no final, checa se j = 254 (se não pula para S4, se sim para S2)
        S7 -- Estado final, ativa a flag 'done' por um ciclo e depois volta para S1
    );

    signal EA, PE: States := S0;
begin

    process(clock, reset)
    begin
        if reset = '1' then
            EA <= S0;
        elsif rising_edge(clock) then
            EA <= PE;
        end if;
    end process;

    process(EA, start, i_254, j_254, write_mem)
    begin
        case(EA) is
            when S0 => 
                PE <= S1;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '0';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '0';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '0';

            when S1 =>
                if start = '1' then
                    PE <= S2;
                else
                    PE <= S1;
                end if;

                mi <= '1';
                mj <= '1';
                ci <= '1';
                cj <= '1';
                mjm1 <= '0';
                cmem <= write_mem;
                ccache <= '0';
                cout <= '0';
                mread <= '1';
                cfilter <= '1';
                done <= '0';
                pixel_out <= '0';

            when S2 =>
                if i_254 = '1' then
                    PE <= S7;
                else
                    PE <= S3;
                end if;

                mi <= '0';
                mj <= '1';
                ci <= '1';
                cj <= '1';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '0';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '0';

            when S3 =>
                PE <= S4;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '1';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '1';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '0';
            
            when S4 =>
                PE <= S5;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '0';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '1';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '0';

            when S5 =>
                PE <= S6;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '0';
                mjm1 <= '1';
                cmem <= '0';
                ccache <= '1';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '0';
            
            when S6 =>
                if j_254 = '1' then
                    PE <= S2;
                else
                    PE <= S4;
                end if;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '1';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '0';
                cout <= '1';
                mread <= '0';
                cfilter <= '0';
                done <= '0';
                pixel_out <= '1';

            when S7 =>
                PE <= S1;

                mi <= '0';
                mj <= '0';
                ci <= '0';
                cj <= '0';
                mjm1 <= '0';
                cmem <= '0';
                ccache <= '0';
                cout <= '0';
                mread <= '0';
                cfilter <= '0';
                done <= '1';
                pixel_out <= '0';
            
        end case;
    end process;      
    
end architecture arch;

