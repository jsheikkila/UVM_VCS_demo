library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RegisterBank is
    Port (
        clk       : in  std_logic;               -- Clock signal
        reset     : in  std_logic;               -- Reset signal
        address   : in  std_logic_vector(7 downto 0); -- 8-bit input address
        data_in   : in  std_logic_vector(15 downto 0); -- 16-bit input data
        rw        : in  std_logic;               -- Read/Write control (1 for write, 0 for read)
        data_out  : out std_logic_vector(15 downto 0)  -- 16-bit output data
    );
end RegisterBank;

architecture Behavioral of RegisterBank is
    -- Define a register bank with 256 registers, each 16 bits wide
    type reg_array is array(0 to 255) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (others => (others => '0')); -- Initialize all registers to 0
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all registers to 0
            registers <= (others => (others => '0'));
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if rw = '1' then
                -- Write operation: Write data_in to the register at the specified address
                registers(to_integer(unsigned(address))) <= data_in(15 downto 0);
                --registers(to_integer(unsigned(address))) <= '1' & data_in(14 downto 0);

            else
                -- Read operation: Output the data from the register at the specified address
                data_out <= registers(to_integer(unsigned(address)));
            end if;
        end if;
    end process;
end Behavioral;
