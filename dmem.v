module dmem
#(
    parameter SIZE = 1024
)
(
    /* inputs */
    input        i_clk,
    input [31:0] i_addr,
    input [31:0] i_w_data,
    input [ 2:0] i_fmt,
    input        i_r_en,
    input        i_w_en,

    /* outputs */
    output reg [31:0] o_r_data
);

    reg [7:0] mem [SIZE-1:0];

    always @(i_r_en, i_addr, i_fmt)
    begin
        if (i_r_en)
        begin
            case (i_fmt)

                3'b000: /* byte */
                begin
                    o_r_data = {
                        {24{mem[i_addr + 0][7]}},
                        mem[i_addr + 0]
                    };
                end

                3'b001: /* half */
                begin
                    o_r_data = {
                        {16{mem[i_addr + 1][7]}},
                        mem[i_addr + 1],
                        mem[i_addr + 0]
                    };
                end

                3'b010: /* word */
                begin
                    o_r_data = {
                        mem[i_addr + 3],
                        mem[i_addr + 2],
                        mem[i_addr + 1],
                        mem[i_addr + 0]
                    };
                end

                default: o_r_data = 32'bx;

            endcase
        end
        else
        begin
            o_r_data = 32'b0;
        end
    end

    always_ff @(posedge i_clk)
    begin
        if (i_w_en)
        begin
            case (i_fmt)

                3'b000: /* byte */
                begin
                    mem[i_addr + 0] <= i_w_data[7:0];
                end

                3'b001: /* half */
                begin
                    mem[i_addr + 0] <= i_w_data[7:0];
                    mem[i_addr + 1] <= i_w_data[15:8];
                end

                3'b010: /* word */
                begin
                    mem[i_addr + 0] <= i_w_data[7:0];
                    mem[i_addr + 1] <= i_w_data[15:8];
                    mem[i_addr + 2] <= i_w_data[23:16];
                    mem[i_addr + 3] <= i_w_data[31:24];
                end

                default: ;

            endcase
        end
    end

endmodule
