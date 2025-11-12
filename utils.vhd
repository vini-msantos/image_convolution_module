library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

package utils is
    type PixelMatrix3x3 is array (0 to 2, 0 to 2) of unsigned(7 downto 0);
    type ExtendedPixelMatrix3x3 is array (0 to 2, 0 to 2) of signed(13 downto 0);
    subtype Pixel is unsigned(7 downto 0);
    type Memory is array (integer range <>) of Pixel;
end package utils;