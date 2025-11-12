-- Objetivo: multiplicar os valores de entrada de acordo com o filtro selecionado

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity multiplicador_kernel is
    port (
        -- Entradas em notação de matriz (a_ij)
        input: in PixelMatrix3x3;

        -- Seletor do filtro que será utilizado: 
        -- 00: bypass (não aplicará filtro nenhum)
        -- 01: sharpen (aumenta a nítidez da imagem)
        -- 10: blur (borra a imagem)
        -- 11: edge detection (imagem com as bordas destacadas)
        filter_selector: in integer range 0 to 3;

        -- Saídas
        output: out ExtendedPixelMatrix3x3
    );
end multiplicador_kernel;

architecture arch of multiplicador_kernel is
    type Kernel is array (0 to 2, 0 to 2) of std_logic_vector(2 downto 0);
    type KernelList is array (0 to 3) of Kernel;

    -- Codificação das operações:
    -- 000: a_ij x 0
    -- 001: a_ij x 1
    -- 010: a_ij x -1
    -- 011: a_ij x 2
    -- 100: a_ij x 4
    -- 101: a_ij x 5
    constant BYPASS: Kernel := (
        ("000", "000", "000"),
        ("000", "001", "000"),
        ("000", "000", "000")
    );

    constant SHARPEN: Kernel := (
        ("000", "010", "000"),
        ("010", "101", "010"),
        ("000", "010", "000")
    );

    constant BLUR: Kernel := (
        ("001", "011", "001"),
        ("011", "100", "011"),
        ("001", "011", "001")
    );

    constant EDGE_DETECTION: Kernel := (
        ("000", "010", "000"),
        ("010", "100", "010"),
        ("000", "010", "000")
    );

    constant FILTERS: KernelList := (
        BYPASS, SHARPEN, BLUR, EDGE_DETECTION
    );

begin
    ROW: for i in 0 to 2 generate
        COL: for j in 0 to 2 generate
            Operator: entity work.operador(arch) port map (
                input => input(i, j),
                operation => FILTERS(filter_selector)(i, j),
                output => output(i, j) 
            );
        end generate COL;
    end generate ROW;
end architecture arch;