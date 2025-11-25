library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
-- Removido o uso de std.env para compatibilidade com VHDL 93
-- use std.env.all; 

entity filter_module_tb is
end entity filter_module_tb;

architecture arch of filter_module_tb is
    signal clock: std_logic := '0'; 
    signal reset, start, write_mem, done_r, done_g, done_b, pixel_out_r, pixel_out_g, pixel_out_b: std_logic := '0';
    signal input_r, input_g, input_b, end_i, end_j, output_r, output_g, output_b: std_logic_vector(7 downto 0) := x"00";
    signal filter: std_logic_vector(1 downto 0) := "10";
begin
    MODULE_R: entity work.filter_module(arch) port map (
        clock => clock, 
        reset => reset, 
        write_mem => write_mem, 
        start => start,
        end_i => end_i,
        end_j => end_j,
        input => input_r,
        filter => filter,
        done => done_r, 
        pixel_out => pixel_out_r,
        output => output_r
    );

    MODULE_G: entity work.filter_module(arch) port map (
        clock => clock, 
        reset => reset, 
        write_mem => write_mem, 
        start => start,
        end_i => end_i,
        end_j => end_j,
        input => input_g,
        filter => filter,
        done => done_g, 
        pixel_out => pixel_out_g,
        output => output_g
    );

    MODULE_B: entity work.filter_module(arch) port map (
        clock => clock, 
        reset => reset, 
        write_mem => write_mem, 
        start => start,
        end_i => end_i,
        end_j => end_j,
        input => input_b,
        filter => filter,
        done => done_b, 
        pixel_out => pixel_out_b,
        output => output_b
    );
    
    process
        variable file_line_r, file_line_g, file_line_b: Line;
        file entrada: text open read_mode is "input.txt";
        file saida: text open write_mode is "output.txt";

        variable ii: integer := 0;

        variable pixel_r, pixel_g, pixel_b: integer;
        variable line_buffer: Line;
    begin
        reset <= '1';

        wait for 5 ns;
        reset <= '0';

        wait for 5 ns;

        clock <= '1';
        wait for 5 ns;

        -- Leitura do arquivo de entrada
        for i in 0 to 255 loop
            for j in 0 to 255 loop
                clock <= '0';
                wait for 5 ns;

                readline(entrada, file_line_r);
                readline(entrada, file_line_g);
                readline(entrada, file_line_b);
                
                read(file_line_r, pixel_r);
                read(file_line_g, pixel_g);
                read(file_line_b, pixel_b);

                end_i <= std_logic_vector(to_unsigned(i, 8));
                end_j <= std_logic_vector(to_unsigned(j, 8));
                
                input_r <= std_logic_vector(to_unsigned(pixel_r, 8));
                input_g <= std_logic_vector(to_unsigned(pixel_g, 8));
                input_b <= std_logic_vector(to_unsigned(pixel_b, 8));
                write_mem <= '1';

                clock <= '1';
                wait for 5 ns;
            end loop;
        end loop;
        file_close(entrada);

        clock <= not clock;
        
        write_mem <= '0';
        start <= '1';
        
        wait for 5 ns;
        start <= '0';

        -- Loop principal de processamento
        WHIL: while true loop
            -- ii := ii + 1;
            -- exit WHIL when ii = 25000;
            exit WHIL when done_r = '1';
            clock <= not clock;
            wait for 5 ns;
        end loop WHIL;

        report "finished";

        -- Escrita do arquivo de saída
        for i in 0 to 255 loop
            for j in 0 to 255 loop
                clock <= not clock;

                end_i <= std_logic_vector(to_unsigned(i, 8));
                end_j <= std_logic_vector(to_unsigned(j, 8));
                
                wait for 5 ns;

                -- report integer'image(j); -- Comentado para poluir menos o console

                write(line_buffer, to_integer(unsigned(output_r)));
                writeline(saida, line_buffer);
                write(line_buffer, to_integer(unsigned(output_g)));
                writeline(saida, line_buffer);
                write(line_buffer, to_integer(unsigned(output_b)));
                writeline(saida, line_buffer);

                clock <= not clock;
                wait for 5 ns;
            end loop;
        end loop;

        file_close(saida); -- Boa prática: fechar o arquivo de saída

        -- CORREÇÃO PRINCIPAL ABAIXO:
        -- Substituindo std.env.finish por assert failure
        assert false report "Simulação Finalizada com Sucesso!" severity failure;
        
        wait;
    end process;
    
end architecture arch;