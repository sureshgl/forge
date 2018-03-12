// Generated from ForgeParser.g4 by ANTLR 4.5
package com.forge.parser.gen;

    import com.forge.parser.ext.*;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link ForgeParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface ForgeParserVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link ForgeParser#start}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStart(ForgeParser.StartContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#constarint_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstarint_list(ForgeParser.Constarint_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#master}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMaster(ForgeParser.MasterContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#master_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMaster_name(ForgeParser.Master_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#chain}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChain(ForgeParser.ChainContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#slave_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlave_name(ForgeParser.Slave_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_log}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_log(ForgeParser.Type_logContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_log_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_log_identifier(ForgeParser.Type_log_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_log_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_log_properties(ForgeParser.Type_log_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#trace}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrace(ForgeParser.TraceContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#debug}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDebug(ForgeParser.DebugContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#info}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInfo(ForgeParser.InfoContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#warning}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWarning(ForgeParser.WarningContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#error}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitError(ForgeParser.ErrorContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#fatal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFatal(ForgeParser.FatalContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#parameter}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter(ForgeParser.ParameterContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_identifier(ForgeParser.Parameter_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#parameter_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_value(ForgeParser.Parameter_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#localparam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalparam(ForgeParser.LocalparamContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#localparam_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalparam_identifier(ForgeParser.Localparam_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#localparam_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalparam_value(ForgeParser.Localparam_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_set}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_set(ForgeParser.Field_setContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_set_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_set_identifier(ForgeParser.Field_set_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_set_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_set_properties(ForgeParser.Field_set_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_enum}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_enum(ForgeParser.Type_enumContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#enum_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_identifier(ForgeParser.Enum_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#enum_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_properties(ForgeParser.Enum_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_map}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_map(ForgeParser.Hash_mapContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_map_integer}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_map_integer(ForgeParser.Hash_map_integerContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_map_mnemonic}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_map_mnemonic(ForgeParser.Hash_map_mnemonicContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_map_description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_map_description(ForgeParser.Hash_map_descriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#slave}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlave(ForgeParser.SlaveContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#slave_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlave_properties(ForgeParser.Slave_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#slave_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlave_type(ForgeParser.Slave_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_slave_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_slave_action(ForgeParser.Type_slave_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_slave_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_slave_action_part1(ForgeParser.Type_slave_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#data_width}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_width(ForgeParser.Data_widthContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_zerotime}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_zerotime(ForgeParser.Hint_zerotimeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_zerotime_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_zerotime_identifier(ForgeParser.Hint_zerotime_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_zerotime_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_zerotime_properties(ForgeParser.Hint_zerotime_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_hashtable}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_hashtable(ForgeParser.Type_hashtableContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_hashtable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_hashtable_identifier(ForgeParser.Type_hashtable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_hashtable_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_hashtable_properties(ForgeParser.Type_hashtable_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_elam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_elam(ForgeParser.Type_elamContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_elam_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_elam_identifier(ForgeParser.Type_elam_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_elam_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_elam_properties(ForgeParser.Type_elam_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_slave}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_slave(ForgeParser.Type_slaveContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_slave_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_slave_identifier(ForgeParser.Type_slave_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_slave_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_slave_properties(ForgeParser.Type_slave_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_ecc}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_ecc(ForgeParser.Type_eccContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_ecc_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_ecc_identifier(ForgeParser.Type_ecc_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_ecc_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_ecc_properties(ForgeParser.Type_ecc_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_cpu_access}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_cpu_access(ForgeParser.Type_cpu_accessContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_cpu_access_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_cpu_access_identifier(ForgeParser.Type_cpu_access_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_cpu_access_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_cpu_access_properties(ForgeParser.Type_cpu_access_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_field}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_field(ForgeParser.Type_fieldContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_field_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_field_identifier(ForgeParser.Type_field_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_field_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_field_properties(ForgeParser.Type_field_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_write}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_write(ForgeParser.Type_writeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_write_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_write_identifier(ForgeParser.Type_write_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_write_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_write_properties(ForgeParser.Type_write_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_read}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_read(ForgeParser.Type_readContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_read_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_read_identifier(ForgeParser.Type_read_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_read_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_read_properties(ForgeParser.Type_read_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#property_elam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_elam(ForgeParser.Property_elamContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#property_elam_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_elam_identifier(ForgeParser.Property_elam_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#property_elam_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_elam_properties(ForgeParser.Property_elam_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#flop_array}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFlop_array(ForgeParser.Flop_arrayContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#flop_array_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFlop_array_properties(ForgeParser.Flop_array_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#flop_array_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFlop_array_identifier(ForgeParser.Flop_array_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#elam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElam(ForgeParser.ElamContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#elam_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElam_properties(ForgeParser.Elam_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#elam_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElam_identifier(ForgeParser.Elam_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_debug}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_debug(ForgeParser.Sim_debugContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_debug_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_debug_properties(ForgeParser.Sim_debug_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_debug_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_debug_identifier(ForgeParser.Sim_debug_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#repeater}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeater(ForgeParser.RepeaterContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#repeater_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeater_properties(ForgeParser.Repeater_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#flop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFlop(ForgeParser.FlopContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#wire}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWire(ForgeParser.WireContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#wire_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWire_list(ForgeParser.Wire_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#wire_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWire_identifier(ForgeParser.Wire_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#repeater_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeater_identifier(ForgeParser.Repeater_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#bundle}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBundle(ForgeParser.BundleContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#bundle_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBundle_properties(ForgeParser.Bundle_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_print}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_print(ForgeParser.Sim_printContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_print_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_print_properties(ForgeParser.Sim_print_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#logger}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLogger(ForgeParser.LoggerContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#sim_print_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSim_print_identifier(ForgeParser.Sim_print_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#trigger_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrigger_identifier(ForgeParser.Trigger_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#tcam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTcam(ForgeParser.TcamContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#tcam_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTcam_properties(ForgeParser.Tcam_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hashtable}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHashtable(ForgeParser.HashtableContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_properties(ForgeParser.Hash_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_attr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_attr(ForgeParser.Type_attrContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#buckets}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBuckets(ForgeParser.BucketsContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#buckets_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBuckets_number(ForgeParser.Buckets_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#key}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitKey(ForgeParser.KeyContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#key_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitKey_identifier(ForgeParser.Key_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitValue(ForgeParser.ValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#value_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitValue_identifier(ForgeParser.Value_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_hint}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_hint(ForgeParser.Hash_hintContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_zerotime_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_zerotime_action(ForgeParser.Hint_zerotime_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_zerotime_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_zerotime_action_part1(ForgeParser.Hint_zerotime_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#register}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegister(ForgeParser.RegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#register_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegister_properties(ForgeParser.Register_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#register_log}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegister_log(ForgeParser.Register_logContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#register_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegister_list(ForgeParser.Register_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#group}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGroup(ForgeParser.GroupContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField(ForgeParser.FieldContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_part1(ForgeParser.Field_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_part2(ForgeParser.Field_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_part3}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_part3(ForgeParser.Field_part3Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_array}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_array(ForgeParser.Field_arrayContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#align}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlign(ForgeParser.AlignContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#attributes}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributes(ForgeParser.AttributesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#array}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray(ForgeParser.ArrayContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#description_attr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDescription_attr(ForgeParser.Description_attrContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#read_attr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRead_attr(ForgeParser.Read_attrContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#write_attr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWrite_attr(ForgeParser.Write_attrContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#rst_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRst_value(ForgeParser.Rst_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#id_or_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitId_or_number(ForgeParser.Id_or_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#min_size}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMin_size(ForgeParser.Min_sizeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#max_size}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMax_size(ForgeParser.Max_sizeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory(ForgeParser.MemoryContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memogen_cut}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemogen_cut(ForgeParser.Memogen_cutContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_list(ForgeParser.Memory_listContext ctx);
	/**
	 * Visit a parse tree produced by the {@code subtraction_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubtraction_expression(ForgeParser.Subtraction_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code division_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDivision_expression(ForgeParser.Division_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code addition_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddition_expression(ForgeParser.Addition_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code multiplication_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMultiplication_expression(ForgeParser.Multiplication_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code number_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumber_only_expression(ForgeParser.Number_only_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modulo_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModulo_expression(ForgeParser.Modulo_expressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code id_only_expression}
	 * labeled alternative in {@link ForgeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitId_only_expression(ForgeParser.Id_only_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_properties}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_properties(ForgeParser.Memory_propertiesContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hint_memogen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHint_memogen(ForgeParser.Hint_memogenContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#start_offset}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStart_offset(ForgeParser.Start_offsetContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#banks_size}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBanks_size(ForgeParser.Banks_sizeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#port_prefix}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_prefix(ForgeParser.Port_prefixContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#read_port_prefix}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRead_port_prefix(ForgeParser.Read_port_prefixContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#write_port_prefix}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWrite_port_prefix(ForgeParser.Write_port_prefixContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#port_prefix_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_prefix_list(ForgeParser.Port_prefix_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#port_prefix_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_prefix_identifier(ForgeParser.Port_prefix_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#port_prefix_mux}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_prefix_mux(ForgeParser.Port_prefix_muxContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_identifier(ForgeParser.Memory_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_log}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_log(ForgeParser.Memory_logContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap(ForgeParser.PortCapContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#pc}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPc(ForgeParser.PcContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#pr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPr(ForgeParser.PrContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#pc_}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPc_(ForgeParser.Pc_Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#pr_}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPr_(ForgeParser.Pr_Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#prt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrt(ForgeParser.PrtContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_xm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_xm(ForgeParser.PortCap_xmContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_xs}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_xs(ForgeParser.PortCap_xsContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_r}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_r(ForgeParser.PortCap_rContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_w}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_w(ForgeParser.PortCap_wContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_ru}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_ru(ForgeParser.PortCap_ruContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_rw}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_rw(ForgeParser.PortCap_rwContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_m}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_m(ForgeParser.PortCap_mContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_d}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_d(ForgeParser.PortCap_dContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_k}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_k(ForgeParser.PortCap_kContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_l}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_l(ForgeParser.PortCap_lContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_c}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_c(ForgeParser.PortCap_cContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_a}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_a(ForgeParser.PortCap_aContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_t}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_t(ForgeParser.PortCap_tContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_b}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_b(ForgeParser.PortCap_bContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#portCap_hu}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPortCap_hu(ForgeParser.PortCap_huContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#words}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWords(ForgeParser.WordsContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#bits}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBits(ForgeParser.BitsContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#hash_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_type(ForgeParser.Hash_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_hashtable_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_hashtable_action(ForgeParser.Type_hashtable_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#type_hashtable_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_hashtable_action_part1(ForgeParser.Type_hashtable_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_cpu}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_cpu(ForgeParser.Memory_cpuContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#memory_ecc}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMemory_ecc(ForgeParser.Memory_eccContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#ecc_words}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEcc_words(ForgeParser.Ecc_wordsContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#ecc_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEcc_action(ForgeParser.Ecc_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#ecc_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEcc_action_part1(ForgeParser.Ecc_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#read_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRead_action(ForgeParser.Read_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#read_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRead_action_part1(ForgeParser.Read_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#write_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWrite_action(ForgeParser.Write_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#write_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWrite_action_part1(ForgeParser.Write_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_action(ForgeParser.Field_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_action_part1(ForgeParser.Field_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#cpu_access_action}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCpu_access_action(ForgeParser.Cpu_access_actionContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#cpu_access_action_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCpu_access_action_part1(ForgeParser.Cpu_access_action_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#action_id}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAction_id(ForgeParser.Action_idContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#action_id_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAction_id_part1(ForgeParser.Action_id_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#action_id_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAction_id_identifier(ForgeParser.Action_id_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#size}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSize(ForgeParser.SizeContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_enum}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_enum(ForgeParser.Field_enumContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#register_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegister_identifier(ForgeParser.Register_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#group_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGroup_identifier(ForgeParser.Group_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#bundle_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBundle_identifier(ForgeParser.Bundle_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#field_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitField_identifier(ForgeParser.Field_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#simple_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_identifier(ForgeParser.Simple_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link ForgeParser#number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumber(ForgeParser.NumberContext ctx);
}