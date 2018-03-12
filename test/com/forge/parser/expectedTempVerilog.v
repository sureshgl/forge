module topModule;

slave1 #()
u_slave1 (
.u_req_valid_slave1(d_req_valid_topModule),
.u_req_intr_slave1(d_req_intr_topModule),
.u_req_type_slave1(d_req_type_topModule),
.u_req_attr_slave1(d_req_attr_topModule),
.u_req_size_slave1(d_req_size_topModule),
.u_req_data_slave1(d_req_data_topModule)
);

slave2 #()
u_slave2 (
.u_req_valid_slave2(d_req_valid_slave1),
.u_req_intr_slave2(d_req_intr_slave1),
.u_req_type_slave2(d_req_type_slave1),
.u_req_attr_slave2(d_req_attr_slave1),
.u_req_size_slave2(d_req_size_slave1),
.u_req_data_slave2(d_req_data_slave1)
);

slave3 #()
u_slave3 (
.u_req_valid_slave3(d_req_valid_slave2),
.u_req_intr_slave3(d_req_intr_slave2),
.u_req_type_slave3(d_req_type_slave2),
.u_req_attr_slave3(d_req_attr_slave2),
.u_req_size_slave3(d_req_size_slave2),
.u_req_data_slave3(d_req_data_slave2)
);


endmodule

