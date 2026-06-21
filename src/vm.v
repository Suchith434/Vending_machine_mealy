module vending_machine (
    input [1:0] coin, 
    input clk, reset, 
    output dispense 
);

    reg [1:0] PS;// Present State
    wire [1:0] NS;// Next State

    always @(posedge clk or posedge reset) begin
        if(reset) PS <= 2'd0;
        else PS <= NS;
    end

    
    assign NS[0] = (~PS[1] & ~PS[0] & coin[0]) | (PS[0] & ~coin[1] & ~coin[0]);
    assign NS[1] = (~PS[1] & ~PS[0] & coin[1]) | (PS[0] & coin[0]) | (PS[1] & ~coin[1] & ~coin[0]);
    assign dispense = (coin[1] & ~coin[0] & (PS[0] | PS[1])) | (~coin[1] & coin[0] & PS[1]);

endmodule