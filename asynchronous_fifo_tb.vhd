library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use IEEE.math_real.uniform;
use IEEE.math_real.floor;

entity asynchronous_fifo_tb is
end asynchronous_fifo_tb;

architecture tb of asynchronous_fifo_tb is
    signal wclk, wrst_n, winc, wfull, rclk, rrst_n, rinc, rempty: std_logic;  
    signal wdata, rdata: std_logic_vector (15 downto 0);  
    signal waddr, raddr: std_logic_vector (3 downto 0);
    constant wclk_period: time := 10 ns; -- 100 MHz clock
    constant rclk_period: time := 20 ns; -- 50 MHz clock
begin
    
    uut : entity work.asynchronous_fifo port map (wclk => wclk, wrst_n => wrst_n, wdata=>wdata, winc => winc, wfull=>wfull, rclk=>rclk, rrst_n=>rrst_n, rdata=>rdata, rinc=>rinc, rempty=>rempty, waddr=>waddr, raddr=>raddr);
    
    wclk_process :process
    begin
        wclk <= '0';
        wait for wclk_period/2;  
        wclk <= '1';
        wait for wclk_period/2;  
    end process;
   
    rclk_process :process
    begin
        rclk <= '0';
        wait for rclk_period/2;  
        rclk <= '1';
        wait for rclk_period/2;  
   end process;
   
   wrst_n_process : process
   begin
        wrst_n <= '0'; 
        wait for 38 ns;   
        wrst_n <= '1'; 
        wait;                              
  end process;
  
   rrst_n_process : process
   begin
        rrst_n <= '0'; 
        wait for 348 ns;   
        rrst_n <= '1'; 
        wait;                                
  end process;
  
  winc_process : process
  begin
        winc <= '0';
        wait for 40 ns;
        for j in 0 to 1 loop
            for i in 0 to 15 loop
                winc <= '1';
                wait for 10 ns;
                winc <= '0';
                wait for 10 ns;
            end loop;
            wait for 400 ns; 
        end loop;
        wait;
  end process;
  
  rinc_process : process
  begin
        rinc <= '0';
        wait for 400 ns;
        for j in 0 to 1 loop
            for i in 0 to 15 loop
                rinc <= '1';
                wait for 20 ns;
                rinc <= '0';
                wait for 20 ns;
            end loop;
            wait for 320 ns; 
        end loop;
        wait;
  end process;
  
  wdata_process : process
  variable seed1: positive;
  variable seed2: positive;
  variable x: real;
  variable y: integer; 
  begin
        wdata <= std_logic_vector(to_signed(0, wdata'length));
        wait for 40 ns;
        for j in 0 to 1 loop
            for i in 0 to 15 loop
                uniform(seed1, seed2, x);
                y := integer(floor(x*1024.0));
                wdata <= std_logic_vector(to_signed(y, wdata'length));
                wait for 20 ns; 
            end loop;
            wait for 400 ns;
        end loop;
        wait;    
  end process;
    
end tb ;
