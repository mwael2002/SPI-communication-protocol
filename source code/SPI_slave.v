module SPI_slave #(parameter DATA_LENGTH=8,CPOL = 0, CPHA = 0)(input sys_clk,rst_n,SS,SCK,MOSI,output MISO,output reg read_available,output [DATA_LENGTH-1:0] data_out);
    
    
    reg [DATA_LENGTH:0] data_reg; 
    reg [5:0] counter;
   
        always@(posedge sys_clk,negedge rst_n) begin
        if(!rst_n) begin
        counter<=0;
        read_available<=1;
        end
        else if(counter==DATA_LENGTH) begin
        counter<=0;
        read_available<=1;
        end

        else if(!SS) begin
        counter<=counter+1;
        read_available<=0;
        end
    
        end 
    

    generate

    if (!(CPHA ^ CPOL)) begin    

    always@(negedge rst_n or posedge SCK) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else if(!SS)
        data_reg[DATA_LENGTH]<=MOSI;


    end

    always @(negedge rst_n or negedge SCK) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(!SS) begin

            data_reg[DATA_LENGTH-1:0]={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    

    end 

    
   else if (CPHA ^ CPOL) begin    

    always@(negedge rst_n or negedge SCK) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else
        data_reg[DATA_LENGTH]<=MOSI;

    end

    always @(negedge rst_n or posedge SCK) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(!SS) begin

            data_reg[DATA_LENGTH-1:0]={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    

    end

    endgenerate


    assign MISO = data_reg[0];
    assign data_out=CPHA? data_reg[DATA_LENGTH:1]:data_reg[DATA_LENGTH-1:0];

endmodule