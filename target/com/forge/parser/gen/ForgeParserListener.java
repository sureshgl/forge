// Generated from ForgeParser.g4 by ANTLR 4.5
package com.forge.parser.gen;

    import com.forge.parser.ext.*;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ForgeParser}.
 */
public interface ForgeParserListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ForgeParser#start}.
	 * @param ctx the parse tree
	 */
	void enterStart(ForgeParser.StartContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#start}.
	 * @param ctx the parse tree
	 */
	void exitStart(ForgeParser.StartContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#constarint_list}.
	 * @param ctx the parse tree
	 */
	void enterConstarint_list(ForgeParser.Constarint_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#constarint_list}.
	 * @param ctx the parse tree
	 */
	void exitConstarint_list(ForgeParser.Constarint_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#master}.
	 * @param ctx the parse tree
	 */
	void enterMaster(ForgeParser.MasterContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#master}.
	 * @param ctx the parse tree
	 */
	void exitMaster(ForgeParser.MasterContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#master_name}.
	 * @param ctx the parse tree
	 */
	void enterMaster_name(ForgeParser.Master_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#master_name}.
	 * @param ctx the parse tree
	 */
	void exitMaster_name(ForgeParser.Master_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#chain}.
	 * @param ctx the parse tree
	 */
	void enterChain(ForgeParser.ChainContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#chain}.
	 * @param ctx the parse tree
	 */
	void exitChain(ForgeParser.ChainContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#slave_name}.
	 * @param ctx the parse tree
	 */
	void enterSlave_name(ForgeParser.Slave_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#slave_name}.
	 * @param ctx the parse tree
	 */
	void exitSlave_name(ForgeParser.Slave_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_log}.
	 * @param ctx the parse tree
	 */
	void enterType_log(ForgeParser.Type_logContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_log}.
	 * @param ctx the parse tree
	 */
	void exitType_log(ForgeParser.Type_logContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_log_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_log_identifier(ForgeParser.Type_log_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_log_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_log_identifier(ForgeParser.Type_log_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_log_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_log_properties(ForgeParser.Type_log_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_log_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_log_properties(ForgeParser.Type_log_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#trace}.
	 * @param ctx the parse tree
	 */
	void enterTrace(ForgeParser.TraceContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#trace}.
	 * @param ctx the parse tree
	 */
	void exitTrace(ForgeParser.TraceContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#debug}.
	 * @param ctx the parse tree
	 */
	void enterDebug(ForgeParser.DebugContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#debug}.
	 * @param ctx the parse tree
	 */
	void exitDebug(ForgeParser.DebugContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#info}.
	 * @param ctx the parse tree
	 */
	void enterInfo(ForgeParser.InfoContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#info}.
	 * @param ctx the parse tree
	 */
	void exitInfo(ForgeParser.InfoContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#warning}.
	 * @param ctx the parse tree
	 */
	void enterWarning(ForgeParser.WarningContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#warning}.
	 * @param ctx the parse tree
	 */
	void exitWarning(ForgeParser.WarningContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#error}.
	 * @param ctx the parse tree
	 */
	void enterError(ForgeParser.ErrorContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#error}.
	 * @param ctx the parse tree
	 */
	void exitError(ForgeParser.ErrorContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#fatal}.
	 * @param ctx the parse tree
	 */
	void enterFatal(ForgeParser.FatalContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#fatal}.
	 * @param ctx the parse tree
	 */
	void exitFatal(ForgeParser.FatalContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#parameter}.
	 * @param ctx the parse tree
	 */
	void enterParameter(ForgeParser.ParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#parameter}.
	 * @param ctx the parse tree
	 */
	void exitParameter(ForgeParser.ParameterContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void enterParameter_identifier(ForgeParser.Parameter_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void exitParameter_identifier(ForgeParser.Parameter_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#parameter_value}.
	 * @param ctx the parse tree
	 */
	void enterParameter_value(ForgeParser.Parameter_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#parameter_value}.
	 * @param ctx the parse tree
	 */
	void exitParameter_value(ForgeParser.Parameter_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#localparam}.
	 * @param ctx the parse tree
	 */
	void enterLocalparam(ForgeParser.LocalparamContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#localparam}.
	 * @param ctx the parse tree
	 */
	void exitLocalparam(ForgeParser.LocalparamContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#localparam_identifier}.
	 * @param ctx the parse tree
	 */
	void enterLocalparam_identifier(ForgeParser.Localparam_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#localparam_identifier}.
	 * @param ctx the parse tree
	 */
	void exitLocalparam_identifier(ForgeParser.Localparam_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#localparam_value}.
	 * @param ctx the parse tree
	 */
	void enterLocalparam_value(ForgeParser.Localparam_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#localparam_value}.
	 * @param ctx the parse tree
	 */
	void exitLocalparam_value(ForgeParser.Localparam_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_set}.
	 * @param ctx the parse tree
	 */
	void enterField_set(ForgeParser.Field_setContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_set}.
	 * @param ctx the parse tree
	 */
	void exitField_set(ForgeParser.Field_setContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_set_identifier}.
	 * @param ctx the parse tree
	 */
	void enterField_set_identifier(ForgeParser.Field_set_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_set_identifier}.
	 * @param ctx the parse tree
	 */
	void exitField_set_identifier(ForgeParser.Field_set_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_set_properties}.
	 * @param ctx the parse tree
	 */
	void enterField_set_properties(ForgeParser.Field_set_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_set_properties}.
	 * @param ctx the parse tree
	 */
	void exitField_set_properties(ForgeParser.Field_set_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_enum}.
	 * @param ctx the parse tree
	 */
	void enterType_enum(ForgeParser.Type_enumContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_enum}.
	 * @param ctx the parse tree
	 */
	void exitType_enum(ForgeParser.Type_enumContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#enum_identifier}.
	 * @param ctx the parse tree
	 */
	void enterEnum_identifier(ForgeParser.Enum_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#enum_identifier}.
	 * @param ctx the parse tree
	 */
	void exitEnum_identifier(ForgeParser.Enum_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#enum_properties}.
	 * @param ctx the parse tree
	 */
	void enterEnum_properties(ForgeParser.Enum_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#enum_properties}.
	 * @param ctx the parse tree
	 */
	void exitEnum_properties(ForgeParser.Enum_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_map}.
	 * @param ctx the parse tree
	 */
	void enterHash_map(ForgeParser.Hash_mapContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_map}.
	 * @param ctx the parse tree
	 */
	void exitHash_map(ForgeParser.Hash_mapContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_map_integer}.
	 * @param ctx the parse tree
	 */
	void enterHash_map_integer(ForgeParser.Hash_map_integerContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_map_integer}.
	 * @param ctx the parse tree
	 */
	void exitHash_map_integer(ForgeParser.Hash_map_integerContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_map_mnemonic}.
	 * @param ctx the parse tree
	 */
	void enterHash_map_mnemonic(ForgeParser.Hash_map_mnemonicContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_map_mnemonic}.
	 * @param ctx the parse tree
	 */
	void exitHash_map_mnemonic(ForgeParser.Hash_map_mnemonicContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_map_description}.
	 * @param ctx the parse tree
	 */
	void enterHash_map_description(ForgeParser.Hash_map_descriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_map_description}.
	 * @param ctx the parse tree
	 */
	void exitHash_map_description(ForgeParser.Hash_map_descriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#slave}.
	 * @param ctx the parse tree
	 */
	void enterSlave(ForgeParser.SlaveContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#slave}.
	 * @param ctx the parse tree
	 */
	void exitSlave(ForgeParser.SlaveContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#slave_properties}.
	 * @param ctx the parse tree
	 */
	void enterSlave_properties(ForgeParser.Slave_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#slave_properties}.
	 * @param ctx the parse tree
	 */
	void exitSlave_properties(ForgeParser.Slave_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#slave_type}.
	 * @param ctx the parse tree
	 */
	void enterSlave_type(ForgeParser.Slave_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#slave_type}.
	 * @param ctx the parse tree
	 */
	void exitSlave_type(ForgeParser.Slave_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_slave_action}.
	 * @param ctx the parse tree
	 */
	void enterType_slave_action(ForgeParser.Type_slave_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_slave_action}.
	 * @param ctx the parse tree
	 */
	void exitType_slave_action(ForgeParser.Type_slave_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_slave_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterType_slave_action_part1(ForgeParser.Type_slave_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_slave_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitType_slave_action_part1(ForgeParser.Type_slave_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#data_width}.
	 * @param ctx the parse tree
	 */
	void enterData_width(ForgeParser.Data_widthContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#data_width}.
	 * @param ctx the parse tree
	 */
	void exitData_width(ForgeParser.Data_widthContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_zerotime}.
	 * @param ctx the parse tree
	 */
	void enterHint_zerotime(ForgeParser.Hint_zerotimeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_zerotime}.
	 * @param ctx the parse tree
	 */
	void exitHint_zerotime(ForgeParser.Hint_zerotimeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_zerotime_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHint_zerotime_identifier(ForgeParser.Hint_zerotime_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_zerotime_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHint_zerotime_identifier(ForgeParser.Hint_zerotime_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_zerotime_properties}.
	 * @param ctx the parse tree
	 */
	void enterHint_zerotime_properties(ForgeParser.Hint_zerotime_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_zerotime_properties}.
	 * @param ctx the parse tree
	 */
	void exitHint_zerotime_properties(ForgeParser.Hint_zerotime_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_hashtable}.
	 * @param ctx the parse tree
	 */
	void enterType_hashtable(ForgeParser.Type_hashtableContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_hashtable}.
	 * @param ctx the parse tree
	 */
	void exitType_hashtable(ForgeParser.Type_hashtableContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_hashtable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_hashtable_identifier(ForgeParser.Type_hashtable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_hashtable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_hashtable_identifier(ForgeParser.Type_hashtable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_hashtable_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_hashtable_properties(ForgeParser.Type_hashtable_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_hashtable_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_hashtable_properties(ForgeParser.Type_hashtable_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_elam}.
	 * @param ctx the parse tree
	 */
	void enterType_elam(ForgeParser.Type_elamContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_elam}.
	 * @param ctx the parse tree
	 */
	void exitType_elam(ForgeParser.Type_elamContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_elam_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_elam_identifier(ForgeParser.Type_elam_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_elam_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_elam_identifier(ForgeParser.Type_elam_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_elam_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_elam_properties(ForgeParser.Type_elam_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_elam_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_elam_properties(ForgeParser.Type_elam_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_slave}.
	 * @param ctx the parse tree
	 */
	void enterType_slave(ForgeParser.Type_slaveContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_slave}.
	 * @param ctx the parse tree
	 */
	void exitType_slave(ForgeParser.Type_slaveContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_slave_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_slave_identifier(ForgeParser.Type_slave_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_slave_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_slave_identifier(ForgeParser.Type_slave_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_slave_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_slave_properties(ForgeParser.Type_slave_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_slave_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_slave_properties(ForgeParser.Type_slave_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_ecc}.
	 * @param ctx the parse tree
	 */
	void enterType_ecc(ForgeParser.Type_eccContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_ecc}.
	 * @param ctx the parse tree
	 */
	void exitType_ecc(ForgeParser.Type_eccContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_ecc_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_ecc_identifier(ForgeParser.Type_ecc_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_ecc_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_ecc_identifier(ForgeParser.Type_ecc_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_ecc_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_ecc_properties(ForgeParser.Type_ecc_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_ecc_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_ecc_properties(ForgeParser.Type_ecc_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_cpu_access}.
	 * @param ctx the parse tree
	 */
	void enterType_cpu_access(ForgeParser.Type_cpu_accessContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_cpu_access}.
	 * @param ctx the parse tree
	 */
	void exitType_cpu_access(ForgeParser.Type_cpu_accessContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_cpu_access_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_cpu_access_identifier(ForgeParser.Type_cpu_access_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_cpu_access_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_cpu_access_identifier(ForgeParser.Type_cpu_access_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_cpu_access_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_cpu_access_properties(ForgeParser.Type_cpu_access_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_cpu_access_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_cpu_access_properties(ForgeParser.Type_cpu_access_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_field}.
	 * @param ctx the parse tree
	 */
	void enterType_field(ForgeParser.Type_fieldContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_field}.
	 * @param ctx the parse tree
	 */
	void exitType_field(ForgeParser.Type_fieldContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_field_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_field_identifier(ForgeParser.Type_field_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_field_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_field_identifier(ForgeParser.Type_field_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_field_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_field_properties(ForgeParser.Type_field_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_field_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_field_properties(ForgeParser.Type_field_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_write}.
	 * @param ctx the parse tree
	 */
	void enterType_write(ForgeParser.Type_writeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_write}.
	 * @param ctx the parse tree
	 */
	void exitType_write(ForgeParser.Type_writeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_write_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_write_identifier(ForgeParser.Type_write_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_write_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_write_identifier(ForgeParser.Type_write_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_write_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_write_properties(ForgeParser.Type_write_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_write_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_write_properties(ForgeParser.Type_write_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_read}.
	 * @param ctx the parse tree
	 */
	void enterType_read(ForgeParser.Type_readContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_read}.
	 * @param ctx the parse tree
	 */
	void exitType_read(ForgeParser.Type_readContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_read_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_read_identifier(ForgeParser.Type_read_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_read_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_read_identifier(ForgeParser.Type_read_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_read_properties}.
	 * @param ctx the parse tree
	 */
	void enterType_read_properties(ForgeParser.Type_read_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_read_properties}.
	 * @param ctx the parse tree
	 */
	void exitType_read_properties(ForgeParser.Type_read_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#property_elam}.
	 * @param ctx the parse tree
	 */
	void enterProperty_elam(ForgeParser.Property_elamContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#property_elam}.
	 * @param ctx the parse tree
	 */
	void exitProperty_elam(ForgeParser.Property_elamContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#property_elam_identifier}.
	 * @param ctx the parse tree
	 */
	void enterProperty_elam_identifier(ForgeParser.Property_elam_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#property_elam_identifier}.
	 * @param ctx the parse tree
	 */
	void exitProperty_elam_identifier(ForgeParser.Property_elam_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#property_elam_properties}.
	 * @param ctx the parse tree
	 */
	void enterProperty_elam_properties(ForgeParser.Property_elam_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#property_elam_properties}.
	 * @param ctx the parse tree
	 */
	void exitProperty_elam_properties(ForgeParser.Property_elam_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#flop_array}.
	 * @param ctx the parse tree
	 */
	void enterFlop_array(ForgeParser.Flop_arrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#flop_array}.
	 * @param ctx the parse tree
	 */
	void exitFlop_array(ForgeParser.Flop_arrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#flop_array_properties}.
	 * @param ctx the parse tree
	 */
	void enterFlop_array_properties(ForgeParser.Flop_array_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#flop_array_properties}.
	 * @param ctx the parse tree
	 */
	void exitFlop_array_properties(ForgeParser.Flop_array_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#flop_array_identifier}.
	 * @param ctx the parse tree
	 */
	void enterFlop_array_identifier(ForgeParser.Flop_array_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#flop_array_identifier}.
	 * @param ctx the parse tree
	 */
	void exitFlop_array_identifier(ForgeParser.Flop_array_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#elam}.
	 * @param ctx the parse tree
	 */
	void enterElam(ForgeParser.ElamContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#elam}.
	 * @param ctx the parse tree
	 */
	void exitElam(ForgeParser.ElamContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#elam_properties}.
	 * @param ctx the parse tree
	 */
	void enterElam_properties(ForgeParser.Elam_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#elam_properties}.
	 * @param ctx the parse tree
	 */
	void exitElam_properties(ForgeParser.Elam_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#elam_identifier}.
	 * @param ctx the parse tree
	 */
	void enterElam_identifier(ForgeParser.Elam_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#elam_identifier}.
	 * @param ctx the parse tree
	 */
	void exitElam_identifier(ForgeParser.Elam_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_debug}.
	 * @param ctx the parse tree
	 */
	void enterSim_debug(ForgeParser.Sim_debugContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_debug}.
	 * @param ctx the parse tree
	 */
	void exitSim_debug(ForgeParser.Sim_debugContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_debug_properties}.
	 * @param ctx the parse tree
	 */
	void enterSim_debug_properties(ForgeParser.Sim_debug_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_debug_properties}.
	 * @param ctx the parse tree
	 */
	void exitSim_debug_properties(ForgeParser.Sim_debug_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_debug_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSim_debug_identifier(ForgeParser.Sim_debug_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_debug_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSim_debug_identifier(ForgeParser.Sim_debug_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#repeater}.
	 * @param ctx the parse tree
	 */
	void enterRepeater(ForgeParser.RepeaterContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#repeater}.
	 * @param ctx the parse tree
	 */
	void exitRepeater(ForgeParser.RepeaterContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#repeater_properties}.
	 * @param ctx the parse tree
	 */
	void enterRepeater_properties(ForgeParser.Repeater_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#repeater_properties}.
	 * @param ctx the parse tree
	 */
	void exitRepeater_properties(ForgeParser.Repeater_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#flop}.
	 * @param ctx the parse tree
	 */
	void enterFlop(ForgeParser.FlopContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#flop}.
	 * @param ctx the parse tree
	 */
	void exitFlop(ForgeParser.FlopContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#wire}.
	 * @param ctx the parse tree
	 */
	void enterWire(ForgeParser.WireContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#wire}.
	 * @param ctx the parse tree
	 */
	void exitWire(ForgeParser.WireContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#wire_list}.
	 * @param ctx the parse tree
	 */
	void enterWire_list(ForgeParser.Wire_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#wire_list}.
	 * @param ctx the parse tree
	 */
	void exitWire_list(ForgeParser.Wire_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#wire_identifier}.
	 * @param ctx the parse tree
	 */
	void enterWire_identifier(ForgeParser.Wire_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#wire_identifier}.
	 * @param ctx the parse tree
	 */
	void exitWire_identifier(ForgeParser.Wire_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#repeater_identifier}.
	 * @param ctx the parse tree
	 */
	void enterRepeater_identifier(ForgeParser.Repeater_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#repeater_identifier}.
	 * @param ctx the parse tree
	 */
	void exitRepeater_identifier(ForgeParser.Repeater_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#bundle}.
	 * @param ctx the parse tree
	 */
	void enterBundle(ForgeParser.BundleContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#bundle}.
	 * @param ctx the parse tree
	 */
	void exitBundle(ForgeParser.BundleContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#bundle_properties}.
	 * @param ctx the parse tree
	 */
	void enterBundle_properties(ForgeParser.Bundle_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#bundle_properties}.
	 * @param ctx the parse tree
	 */
	void exitBundle_properties(ForgeParser.Bundle_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_print}.
	 * @param ctx the parse tree
	 */
	void enterSim_print(ForgeParser.Sim_printContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_print}.
	 * @param ctx the parse tree
	 */
	void exitSim_print(ForgeParser.Sim_printContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_print_properties}.
	 * @param ctx the parse tree
	 */
	void enterSim_print_properties(ForgeParser.Sim_print_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_print_properties}.
	 * @param ctx the parse tree
	 */
	void exitSim_print_properties(ForgeParser.Sim_print_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#logger}.
	 * @param ctx the parse tree
	 */
	void enterLogger(ForgeParser.LoggerContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#logger}.
	 * @param ctx the parse tree
	 */
	void exitLogger(ForgeParser.LoggerContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#sim_print_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSim_print_identifier(ForgeParser.Sim_print_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#sim_print_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSim_print_identifier(ForgeParser.Sim_print_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#trigger_identifier}.
	 * @param ctx the parse tree
	 */
	void enterTrigger_identifier(ForgeParser.Trigger_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#trigger_identifier}.
	 * @param ctx the parse tree
	 */
	void exitTrigger_identifier(ForgeParser.Trigger_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#tcam}.
	 * @param ctx the parse tree
	 */
	void enterTcam(ForgeParser.TcamContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#tcam}.
	 * @param ctx the parse tree
	 */
	void exitTcam(ForgeParser.TcamContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#tcam_properties}.
	 * @param ctx the parse tree
	 */
	void enterTcam_properties(ForgeParser.Tcam_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#tcam_properties}.
	 * @param ctx the parse tree
	 */
	void exitTcam_properties(ForgeParser.Tcam_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hashtable}.
	 * @param ctx the parse tree
	 */
	void enterHashtable(ForgeParser.HashtableContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hashtable}.
	 * @param ctx the parse tree
	 */
	void exitHashtable(ForgeParser.HashtableContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_properties}.
	 * @param ctx the parse tree
	 */
	void enterHash_properties(ForgeParser.Hash_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_properties}.
	 * @param ctx the parse tree
	 */
	void exitHash_properties(ForgeParser.Hash_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_attr}.
	 * @param ctx the parse tree
	 */
	void enterType_attr(ForgeParser.Type_attrContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_attr}.
	 * @param ctx the parse tree
	 */
	void exitType_attr(ForgeParser.Type_attrContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#buckets}.
	 * @param ctx the parse tree
	 */
	void enterBuckets(ForgeParser.BucketsContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#buckets}.
	 * @param ctx the parse tree
	 */
	void exitBuckets(ForgeParser.BucketsContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#buckets_number}.
	 * @param ctx the parse tree
	 */
	void enterBuckets_number(ForgeParser.Buckets_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#buckets_number}.
	 * @param ctx the parse tree
	 */
	void exitBuckets_number(ForgeParser.Buckets_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#key}.
	 * @param ctx the parse tree
	 */
	void enterKey(ForgeParser.KeyContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#key}.
	 * @param ctx the parse tree
	 */
	void exitKey(ForgeParser.KeyContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#key_identifier}.
	 * @param ctx the parse tree
	 */
	void enterKey_identifier(ForgeParser.Key_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#key_identifier}.
	 * @param ctx the parse tree
	 */
	void exitKey_identifier(ForgeParser.Key_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValue(ForgeParser.ValueContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValue(ForgeParser.ValueContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#value_identifier}.
	 * @param ctx the parse tree
	 */
	void enterValue_identifier(ForgeParser.Value_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#value_identifier}.
	 * @param ctx the parse tree
	 */
	void exitValue_identifier(ForgeParser.Value_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_hint}.
	 * @param ctx the parse tree
	 */
	void enterHash_hint(ForgeParser.Hash_hintContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_hint}.
	 * @param ctx the parse tree
	 */
	void exitHash_hint(ForgeParser.Hash_hintContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_zerotime_action}.
	 * @param ctx the parse tree
	 */
	void enterHint_zerotime_action(ForgeParser.Hint_zerotime_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_zerotime_action}.
	 * @param ctx the parse tree
	 */
	void exitHint_zerotime_action(ForgeParser.Hint_zerotime_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_zerotime_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterHint_zerotime_action_part1(ForgeParser.Hint_zerotime_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_zerotime_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitHint_zerotime_action_part1(ForgeParser.Hint_zerotime_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#register}.
	 * @param ctx the parse tree
	 */
	void enterRegister(ForgeParser.RegisterContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#register}.
	 * @param ctx the parse tree
	 */
	void exitRegister(ForgeParser.RegisterContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#register_properties}.
	 * @param ctx the parse tree
	 */
	void enterRegister_properties(ForgeParser.Register_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#register_properties}.
	 * @param ctx the parse tree
	 */
	void exitRegister_properties(ForgeParser.Register_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#register_log}.
	 * @param ctx the parse tree
	 */
	void enterRegister_log(ForgeParser.Register_logContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#register_log}.
	 * @param ctx the parse tree
	 */
	void exitRegister_log(ForgeParser.Register_logContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#register_list}.
	 * @param ctx the parse tree
	 */
	void enterRegister_list(ForgeParser.Register_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#register_list}.
	 * @param ctx the parse tree
	 */
	void exitRegister_list(ForgeParser.Register_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#group}.
	 * @param ctx the parse tree
	 */
	void enterGroup(ForgeParser.GroupContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#group}.
	 * @param ctx the parse tree
	 */
	void exitGroup(ForgeParser.GroupContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field}.
	 * @param ctx the parse tree
	 */
	void enterField(ForgeParser.FieldContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field}.
	 * @param ctx the parse tree
	 */
	void exitField(ForgeParser.FieldContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_part1}.
	 * @param ctx the parse tree
	 */
	void enterField_part1(ForgeParser.Field_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_part1}.
	 * @param ctx the parse tree
	 */
	void exitField_part1(ForgeParser.Field_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_part2}.
	 * @param ctx the parse tree
	 */
	void enterField_part2(ForgeParser.Field_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_part2}.
	 * @param ctx the parse tree
	 */
	void exitField_part2(ForgeParser.Field_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_part3}.
	 * @param ctx the parse tree
	 */
	void enterField_part3(ForgeParser.Field_part3Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_part3}.
	 * @param ctx the parse tree
	 */
	void exitField_part3(ForgeParser.Field_part3Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_array}.
	 * @param ctx the parse tree
	 */
	void enterField_array(ForgeParser.Field_arrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_array}.
	 * @param ctx the parse tree
	 */
	void exitField_array(ForgeParser.Field_arrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#align}.
	 * @param ctx the parse tree
	 */
	void enterAlign(ForgeParser.AlignContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#align}.
	 * @param ctx the parse tree
	 */
	void exitAlign(ForgeParser.AlignContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#attributes}.
	 * @param ctx the parse tree
	 */
	void enterAttributes(ForgeParser.AttributesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#attributes}.
	 * @param ctx the parse tree
	 */
	void exitAttributes(ForgeParser.AttributesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#array}.
	 * @param ctx the parse tree
	 */
	void enterArray(ForgeParser.ArrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#array}.
	 * @param ctx the parse tree
	 */
	void exitArray(ForgeParser.ArrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#description_attr}.
	 * @param ctx the parse tree
	 */
	void enterDescription_attr(ForgeParser.Description_attrContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#description_attr}.
	 * @param ctx the parse tree
	 */
	void exitDescription_attr(ForgeParser.Description_attrContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#read_attr}.
	 * @param ctx the parse tree
	 */
	void enterRead_attr(ForgeParser.Read_attrContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#read_attr}.
	 * @param ctx the parse tree
	 */
	void exitRead_attr(ForgeParser.Read_attrContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#write_attr}.
	 * @param ctx the parse tree
	 */
	void enterWrite_attr(ForgeParser.Write_attrContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#write_attr}.
	 * @param ctx the parse tree
	 */
	void exitWrite_attr(ForgeParser.Write_attrContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#rst_value}.
	 * @param ctx the parse tree
	 */
	void enterRst_value(ForgeParser.Rst_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#rst_value}.
	 * @param ctx the parse tree
	 */
	void exitRst_value(ForgeParser.Rst_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#id_or_number}.
	 * @param ctx the parse tree
	 */
	void enterId_or_number(ForgeParser.Id_or_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#id_or_number}.
	 * @param ctx the parse tree
	 */
	void exitId_or_number(ForgeParser.Id_or_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#min_size}.
	 * @param ctx the parse tree
	 */
	void enterMin_size(ForgeParser.Min_sizeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#min_size}.
	 * @param ctx the parse tree
	 */
	void exitMin_size(ForgeParser.Min_sizeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#max_size}.
	 * @param ctx the parse tree
	 */
	void enterMax_size(ForgeParser.Max_sizeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#max_size}.
	 * @param ctx the parse tree
	 */
	void exitMax_size(ForgeParser.Max_sizeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory}.
	 * @param ctx the parse tree
	 */
	void enterMemory(ForgeParser.MemoryContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory}.
	 * @param ctx the parse tree
	 */
	void exitMemory(ForgeParser.MemoryContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memogen_cut}.
	 * @param ctx the parse tree
	 */
	void enterMemogen_cut(ForgeParser.Memogen_cutContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memogen_cut}.
	 * @param ctx the parse tree
	 */
	void exitMemogen_cut(ForgeParser.Memogen_cutContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_list}.
	 * @param ctx the parse tree
	 */
	void enterMemory_list(ForgeParser.Memory_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_list}.
	 * @param ctx the parse tree
	 */
	void exitMemory_list(ForgeParser.Memory_listContext ctx);
	/**
	 * Enter a parse tree produced by the {@code subtraction_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterSubtraction_expression(ForgeParser.Subtraction_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code subtraction_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitSubtraction_expression(ForgeParser.Subtraction_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code division_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterDivision_expression(ForgeParser.Division_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code division_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitDivision_expression(ForgeParser.Division_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code addition_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterAddition_expression(ForgeParser.Addition_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code addition_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitAddition_expression(ForgeParser.Addition_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code multiplication_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterMultiplication_expression(ForgeParser.Multiplication_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code multiplication_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitMultiplication_expression(ForgeParser.Multiplication_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code number_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterNumber_only_expression(ForgeParser.Number_only_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code number_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitNumber_only_expression(ForgeParser.Number_only_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modulo_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterModulo_expression(ForgeParser.Modulo_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modulo_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitModulo_expression(ForgeParser.Modulo_expressionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code id_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterId_only_expression(ForgeParser.Id_only_expressionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code id_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitId_only_expression(ForgeParser.Id_only_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_properties}.
	 * @param ctx the parse tree
	 */
	void enterMemory_properties(ForgeParser.Memory_propertiesContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_properties}.
	 * @param ctx the parse tree
	 */
	void exitMemory_properties(ForgeParser.Memory_propertiesContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hint_memogen}.
	 * @param ctx the parse tree
	 */
	void enterHint_memogen(ForgeParser.Hint_memogenContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hint_memogen}.
	 * @param ctx the parse tree
	 */
	void exitHint_memogen(ForgeParser.Hint_memogenContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#start_offset}.
	 * @param ctx the parse tree
	 */
	void enterStart_offset(ForgeParser.Start_offsetContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#start_offset}.
	 * @param ctx the parse tree
	 */
	void exitStart_offset(ForgeParser.Start_offsetContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#banks_size}.
	 * @param ctx the parse tree
	 */
	void enterBanks_size(ForgeParser.Banks_sizeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#banks_size}.
	 * @param ctx the parse tree
	 */
	void exitBanks_size(ForgeParser.Banks_sizeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#port_prefix}.
	 * @param ctx the parse tree
	 */
	void enterPort_prefix(ForgeParser.Port_prefixContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#port_prefix}.
	 * @param ctx the parse tree
	 */
	void exitPort_prefix(ForgeParser.Port_prefixContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#read_port_prefix}.
	 * @param ctx the parse tree
	 */
	void enterRead_port_prefix(ForgeParser.Read_port_prefixContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#read_port_prefix}.
	 * @param ctx the parse tree
	 */
	void exitRead_port_prefix(ForgeParser.Read_port_prefixContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#write_port_prefix}.
	 * @param ctx the parse tree
	 */
	void enterWrite_port_prefix(ForgeParser.Write_port_prefixContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#write_port_prefix}.
	 * @param ctx the parse tree
	 */
	void exitWrite_port_prefix(ForgeParser.Write_port_prefixContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#port_prefix_list}.
	 * @param ctx the parse tree
	 */
	void enterPort_prefix_list(ForgeParser.Port_prefix_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#port_prefix_list}.
	 * @param ctx the parse tree
	 */
	void exitPort_prefix_list(ForgeParser.Port_prefix_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#port_prefix_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPort_prefix_identifier(ForgeParser.Port_prefix_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#port_prefix_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPort_prefix_identifier(ForgeParser.Port_prefix_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#port_prefix_mux}.
	 * @param ctx the parse tree
	 */
	void enterPort_prefix_mux(ForgeParser.Port_prefix_muxContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#port_prefix_mux}.
	 * @param ctx the parse tree
	 */
	void exitPort_prefix_mux(ForgeParser.Port_prefix_muxContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_identifier}.
	 * @param ctx the parse tree
	 */
	void enterMemory_identifier(ForgeParser.Memory_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_identifier}.
	 * @param ctx the parse tree
	 */
	void exitMemory_identifier(ForgeParser.Memory_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_log}.
	 * @param ctx the parse tree
	 */
	void enterMemory_log(ForgeParser.Memory_logContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_log}.
	 * @param ctx the parse tree
	 */
	void exitMemory_log(ForgeParser.Memory_logContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap}.
	 * @param ctx the parse tree
	 */
	void enterPortCap(ForgeParser.PortCapContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap}.
	 * @param ctx the parse tree
	 */
	void exitPortCap(ForgeParser.PortCapContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#pc}.
	 * @param ctx the parse tree
	 */
	void enterPc(ForgeParser.PcContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#pc}.
	 * @param ctx the parse tree
	 */
	void exitPc(ForgeParser.PcContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#pr}.
	 * @param ctx the parse tree
	 */
	void enterPr(ForgeParser.PrContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#pr}.
	 * @param ctx the parse tree
	 */
	void exitPr(ForgeParser.PrContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#pc_}.
	 * @param ctx the parse tree
	 */
	void enterPc_(ForgeParser.Pc_Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#pc_}.
	 * @param ctx the parse tree
	 */
	void exitPc_(ForgeParser.Pc_Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#pr_}.
	 * @param ctx the parse tree
	 */
	void enterPr_(ForgeParser.Pr_Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#pr_}.
	 * @param ctx the parse tree
	 */
	void exitPr_(ForgeParser.Pr_Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#prt}.
	 * @param ctx the parse tree
	 */
	void enterPrt(ForgeParser.PrtContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#prt}.
	 * @param ctx the parse tree
	 */
	void exitPrt(ForgeParser.PrtContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_xm}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_xm(ForgeParser.PortCap_xmContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_xm}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_xm(ForgeParser.PortCap_xmContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_xs}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_xs(ForgeParser.PortCap_xsContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_xs}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_xs(ForgeParser.PortCap_xsContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_r}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_r(ForgeParser.PortCap_rContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_r}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_r(ForgeParser.PortCap_rContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_w}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_w(ForgeParser.PortCap_wContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_w}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_w(ForgeParser.PortCap_wContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_ru}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_ru(ForgeParser.PortCap_ruContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_ru}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_ru(ForgeParser.PortCap_ruContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_rw}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_rw(ForgeParser.PortCap_rwContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_rw}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_rw(ForgeParser.PortCap_rwContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_m}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_m(ForgeParser.PortCap_mContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_m}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_m(ForgeParser.PortCap_mContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_d}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_d(ForgeParser.PortCap_dContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_d}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_d(ForgeParser.PortCap_dContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_k}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_k(ForgeParser.PortCap_kContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_k}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_k(ForgeParser.PortCap_kContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_l}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_l(ForgeParser.PortCap_lContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_l}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_l(ForgeParser.PortCap_lContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_c}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_c(ForgeParser.PortCap_cContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_c}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_c(ForgeParser.PortCap_cContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_a}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_a(ForgeParser.PortCap_aContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_a}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_a(ForgeParser.PortCap_aContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_t}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_t(ForgeParser.PortCap_tContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_t}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_t(ForgeParser.PortCap_tContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_b}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_b(ForgeParser.PortCap_bContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_b}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_b(ForgeParser.PortCap_bContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#portCap_hu}.
	 * @param ctx the parse tree
	 */
	void enterPortCap_hu(ForgeParser.PortCap_huContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#portCap_hu}.
	 * @param ctx the parse tree
	 */
	void exitPortCap_hu(ForgeParser.PortCap_huContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#words}.
	 * @param ctx the parse tree
	 */
	void enterWords(ForgeParser.WordsContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#words}.
	 * @param ctx the parse tree
	 */
	void exitWords(ForgeParser.WordsContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#bits}.
	 * @param ctx the parse tree
	 */
	void enterBits(ForgeParser.BitsContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#bits}.
	 * @param ctx the parse tree
	 */
	void exitBits(ForgeParser.BitsContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#hash_type}.
	 * @param ctx the parse tree
	 */
	void enterHash_type(ForgeParser.Hash_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#hash_type}.
	 * @param ctx the parse tree
	 */
	void exitHash_type(ForgeParser.Hash_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_hashtable_action}.
	 * @param ctx the parse tree
	 */
	void enterType_hashtable_action(ForgeParser.Type_hashtable_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_hashtable_action}.
	 * @param ctx the parse tree
	 */
	void exitType_hashtable_action(ForgeParser.Type_hashtable_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#type_hashtable_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterType_hashtable_action_part1(ForgeParser.Type_hashtable_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#type_hashtable_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitType_hashtable_action_part1(ForgeParser.Type_hashtable_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_cpu}.
	 * @param ctx the parse tree
	 */
	void enterMemory_cpu(ForgeParser.Memory_cpuContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_cpu}.
	 * @param ctx the parse tree
	 */
	void exitMemory_cpu(ForgeParser.Memory_cpuContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#memory_ecc}.
	 * @param ctx the parse tree
	 */
	void enterMemory_ecc(ForgeParser.Memory_eccContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#memory_ecc}.
	 * @param ctx the parse tree
	 */
	void exitMemory_ecc(ForgeParser.Memory_eccContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#ecc_words}.
	 * @param ctx the parse tree
	 */
	void enterEcc_words(ForgeParser.Ecc_wordsContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#ecc_words}.
	 * @param ctx the parse tree
	 */
	void exitEcc_words(ForgeParser.Ecc_wordsContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#ecc_action}.
	 * @param ctx the parse tree
	 */
	void enterEcc_action(ForgeParser.Ecc_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#ecc_action}.
	 * @param ctx the parse tree
	 */
	void exitEcc_action(ForgeParser.Ecc_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#ecc_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterEcc_action_part1(ForgeParser.Ecc_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#ecc_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitEcc_action_part1(ForgeParser.Ecc_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#read_action}.
	 * @param ctx the parse tree
	 */
	void enterRead_action(ForgeParser.Read_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#read_action}.
	 * @param ctx the parse tree
	 */
	void exitRead_action(ForgeParser.Read_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#read_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterRead_action_part1(ForgeParser.Read_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#read_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitRead_action_part1(ForgeParser.Read_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#write_action}.
	 * @param ctx the parse tree
	 */
	void enterWrite_action(ForgeParser.Write_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#write_action}.
	 * @param ctx the parse tree
	 */
	void exitWrite_action(ForgeParser.Write_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#write_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterWrite_action_part1(ForgeParser.Write_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#write_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitWrite_action_part1(ForgeParser.Write_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_action}.
	 * @param ctx the parse tree
	 */
	void enterField_action(ForgeParser.Field_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_action}.
	 * @param ctx the parse tree
	 */
	void exitField_action(ForgeParser.Field_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterField_action_part1(ForgeParser.Field_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitField_action_part1(ForgeParser.Field_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#cpu_access_action}.
	 * @param ctx the parse tree
	 */
	void enterCpu_access_action(ForgeParser.Cpu_access_actionContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#cpu_access_action}.
	 * @param ctx the parse tree
	 */
	void exitCpu_access_action(ForgeParser.Cpu_access_actionContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#cpu_access_action_part1}.
	 * @param ctx the parse tree
	 */
	void enterCpu_access_action_part1(ForgeParser.Cpu_access_action_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#cpu_access_action_part1}.
	 * @param ctx the parse tree
	 */
	void exitCpu_access_action_part1(ForgeParser.Cpu_access_action_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#action_id}.
	 * @param ctx the parse tree
	 */
	void enterAction_id(ForgeParser.Action_idContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#action_id}.
	 * @param ctx the parse tree
	 */
	void exitAction_id(ForgeParser.Action_idContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#action_id_part1}.
	 * @param ctx the parse tree
	 */
	void enterAction_id_part1(ForgeParser.Action_id_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#action_id_part1}.
	 * @param ctx the parse tree
	 */
	void exitAction_id_part1(ForgeParser.Action_id_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#action_id_identifier}.
	 * @param ctx the parse tree
	 */
	void enterAction_id_identifier(ForgeParser.Action_id_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#action_id_identifier}.
	 * @param ctx the parse tree
	 */
	void exitAction_id_identifier(ForgeParser.Action_id_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#size}.
	 * @param ctx the parse tree
	 */
	void enterSize(ForgeParser.SizeContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#size}.
	 * @param ctx the parse tree
	 */
	void exitSize(ForgeParser.SizeContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_enum}.
	 * @param ctx the parse tree
	 */
	void enterField_enum(ForgeParser.Field_enumContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_enum}.
	 * @param ctx the parse tree
	 */
	void exitField_enum(ForgeParser.Field_enumContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#register_identifier}.
	 * @param ctx the parse tree
	 */
	void enterRegister_identifier(ForgeParser.Register_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#register_identifier}.
	 * @param ctx the parse tree
	 */
	void exitRegister_identifier(ForgeParser.Register_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#group_identifier}.
	 * @param ctx the parse tree
	 */
	void enterGroup_identifier(ForgeParser.Group_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#group_identifier}.
	 * @param ctx the parse tree
	 */
	void exitGroup_identifier(ForgeParser.Group_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#bundle_identifier}.
	 * @param ctx the parse tree
	 */
	void enterBundle_identifier(ForgeParser.Bundle_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#bundle_identifier}.
	 * @param ctx the parse tree
	 */
	void exitBundle_identifier(ForgeParser.Bundle_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#field_identifier}.
	 * @param ctx the parse tree
	 */
	void enterField_identifier(ForgeParser.Field_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#field_identifier}.
	 * @param ctx the parse tree
	 */
	void exitField_identifier(ForgeParser.Field_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#simple_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSimple_identifier(ForgeParser.Simple_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#simple_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSimple_identifier(ForgeParser.Simple_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link ForgeParser#number}.
	 * @param ctx the parse tree
	 */
	void enterNumber(ForgeParser.NumberContext ctx);
	/**
	 * Exit a parse tree produced by {@link ForgeParser#number}.
	 * @param ctx the parse tree
	 */
	void exitNumber(ForgeParser.NumberContext ctx);
}