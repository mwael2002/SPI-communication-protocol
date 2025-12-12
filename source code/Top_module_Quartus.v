module Top_module(clk,rst_n,tx_en,tx_data,data_out); 
input clk,rst_n;
input [7:0] tx_data;
output [7:0] data_out;
input tx_en;

wire SCK,MOSI,MISO,MISO_golden,ss,clk_out;
reg tx_reg;

always@(posedge clk,negedge rst_n) begin

	if(!rst_n)
		tx_reg<=0;
	else
		tx_reg<=tx_en;

end


assign ss= ~rst_n | ~tx_reg;


SPI_master #(.DATA_LENGTH(8),.CPOL(1),.CPHA(0)) MASTER_DUT(clk,rst_n,MISO,tx_reg,tx_data,SCK,MOSI);
SPI_slave #(.DATA_LENGTH(8),.CPOL(1),.CPHA(0)) SLAVE_DUT(ss,SCK,MOSI,8'b01001101,MISO,data_out);


endmodule
