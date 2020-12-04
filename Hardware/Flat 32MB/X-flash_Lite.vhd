-- X-flash 
-- Simple cartridge in 32MB Mode
-- X-death 12/2020
-- pinout & name based on https://plutiedev.com/cartridge-slot
	 
LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL; 
                  
ENTITY Xflash is                                        
     PORT(
	   
        --Megadrive pin declaration

		  MD_ADDR_L:OUT STD_LOGIC_VECTOR (4 DOWNTO 1); --Low Part of the Megadrive address bus
		  MD_ADDR_H:IN STD_LOGIC_VECTOR (22 DOWNTO 19); --High Part of the Megadrive address bus
		  
	      MD_DQ:OUT STD_LOGIC_VECTOR (15 DOWNTO 0);  --Megadrive Data	  
		  MD_OE:IN STD_LOGIC;    --Acts as /OE signal for 68K Bus
		  MD_CE:IN STD_LOGIC;    --Acts as /CE signal for 68K Bus
		  
		  MD_VCLK:IN STD_LOGIC;    --68K Clock
		  
		  MD_LWR:IN STD_LOGIC;     --Write enable for lower byte of a word
		  MD_UWR:IN STD_LOGIC;     --Write enable for upper byte of a word 
		  MD_TIME:IN STD_LOGIC;    --Chip enable for $A13000-$A130FF
		  
		  MD_VRES:OUT STD_LOGIC;    --Acts as Soft reset only reset the CPUs and YM2612 (but not the VDP and PSG)
		  MD_MARK3:OUT STD_LOGIC;    --Force Mark 3 (Master System) mode when low
		 
		  -- 64Mb Flash Part
							
		  FLASH_ADDR : OUT STD_LOGIC_VECTOR (22 DOWNTO 19); --High Part of the Flash address bus
		  FLASH_WE   : OUT STD_LOGIC; --Acts as /WE signal for Flash Chip
		  FLASH_CE   : OUT STD_LOGIC; --Acts as /CE signal for Flash Chip
		  FLASH_OE   : OUT STD_LOGIC; --Acts as /OE signal for Flash Chip
          FLASH_RYBY : IN STD_LOGIC; --Read/Busy Output from Flash chip
          FLASH_BYTE : OUT STD_LOGIC; --Word/Byte Selection Input ( VIH = word VIL = byte)
          FLASH_ACC  : OUT STD_LOGIC; --Hardware Write Protect/ProgrammingAcceleration Input
	      FLASH_RESET  : OUT STD_LOGIC; --Acts as Reset for flash memory			
		  		  
		  --Extras pin declaration
			
	      BUFF_DIR:OUT STD_LOGIC;    --Used for control Level Shifter direction
		  
		   SPI_CLK:OUT STD_LOGIC;    --SPI Signal Clock
		   SPI_MISO :IN STD_LOGIC;   --IN Data CPLD < OUT Data SPI Slave
		   SPI_MOSI :OUT STD_LOGIC;   --OUT Data CPLD > IN Data SPI Slave
		   SPI_CE :OUT STD_LOGIC;     --Acts as /CE signal for SPI Slave
			
		   SERIAL_RX :IN STD_LOGIC;     --IN Data CPLD < OUT Data Serial Slave
		   SERIAL_TX :OUT STD_LOGIC;     --OUT Data CPLD > IN Data Serial Slave
		   SERIAL_RTS :OUT STD_LOGIC;     --Flow control pin for Serial
	       SERIAL_CTS :IN STD_LOGIC     ----Flow control pin for Serial
			
			 );                                           
		END Xflash;       
		
ARCHITECTURE toplevel OF Xflash IS

                                 
BEGIN
  
  -- Fix max cartride size to 32MB
    
	   FLASH_ADDR(22) <= '0';
	   FLASH_ADDR (21 DOWNTO 19) <= MD_ADDR_H (21 downto 19 );
		
  -- Flash Control Pin
      
		FLASH_BYTE <= '1';
		FLASH_RESET <= '1';
		FLASH_ACC <= '1';
        BUFF_DIR <= (MD_OE or MD_CE) ; 
  
  -- Megadrive Control Pin
        
		FLASH_CE <= MD_CE;
        FLASH_OE <= MD_OE;
		FLASH_WE <= MD_LWR;
		MD_MARK3 <= 'Z';    -- Disable Master System mode
		MD_VRES  <= 'Z';    -- Disable Soft Reset
		
	-- Non controlled MD DQ Pin in these design
  
		MD_DQ(7 DOWNTO 0) <= "ZZZZZZZZ";
		MD_DQ(15 DOWNTO 8) <= "ZZZZZZZZ";
		MD_ADDR_L(4 DOWNTO 1) <= "ZZZZ";				
		
	-- Extra hardware pin no needed here
	
	   SPI_CLK  <= '1';
	   SPI_MOSI  <= '1';
	   SPI_CE  <= '1';
	   SERIAL_TX  <= '1';
	   SERIAL_RTS  <= '1';
  	
END toplevel;
