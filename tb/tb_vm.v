module tb_vending_machine;
    reg clk, rst;
    reg [1:0] coin_in;
    wire disp;

    vending_machine uut (
        .clk(clk),
        .reset(rst),
        .coin(coin_in),
        .dispense(disp)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vm.vcd");
        $dumpvars(0, tb_vending_machine);
        clk = 0;
        rst = 1;
        coin_in = 2'b00;
        
        $monitor("T=%0t | rst=%b | coin=%b | disp=%b", $time, rst, coin_in, disp);

        @(negedge clk) rst = 0;

        // 5 + 5 + 5
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b00;

        // 5 + 10
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b10;
        @(negedge clk) coin_in = 2'b00;

        // 10 + 5
        @(negedge clk) coin_in = 2'b10;
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b00;

        // 10 + 10 overflow
        @(negedge clk) coin_in = 2'b10;
        @(negedge clk) coin_in = 2'b10;
        @(negedge clk) coin_in = 2'b00;

        // reset check mid-transaction
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) coin_in = 2'b01;
        @(negedge clk) rst = 1;      
        @(negedge clk) rst = 0;      
        coin_in = 2'b00;

        // invalid coin check
        @(negedge clk) coin_in = 2'b01; 
        @(negedge clk) coin_in = 2'b11; 

        #20 $finish;
    end
endmodule