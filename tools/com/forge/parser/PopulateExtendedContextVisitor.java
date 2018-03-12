package com.forge.parser;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.ext.*;
import com.forge.parser.gen.ForgeParser;
import com.forge.parser.gen.ForgeParserBaseVisitor;

public class PopulateExtendedContextVisitor extends ForgeParserBaseVisitor<ParserRuleContext> {

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitStart(ForgeParser.StartContext ctx) {
		super.visitStart(ctx);
		ctx.extendedContext = new StartContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitConstarint_list(ForgeParser.Constarint_listContext ctx) {
		super.visitConstarint_list(ctx);
		ctx.extendedContext = new Constarint_listContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_log(ForgeParser.Type_logContext ctx) {
		super.visitType_log(ctx);
		ctx.extendedContext = new Type_logContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_log_identifier(ForgeParser.Type_log_identifierContext ctx) {
		super.visitType_log_identifier(ctx);
		ctx.extendedContext = new Type_log_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_log_properties(ForgeParser.Type_log_propertiesContext ctx) {
		super.visitType_log_properties(ctx);
		ctx.extendedContext = new Type_log_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitTrace(ForgeParser.TraceContext ctx) {
		super.visitTrace(ctx);
		ctx.extendedContext = new TraceContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitDebug(ForgeParser.DebugContext ctx) {
		super.visitDebug(ctx);
		ctx.extendedContext = new DebugContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitInfo(ForgeParser.InfoContext ctx) {
		super.visitInfo(ctx);
		ctx.extendedContext = new InfoContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWarning(ForgeParser.WarningContext ctx) {
		super.visitWarning(ctx);
		ctx.extendedContext = new WarningContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitError(ForgeParser.ErrorContext ctx) {
		super.visitError(ctx);
		ctx.extendedContext = new ErrorContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitFatal(ForgeParser.FatalContext ctx) {
		super.visitFatal(ctx);
		ctx.extendedContext = new FatalContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitParameter(ForgeParser.ParameterContext ctx) {
		super.visitParameter(ctx);
		ctx.extendedContext = new ParameterContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitParameter_identifier(
			ForgeParser.Parameter_identifierContext ctx) {
		super.visitParameter_identifier(ctx);
		ctx.extendedContext = new Parameter_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitParameter_value(ForgeParser.Parameter_valueContext ctx) {
		super.visitParameter_value(ctx);
		ctx.extendedContext = new Parameter_valueContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitLocalparam(ForgeParser.LocalparamContext ctx) {
		super.visitLocalparam(ctx);
		ctx.extendedContext = new LocalparamContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitLocalparam_identifier(
			ForgeParser.Localparam_identifierContext ctx) {
		super.visitLocalparam_identifier(ctx);
		ctx.extendedContext = new Localparam_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitLocalparam_value(ForgeParser.Localparam_valueContext ctx) {
		super.visitLocalparam_value(ctx);
		ctx.extendedContext = new Localparam_valueContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_set(ForgeParser.Field_setContext ctx) {
		super.visitField_set(ctx);
		ctx.extendedContext = new Field_setContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_set_identifier(
			ForgeParser.Field_set_identifierContext ctx) {
		super.visitField_set_identifier(ctx);
		ctx.extendedContext = new Field_set_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_set_properties(
			ForgeParser.Field_set_propertiesContext ctx) {
		super.visitField_set_properties(ctx);
		ctx.extendedContext = new Field_set_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_enum(ForgeParser.Type_enumContext ctx) {
		super.visitType_enum(ctx);
		ctx.extendedContext = new Type_enumContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitEnum_identifier(ForgeParser.Enum_identifierContext ctx) {
		super.visitEnum_identifier(ctx);
		ctx.extendedContext = new Enum_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitEnum_properties(ForgeParser.Enum_propertiesContext ctx) {
		super.visitEnum_properties(ctx);
		ctx.extendedContext = new Enum_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_map(ForgeParser.Hash_mapContext ctx) {
		super.visitHash_map(ctx);
		ctx.extendedContext = new Hash_mapContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_map_integer(ForgeParser.Hash_map_integerContext ctx) {
		super.visitHash_map_integer(ctx);
		ctx.extendedContext = new Hash_map_integerContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_map_mnemonic(ForgeParser.Hash_map_mnemonicContext ctx) {
		super.visitHash_map_mnemonic(ctx);
		ctx.extendedContext = new Hash_map_mnemonicContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_map_description(
			ForgeParser.Hash_map_descriptionContext ctx) {
		super.visitHash_map_description(ctx);
		ctx.extendedContext = new Hash_map_descriptionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSlave(ForgeParser.SlaveContext ctx) {
		super.visitSlave(ctx);
		ctx.extendedContext = new SlaveContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSlave_properties(ForgeParser.Slave_propertiesContext ctx) {
		super.visitSlave_properties(ctx);
		ctx.extendedContext = new Slave_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSlave_type(ForgeParser.Slave_typeContext ctx) {
		super.visitSlave_type(ctx);
		ctx.extendedContext = new Slave_typeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_slave_action(ForgeParser.Type_slave_actionContext ctx) {
		super.visitType_slave_action(ctx);
		ctx.extendedContext = new Type_slave_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_slave_action_part1(
			ForgeParser.Type_slave_action_part1Context ctx) {
		super.visitType_slave_action_part1(ctx);
		ctx.extendedContext = new Type_slave_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitData_width(ForgeParser.Data_widthContext ctx) {
		super.visitData_width(ctx);
		ctx.extendedContext = new Data_widthContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_zerotime(ForgeParser.Hint_zerotimeContext ctx) {
		super.visitHint_zerotime(ctx);
		ctx.extendedContext = new Hint_zerotimeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_zerotime_identifier(
			ForgeParser.Hint_zerotime_identifierContext ctx) {
		super.visitHint_zerotime_identifier(ctx);
		ctx.extendedContext = new Hint_zerotime_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_zerotime_properties(
			ForgeParser.Hint_zerotime_propertiesContext ctx) {
		super.visitHint_zerotime_properties(ctx);
		ctx.extendedContext = new Hint_zerotime_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_hashtable(ForgeParser.Type_hashtableContext ctx) {
		super.visitType_hashtable(ctx);
		ctx.extendedContext = new Type_hashtableContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_hashtable_identifier(
			ForgeParser.Type_hashtable_identifierContext ctx) {
		super.visitType_hashtable_identifier(ctx);
		ctx.extendedContext = new Type_hashtable_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_hashtable_properties(
			ForgeParser.Type_hashtable_propertiesContext ctx) {
		super.visitType_hashtable_properties(ctx);
		ctx.extendedContext = new Type_hashtable_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_elam(ForgeParser.Type_elamContext ctx) {
		super.visitType_elam(ctx);
		ctx.extendedContext = new Type_elamContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_elam_identifier(
			ForgeParser.Type_elam_identifierContext ctx) {
		super.visitType_elam_identifier(ctx);
		ctx.extendedContext = new Type_elam_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_elam_properties(
			ForgeParser.Type_elam_propertiesContext ctx) {
		super.visitType_elam_properties(ctx);
		ctx.extendedContext = new Type_elam_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_slave(ForgeParser.Type_slaveContext ctx) {
		super.visitType_slave(ctx);
		ctx.extendedContext = new Type_slaveContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_slave_identifier(
			ForgeParser.Type_slave_identifierContext ctx) {
		super.visitType_slave_identifier(ctx);
		ctx.extendedContext = new Type_slave_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_slave_properties(
			ForgeParser.Type_slave_propertiesContext ctx) {
		super.visitType_slave_properties(ctx);
		ctx.extendedContext = new Type_slave_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_ecc(ForgeParser.Type_eccContext ctx) {
		super.visitType_ecc(ctx);
		ctx.extendedContext = new Type_eccContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_ecc_identifier(ForgeParser.Type_ecc_identifierContext ctx) {
		super.visitType_ecc_identifier(ctx);
		ctx.extendedContext = new Type_ecc_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_ecc_properties(ForgeParser.Type_ecc_propertiesContext ctx) {
		super.visitType_ecc_properties(ctx);
		ctx.extendedContext = new Type_ecc_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_cpu_access(ForgeParser.Type_cpu_accessContext ctx) {
		super.visitType_cpu_access(ctx);
		ctx.extendedContext = new Type_cpu_accessContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_cpu_access_identifier(
			ForgeParser.Type_cpu_access_identifierContext ctx) {
		super.visitType_cpu_access_identifier(ctx);
		ctx.extendedContext = new Type_cpu_access_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_cpu_access_properties(
			ForgeParser.Type_cpu_access_propertiesContext ctx) {
		super.visitType_cpu_access_properties(ctx);
		ctx.extendedContext = new Type_cpu_access_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_field(ForgeParser.Type_fieldContext ctx) {
		super.visitType_field(ctx);
		ctx.extendedContext = new Type_fieldContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_field_identifier(
			ForgeParser.Type_field_identifierContext ctx) {
		super.visitType_field_identifier(ctx);
		ctx.extendedContext = new Type_field_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_field_properties(
			ForgeParser.Type_field_propertiesContext ctx) {
		super.visitType_field_properties(ctx);
		ctx.extendedContext = new Type_field_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_write(ForgeParser.Type_writeContext ctx) {
		super.visitType_write(ctx);
		ctx.extendedContext = new Type_writeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_write_identifier(
			ForgeParser.Type_write_identifierContext ctx) {
		super.visitType_write_identifier(ctx);
		ctx.extendedContext = new Type_write_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_write_properties(
			ForgeParser.Type_write_propertiesContext ctx) {
		super.visitType_write_properties(ctx);
		ctx.extendedContext = new Type_write_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_read(ForgeParser.Type_readContext ctx) {
		super.visitType_read(ctx);
		ctx.extendedContext = new Type_readContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_read_identifier(
			ForgeParser.Type_read_identifierContext ctx) {
		super.visitType_read_identifier(ctx);
		ctx.extendedContext = new Type_read_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_read_properties(
			ForgeParser.Type_read_propertiesContext ctx) {
		super.visitType_read_properties(ctx);
		ctx.extendedContext = new Type_read_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitProperty_elam(ForgeParser.Property_elamContext ctx) {
		super.visitProperty_elam(ctx);
		ctx.extendedContext = new Property_elamContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitProperty_elam_identifier(
			ForgeParser.Property_elam_identifierContext ctx) {
		super.visitProperty_elam_identifier(ctx);
		ctx.extendedContext = new Property_elam_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitProperty_elam_properties(
			ForgeParser.Property_elam_propertiesContext ctx) {
		super.visitProperty_elam_properties(ctx);
		ctx.extendedContext = new Property_elam_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitFlop_array(ForgeParser.Flop_arrayContext ctx) {
		super.visitFlop_array(ctx);
		ctx.extendedContext = new Flop_arrayContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitFlop_array_properties(
			ForgeParser.Flop_array_propertiesContext ctx) {
		super.visitFlop_array_properties(ctx);
		ctx.extendedContext = new Flop_array_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitFlop_array_identifier(
			ForgeParser.Flop_array_identifierContext ctx) {
		super.visitFlop_array_identifier(ctx);
		ctx.extendedContext = new Flop_array_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitElam(ForgeParser.ElamContext ctx) {
		super.visitElam(ctx);
		ctx.extendedContext = new ElamContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitElam_properties(ForgeParser.Elam_propertiesContext ctx) {
		super.visitElam_properties(ctx);
		ctx.extendedContext = new Elam_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitElam_identifier(ForgeParser.Elam_identifierContext ctx) {
		super.visitElam_identifier(ctx);
		ctx.extendedContext = new Elam_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_debug(ForgeParser.Sim_debugContext ctx) {
		super.visitSim_debug(ctx);
		ctx.extendedContext = new Sim_debugContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_debug_properties(
			ForgeParser.Sim_debug_propertiesContext ctx) {
		super.visitSim_debug_properties(ctx);
		ctx.extendedContext = new Sim_debug_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_debug_identifier(
			ForgeParser.Sim_debug_identifierContext ctx) {
		super.visitSim_debug_identifier(ctx);
		ctx.extendedContext = new Sim_debug_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRepeater(ForgeParser.RepeaterContext ctx) {
		super.visitRepeater(ctx);
		ctx.extendedContext = new RepeaterContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRepeater_properties(ForgeParser.Repeater_propertiesContext ctx) {
		super.visitRepeater_properties(ctx);
		ctx.extendedContext = new Repeater_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitFlop(ForgeParser.FlopContext ctx) {
		super.visitFlop(ctx);
		ctx.extendedContext = new FlopContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWire(ForgeParser.WireContext ctx) {
		super.visitWire(ctx);
		ctx.extendedContext = new WireContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWire_list(ForgeParser.Wire_listContext ctx) {
		super.visitWire_list(ctx);
		ctx.extendedContext = new Wire_listContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWire_identifier(ForgeParser.Wire_identifierContext ctx) {
		super.visitWire_identifier(ctx);
		ctx.extendedContext = new Wire_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRepeater_identifier(ForgeParser.Repeater_identifierContext ctx) {
		super.visitRepeater_identifier(ctx);
		ctx.extendedContext = new Repeater_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBundle(ForgeParser.BundleContext ctx) {
		super.visitBundle(ctx);
		ctx.extendedContext = new BundleContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBundle_properties(ForgeParser.Bundle_propertiesContext ctx) {
		super.visitBundle_properties(ctx);
		ctx.extendedContext = new Bundle_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_print(ForgeParser.Sim_printContext ctx) {
		super.visitSim_print(ctx);
		ctx.extendedContext = new Sim_printContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_print_properties(
			ForgeParser.Sim_print_propertiesContext ctx) {
		super.visitSim_print_properties(ctx);
		ctx.extendedContext = new Sim_print_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitLogger(ForgeParser.LoggerContext ctx) {
		super.visitLogger(ctx);
		ctx.extendedContext = new LoggerContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSim_print_identifier(
			ForgeParser.Sim_print_identifierContext ctx) {
		super.visitSim_print_identifier(ctx);
		ctx.extendedContext = new Sim_print_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitTrigger_identifier(ForgeParser.Trigger_identifierContext ctx) {
		super.visitTrigger_identifier(ctx);
		ctx.extendedContext = new Trigger_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitTcam(ForgeParser.TcamContext ctx) {
		super.visitTcam(ctx);
		ctx.extendedContext = new TcamContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitTcam_properties(ForgeParser.Tcam_propertiesContext ctx) {
		super.visitTcam_properties(ctx);
		ctx.extendedContext = new Tcam_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHashtable(ForgeParser.HashtableContext ctx) {
		super.visitHashtable(ctx);
		ctx.extendedContext = new HashtableContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_properties(ForgeParser.Hash_propertiesContext ctx) {
		super.visitHash_properties(ctx);
		ctx.extendedContext = new Hash_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_attr(ForgeParser.Type_attrContext ctx) {
		super.visitType_attr(ctx);
		ctx.extendedContext = new Type_attrContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBuckets(ForgeParser.BucketsContext ctx) {
		super.visitBuckets(ctx);
		ctx.extendedContext = new BucketsContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBuckets_number(ForgeParser.Buckets_numberContext ctx) {
		super.visitBuckets_number(ctx);
		ctx.extendedContext = new Buckets_numberContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitKey(ForgeParser.KeyContext ctx) {
		super.visitKey(ctx);
		ctx.extendedContext = new KeyContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitKey_identifier(ForgeParser.Key_identifierContext ctx) {
		super.visitKey_identifier(ctx);
		ctx.extendedContext = new Key_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitValue(ForgeParser.ValueContext ctx) {
		super.visitValue(ctx);
		ctx.extendedContext = new ValueContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitValue_identifier(ForgeParser.Value_identifierContext ctx) {
		super.visitValue_identifier(ctx);
		ctx.extendedContext = new Value_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_hint(ForgeParser.Hash_hintContext ctx) {
		super.visitHash_hint(ctx);
		ctx.extendedContext = new Hash_hintContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_zerotime_action(
			ForgeParser.Hint_zerotime_actionContext ctx) {
		super.visitHint_zerotime_action(ctx);
		ctx.extendedContext = new Hint_zerotime_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_zerotime_action_part1(
			ForgeParser.Hint_zerotime_action_part1Context ctx) {
		super.visitHint_zerotime_action_part1(ctx);
		ctx.extendedContext = new Hint_zerotime_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRegister(ForgeParser.RegisterContext ctx) {
		super.visitRegister(ctx);
		ctx.extendedContext = new RegisterContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRegister_properties(ForgeParser.Register_propertiesContext ctx) {
		super.visitRegister_properties(ctx);
		ctx.extendedContext = new Register_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRegister_log(ForgeParser.Register_logContext ctx) {
		super.visitRegister_log(ctx);
		ctx.extendedContext = new Register_logContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRegister_list(ForgeParser.Register_listContext ctx) {
		super.visitRegister_list(ctx);
		ctx.extendedContext = new Register_listContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitGroup(ForgeParser.GroupContext ctx) {
		super.visitGroup(ctx);
		ctx.extendedContext = new GroupContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField(ForgeParser.FieldContext ctx) {
		super.visitField(ctx);
		ctx.extendedContext = new FieldContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_part1(ForgeParser.Field_part1Context ctx) {
		super.visitField_part1(ctx);
		ctx.extendedContext = new Field_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_part2(ForgeParser.Field_part2Context ctx) {
		super.visitField_part2(ctx);
		ctx.extendedContext = new Field_part2ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_part3(ForgeParser.Field_part3Context ctx) {
		super.visitField_part3(ctx);
		ctx.extendedContext = new Field_part3ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_array(ForgeParser.Field_arrayContext ctx) {
		super.visitField_array(ctx);
		ctx.extendedContext = new Field_arrayContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAlign(ForgeParser.AlignContext ctx) {
		super.visitAlign(ctx);
		ctx.extendedContext = new AlignContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAttributes(ForgeParser.AttributesContext ctx) {
		super.visitAttributes(ctx);
		ctx.extendedContext = new AttributesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitArray(ForgeParser.ArrayContext ctx) {
		super.visitArray(ctx);
		ctx.extendedContext = new ArrayContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitDescription_attr(ForgeParser.Description_attrContext ctx) {
		super.visitDescription_attr(ctx);
		ctx.extendedContext = new Description_attrContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRead_attr(ForgeParser.Read_attrContext ctx) {
		super.visitRead_attr(ctx);
		ctx.extendedContext = new Read_attrContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWrite_attr(ForgeParser.Write_attrContext ctx) {
		super.visitWrite_attr(ctx);
		ctx.extendedContext = new Write_attrContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRst_value(ForgeParser.Rst_valueContext ctx) {
		super.visitRst_value(ctx);
		ctx.extendedContext = new Rst_valueContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMin_size(ForgeParser.Min_sizeContext ctx) {
		super.visitMin_size(ctx);
		ctx.extendedContext = new Min_sizeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMax_size(ForgeParser.Max_sizeContext ctx) {
		super.visitMax_size(ctx);
		ctx.extendedContext = new Max_sizeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory(ForgeParser.MemoryContext ctx) {
		super.visitMemory(ctx);
		ctx.extendedContext = new MemoryContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_list(ForgeParser.Memory_listContext ctx) {
		super.visitMemory_list(ctx);
		ctx.extendedContext = new Memory_listContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_properties(ForgeParser.Memory_propertiesContext ctx) {
		super.visitMemory_properties(ctx);
		ctx.extendedContext = new Memory_propertiesContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBanks_size(ForgeParser.Banks_sizeContext ctx) {
		super.visitBanks_size(ctx);
		ctx.extendedContext = new Banks_sizeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPort_prefix(ForgeParser.Port_prefixContext ctx) {
		super.visitPort_prefix(ctx);
		ctx.extendedContext = new Port_prefixContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRead_port_prefix(ForgeParser.Read_port_prefixContext ctx) {
		super.visitRead_port_prefix(ctx);
		ctx.extendedContext = new Read_port_prefixContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWrite_port_prefix(ForgeParser.Write_port_prefixContext ctx) {
		super.visitWrite_port_prefix(ctx);
		ctx.extendedContext = new Write_port_prefixContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPort_prefix_list(ForgeParser.Port_prefix_listContext ctx) {
		super.visitPort_prefix_list(ctx);
		ctx.extendedContext = new Port_prefix_listContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPort_prefix_identifier(
			ForgeParser.Port_prefix_identifierContext ctx) {
		super.visitPort_prefix_identifier(ctx);
		ctx.extendedContext = new Port_prefix_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPort_prefix_mux(ForgeParser.Port_prefix_muxContext ctx) {
		super.visitPort_prefix_mux(ctx);
		ctx.extendedContext = new Port_prefix_muxContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_identifier(ForgeParser.Memory_identifierContext ctx) {
		super.visitMemory_identifier(ctx);
		ctx.extendedContext = new Memory_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_log(ForgeParser.Memory_logContext ctx) {
		super.visitMemory_log(ctx);
		ctx.extendedContext = new Memory_logContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap(ForgeParser.PortCapContext ctx) {
		super.visitPortCap(ctx);
		ctx.extendedContext = new PortCapContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPc(ForgeParser.PcContext ctx) {
		super.visitPc(ctx);
		ctx.extendedContext = new PcContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPr(ForgeParser.PrContext ctx) {
		super.visitPr(ctx);
		ctx.extendedContext = new PrContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPc_(ForgeParser.Pc_Context ctx) {
		super.visitPc_(ctx);
		ctx.extendedContext = new Pc_ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPr_(ForgeParser.Pr_Context ctx) {
		super.visitPr_(ctx);
		ctx.extendedContext = new Pr_ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPrt(ForgeParser.PrtContext ctx) {
		super.visitPrt(ctx);
		ctx.extendedContext = new PrtContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_xm(ForgeParser.PortCap_xmContext ctx) {
		super.visitPortCap_xm(ctx);
		ctx.extendedContext = new PortCap_xmContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_xs(ForgeParser.PortCap_xsContext ctx) {
		super.visitPortCap_xs(ctx);
		ctx.extendedContext = new PortCap_xsContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_r(ForgeParser.PortCap_rContext ctx) {
		super.visitPortCap_r(ctx);
		ctx.extendedContext = new PortCap_rContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_w(ForgeParser.PortCap_wContext ctx) {
		super.visitPortCap_w(ctx);
		ctx.extendedContext = new PortCap_wContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_ru(ForgeParser.PortCap_ruContext ctx) {
		super.visitPortCap_ru(ctx);
		ctx.extendedContext = new PortCap_ruContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_rw(ForgeParser.PortCap_rwContext ctx) {
		super.visitPortCap_rw(ctx);
		ctx.extendedContext = new PortCap_rwContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_m(ForgeParser.PortCap_mContext ctx) {
		super.visitPortCap_m(ctx);
		ctx.extendedContext = new PortCap_mContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_d(ForgeParser.PortCap_dContext ctx) {
		super.visitPortCap_d(ctx);
		ctx.extendedContext = new PortCap_dContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_k(ForgeParser.PortCap_kContext ctx) {
		super.visitPortCap_k(ctx);
		ctx.extendedContext = new PortCap_kContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_l(ForgeParser.PortCap_lContext ctx) {
		super.visitPortCap_l(ctx);
		ctx.extendedContext = new PortCap_lContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_c(ForgeParser.PortCap_cContext ctx) {
		super.visitPortCap_c(ctx);
		ctx.extendedContext = new PortCap_cContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_a(ForgeParser.PortCap_aContext ctx) {
		super.visitPortCap_a(ctx);
		ctx.extendedContext = new PortCap_aContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_t(ForgeParser.PortCap_tContext ctx) {
		super.visitPortCap_t(ctx);
		ctx.extendedContext = new PortCap_tContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_b(ForgeParser.PortCap_bContext ctx) {
		super.visitPortCap_b(ctx);
		ctx.extendedContext = new PortCap_bContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitPortCap_hu(ForgeParser.PortCap_huContext ctx) {
		super.visitPortCap_hu(ctx);
		ctx.extendedContext = new PortCap_huContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWords(ForgeParser.WordsContext ctx) {
		super.visitWords(ctx);
		ctx.extendedContext = new WordsContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBits(ForgeParser.BitsContext ctx) {
		super.visitBits(ctx);
		ctx.extendedContext = new BitsContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHash_type(ForgeParser.Hash_typeContext ctx) {
		super.visitHash_type(ctx);
		ctx.extendedContext = new Hash_typeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_hashtable_action(
			ForgeParser.Type_hashtable_actionContext ctx) {
		super.visitType_hashtable_action(ctx);
		ctx.extendedContext = new Type_hashtable_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitType_hashtable_action_part1(
			ForgeParser.Type_hashtable_action_part1Context ctx) {
		super.visitType_hashtable_action_part1(ctx);
		ctx.extendedContext = new Type_hashtable_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitHint_memogen(
			ForgeParser.Hint_memogenContext ctx) {
		super.visitHint_memogen(ctx);
		ctx.extendedContext = new Hint_memogenContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_cpu(ForgeParser.Memory_cpuContext ctx) {
		super.visitMemory_cpu(ctx);
		ctx.extendedContext = new Memory_cpuContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemory_ecc(ForgeParser.Memory_eccContext ctx) {
		super.visitMemory_ecc(ctx);
		ctx.extendedContext = new Memory_eccContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitEcc_words(ForgeParser.Ecc_wordsContext ctx) {
		super.visitEcc_words(ctx);
		ctx.extendedContext = new Ecc_wordsContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitEcc_action(ForgeParser.Ecc_actionContext ctx) {
		super.visitEcc_action(ctx);
		ctx.extendedContext = new Ecc_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitEcc_action_part1(ForgeParser.Ecc_action_part1Context ctx) {
		super.visitEcc_action_part1(ctx);
		ctx.extendedContext = new Ecc_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRead_action(ForgeParser.Read_actionContext ctx) {
		super.visitRead_action(ctx);
		ctx.extendedContext = new Read_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRead_action_part1(ForgeParser.Read_action_part1Context ctx) {
		super.visitRead_action_part1(ctx);
		ctx.extendedContext = new Read_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWrite_action(ForgeParser.Write_actionContext ctx) {
		super.visitWrite_action(ctx);
		ctx.extendedContext = new Write_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitWrite_action_part1(ForgeParser.Write_action_part1Context ctx) {
		super.visitWrite_action_part1(ctx);
		ctx.extendedContext = new Write_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_action(ForgeParser.Field_actionContext ctx) {
		super.visitField_action(ctx);
		ctx.extendedContext = new Field_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_action_part1(ForgeParser.Field_action_part1Context ctx) {
		super.visitField_action_part1(ctx);
		ctx.extendedContext = new Field_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitCpu_access_action(ForgeParser.Cpu_access_actionContext ctx) {
		super.visitCpu_access_action(ctx);
		ctx.extendedContext = new Cpu_access_actionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitCpu_access_action_part1(
			ForgeParser.Cpu_access_action_part1Context ctx) {
		super.visitCpu_access_action_part1(ctx);
		ctx.extendedContext = new Cpu_access_action_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAction_id(ForgeParser.Action_idContext ctx) {
		super.visitAction_id(ctx);
		ctx.extendedContext = new Action_idContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAction_id_part1(ForgeParser.Action_id_part1Context ctx) {
		super.visitAction_id_part1(ctx);
		ctx.extendedContext = new Action_id_part1ContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAction_id_identifier(
			ForgeParser.Action_id_identifierContext ctx) {
		super.visitAction_id_identifier(ctx);
		ctx.extendedContext = new Action_id_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSize(ForgeParser.SizeContext ctx) {
		super.visitSize(ctx);
		ctx.extendedContext = new SizeContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_enum(ForgeParser.Field_enumContext ctx) {
		super.visitField_enum(ctx);
		ctx.extendedContext = new Field_enumContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitRegister_identifier(ForgeParser.Register_identifierContext ctx) {
		super.visitRegister_identifier(ctx);
		ctx.extendedContext = new Register_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitGroup_identifier(ForgeParser.Group_identifierContext ctx) {
		super.visitGroup_identifier(ctx);
		ctx.extendedContext = new Group_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitBundle_identifier(ForgeParser.Bundle_identifierContext ctx) {
		super.visitBundle_identifier(ctx);
		ctx.extendedContext = new Bundle_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitField_identifier(ForgeParser.Field_identifierContext ctx) {
		super.visitField_identifier(ctx);
		ctx.extendedContext = new Field_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSimple_identifier(ForgeParser.Simple_identifierContext ctx) {
		super.visitSimple_identifier(ctx);
		ctx.extendedContext = new Simple_identifierContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitNumber(ForgeParser.NumberContext ctx) {
		super.visitNumber(ctx);
		ctx.extendedContext = new NumberContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitNumber_only_expression(
			ForgeParser.Number_only_expressionContext ctx) {
		super.visitNumber_only_expression(ctx);
		ctx.extendedContext = new Number_only_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitId_only_expression(ForgeParser.Id_only_expressionContext ctx) {
		super.visitId_only_expression(ctx);
		ctx.extendedContext = new Id_only_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitAddition_expression(ForgeParser.Addition_expressionContext ctx) {
		super.visitAddition_expression(ctx);
		ctx.extendedContext = new Addition_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSubtraction_expression(
			ForgeParser.Subtraction_expressionContext ctx) {
		super.visitSubtraction_expression(ctx);
		ctx.extendedContext = new Subtraction_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMultiplication_expression(
			ForgeParser.Multiplication_expressionContext ctx) {
		super.visitMultiplication_expression(ctx);
		ctx.extendedContext = new Multiplication_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitDivision_expression(ForgeParser.Division_expressionContext ctx) {
		super.visitDivision_expression(ctx);
		ctx.extendedContext = new Division_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitModulo_expression(ForgeParser.Modulo_expressionContext ctx) {
		super.visitModulo_expression(ctx);
		ctx.extendedContext = new Modulo_expressionContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitStart_offset(ForgeParser.Start_offsetContext ctx) {
		super.visitStart_offset(ctx);
		ctx.extendedContext = new Start_offsetContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitId_or_number(ForgeParser.Id_or_numberContext ctx) {
		super.visitId_or_number(ctx);
		ctx.extendedContext = new Id_or_numberContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMaster(ForgeParser.MasterContext ctx) {
		super.visitMaster(ctx);
		ctx.extendedContext = new MasterContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMaster_name(ForgeParser.Master_nameContext ctx) {
		super.visitMaster_name(ctx);
		ctx.extendedContext = new Master_nameContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitChain(ForgeParser.ChainContext ctx) {
		super.visitChain(ctx);
		ctx.extendedContext = new ChainContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitSlave_name(ForgeParser.Slave_nameContext ctx) {
		super.visitSlave_name(ctx);
		ctx.extendedContext = new Slave_nameContextExt(ctx);
		return ctx;
	}

	@Override
	public org.antlr.v4.runtime.ParserRuleContext visitMemogen_cut(ForgeParser.Memogen_cutContext ctx) {
		super.visitMemogen_cut(ctx);
		ctx.extendedContext = new Memogen_cutContextExt(ctx);
		return ctx;
	}
}
