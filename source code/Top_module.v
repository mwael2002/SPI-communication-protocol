module Top_module(input clk,rst_n,output reg[5:0] data_out_M,data_out_S); 

wire SCK,MOSI,MISO,read_available_M,read_available_S;
wire [5:0] data_tmp_M,data_tmp_S;

always@(posedge clk,negedge rst_n) begin
    if(!rst_n) begin
    data_out_M<=0;

    end

    else if(read_available_M==1) 
    data_out_M<=data_tmp_M;
    

end

always@(posedge clk,negedge rst_n) begin
    if(!rst_n) begin
    data_out_S<=0;
    end


    else if(read_available_S==1) 
    data_out_S<=data_tmp_S;
    

end

SPI_master #(.DATA_LENGTH(6),.CPOL(1),.CPHA(0)) MASTER_DUT(clk,rst_n,MISO,6'b01_0111,SCK,MOSI,read_available_M,data_tmp_M);

SPI_slave #(.DATA_LENGTH(6),.CPOL(1),.CPHA(0)) SLAVE_DUT(clk,rst_n,0,SCK,MOSI,MISO,read_available_S,data_tmp_S);

endmodule