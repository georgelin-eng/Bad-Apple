// Hard time compiling with 640*480 since that results in a vector
// larger than 2^16. This is similar to the "bank" concept
// of storing data across various banks. 
// I'm treating this as multiple "layers" of a bitmask
// so that multiple color levels can be implemented

module bram_top (
);


endmodule