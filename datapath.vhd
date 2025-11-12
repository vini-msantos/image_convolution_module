library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity datapath is
    port (
        input: in Pixel;
        in_i, in_j: in unsigned(7 downto 0);
        clock, reset: in std_logic;
        filter: in unsigned(1 downto 0);
        output: out Pixel;
        -- Sinais de controle:
        mi, mj, ci, cj, mjm1, cmem, ccache, cout, mread, cfilter: in std_logic;
        i_254, j_254: out std_logic := '0'
    );
end entity datapath;

architecture arch of datapath is
    signal i, j, pi, pj, jm1, col: unsigned(7 downto 0) := x"00"; -- pi -> próximo i; jm1 -- j + 1;
    signal end_a, end_b, end_c, new_end_b, end_out: unsigned(15 downto 0) := x"0000";
    signal out_a, out_b, out_c, mem_out, out_pixel: Pixel := x"00";
    signal matrix: PixelMatrix3x3;
    signal selected: integer range 0 to 3 := 0;
begin
    jm1 <= j + 1;

    i_254 <= '1' when i = x"FE" else '0'; -- checa se é igual à 254
    j_254 <= '1' when j = x"FE" else '0';

    REG_FILTER: entity work.registrador_integer(arch) generic map (N => 2) port map (
        clock => clock,
        reset => reset,
        enable => cfilter,
        input => to_integer(filter),
        output => selected
    );

    MUX_I: entity work.mux_2pra1(arch) generic map (N => 8) port map (
        in_0 => (i + 1),
        in_1 => x"00",
        sel => mi,
        output => pi
    );

    MUX_J: entity work.mux_2pra1(arch) generic map (N => 8) port map (
        in_0 => jm1,
        in_1 => x"00",
        sel => mj,
        output => pj
    );

    REG_I: entity work.registrador(arch) generic map (N => 8) port map (
        clock => clock,
        reset => reset,
        enable => ci,
        input => pi,
        output => i
    );

    REG_J: entity work.registrador(arch) generic map (N => 8) port map (
        clock => clock,
        reset => reset,
        enable => cj,
        input => pj,
        output => j
    );

    MUX_COL: entity work.mux_2pra1(arch) generic map (N => 8) port map (
        in_0 => jm1,
        in_1 => j,
        sel => mjm1,
        output => col
    );

    END_COL: entity work.enderecos_coluna(arch) port map (
        col => col,
        row => i,
        end_a => end_a,
        end_b => end_b,
        end_c => end_c
    );

    MUX_READ_OR_WRITE: entity work.mux_2pra1(arch) generic map (N => 16) port map (
        in_0 => end_b,
        in_1 => (in_i & in_j),
        sel => cmem,
        output => new_end_b
    );

    MEM: entity work.memoria_entrada(arch) port map (
        in_b => input,
        end_a => end_a,
        end_b => new_end_b,
        end_c => end_c,
        clock => clock,
        reset => reset,
        enable => cmem,
        out_a => out_a, 
        out_b => out_b, 
        out_c => out_c
    );

    CACHE: entity work.memoria_cache(arch) port map (
        in_a => out_a,
        in_b => out_b,
        in_c => out_c,
        clock => clock,
        reset => reset,
        enable => ccache,
        output => matrix
    );
    
    CALC_PIXEL: entity work.calculador_pixel(arch) port map (
        input => matrix,
        filter_selector => selected,
        output => out_pixel
    );

    MUX_END_OUT: entity work.mux_2pra1(arch) generic map (N => 16) port map (
        in_0 => (i & j),
        in_1 => (in_i & in_j),
        sel => mread,
        output => end_out
    );

    OUT_MEM: entity work.memoria_saida(arch) port map (
        input => out_pixel,
        clock => clock,
        reset => reset,
        enable => cout,
        address => end_out,
        output => mem_out
    );
    
    MUX_OUT: entity work.mux_2pra1(arch) generic map (N => 8) port map (
        in_0 => out_pixel,
        in_1 => mem_out,
        sel => mread,
        output => output
    );
end architecture arch;