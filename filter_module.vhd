-- Top Level Entity
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity filter_module is
    port (
        clock, reset, write_mem, start: in std_logic;
        end_i, end_j, input: in std_logic_vector(7 downto 0);
        filter: in std_logic_vector(1 downto 0);
        done, pixel_out: out std_logic := '0';
        output: out std_logic_vector(7 downto 0)
    );
end entity filter_module;

architecture arch of filter_module is
    signal mi, mj, ci, cj, mjm1, cmem, ccache, cout, mread, i_254, j_254, cfilter: std_logic;
begin
    DATAPATH: entity work.datapath(arch) port map (
        reset => reset,
        clock => clock,
        std_logic_vector(output) => output,
        input => unsigned(input),
        in_i => unsigned(end_i),
        in_j => unsigned(end_j),
        i_254 => i_254,
        j_254 => j_254,
        filter => unsigned(filter),
        cfilter => cfilter,
        mi => mi, 
        mj => mj, 
        ci => ci, 
        cj => cj, 
        mjm1 => mjm1, 
        cmem => cmem, 
        ccache => ccache, 
        cout => cout,
        mread => mread
    );

    CONTROL: entity work.controle(arch) port map (
        reset => reset,
        start => start,
        clock => clock,
        write_mem => write_mem,
        cfilter => cfilter,
        pixel_out => pixel_out,
        i_254 => i_254,
        j_254 => j_254,
        done => done,
        mi => mi, 
        mj => mj, 
        ci => ci, 
        cj => cj, 
        mjm1 => mjm1, 
        cmem => cmem, 
        ccache => ccache, 
        cout => cout,
        mread => mread
    );
end architecture arch;