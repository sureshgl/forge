package com.forge.parser;

import com.forge.parser.ext.AbstractBaseExt;
import com.forge.parser.gen.ForgeParser;
import com.forge.parser.gen.ForgeParserBaseVisitor;

public class ExtendedContextVisitor extends ForgeParserBaseVisitor<AbstractBaseExt> {
	@Override
	public AbstractBaseExt visitStart(ForgeParser.StartContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitConstarint_list(ForgeParser.Constarint_listContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_log(ForgeParser.Type_logContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_log_identifier(ForgeParser.Type_log_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_log_properties(ForgeParser.Type_log_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitTrace(ForgeParser.TraceContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitDebug(ForgeParser.DebugContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitInfo(ForgeParser.InfoContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWarning(ForgeParser.WarningContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitError(ForgeParser.ErrorContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitFatal(ForgeParser.FatalContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitParameter(ForgeParser.ParameterContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitParameter_identifier(ForgeParser.Parameter_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitParameter_value(ForgeParser.Parameter_valueContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitLocalparam(ForgeParser.LocalparamContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitLocalparam_identifier(ForgeParser.Localparam_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitLocalparam_value(ForgeParser.Localparam_valueContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_set(ForgeParser.Field_setContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_set_identifier(ForgeParser.Field_set_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_set_properties(ForgeParser.Field_set_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_enum(ForgeParser.Type_enumContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitEnum_identifier(ForgeParser.Enum_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitEnum_properties(ForgeParser.Enum_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_map(ForgeParser.Hash_mapContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_map_integer(ForgeParser.Hash_map_integerContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_map_mnemonic(ForgeParser.Hash_map_mnemonicContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_map_description(ForgeParser.Hash_map_descriptionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSlave(ForgeParser.SlaveContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSlave_properties(ForgeParser.Slave_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSlave_type(ForgeParser.Slave_typeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_slave_action(ForgeParser.Type_slave_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_slave_action_part1(ForgeParser.Type_slave_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitData_width(ForgeParser.Data_widthContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHint_zerotime(ForgeParser.Hint_zerotimeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHint_zerotime_identifier(ForgeParser.Hint_zerotime_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHint_zerotime_properties(ForgeParser.Hint_zerotime_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_hashtable(ForgeParser.Type_hashtableContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_hashtable_identifier(ForgeParser.Type_hashtable_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_hashtable_properties(ForgeParser.Type_hashtable_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_elam(ForgeParser.Type_elamContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_elam_identifier(ForgeParser.Type_elam_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_elam_properties(ForgeParser.Type_elam_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_slave(ForgeParser.Type_slaveContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_slave_identifier(ForgeParser.Type_slave_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_slave_properties(ForgeParser.Type_slave_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_ecc(ForgeParser.Type_eccContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_ecc_identifier(ForgeParser.Type_ecc_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_ecc_properties(ForgeParser.Type_ecc_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_cpu_access(ForgeParser.Type_cpu_accessContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_cpu_access_identifier(ForgeParser.Type_cpu_access_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_cpu_access_properties(ForgeParser.Type_cpu_access_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_field(ForgeParser.Type_fieldContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_field_identifier(ForgeParser.Type_field_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_field_properties(ForgeParser.Type_field_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_write(ForgeParser.Type_writeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_write_identifier(ForgeParser.Type_write_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_write_properties(ForgeParser.Type_write_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_read(ForgeParser.Type_readContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_read_identifier(ForgeParser.Type_read_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_read_properties(ForgeParser.Type_read_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitProperty_elam(ForgeParser.Property_elamContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitProperty_elam_identifier(ForgeParser.Property_elam_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitProperty_elam_properties(ForgeParser.Property_elam_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitFlop_array(ForgeParser.Flop_arrayContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitFlop_array_properties(ForgeParser.Flop_array_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitFlop_array_identifier(ForgeParser.Flop_array_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitElam(ForgeParser.ElamContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitElam_properties(ForgeParser.Elam_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitElam_identifier(ForgeParser.Elam_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_debug(ForgeParser.Sim_debugContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_debug_properties(ForgeParser.Sim_debug_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_debug_identifier(ForgeParser.Sim_debug_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRepeater(ForgeParser.RepeaterContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRepeater_properties(ForgeParser.Repeater_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitFlop(ForgeParser.FlopContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWire(ForgeParser.WireContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWire_list(ForgeParser.Wire_listContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWire_identifier(ForgeParser.Wire_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRepeater_identifier(ForgeParser.Repeater_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBundle(ForgeParser.BundleContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBundle_properties(ForgeParser.Bundle_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_print(ForgeParser.Sim_printContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_print_properties(ForgeParser.Sim_print_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitLogger(ForgeParser.LoggerContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSim_print_identifier(ForgeParser.Sim_print_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitTrigger_identifier(ForgeParser.Trigger_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitTcam(ForgeParser.TcamContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitTcam_properties(ForgeParser.Tcam_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHashtable(ForgeParser.HashtableContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_properties(ForgeParser.Hash_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_attr(ForgeParser.Type_attrContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBuckets(ForgeParser.BucketsContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBuckets_number(ForgeParser.Buckets_numberContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitKey(ForgeParser.KeyContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitKey_identifier(ForgeParser.Key_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitValue(ForgeParser.ValueContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitValue_identifier(ForgeParser.Value_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_hint(ForgeParser.Hash_hintContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitHint_memogen(ForgeParser.Hint_memogenContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitHint_zerotime_action(ForgeParser.Hint_zerotime_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHint_zerotime_action_part1(ForgeParser.Hint_zerotime_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRegister(ForgeParser.RegisterContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRegister_properties(ForgeParser.Register_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRegister_log(ForgeParser.Register_logContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRegister_list(ForgeParser.Register_listContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitGroup(ForgeParser.GroupContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField(ForgeParser.FieldContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_part1(ForgeParser.Field_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_part2(ForgeParser.Field_part2Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_part3(ForgeParser.Field_part3Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_array(ForgeParser.Field_arrayContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAlign(ForgeParser.AlignContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAttributes(ForgeParser.AttributesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitArray(ForgeParser.ArrayContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitDescription_attr(ForgeParser.Description_attrContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRead_attr(ForgeParser.Read_attrContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWrite_attr(ForgeParser.Write_attrContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRst_value(ForgeParser.Rst_valueContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMin_size(ForgeParser.Min_sizeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMax_size(ForgeParser.Max_sizeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory(ForgeParser.MemoryContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_list(ForgeParser.Memory_listContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_properties(ForgeParser.Memory_propertiesContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBanks_size(ForgeParser.Banks_sizeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPort_prefix(ForgeParser.Port_prefixContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRead_port_prefix(ForgeParser.Read_port_prefixContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWrite_port_prefix(ForgeParser.Write_port_prefixContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPort_prefix_list(ForgeParser.Port_prefix_listContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPort_prefix_identifier(ForgeParser.Port_prefix_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPort_prefix_mux(ForgeParser.Port_prefix_muxContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_identifier(ForgeParser.Memory_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_log(ForgeParser.Memory_logContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap(ForgeParser.PortCapContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPc(ForgeParser.PcContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPr(ForgeParser.PrContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPc_(ForgeParser.Pc_Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPr_(ForgeParser.Pr_Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPrt(ForgeParser.PrtContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_xm(ForgeParser.PortCap_xmContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_xs(ForgeParser.PortCap_xsContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_r(ForgeParser.PortCap_rContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_w(ForgeParser.PortCap_wContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_ru(ForgeParser.PortCap_ruContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_rw(ForgeParser.PortCap_rwContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_m(ForgeParser.PortCap_mContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_d(ForgeParser.PortCap_dContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_k(ForgeParser.PortCap_kContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_l(ForgeParser.PortCap_lContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_c(ForgeParser.PortCap_cContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_a(ForgeParser.PortCap_aContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_t(ForgeParser.PortCap_tContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_b(ForgeParser.PortCap_bContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitPortCap_hu(ForgeParser.PortCap_huContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWords(ForgeParser.WordsContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBits(ForgeParser.BitsContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitHash_type(ForgeParser.Hash_typeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_hashtable_action(ForgeParser.Type_hashtable_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitType_hashtable_action_part1(ForgeParser.Type_hashtable_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_cpu(ForgeParser.Memory_cpuContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMemory_ecc(ForgeParser.Memory_eccContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitEcc_words(ForgeParser.Ecc_wordsContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitEcc_action(ForgeParser.Ecc_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitEcc_action_part1(ForgeParser.Ecc_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRead_action(ForgeParser.Read_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRead_action_part1(ForgeParser.Read_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWrite_action(ForgeParser.Write_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitWrite_action_part1(ForgeParser.Write_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_action(ForgeParser.Field_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_action_part1(ForgeParser.Field_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitCpu_access_action(ForgeParser.Cpu_access_actionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitCpu_access_action_part1(ForgeParser.Cpu_access_action_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAction_id(ForgeParser.Action_idContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAction_id_part1(ForgeParser.Action_id_part1Context ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAction_id_identifier(ForgeParser.Action_id_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSize(ForgeParser.SizeContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_enum(ForgeParser.Field_enumContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitRegister_identifier(ForgeParser.Register_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitGroup_identifier(ForgeParser.Group_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitBundle_identifier(ForgeParser.Bundle_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitField_identifier(ForgeParser.Field_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSimple_identifier(ForgeParser.Simple_identifierContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitNumber(ForgeParser.NumberContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitNumber_only_expression(ForgeParser.Number_only_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitId_only_expression(ForgeParser.Id_only_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitAddition_expression(ForgeParser.Addition_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitSubtraction_expression(ForgeParser.Subtraction_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitMultiplication_expression(ForgeParser.Multiplication_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitDivision_expression(ForgeParser.Division_expressionContext ctx) {
		return ctx.extendedContext;
	}

	@Override
	public AbstractBaseExt visitModulo_expression(ForgeParser.Modulo_expressionContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitStart_offset(ForgeParser.Start_offsetContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitId_or_number(ForgeParser.Id_or_numberContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitMaster(ForgeParser.MasterContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitMaster_name(ForgeParser.Master_nameContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitChain(ForgeParser.ChainContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitSlave_name(ForgeParser.Slave_nameContext ctx) {
		return ctx.extendedContext;
	}
	
	@Override
	public AbstractBaseExt visitMemogen_cut(ForgeParser.Memogen_cutContext ctx) {
		return ctx.extendedContext;
	}
	
}
