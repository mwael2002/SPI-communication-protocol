module Top_module_tb;

    logic clk,rst_n;
    logic [5:0] data_out_M,data_out_S;

    Top_module DUT(clk,rst_n,data_out_M,data_out_S); 

    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end

    initial begin
        
        rst_n=0;
        #2;
        rst_n=1;
        #240;

    $stop;
    end

endmodule