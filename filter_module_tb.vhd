library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity filter_module_tb is
end entity filter_module_tb;

architecture arch of filter_module_tb is
    signal clock: std_logic := '0'; 
    signal reset, start, write_mem, done, pixel_out: std_logic := '0';
    signal input, end_i, end_j, output: std_logic_vector(7 downto 0) := x"00";
    signal filter: std_logic_vector(1 downto 0) := "01";
begin
    MODULE: entity work.filter_module(arch) port map (
        clock => clock, 
        reset => reset, 
        write_mem => write_mem, 
        start => start,
        end_i => end_i,
        end_j => end_j,
        input => input,
        filter => filter,
        done => done, 
        pixel_out => pixel_out,
        output => output
    );
    
    process
        variable file_line: Line;
        file entrada: text open read_mode is "input.txt";
        file saida: text open write_mode is "output.txt";

        variable ii: integer := 0;

        variable pixel: integer;
        variable line_buffer: Line;
    begin
        reset <= '1';

        wait for 5 ns;
        reset <= '0';

        wait for 5 ns;



        clock <= '1';
        wait for 5 ns;

        for i in 0 to 255 loop
            for j in 0 to 255 loop
                clock <= '0';
                wait for 5 ns;

                readline(entrada, file_line);
                
                read(file_line, pixel);

                end_i <= std_logic_vector(to_unsigned(i, 8));
                end_j <= std_logic_vector(to_unsigned(j, 8));
                
                input <= std_logic_vector(to_unsigned(pixel, 8));
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

        
        WHIL: while true loop
            -- ii := ii + 1;

            -- exit WHIL when ii = 25000;
            exit WHIL when done = '1';
            clock <= not clock;
            wait for 5 ns;
        end loop WHIL;

        report "finished";

        for i in 0 to 255 loop
            for j in 0 to 255 loop
                clock <= not clock;

                end_i <= std_logic_vector(to_unsigned(i, 8));
                end_j <= std_logic_vector(to_unsigned(j, 8));
                
                wait for 5 ns;

                report integer'image(j);

                write(line_buffer, to_integer(unsigned(output)));
                writeline(saida, line_buffer);
                

                clock <= not clock;
                wait for 5 ns;
            end loop;
        end loop;

        std.env.finish;
        wait;
    end process;
    
end architecture arch;