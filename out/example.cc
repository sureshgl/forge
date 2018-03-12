#include "example_block.h"

example_block::CFG_arb_fifo_pkt_threshold_class::CFG_arb_fifo_pkt_threshold_class(
	string name,
	u64 offsetArg,
	u64 sizeArg,
	mrl_type_t mrlType,
	component_type_t compType,
	CMrlComponent *parentP
) :
	CMrlRegister ( 
		name /*Name*/, 
		offsetArg /*Offset*/, 
		sizeArg /*Size*/, 
		mrlType, 
		compType, 
		parentP /*parent*/
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 16, 
		/*width*/ 16, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
	SetBoundary(1);
	}

example_block::CFG_arb_fifo_pkt_threshold_class::CFG_arb_fifo_pkt_threshold_class(const CFG_arb_fifo_pkt_threshold_class& rhs) : 
	CMrlRegister ( 
		"CFG_arb_fifo_pkt_threshold" /*Name*/, 
		0 /*Offset*/, 
    	16 /*Size*/, 
    	CMrlComponent::MRL_REGISTER, 
    	CMrlComponent::REG_CFG, 
    	NULL /*parent*/ 
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 16, 
		/*width*/ 16, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)


example_block::CFG_arb_fifo_pkt_threshold_class::~CFG_arb_fifo_pkt_threshold_class() {

}

example_block::CFG_arb_fifo_pkt_threshold_class& example_block::CFG_arb_fifo_pkt_threshold_class::operator=(const example_block::CFG_arb_fifo_pkt_threshold_class& rhs) { 
	SetValue(rhs.GetValue()); return(*this); 
}

void example_block::CFG_arb_fifo_pkt_threshold_class::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
    CMrlComponent::OperationMode = operationMode; 
	}
}


#include "example_block.h"

example_block::CFG_proc_pkt_threshold_class::CFG_proc_pkt_threshold_class(
	string name,
	u64 offsetArg,
	u64 sizeArg,
	mrl_type_t mrlType,
	component_type_t compType,
	CMrlComponent *parentP
) :
	CMrlRegister ( 
		name /*Name*/, 
		offsetArg /*Offset*/, 
		sizeArg /*Size*/, 
		mrlType, 
		compType, 
		parentP /*parent*/
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 33, 
		/*width*/ 33, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
	SetBoundary(1);
	}

example_block::CFG_proc_pkt_threshold_class::CFG_proc_pkt_threshold_class(const CFG_proc_pkt_threshold_class& rhs) : 
	CMrlRegister ( 
		"CFG_proc_pkt_threshold" /*Name*/, 
		8 /*Offset*/, 
    	33 /*Size*/, 
    	CMrlComponent::MRL_REGISTER, 
    	CMrlComponent::REG_CFG, 
    	NULL /*parent*/ 
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 33, 
		/*width*/ 33, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)


example_block::CFG_proc_pkt_threshold_class::~CFG_proc_pkt_threshold_class() {

}

example_block::CFG_proc_pkt_threshold_class& example_block::CFG_proc_pkt_threshold_class::operator=(const example_block::CFG_proc_pkt_threshold_class& rhs) { 
	SetValue(rhs.GetValue()); return(*this); 
}

void example_block::CFG_proc_pkt_threshold_class::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
    CMrlComponent::OperationMode = operationMode; 
	}
}


#include "example_block.h"

example_block::CFG_dummyReg_class::CFG_dummyReg_class(
	string name,
	u64 offsetArg,
	u64 sizeArg,
	mrl_type_t mrlType,
	component_type_t compType,
	CMrlComponent *parentP
) :
	CMrlRegister ( 
		name /*Name*/, 
		offsetArg /*Offset*/, 
		sizeArg /*Size*/, 
		mrlType, 
		compType, 
		parentP /*parent*/
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 39, 
		/*width*/ 39, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
	SetBoundary(1);
	}

example_block::CFG_dummyReg_class::CFG_dummyReg_class(const CFG_dummyReg_class& rhs) : 
	CMrlRegister ( 
		"CFG_dummyReg" /*Name*/, 
		16 /*Offset*/, 
    	39 /*Size*/, 
    	CMrlComponent::MRL_REGISTER, 
    	CMrlComponent::REG_CFG, 
    	NULL /*parent*/ 
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 39, 
		/*width*/ 39, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)


example_block::CFG_dummyReg_class::~CFG_dummyReg_class() {

}

example_block::CFG_dummyReg_class& example_block::CFG_dummyReg_class::operator=(const example_block::CFG_dummyReg_class& rhs) { 
	SetValue(rhs.GetValue()); return(*this); 
}

void example_block::CFG_dummyReg_class::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
    CMrlComponent::OperationMode = operationMode; 
	}
}


#include "example_block.h"

example_block::CFG_dummy_reg_class::CFG_dummy_reg_class(
	string name,
	u64 offsetArg,
	u64 sizeArg,
	mrl_type_t mrlType,
	component_type_t compType,
	CMrlComponent *parentP
) :
	CMrlRegister ( 
		name /*Name*/, 
		offsetArg /*Offset*/, 
		sizeArg /*Size*/, 
		mrlType, 
		compType, 
		parentP /*parent*/
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 65, 
		/*width*/ 65, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
	SetBoundary(1);
	}

example_block::CFG_dummy_reg_class::CFG_dummy_reg_class(const CFG_dummy_reg_class& rhs) : 
	CMrlRegister ( 
		"CFG_dummy_reg" /*Name*/, 
		32 /*Offset*/, 
    	65 /*Size*/, 
    	CMrlComponent::MRL_REGISTER, 
    	CMrlComponent::REG_CFG, 
    	NULL /*parent*/ 
	)
	, thresh(
		/*name*/ "thresh",
		/*offset*/ 65, 
		/*width*/ 65, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)


example_block::CFG_dummy_reg_class::~CFG_dummy_reg_class() {

}

example_block::CFG_dummy_reg_class& example_block::CFG_dummy_reg_class::operator=(const example_block::CFG_dummy_reg_class& rhs) { 
	SetValue(rhs.GetValue()); return(*this); 
}

void example_block::CFG_dummy_reg_class::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
    CMrlComponent::OperationMode = operationMode; 
	}
}


example_block::mem_1_class_Prxy::mem_1_class_Prxy(
	string name,
	u64 rowNb,
	CMrlComponent* parentP
) : 
    CMrlRegister( 
		name /*Name*/, 
		rowNb, 
		12,  
		CMrlComponent::MRL_MEMORY_PROXY, 
		CMrlComponent::MEM_PROXY, 
		parentP /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 11, 
		/*width*/ 11, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
		if (parentP != (mem_1_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
        RowNb = rowNb;
	}

example_block::mem_1_class_Prxy::mem_1_class_Prxy(
          ac_bv* externalStorageP, u32 acBitOffset, bool bigEndian, u64 sizeArg, const string& name
) : CMrlRegister (
		externalStorageP, 
		acBitOffset, 
		bigEndian, 
		sizeArg, 
		name
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 11, 
		/*width*/ 11, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetMrlType(CMrlComponent::MRL_MEMORY_PROXY);
        if (ParentP != (mem_1_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
	}

example_block::mem_1_class_Prxy::mem_1_class_Prxy(const mem_1_class_Prxy& rhs
) : CMrlRegister( 
	"mem_1" /*Name*/, 
	0, 
	12,  
	CMrlComponent::MRL_MEMORY_PROXY, 
	CMrlComponent::MEM_PROXY, 
	NULL /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 11, 
		/*width*/ 11, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetComponentType   (rhs.ComponentType)    ;
        SetName            (rhs.Name)             ;
        SetOperationMode   (rhs.OperationMode)    ;
        SetOffset          (rhs.Offset)           ;
        SetSize            (rhs.Size)             ;
        SetPhantom         (rhs.Phantom)          ;

        SetArrayIndex      (rhs.ArrayIndex)       ;
        SetNbArrayElements (rhs.NbArrayElements)  ;
        SetDirty           (rhs.Dirty)            ;
        SetActive          (rhs.Active)           ;
        SetClassName       (rhs.ClassName)        ;
        SetDoc             (rhs.Doc)              ;
        SetMrlType         (rhs.MrlType)          ;
        SetValidValues     (rhs.ValidValues)      ;
        SetCpuRdWrEnable   (rhs.CpuRdWrEnable)    ;

        RowNb   = rhs.GetRowNb();
        ParentP = rhs.GetParentP();

        if (ParentP == (mem_1_class*) 0) {
          this->SetOperationMode(CMrlComponent::GetGlobalOperationMode());
        }

        this->SetValue(rhs.GetValue());
      }

example_block::mem_1_class_Prxy::~mem_1_class_Prxy() {

}

example_block::mem_1_class_Prxy& example_block::mem_1_class_Prxy::operator=(
	const example_block::mem_1_class_Prxy& rhs) { 
			SetValue(rhs.GetValue()); 
			return(*this); 
	}

u32 example_block::mem_1_class_Prxy::GetRowNb() const {
	return(RowNb);
}

void example_block::mem_1_class_Prxy::SetRowNb(u32 value ) {
	RowNb = value;
}

void example_block::mem_1_class_Prxy::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
	if  (operationMode == "wol") {  
		CMrlComponent::OperationMode = operationMode;
		this->data.SetResetValue(0x0);
  }
}

example_block::mem_1_class::mem_1_class(
		string name, 
		u64 offsetArg, 
		mrl_type_t memoryMrlType,
		component_type_t memoryComponentType,
		u32 memDepthArg,
		u32 memWidthArg,
		CMrlComponent* parentP
  ) : CMrlMemory<mem_1_class_Prxy>(
		name, offsetArg, 
		memoryMrlType, 
		memoryComponentType, 
		memDepthArg, 
		memWidthArg, 
		parentP)
{

	SetAttribute("mem_test_ro", (ac_bv) 1);
	SetTypeString("flop_array");
	if (CMrlComponent::GetGlobalOperationMode() != "") {
		SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
	} else {
		SetOperationMode ("wol", false /*true*/); /* default */
	}
 }

void example_block::mem_1_class::SetOperationMode ( const string& operationMode, bool recurse, bool setit )  {
	if (setit) {
		CMrlComponent::OperationMode = operationMode;
	}
	CMrlMemory<mem_1_class_Prxy>::SetOperationMode(operationMode, recurse);
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
  	if  (operationMode == "wol") {  
    CMrlComponent::OperationMode = operationMode;
	}
}

void example_block::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	bool operationModeChanged = (operationMode != GetOperationMode());
	note("%s : (Id = %p)  Setting operation mode to '%s'", GetName().c_str(), Id, operationMode.c_str());
  	if (recurse) { 
  		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
		CMrlComponent::OperationMode = operationMode;
	}
	if (operationModeChanged)
  		Reset();
}


example_block::mem_2_class_Prxy::mem_2_class_Prxy(
	string name,
	u64 rowNb,
	CMrlComponent* parentP
) : 
    CMrlRegister( 
		name /*Name*/, 
		rowNb, 
		12,  
		CMrlComponent::MRL_MEMORY_PROXY, 
		CMrlComponent::MEM_PROXY, 
		parentP /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 13, 
		/*width*/ 13, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
		if (parentP != (mem_2_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
        RowNb = rowNb;
	}

example_block::mem_2_class_Prxy::mem_2_class_Prxy(
          ac_bv* externalStorageP, u32 acBitOffset, bool bigEndian, u64 sizeArg, const string& name
) : CMrlRegister (
		externalStorageP, 
		acBitOffset, 
		bigEndian, 
		sizeArg, 
		name
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 13, 
		/*width*/ 13, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetMrlType(CMrlComponent::MRL_MEMORY_PROXY);
        if (ParentP != (mem_2_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
	}

example_block::mem_2_class_Prxy::mem_2_class_Prxy(const mem_2_class_Prxy& rhs
) : CMrlRegister( 
	"mem_2" /*Name*/, 
	0, 
	12,  
	CMrlComponent::MRL_MEMORY_PROXY, 
	CMrlComponent::MEM_PROXY, 
	NULL /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 13, 
		/*width*/ 13, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetComponentType   (rhs.ComponentType)    ;
        SetName            (rhs.Name)             ;
        SetOperationMode   (rhs.OperationMode)    ;
        SetOffset          (rhs.Offset)           ;
        SetSize            (rhs.Size)             ;
        SetPhantom         (rhs.Phantom)          ;

        SetArrayIndex      (rhs.ArrayIndex)       ;
        SetNbArrayElements (rhs.NbArrayElements)  ;
        SetDirty           (rhs.Dirty)            ;
        SetActive          (rhs.Active)           ;
        SetClassName       (rhs.ClassName)        ;
        SetDoc             (rhs.Doc)              ;
        SetMrlType         (rhs.MrlType)          ;
        SetValidValues     (rhs.ValidValues)      ;
        SetCpuRdWrEnable   (rhs.CpuRdWrEnable)    ;

        RowNb   = rhs.GetRowNb();
        ParentP = rhs.GetParentP();

        if (ParentP == (mem_2_class*) 0) {
          this->SetOperationMode(CMrlComponent::GetGlobalOperationMode());
        }

        this->SetValue(rhs.GetValue());
      }

example_block::mem_2_class_Prxy::~mem_2_class_Prxy() {

}

example_block::mem_2_class_Prxy& example_block::mem_2_class_Prxy::operator=(
	const example_block::mem_2_class_Prxy& rhs) { 
			SetValue(rhs.GetValue()); 
			return(*this); 
	}

u32 example_block::mem_2_class_Prxy::GetRowNb() const {
	return(RowNb);
}

void example_block::mem_2_class_Prxy::SetRowNb(u32 value ) {
	RowNb = value;
}

void example_block::mem_2_class_Prxy::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
	if  (operationMode == "wol") {  
		CMrlComponent::OperationMode = operationMode;
		this->data.SetResetValue(0x0);
  }
}

example_block::mem_2_class::mem_2_class(
		string name, 
		u64 offsetArg, 
		mrl_type_t memoryMrlType,
		component_type_t memoryComponentType,
		u32 memDepthArg,
		u32 memWidthArg,
		CMrlComponent* parentP
  ) : CMrlMemory<mem_2_class_Prxy>(
		name, offsetArg, 
		memoryMrlType, 
		memoryComponentType, 
		memDepthArg, 
		memWidthArg, 
		parentP)
{

	SetAttribute("mem_test_ro", (ac_bv) 1);
	SetTypeString("flop_array");
	if (CMrlComponent::GetGlobalOperationMode() != "") {
		SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
	} else {
		SetOperationMode ("wol", false /*true*/); /* default */
	}
 }

void example_block::mem_2_class::SetOperationMode ( const string& operationMode, bool recurse, bool setit )  {
	if (setit) {
		CMrlComponent::OperationMode = operationMode;
	}
	CMrlMemory<mem_2_class_Prxy>::SetOperationMode(operationMode, recurse);
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
  	if  (operationMode == "wol") {  
    CMrlComponent::OperationMode = operationMode;
	}
}

void example_block::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	bool operationModeChanged = (operationMode != GetOperationMode());
	note("%s : (Id = %p)  Setting operation mode to '%s'", GetName().c_str(), Id, operationMode.c_str());
  	if (recurse) { 
  		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
		CMrlComponent::OperationMode = operationMode;
	}
	if (operationModeChanged)
  		Reset();
}


example_block::mem_3_class_Prxy::mem_3_class_Prxy(
	string name,
	u64 rowNb,
	CMrlComponent* parentP
) : 
    CMrlRegister( 
		name /*Name*/, 
		rowNb, 
		12,  
		CMrlComponent::MRL_MEMORY_PROXY, 
		CMrlComponent::MEM_PROXY, 
		parentP /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 14, 
		/*width*/ 14, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		if (CMrlComponent::GetGlobalOperationMode() != "") {
			SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
		} else {
			SetOperationMode ("wol", false /*true*/); /* default */
		}
		if (parentP != (mem_3_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
        RowNb = rowNb;
	}

example_block::mem_3_class_Prxy::mem_3_class_Prxy(
          ac_bv* externalStorageP, u32 acBitOffset, bool bigEndian, u64 sizeArg, const string& name
) : CMrlRegister (
		externalStorageP, 
		acBitOffset, 
		bigEndian, 
		sizeArg, 
		name
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 14, 
		/*width*/ 14, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetMrlType(CMrlComponent::MRL_MEMORY_PROXY);
        if (ParentP != (mem_3_class*) 0) {
			this->SetOperationMode(ParentP->GetOperationMode(), false /*true*/);
        } else if (CMrlComponent::GetGlobalOperationMode() != "") {
			this->SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
        }
	}

example_block::mem_3_class_Prxy::mem_3_class_Prxy(const mem_3_class_Prxy& rhs
) : CMrlRegister( 
	"mem_3" /*Name*/, 
	0, 
	12,  
	CMrlComponent::MRL_MEMORY_PROXY, 
	CMrlComponent::MEM_PROXY, 
	NULL /*Parent*/ 
	)
	, fl1(
		/*name*/ "fl1",
		/*offset*/ 14, 
		/*width*/ 14, 
		CMrlComponent::MRL_FIELD, 
		CMrlComponent::FIELD, 
		/*parent reg ptr*/ (CMrlComponent*) this, 
		/*Access Permissions*/ CMrlComponent::READ_WRITE, 
		/*reset value*/ (const ac_bv&) ac_bv::bv(0ULL)
	)

	{
		SetComponentType   (rhs.ComponentType)    ;
        SetName            (rhs.Name)             ;
        SetOperationMode   (rhs.OperationMode)    ;
        SetOffset          (rhs.Offset)           ;
        SetSize            (rhs.Size)             ;
        SetPhantom         (rhs.Phantom)          ;

        SetArrayIndex      (rhs.ArrayIndex)       ;
        SetNbArrayElements (rhs.NbArrayElements)  ;
        SetDirty           (rhs.Dirty)            ;
        SetActive          (rhs.Active)           ;
        SetClassName       (rhs.ClassName)        ;
        SetDoc             (rhs.Doc)              ;
        SetMrlType         (rhs.MrlType)          ;
        SetValidValues     (rhs.ValidValues)      ;
        SetCpuRdWrEnable   (rhs.CpuRdWrEnable)    ;

        RowNb   = rhs.GetRowNb();
        ParentP = rhs.GetParentP();

        if (ParentP == (mem_3_class*) 0) {
          this->SetOperationMode(CMrlComponent::GetGlobalOperationMode());
        }

        this->SetValue(rhs.GetValue());
      }

example_block::mem_3_class_Prxy::~mem_3_class_Prxy() {

}

example_block::mem_3_class_Prxy& example_block::mem_3_class_Prxy::operator=(
	const example_block::mem_3_class_Prxy& rhs) { 
			SetValue(rhs.GetValue()); 
			return(*this); 
	}

u32 example_block::mem_3_class_Prxy::GetRowNb() const {
	return(RowNb);
}

void example_block::mem_3_class_Prxy::SetRowNb(u32 value ) {
	RowNb = value;
}

void example_block::mem_3_class_Prxy::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
	if  (operationMode == "wol") {  
		CMrlComponent::OperationMode = operationMode;
		this->data.SetResetValue(0x0);
  }
}

example_block::mem_3_class::mem_3_class(
		string name, 
		u64 offsetArg, 
		mrl_type_t memoryMrlType,
		component_type_t memoryComponentType,
		u32 memDepthArg,
		u32 memWidthArg,
		CMrlComponent* parentP
  ) : CMrlMemory<mem_3_class_Prxy>(
		name, offsetArg, 
		memoryMrlType, 
		memoryComponentType, 
		memDepthArg, 
		memWidthArg, 
		parentP)
{

	SetAttribute("mem_test_ro", (ac_bv) 1);
	SetTypeString("flop_array");
	if (CMrlComponent::GetGlobalOperationMode() != "") {
		SetOperationMode(CMrlComponent::GetGlobalOperationMode(), false /*true*/);
	} else {
		SetOperationMode ("wol", false /*true*/); /* default */
	}
 }

void example_block::mem_3_class::SetOperationMode ( const string& operationMode, bool recurse, bool setit )  {
	if (setit) {
		CMrlComponent::OperationMode = operationMode;
	}
	CMrlMemory<mem_3_class_Prxy>::SetOperationMode(operationMode, recurse);
	if (recurse) { 
		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	}
  	if  (operationMode == "wol") {  
    CMrlComponent::OperationMode = operationMode;
	}
}

void example_block::SetOperationMode(const string& operationMode, bool recurse, bool setit) {
	bool operationModeChanged = (operationMode != GetOperationMode());
	note("%s : (Id = %p)  Setting operation mode to '%s'", GetName().c_str(), Id, operationMode.c_str());
  	if (recurse) { 
  		CMrlComponent::SetOperationMode(operationMode, recurse, false); 
	} 
	if  (operationMode == "wol") { 
		CMrlComponent::OperationMode = operationMode;
	}
	if (operationModeChanged)
  		Reset();
}


