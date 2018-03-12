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
		u64 offsetArg            = 4, // index = 0x1
		u64 sizeArg              = 16, 
		mrl_type_t mrlType       = CMrlComponent::MRL_REGISTER,
		component_type_t regType = CMrlComponent::REG_CFG,
		CMrlComponent*   parentP = NULL
	);

	CFG_proc_pkt_threshold_class(
		const CFG_proc_pkt_threshold_class& rhs
	);

	virtual ~CFG_proc_pkt_threshold_class();

	static const int SIZE   = 16;

	using CMrlComponent::operator=;

	CFG_proc_pkt_threshold_class& operator=(
		const CFG_proc_pkt_threshold_class& rhs
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

class pifo_mem_1_class;
class pifo_mem_1_class_Prxy : public CMrlRegister {
public:
	pifo_mem_1_class_Prxy(
		string name            = "pifo_mem_1",
		u64 rowNb              = 0,
		CMrlComponent* parentP = NULL
	);

 	pifo_mem_1_class_Prxy(
		ac_bv* externalStorageP, 
		u32 acBitOffset = 0, 
		bool bigEndian = true, 
		u64 sizeArg = 512, 
		const string& name = "pifo_mem_1" 
 	);

	pifo_mem_1_class_Prxy(
		const pifo_mem_1_class_Prxy& rhs
	);

	virtual ~pifo_mem_1_class_Prxy();

	static const int SIZE = 512;

	using CMrlComponent::operator=;

	pifo_mem_1_class_Prxy& operator=(
		const pifo_mem_1_class_Prxy& rhs
	);

	u64 RowNb;
	

	// Fields' declaration
	typedef MrlComponentT11 fl1_t;   
	typedef ac_int<11, false> fl1_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<11> fl1;


class pifo_mem_1_class : public CMrlMemory<pifo_mem_1_class_Prxy>{
public:
	pifo_mem_1_class(
		string name = "pifo_mem_1", 
		u64 offsetArg = 32, // index = 0x14
		mrl_type_t memoryMrlType = CMrlComponent::MRL_MEMORY,
		component_type_t memoryComponentType = CMrlComponent::MEM_FLOP_ARRAY,
		u32 memDepthArg = 16,
		u32 memWidthArg = 32,
		CMrlComponent* parentP = NULL
	);
		
	typedef pifo_mem_1_class_Prxy    Row;
	typedef ac_int<32, false> Entry;

	static const int SIZE            = 32;
	
	virtual void SetOperationMode (
		const string& operationMode, bool recurse = true, bool setit = true 
	);
};
	

class pifo_mem_2_class;
class pifo_mem_2_class_Prxy : public CMrlRegister {
public:
	pifo_mem_2_class_Prxy(
		string name            = "pifo_mem_2",
		u64 rowNb              = 0,
		CMrlComponent* parentP = NULL
	);

 	pifo_mem_2_class_Prxy(
		ac_bv* externalStorageP, 
		u32 acBitOffset = 0, 
		bool bigEndian = true, 
		u64 sizeArg = 2048, 
		const string& name = "pifo_mem_2" 
 	);

	pifo_mem_2_class_Prxy(
		const pifo_mem_2_class_Prxy& rhs
	);

	virtual ~pifo_mem_2_class_Prxy();

	static const int SIZE = 2048;

	using CMrlComponent::operator=;

	pifo_mem_2_class_Prxy& operator=(
		const pifo_mem_2_class_Prxy& rhs
	);

	u64 RowNb;
	

	// Fields' declaration
	typedef MrlComponentT13 fl1_t;   
	typedef ac_int<13, false> fl1_ac_int_t;	

	// Fields' instantiations #1
	MrlComponentT<13> fl1;


class pifo_mem_2_class : public CMrlMemory<pifo_mem_2_class_Prxy>{
public:
	pifo_mem_2_class(
		string name = "pifo_mem_2", 
		u64 offsetArg = 64, // index = 0x14
		mrl_type_t memoryMrlType = CMrlComponent::MRL_MEMORY,
		component_type_t memoryComponentType = CMrlComponent::MEM_FLOP_ARRAY,
		u32 memDepthArg = 64,
		u32 memWidthArg = 32,
		CMrlComponent* parentP = NULL
	);
		
	typedef pifo_mem_2_class_Prxy    Row;
	typedef ac_int<32, false> Entry;

	static const int SIZE            = 32;
	
	virtual void SetOperationMode (
		const string& operationMode, bool recurse = true, bool setit = true 
	);
};
	

