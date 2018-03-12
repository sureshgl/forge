class CFG_arb_fifo_pkt_threshold_class : public CMrlRegister {
public:
	CFG_arb_fifo_pkt_threshold_class(
		string name = "CFG_arb_fifo_pkt_threshold",
		u64 offsetArg            = 0, // index = 0x1
		u64 sizeArg              = 16, 
		mrl_type_t mrlType       = CMrlComponent::MRL_REGISTER,
		component_type_t regType = CMrlComponent::REG_CFG,
		CMrlComponent*   parentP = NULL
	);

	CFG_arb_fifo_pkt_threshold_class(
		const CFG_arb_fifo_pkt_threshold_class& rhs
	);

	virtual ~CFG_arb_fifo_pkt_threshold_class();

	static const int SIZE   = 16;

	using CMrlComponent::operator=;

	CFG_arb_fifo_pkt_threshold_class& operator=(
		const CFG_arb_fifo_pkt_threshold_class& rhs
	);   

	// Fields' declaration
	typedef MrlComponentT16 thresh_t;   
	typedef ac_int<16, false> thresh_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<16> thresh;


	virtual void SetOperationMode ( 
		const string& operationMode, bool recurse = true, bool setit = true
	);

};


class CFG_proc_pkt_threshold_class : public CMrlRegister {
public:
	CFG_proc_pkt_threshold_class(
		string name = "CFG_proc_pkt_threshold",
		u64 offsetArg            = 8, // index = 0x1
		u64 sizeArg              = 33, 
		mrl_type_t mrlType       = CMrlComponent::MRL_REGISTER,
		component_type_t regType = CMrlComponent::REG_CFG,
		CMrlComponent*   parentP = NULL
	);

	CFG_proc_pkt_threshold_class(
		const CFG_proc_pkt_threshold_class& rhs
	);

	virtual ~CFG_proc_pkt_threshold_class();

	static const int SIZE   = 33;

	using CMrlComponent::operator=;

	CFG_proc_pkt_threshold_class& operator=(
		const CFG_proc_pkt_threshold_class& rhs
	);   

	// Fields' declaration
	typedef MrlComponentT33 thresh_t;   
	typedef ac_int<33, false> thresh_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<33> thresh;


	virtual void SetOperationMode ( 
		const string& operationMode, bool recurse = true, bool setit = true
	);

};


class CFG_dummyReg_class : public CMrlRegister {
public:
	CFG_dummyReg_class(
		string name = "CFG_dummyReg",
		u64 offsetArg            = 16, // index = 0x1
		u64 sizeArg              = 39, 
		mrl_type_t mrlType       = CMrlComponent::MRL_REGISTER,
		component_type_t regType = CMrlComponent::REG_CFG,
		CMrlComponent*   parentP = NULL
	);

	CFG_dummyReg_class(
		const CFG_dummyReg_class& rhs
	);

	virtual ~CFG_dummyReg_class();

	static const int SIZE   = 39;

	using CMrlComponent::operator=;

	CFG_dummyReg_class& operator=(
		const CFG_dummyReg_class& rhs
	);   

	// Fields' declaration
	typedef MrlComponentT39 thresh_t;   
	typedef ac_int<39, false> thresh_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<39> thresh;


	virtual void SetOperationMode ( 
		const string& operationMode, bool recurse = true, bool setit = true
	);

};


class CFG_dummy_reg_class : public CMrlRegister {
public:
	CFG_dummy_reg_class(
		string name = "CFG_dummy_reg",
		u64 offsetArg            = 32, // index = 0x1
		u64 sizeArg              = 65, 
		mrl_type_t mrlType       = CMrlComponent::MRL_REGISTER,
		component_type_t regType = CMrlComponent::REG_CFG,
		CMrlComponent*   parentP = NULL
	);

	CFG_dummy_reg_class(
		const CFG_dummy_reg_class& rhs
	);

	virtual ~CFG_dummy_reg_class();

	static const int SIZE   = 65;

	using CMrlComponent::operator=;

	CFG_dummy_reg_class& operator=(
		const CFG_dummy_reg_class& rhs
	);   

	// Fields' declaration
	typedef MrlComponentT65 thresh_t;   
	typedef ac_int<65, false> thresh_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<65> thresh;


	virtual void SetOperationMode ( 
		const string& operationMode, bool recurse = true, bool setit = true
	);

};

class mem_1_class;
class mem_1_class_Prxy : public CMrlRegister {
public:
	mem_1_class_Prxy(
		string name            = "mem_1",
		u64 rowNb              = 0,
		CMrlComponent* parentP = NULL
	);

 	mem_1_class_Prxy(
		ac_bv* externalStorageP, 
		u32 acBitOffset = 0, 
		bool bigEndian = true, 
		u64 sizeArg = 512, 
		const string& name = "mem_1" 
 	);

	mem_1_class_Prxy(
		const mem_1_class_Prxy& rhs
	);

	virtual ~mem_1_class_Prxy();

	static const int SIZE = 512;

	using CMrlComponent::operator=;

	mem_1_class_Prxy& operator=(
		const mem_1_class_Prxy& rhs
	);

	u64 RowNb;
	

	// Fields' declaration
	typedef MrlComponentT11 fl1_t;   
	typedef ac_int<11, false> fl1_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<11> fl1;


class mem_1_class : public CMrlMemory<mem_1_class_Prxy>{
public:
	mem_1_class(
		string name = "mem_1", 
		u64 offsetArg = 64, // index = 0x14
		mrl_type_t memoryMrlType = CMrlComponent::MRL_MEMORY,
		component_type_t memoryComponentType = CMrlComponent::MEM_FLOP_ARRAY,
		u32 memDepthArg = 16,
		u32 memWidthArg = 32,
		CMrlComponent* parentP = NULL
	);
		
	typedef mem_1_class_Prxy    Row;
	typedef ac_int<32, false> Entry;

	static const int SIZE            = 32;
	
	virtual void SetOperationMode (
		const string& operationMode, bool recurse = true, bool setit = true 
	);
};
	

class mem_2_class;
class mem_2_class_Prxy : public CMrlRegister {
public:
	mem_2_class_Prxy(
		string name            = "mem_2",
		u64 rowNb              = 0,
		CMrlComponent* parentP = NULL
	);

 	mem_2_class_Prxy(
		ac_bv* externalStorageP, 
		u32 acBitOffset = 0, 
		bool bigEndian = true, 
		u64 sizeArg = 2048, 
		const string& name = "mem_2" 
 	);

	mem_2_class_Prxy(
		const mem_2_class_Prxy& rhs
	);

	virtual ~mem_2_class_Prxy();

	static const int SIZE = 2048;

	using CMrlComponent::operator=;

	mem_2_class_Prxy& operator=(
		const mem_2_class_Prxy& rhs
	);

	u64 RowNb;
	

	// Fields' declaration
	typedef MrlComponentT13 fl1_t;   
	typedef ac_int<13, false> fl1_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<13> fl1;


class mem_2_class : public CMrlMemory<mem_2_class_Prxy>{
public:
	mem_2_class(
		string name = "mem_2", 
		u64 offsetArg = 128, // index = 0x14
		mrl_type_t memoryMrlType = CMrlComponent::MRL_MEMORY,
		component_type_t memoryComponentType = CMrlComponent::MEM_FLOP_ARRAY,
		u32 memDepthArg = 64,
		u32 memWidthArg = 32,
		CMrlComponent* parentP = NULL
	);
		
	typedef mem_2_class_Prxy    Row;
	typedef ac_int<32, false> Entry;

	static const int SIZE            = 32;
	
	virtual void SetOperationMode (
		const string& operationMode, bool recurse = true, bool setit = true 
	);
};
	

class mem_3_class;
class mem_3_class_Prxy : public CMrlRegister {
public:
	mem_3_class_Prxy(
		string name            = "mem_3",
		u64 rowNb              = 0,
		CMrlComponent* parentP = NULL
	);

 	mem_3_class_Prxy(
		ac_bv* externalStorageP, 
		u32 acBitOffset = 0, 
		bool bigEndian = true, 
		u64 sizeArg = 8192, 
		const string& name = "mem_3" 
 	);

	mem_3_class_Prxy(
		const mem_3_class_Prxy& rhs
	);

	virtual ~mem_3_class_Prxy();

	static const int SIZE = 8192;

	using CMrlComponent::operator=;

	mem_3_class_Prxy& operator=(
		const mem_3_class_Prxy& rhs
	);

	u64 RowNb;
	

	// Fields' declaration
	typedef MrlComponentT14 fl1_t;   
	typedef ac_int<14, false> fl1_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<14> fl1;


class mem_3_class : public CMrlMemory<mem_3_class_Prxy>{
public:
	mem_3_class(
		string name = "mem_3", 
		u64 offsetArg = 512, // index = 0x14
		mrl_type_t memoryMrlType = CMrlComponent::MRL_MEMORY,
		component_type_t memoryComponentType = CMrlComponent::MEM_FLOP_ARRAY,
		u32 memDepthArg = 64,
		u32 memWidthArg = 128,
		CMrlComponent* parentP = NULL
	);
		
	typedef mem_3_class_Prxy    Row;
	typedef ac_int<128, false> Entry;

	static const int SIZE            = 32;
	
	virtual void SetOperationMode (
		const string& operationMode, bool recurse = true, bool setit = true 
	);
};
	

