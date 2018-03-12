// Generated from VerilogPrimeParser.g4 by ANTLR 4.5
package com.forge.fex.verilogprime.gen;

    import com.forge.fex.verilogprime.ext.*;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link VerilogPrimeParser}.
 */
public interface VerilogPrimeParserListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#source_text}.
	 * @param ctx the parse tree
	 */
	void enterSource_text(VerilogPrimeParser.Source_textContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#source_text}.
	 * @param ctx the parse tree
	 */
	void exitSource_text(VerilogPrimeParser.Source_textContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#description}.
	 * @param ctx the parse tree
	 */
	void enterDescription(VerilogPrimeParser.DescriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#description}.
	 * @param ctx the parse tree
	 */
	void exitDescription(VerilogPrimeParser.DescriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModule_declaration(VerilogPrimeParser.Module_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModule_declaration(VerilogPrimeParser.Module_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void enterModule_nonansi_header(VerilogPrimeParser.Module_nonansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void exitModule_nonansi_header(VerilogPrimeParser.Module_nonansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_ansi_header}.
	 * @param ctx the parse tree
	 */
	void enterModule_ansi_header(VerilogPrimeParser.Module_ansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_ansi_header}.
	 * @param ctx the parse tree
	 */
	void exitModule_ansi_header(VerilogPrimeParser.Module_ansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_keyword}.
	 * @param ctx the parse tree
	 */
	void enterModule_keyword(VerilogPrimeParser.Module_keywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_keyword}.
	 * @param ctx the parse tree
	 */
	void exitModule_keyword(VerilogPrimeParser.Module_keywordContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_declaration}.
	 * @param ctx the parse tree
	 */
	void enterInterface_declaration(VerilogPrimeParser.Interface_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_declaration}.
	 * @param ctx the parse tree
	 */
	void exitInterface_declaration(VerilogPrimeParser.Interface_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void enterInterface_nonansi_header(VerilogPrimeParser.Interface_nonansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void exitInterface_nonansi_header(VerilogPrimeParser.Interface_nonansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_ansi_header}.
	 * @param ctx the parse tree
	 */
	void enterInterface_ansi_header(VerilogPrimeParser.Interface_ansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_ansi_header}.
	 * @param ctx the parse tree
	 */
	void exitInterface_ansi_header(VerilogPrimeParser.Interface_ansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_declaration}.
	 * @param ctx the parse tree
	 */
	void enterProgram_declaration(VerilogPrimeParser.Program_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_declaration}.
	 * @param ctx the parse tree
	 */
	void exitProgram_declaration(VerilogPrimeParser.Program_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void enterProgram_nonansi_header(VerilogPrimeParser.Program_nonansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_nonansi_header}.
	 * @param ctx the parse tree
	 */
	void exitProgram_nonansi_header(VerilogPrimeParser.Program_nonansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_ansi_header}.
	 * @param ctx the parse tree
	 */
	void enterProgram_ansi_header(VerilogPrimeParser.Program_ansi_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_ansi_header}.
	 * @param ctx the parse tree
	 */
	void exitProgram_ansi_header(VerilogPrimeParser.Program_ansi_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_declaration}.
	 * @param ctx the parse tree
	 */
	void enterChecker_declaration(VerilogPrimeParser.Checker_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_declaration}.
	 * @param ctx the parse tree
	 */
	void exitChecker_declaration(VerilogPrimeParser.Checker_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_declaration}.
	 * @param ctx the parse tree
	 */
	void enterClass_declaration(VerilogPrimeParser.Class_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_declaration}.
	 * @param ctx the parse tree
	 */
	void exitClass_declaration(VerilogPrimeParser.Class_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPackage_declaration(VerilogPrimeParser.Package_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPackage_declaration(VerilogPrimeParser.Package_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void enterPackage_declaration_part1(VerilogPrimeParser.Package_declaration_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void exitPackage_declaration_part1(VerilogPrimeParser.Package_declaration_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timeunits_declaration}.
	 * @param ctx the parse tree
	 */
	void enterTimeunits_declaration(VerilogPrimeParser.Timeunits_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timeunits_declaration}.
	 * @param ctx the parse tree
	 */
	void exitTimeunits_declaration(VerilogPrimeParser.Timeunits_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_port_list}.
	 * @param ctx the parse tree
	 */
	void enterParameter_port_list(VerilogPrimeParser.Parameter_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_port_list}.
	 * @param ctx the parse tree
	 */
	void exitParameter_port_list(VerilogPrimeParser.Parameter_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterList_of_parameter_port_declaration(VerilogPrimeParser.List_of_parameter_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitList_of_parameter_port_declaration(VerilogPrimeParser.List_of_parameter_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterParameter_port_declaration(VerilogPrimeParser.Parameter_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitParameter_port_declaration(VerilogPrimeParser.Parameter_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_ports}.
	 * @param ctx the parse tree
	 */
	void enterList_of_ports(VerilogPrimeParser.List_of_portsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_ports}.
	 * @param ctx the parse tree
	 */
	void exitList_of_ports(VerilogPrimeParser.List_of_portsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations}.
	 * @param ctx the parse tree
	 */
	void enterList_of_port_declarations(VerilogPrimeParser.List_of_port_declarationsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations}.
	 * @param ctx the parse tree
	 */
	void exitList_of_port_declarations(VerilogPrimeParser.List_of_port_declarationsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_port_declarations_part1(VerilogPrimeParser.List_of_port_declarations_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_port_declarations_part1(VerilogPrimeParser.List_of_port_declarations_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPort_declaration(VerilogPrimeParser.Port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPort_declaration(VerilogPrimeParser.Port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port}.
	 * @param ctx the parse tree
	 */
	void enterPort(VerilogPrimeParser.PortContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port}.
	 * @param ctx the parse tree
	 */
	void exitPort(VerilogPrimeParser.PortContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port_expression}.
	 * @param ctx the parse tree
	 */
	void enterPort_expression(VerilogPrimeParser.Port_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port_expression}.
	 * @param ctx the parse tree
	 */
	void exitPort_expression(VerilogPrimeParser.Port_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port_reference}.
	 * @param ctx the parse tree
	 */
	void enterPort_reference(VerilogPrimeParser.Port_referenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port_reference}.
	 * @param ctx the parse tree
	 */
	void exitPort_reference(VerilogPrimeParser.Port_referenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port_direction}.
	 * @param ctx the parse tree
	 */
	void enterPort_direction(VerilogPrimeParser.Port_directionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port_direction}.
	 * @param ctx the parse tree
	 */
	void exitPort_direction(VerilogPrimeParser.Port_directionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_port_header}.
	 * @param ctx the parse tree
	 */
	void enterNet_port_header(VerilogPrimeParser.Net_port_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_port_header}.
	 * @param ctx the parse tree
	 */
	void exitNet_port_header(VerilogPrimeParser.Net_port_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_port_header}.
	 * @param ctx the parse tree
	 */
	void enterVariable_port_header(VerilogPrimeParser.Variable_port_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_port_header}.
	 * @param ctx the parse tree
	 */
	void exitVariable_port_header(VerilogPrimeParser.Variable_port_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_port_header}.
	 * @param ctx the parse tree
	 */
	void enterInterface_port_header(VerilogPrimeParser.Interface_port_headerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_port_header}.
	 * @param ctx the parse tree
	 */
	void exitInterface_port_header(VerilogPrimeParser.Interface_port_headerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ansi_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterAnsi_port_declaration(VerilogPrimeParser.Ansi_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ansi_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitAnsi_port_declaration(VerilogPrimeParser.Ansi_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#elaboration_system_task}.
	 * @param ctx the parse tree
	 */
	void enterElaboration_system_task(VerilogPrimeParser.Elaboration_system_taskContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#elaboration_system_task}.
	 * @param ctx the parse tree
	 */
	void exitElaboration_system_task(VerilogPrimeParser.Elaboration_system_taskContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#finish_number}.
	 * @param ctx the parse tree
	 */
	void enterFinish_number(VerilogPrimeParser.Finish_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#finish_number}.
	 * @param ctx the parse tree
	 */
	void exitFinish_number(VerilogPrimeParser.Finish_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_common_item}.
	 * @param ctx the parse tree
	 */
	void enterModule_common_item(VerilogPrimeParser.Module_common_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_common_item}.
	 * @param ctx the parse tree
	 */
	void exitModule_common_item(VerilogPrimeParser.Module_common_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_item}.
	 * @param ctx the parse tree
	 */
	void enterModule_item(VerilogPrimeParser.Module_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_item}.
	 * @param ctx the parse tree
	 */
	void exitModule_item(VerilogPrimeParser.Module_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterModule_or_generate_item(VerilogPrimeParser.Module_or_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitModule_or_generate_item(VerilogPrimeParser.Module_or_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#non_port_module_item}.
	 * @param ctx the parse tree
	 */
	void enterNon_port_module_item(VerilogPrimeParser.Non_port_module_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#non_port_module_item}.
	 * @param ctx the parse tree
	 */
	void exitNon_port_module_item(VerilogPrimeParser.Non_port_module_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_override}.
	 * @param ctx the parse tree
	 */
	void enterParameter_override(VerilogPrimeParser.Parameter_overrideContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_override}.
	 * @param ctx the parse tree
	 */
	void exitParameter_override(VerilogPrimeParser.Parameter_overrideContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bind_directive}.
	 * @param ctx the parse tree
	 */
	void enterBind_directive(VerilogPrimeParser.Bind_directiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bind_directive}.
	 * @param ctx the parse tree
	 */
	void exitBind_directive(VerilogPrimeParser.Bind_directiveContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bind_target_scope}.
	 * @param ctx the parse tree
	 */
	void enterBind_target_scope(VerilogPrimeParser.Bind_target_scopeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bind_target_scope}.
	 * @param ctx the parse tree
	 */
	void exitBind_target_scope(VerilogPrimeParser.Bind_target_scopeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bind_target_instance}.
	 * @param ctx the parse tree
	 */
	void enterBind_target_instance(VerilogPrimeParser.Bind_target_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bind_target_instance}.
	 * @param ctx the parse tree
	 */
	void exitBind_target_instance(VerilogPrimeParser.Bind_target_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bind_target_instance_list}.
	 * @param ctx the parse tree
	 */
	void enterBind_target_instance_list(VerilogPrimeParser.Bind_target_instance_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bind_target_instance_list}.
	 * @param ctx the parse tree
	 */
	void exitBind_target_instance_list(VerilogPrimeParser.Bind_target_instance_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bind_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterBind_instantiation(VerilogPrimeParser.Bind_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bind_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitBind_instantiation(VerilogPrimeParser.Bind_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#config_declaration}.
	 * @param ctx the parse tree
	 */
	void enterConfig_declaration(VerilogPrimeParser.Config_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#config_declaration}.
	 * @param ctx the parse tree
	 */
	void exitConfig_declaration(VerilogPrimeParser.Config_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#design_statement}.
	 * @param ctx the parse tree
	 */
	void enterDesign_statement(VerilogPrimeParser.Design_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#design_statement}.
	 * @param ctx the parse tree
	 */
	void exitDesign_statement(VerilogPrimeParser.Design_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#design_statement_part1}.
	 * @param ctx the parse tree
	 */
	void enterDesign_statement_part1(VerilogPrimeParser.Design_statement_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#design_statement_part1}.
	 * @param ctx the parse tree
	 */
	void exitDesign_statement_part1(VerilogPrimeParser.Design_statement_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#config_rule_statement}.
	 * @param ctx the parse tree
	 */
	void enterConfig_rule_statement(VerilogPrimeParser.Config_rule_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#config_rule_statement}.
	 * @param ctx the parse tree
	 */
	void exitConfig_rule_statement(VerilogPrimeParser.Config_rule_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#default_clause}.
	 * @param ctx the parse tree
	 */
	void enterDefault_clause(VerilogPrimeParser.Default_clauseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#default_clause}.
	 * @param ctx the parse tree
	 */
	void exitDefault_clause(VerilogPrimeParser.Default_clauseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inst_clause}.
	 * @param ctx the parse tree
	 */
	void enterInst_clause(VerilogPrimeParser.Inst_clauseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inst_clause}.
	 * @param ctx the parse tree
	 */
	void exitInst_clause(VerilogPrimeParser.Inst_clauseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inst_name}.
	 * @param ctx the parse tree
	 */
	void enterInst_name(VerilogPrimeParser.Inst_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inst_name}.
	 * @param ctx the parse tree
	 */
	void exitInst_name(VerilogPrimeParser.Inst_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cell_clause}.
	 * @param ctx the parse tree
	 */
	void enterCell_clause(VerilogPrimeParser.Cell_clauseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cell_clause}.
	 * @param ctx the parse tree
	 */
	void exitCell_clause(VerilogPrimeParser.Cell_clauseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#liblist_clause}.
	 * @param ctx the parse tree
	 */
	void enterLiblist_clause(VerilogPrimeParser.Liblist_clauseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#liblist_clause}.
	 * @param ctx the parse tree
	 */
	void exitLiblist_clause(VerilogPrimeParser.Liblist_clauseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#use_clause}.
	 * @param ctx the parse tree
	 */
	void enterUse_clause(VerilogPrimeParser.Use_clauseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#use_clause}.
	 * @param ctx the parse tree
	 */
	void exitUse_clause(VerilogPrimeParser.Use_clauseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModule_or_generate_item_declaration(VerilogPrimeParser.Module_or_generate_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModule_or_generate_item_declaration(VerilogPrimeParser.Module_or_generate_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterInterface_or_generate_item(VerilogPrimeParser.Interface_or_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitInterface_or_generate_item(VerilogPrimeParser.Interface_or_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#extern_tf_declaration}.
	 * @param ctx the parse tree
	 */
	void enterExtern_tf_declaration(VerilogPrimeParser.Extern_tf_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#extern_tf_declaration}.
	 * @param ctx the parse tree
	 */
	void exitExtern_tf_declaration(VerilogPrimeParser.Extern_tf_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_item}.
	 * @param ctx the parse tree
	 */
	void enterInterface_item(VerilogPrimeParser.Interface_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_item}.
	 * @param ctx the parse tree
	 */
	void exitInterface_item(VerilogPrimeParser.Interface_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#non_port_interface_item}.
	 * @param ctx the parse tree
	 */
	void enterNon_port_interface_item(VerilogPrimeParser.Non_port_interface_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#non_port_interface_item}.
	 * @param ctx the parse tree
	 */
	void exitNon_port_interface_item(VerilogPrimeParser.Non_port_interface_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_item}.
	 * @param ctx the parse tree
	 */
	void enterProgram_item(VerilogPrimeParser.Program_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_item}.
	 * @param ctx the parse tree
	 */
	void exitProgram_item(VerilogPrimeParser.Program_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#non_port_program_item}.
	 * @param ctx the parse tree
	 */
	void enterNon_port_program_item(VerilogPrimeParser.Non_port_program_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#non_port_program_item}.
	 * @param ctx the parse tree
	 */
	void exitNon_port_program_item(VerilogPrimeParser.Non_port_program_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterProgram_generate_item(VerilogPrimeParser.Program_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitProgram_generate_item(VerilogPrimeParser.Program_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_port_list}.
	 * @param ctx the parse tree
	 */
	void enterChecker_port_list(VerilogPrimeParser.Checker_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_port_list}.
	 * @param ctx the parse tree
	 */
	void exitChecker_port_list(VerilogPrimeParser.Checker_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_port_item}.
	 * @param ctx the parse tree
	 */
	void enterChecker_port_item(VerilogPrimeParser.Checker_port_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_port_item}.
	 * @param ctx the parse tree
	 */
	void exitChecker_port_item(VerilogPrimeParser.Checker_port_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterChecker_or_generate_item(VerilogPrimeParser.Checker_or_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitChecker_or_generate_item(VerilogPrimeParser.Checker_or_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterChecker_or_generate_item_declaration(VerilogPrimeParser.Checker_or_generate_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitChecker_or_generate_item_declaration(VerilogPrimeParser.Checker_or_generate_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterChecker_generate_item(VerilogPrimeParser.Checker_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitChecker_generate_item(VerilogPrimeParser.Checker_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_always_construct}.
	 * @param ctx the parse tree
	 */
	void enterChecker_always_construct(VerilogPrimeParser.Checker_always_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_always_construct}.
	 * @param ctx the parse tree
	 */
	void exitChecker_always_construct(VerilogPrimeParser.Checker_always_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_item}.
	 * @param ctx the parse tree
	 */
	void enterClass_item(VerilogPrimeParser.Class_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_item}.
	 * @param ctx the parse tree
	 */
	void exitClass_item(VerilogPrimeParser.Class_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_property}.
	 * @param ctx the parse tree
	 */
	void enterClass_property(VerilogPrimeParser.Class_propertyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_property}.
	 * @param ctx the parse tree
	 */
	void exitClass_property(VerilogPrimeParser.Class_propertyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_method}.
	 * @param ctx the parse tree
	 */
	void enterClass_method(VerilogPrimeParser.Class_methodContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_method}.
	 * @param ctx the parse tree
	 */
	void exitClass_method(VerilogPrimeParser.Class_methodContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_constructor_prototype}.
	 * @param ctx the parse tree
	 */
	void enterClass_constructor_prototype(VerilogPrimeParser.Class_constructor_prototypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_constructor_prototype}.
	 * @param ctx the parse tree
	 */
	void exitClass_constructor_prototype(VerilogPrimeParser.Class_constructor_prototypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_constraint}.
	 * @param ctx the parse tree
	 */
	void enterClass_constraint(VerilogPrimeParser.Class_constraintContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_constraint}.
	 * @param ctx the parse tree
	 */
	void exitClass_constraint(VerilogPrimeParser.Class_constraintContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_item_qualifier}.
	 * @param ctx the parse tree
	 */
	void enterClass_item_qualifier(VerilogPrimeParser.Class_item_qualifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_item_qualifier}.
	 * @param ctx the parse tree
	 */
	void exitClass_item_qualifier(VerilogPrimeParser.Class_item_qualifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_qualifier}.
	 * @param ctx the parse tree
	 */
	void enterProperty_qualifier(VerilogPrimeParser.Property_qualifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_qualifier}.
	 * @param ctx the parse tree
	 */
	void exitProperty_qualifier(VerilogPrimeParser.Property_qualifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#random_qualifier}.
	 * @param ctx the parse tree
	 */
	void enterRandom_qualifier(VerilogPrimeParser.Random_qualifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#random_qualifier}.
	 * @param ctx the parse tree
	 */
	void exitRandom_qualifier(VerilogPrimeParser.Random_qualifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_qualifier}.
	 * @param ctx the parse tree
	 */
	void enterMethod_qualifier(VerilogPrimeParser.Method_qualifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_qualifier}.
	 * @param ctx the parse tree
	 */
	void exitMethod_qualifier(VerilogPrimeParser.Method_qualifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_prototype}.
	 * @param ctx the parse tree
	 */
	void enterMethod_prototype(VerilogPrimeParser.Method_prototypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_prototype}.
	 * @param ctx the parse tree
	 */
	void exitMethod_prototype(VerilogPrimeParser.Method_prototypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_constructor_declaration}.
	 * @param ctx the parse tree
	 */
	void enterClass_constructor_declaration(VerilogPrimeParser.Class_constructor_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_constructor_declaration}.
	 * @param ctx the parse tree
	 */
	void exitClass_constructor_declaration(VerilogPrimeParser.Class_constructor_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_declaration}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_declaration(VerilogPrimeParser.Constraint_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_declaration}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_declaration(VerilogPrimeParser.Constraint_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_block}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_block(VerilogPrimeParser.Constraint_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_block}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_block(VerilogPrimeParser.Constraint_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_block_item}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_block_item(VerilogPrimeParser.Constraint_block_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_block_item}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_block_item(VerilogPrimeParser.Constraint_block_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#solve_before_list}.
	 * @param ctx the parse tree
	 */
	void enterSolve_before_list(VerilogPrimeParser.Solve_before_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#solve_before_list}.
	 * @param ctx the parse tree
	 */
	void exitSolve_before_list(VerilogPrimeParser.Solve_before_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#solve_before_primary}.
	 * @param ctx the parse tree
	 */
	void enterSolve_before_primary(VerilogPrimeParser.Solve_before_primaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#solve_before_primary}.
	 * @param ctx the parse tree
	 */
	void exitSolve_before_primary(VerilogPrimeParser.Solve_before_primaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_expression(VerilogPrimeParser.Constraint_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_expression(VerilogPrimeParser.Constraint_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_set}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_set(VerilogPrimeParser.Constraint_setContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_set}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_set(VerilogPrimeParser.Constraint_setContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dist_list}.
	 * @param ctx the parse tree
	 */
	void enterDist_list(VerilogPrimeParser.Dist_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dist_list}.
	 * @param ctx the parse tree
	 */
	void exitDist_list(VerilogPrimeParser.Dist_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dist_item}.
	 * @param ctx the parse tree
	 */
	void enterDist_item(VerilogPrimeParser.Dist_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dist_item}.
	 * @param ctx the parse tree
	 */
	void exitDist_item(VerilogPrimeParser.Dist_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dist_weight}.
	 * @param ctx the parse tree
	 */
	void enterDist_weight(VerilogPrimeParser.Dist_weightContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dist_weight}.
	 * @param ctx the parse tree
	 */
	void exitDist_weight(VerilogPrimeParser.Dist_weightContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_prototype}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_prototype(VerilogPrimeParser.Constraint_prototypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_prototype}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_prototype(VerilogPrimeParser.Constraint_prototypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#extern_constraint_declaration}.
	 * @param ctx the parse tree
	 */
	void enterExtern_constraint_declaration(VerilogPrimeParser.Extern_constraint_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#extern_constraint_declaration}.
	 * @param ctx the parse tree
	 */
	void exitExtern_constraint_declaration(VerilogPrimeParser.Extern_constraint_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#identifier_list}.
	 * @param ctx the parse tree
	 */
	void enterIdentifier_list(VerilogPrimeParser.Identifier_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#identifier_list}.
	 * @param ctx the parse tree
	 */
	void exitIdentifier_list(VerilogPrimeParser.Identifier_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_item}.
	 * @param ctx the parse tree
	 */
	void enterPackage_item(VerilogPrimeParser.Package_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_item}.
	 * @param ctx the parse tree
	 */
	void exitPackage_item(VerilogPrimeParser.Package_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPackage_or_generate_item_declaration(VerilogPrimeParser.Package_or_generate_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPackage_or_generate_item_declaration(VerilogPrimeParser.Package_or_generate_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#anonymous_program}.
	 * @param ctx the parse tree
	 */
	void enterAnonymous_program(VerilogPrimeParser.Anonymous_programContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#anonymous_program}.
	 * @param ctx the parse tree
	 */
	void exitAnonymous_program(VerilogPrimeParser.Anonymous_programContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#anonymous_program_item}.
	 * @param ctx the parse tree
	 */
	void enterAnonymous_program_item(VerilogPrimeParser.Anonymous_program_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#anonymous_program_item}.
	 * @param ctx the parse tree
	 */
	void exitAnonymous_program_item(VerilogPrimeParser.Anonymous_program_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#local_parameter_declaration}.
	 * @param ctx the parse tree
	 */
	void enterLocal_parameter_declaration(VerilogPrimeParser.Local_parameter_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#local_parameter_declaration}.
	 * @param ctx the parse tree
	 */
	void exitLocal_parameter_declaration(VerilogPrimeParser.Local_parameter_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_declaration}.
	 * @param ctx the parse tree
	 */
	void enterParameter_declaration(VerilogPrimeParser.Parameter_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_declaration}.
	 * @param ctx the parse tree
	 */
	void exitParameter_declaration(VerilogPrimeParser.Parameter_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specparam_declaration}.
	 * @param ctx the parse tree
	 */
	void enterSpecparam_declaration(VerilogPrimeParser.Specparam_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specparam_declaration}.
	 * @param ctx the parse tree
	 */
	void exitSpecparam_declaration(VerilogPrimeParser.Specparam_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inout_declaration}.
	 * @param ctx the parse tree
	 */
	void enterInout_declaration(VerilogPrimeParser.Inout_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inout_declaration}.
	 * @param ctx the parse tree
	 */
	void exitInout_declaration(VerilogPrimeParser.Inout_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#input_declaration}.
	 * @param ctx the parse tree
	 */
	void enterInput_declaration(VerilogPrimeParser.Input_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#input_declaration}.
	 * @param ctx the parse tree
	 */
	void exitInput_declaration(VerilogPrimeParser.Input_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#output_declaration}.
	 * @param ctx the parse tree
	 */
	void enterOutput_declaration(VerilogPrimeParser.Output_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#output_declaration}.
	 * @param ctx the parse tree
	 */
	void exitOutput_declaration(VerilogPrimeParser.Output_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterInterface_port_declaration(VerilogPrimeParser.Interface_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitInterface_port_declaration(VerilogPrimeParser.Interface_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ref_declaration}.
	 * @param ctx the parse tree
	 */
	void enterRef_declaration(VerilogPrimeParser.Ref_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ref_declaration}.
	 * @param ctx the parse tree
	 */
	void exitRef_declaration(VerilogPrimeParser.Ref_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_declaration}.
	 * @param ctx the parse tree
	 */
	void enterData_declaration(VerilogPrimeParser.Data_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_declaration}.
	 * @param ctx the parse tree
	 */
	void exitData_declaration(VerilogPrimeParser.Data_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_import_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPackage_import_declaration(VerilogPrimeParser.Package_import_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_import_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPackage_import_declaration(VerilogPrimeParser.Package_import_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_import_item}.
	 * @param ctx the parse tree
	 */
	void enterPackage_import_item(VerilogPrimeParser.Package_import_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_import_item}.
	 * @param ctx the parse tree
	 */
	void exitPackage_import_item(VerilogPrimeParser.Package_import_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_export_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPackage_export_declaration(VerilogPrimeParser.Package_export_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_export_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPackage_export_declaration(VerilogPrimeParser.Package_export_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvar_declaration}.
	 * @param ctx the parse tree
	 */
	void enterGenvar_declaration(VerilogPrimeParser.Genvar_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvar_declaration}.
	 * @param ctx the parse tree
	 */
	void exitGenvar_declaration(VerilogPrimeParser.Genvar_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_declaration}.
	 * @param ctx the parse tree
	 */
	void enterNet_declaration(VerilogPrimeParser.Net_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_declaration}.
	 * @param ctx the parse tree
	 */
	void exitNet_declaration(VerilogPrimeParser.Net_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#type_declaration}.
	 * @param ctx the parse tree
	 */
	void enterType_declaration(VerilogPrimeParser.Type_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#type_declaration}.
	 * @param ctx the parse tree
	 */
	void exitType_declaration(VerilogPrimeParser.Type_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lifetime}.
	 * @param ctx the parse tree
	 */
	void enterLifetime(VerilogPrimeParser.LifetimeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lifetime}.
	 * @param ctx the parse tree
	 */
	void exitLifetime(VerilogPrimeParser.LifetimeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#casting_type}.
	 * @param ctx the parse tree
	 */
	void enterCasting_type(VerilogPrimeParser.Casting_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#casting_type}.
	 * @param ctx the parse tree
	 */
	void exitCasting_type(VerilogPrimeParser.Casting_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_type}.
	 * @param ctx the parse tree
	 */
	void enterData_type(VerilogPrimeParser.Data_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_type}.
	 * @param ctx the parse tree
	 */
	void exitData_type(VerilogPrimeParser.Data_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_type_or_implicit}.
	 * @param ctx the parse tree
	 */
	void enterData_type_or_implicit(VerilogPrimeParser.Data_type_or_implicitContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_type_or_implicit}.
	 * @param ctx the parse tree
	 */
	void exitData_type_or_implicit(VerilogPrimeParser.Data_type_or_implicitContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#implicit_data_type}.
	 * @param ctx the parse tree
	 */
	void enterImplicit_data_type(VerilogPrimeParser.Implicit_data_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#implicit_data_type}.
	 * @param ctx the parse tree
	 */
	void exitImplicit_data_type(VerilogPrimeParser.Implicit_data_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enum_base_type}.
	 * @param ctx the parse tree
	 */
	void enterEnum_base_type(VerilogPrimeParser.Enum_base_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enum_base_type}.
	 * @param ctx the parse tree
	 */
	void exitEnum_base_type(VerilogPrimeParser.Enum_base_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration}.
	 * @param ctx the parse tree
	 */
	void enterEnum_name_declaration(VerilogPrimeParser.Enum_name_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration}.
	 * @param ctx the parse tree
	 */
	void exitEnum_name_declaration(VerilogPrimeParser.Enum_name_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void enterEnum_name_declaration_part1(VerilogPrimeParser.Enum_name_declaration_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void exitEnum_name_declaration_part1(VerilogPrimeParser.Enum_name_declaration_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_scope}.
	 * @param ctx the parse tree
	 */
	void enterClass_scope(VerilogPrimeParser.Class_scopeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_scope}.
	 * @param ctx the parse tree
	 */
	void exitClass_scope(VerilogPrimeParser.Class_scopeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_type}.
	 * @param ctx the parse tree
	 */
	void enterClass_type(VerilogPrimeParser.Class_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_type}.
	 * @param ctx the parse tree
	 */
	void exitClass_type(VerilogPrimeParser.Class_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_type_part1}.
	 * @param ctx the parse tree
	 */
	void enterClass_type_part1(VerilogPrimeParser.Class_type_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_type_part1}.
	 * @param ctx the parse tree
	 */
	void exitClass_type_part1(VerilogPrimeParser.Class_type_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#integer_type}.
	 * @param ctx the parse tree
	 */
	void enterInteger_type(VerilogPrimeParser.Integer_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#integer_type}.
	 * @param ctx the parse tree
	 */
	void exitInteger_type(VerilogPrimeParser.Integer_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#integer_atom_type}.
	 * @param ctx the parse tree
	 */
	void enterInteger_atom_type(VerilogPrimeParser.Integer_atom_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#integer_atom_type}.
	 * @param ctx the parse tree
	 */
	void exitInteger_atom_type(VerilogPrimeParser.Integer_atom_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#integer_vector_type}.
	 * @param ctx the parse tree
	 */
	void enterInteger_vector_type(VerilogPrimeParser.Integer_vector_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#integer_vector_type}.
	 * @param ctx the parse tree
	 */
	void exitInteger_vector_type(VerilogPrimeParser.Integer_vector_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#non_integer_type}.
	 * @param ctx the parse tree
	 */
	void enterNon_integer_type(VerilogPrimeParser.Non_integer_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#non_integer_type}.
	 * @param ctx the parse tree
	 */
	void exitNon_integer_type(VerilogPrimeParser.Non_integer_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_type}.
	 * @param ctx the parse tree
	 */
	void enterNet_type(VerilogPrimeParser.Net_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_type}.
	 * @param ctx the parse tree
	 */
	void exitNet_type(VerilogPrimeParser.Net_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_port_type}.
	 * @param ctx the parse tree
	 */
	void enterNet_port_type(VerilogPrimeParser.Net_port_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_port_type}.
	 * @param ctx the parse tree
	 */
	void exitNet_port_type(VerilogPrimeParser.Net_port_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_port_type}.
	 * @param ctx the parse tree
	 */
	void enterVariable_port_type(VerilogPrimeParser.Variable_port_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_port_type}.
	 * @param ctx the parse tree
	 */
	void exitVariable_port_type(VerilogPrimeParser.Variable_port_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#var_data_type}.
	 * @param ctx the parse tree
	 */
	void enterVar_data_type(VerilogPrimeParser.Var_data_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#var_data_type}.
	 * @param ctx the parse tree
	 */
	void exitVar_data_type(VerilogPrimeParser.Var_data_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#signing}.
	 * @param ctx the parse tree
	 */
	void enterSigning(VerilogPrimeParser.SigningContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#signing}.
	 * @param ctx the parse tree
	 */
	void exitSigning(VerilogPrimeParser.SigningContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_type}.
	 * @param ctx the parse tree
	 */
	void enterSimple_type(VerilogPrimeParser.Simple_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_type}.
	 * @param ctx the parse tree
	 */
	void exitSimple_type(VerilogPrimeParser.Simple_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#struct_union_member}.
	 * @param ctx the parse tree
	 */
	void enterStruct_union_member(VerilogPrimeParser.Struct_union_memberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#struct_union_member}.
	 * @param ctx the parse tree
	 */
	void exitStruct_union_member(VerilogPrimeParser.Struct_union_memberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_type_or_void}.
	 * @param ctx the parse tree
	 */
	void enterData_type_or_void(VerilogPrimeParser.Data_type_or_voidContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_type_or_void}.
	 * @param ctx the parse tree
	 */
	void exitData_type_or_void(VerilogPrimeParser.Data_type_or_voidContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#struct_union}.
	 * @param ctx the parse tree
	 */
	void enterStruct_union(VerilogPrimeParser.Struct_unionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#struct_union}.
	 * @param ctx the parse tree
	 */
	void exitStruct_union(VerilogPrimeParser.Struct_unionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#type_reference}.
	 * @param ctx the parse tree
	 */
	void enterType_reference(VerilogPrimeParser.Type_referenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#type_reference}.
	 * @param ctx the parse tree
	 */
	void exitType_reference(VerilogPrimeParser.Type_referenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#drive_strength}.
	 * @param ctx the parse tree
	 */
	void enterDrive_strength(VerilogPrimeParser.Drive_strengthContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#drive_strength}.
	 * @param ctx the parse tree
	 */
	void exitDrive_strength(VerilogPrimeParser.Drive_strengthContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#strength0}.
	 * @param ctx the parse tree
	 */
	void enterStrength0(VerilogPrimeParser.Strength0Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#strength0}.
	 * @param ctx the parse tree
	 */
	void exitStrength0(VerilogPrimeParser.Strength0Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#strength1}.
	 * @param ctx the parse tree
	 */
	void enterStrength1(VerilogPrimeParser.Strength1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#strength1}.
	 * @param ctx the parse tree
	 */
	void exitStrength1(VerilogPrimeParser.Strength1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#charge_strength}.
	 * @param ctx the parse tree
	 */
	void enterCharge_strength(VerilogPrimeParser.Charge_strengthContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#charge_strength}.
	 * @param ctx the parse tree
	 */
	void exitCharge_strength(VerilogPrimeParser.Charge_strengthContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delay3}.
	 * @param ctx the parse tree
	 */
	void enterDelay3(VerilogPrimeParser.Delay3Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delay3}.
	 * @param ctx the parse tree
	 */
	void exitDelay3(VerilogPrimeParser.Delay3Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delay2}.
	 * @param ctx the parse tree
	 */
	void enterDelay2(VerilogPrimeParser.Delay2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delay2}.
	 * @param ctx the parse tree
	 */
	void exitDelay2(VerilogPrimeParser.Delay2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delay_value}.
	 * @param ctx the parse tree
	 */
	void enterDelay_value(VerilogPrimeParser.Delay_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delay_value}.
	 * @param ctx the parse tree
	 */
	void exitDelay_value(VerilogPrimeParser.Delay_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_defparam_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_defparam_assignments(VerilogPrimeParser.List_of_defparam_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_defparam_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_defparam_assignments(VerilogPrimeParser.List_of_defparam_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_genvar_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_genvar_identifiers(VerilogPrimeParser.List_of_genvar_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_genvar_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_genvar_identifiers(VerilogPrimeParser.List_of_genvar_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_interface_identifiers(VerilogPrimeParser.List_of_interface_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_interface_identifiers(VerilogPrimeParser.List_of_interface_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_interface_identifiers_part1(VerilogPrimeParser.List_of_interface_identifiers_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_interface_identifiers_part1(VerilogPrimeParser.List_of_interface_identifiers_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_param_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_param_assignments(VerilogPrimeParser.List_of_param_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_param_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_param_assignments(VerilogPrimeParser.List_of_param_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_port_identifiers(VerilogPrimeParser.List_of_port_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_port_identifiers(VerilogPrimeParser.List_of_port_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_port_identifiers_part1(VerilogPrimeParser.List_of_port_identifiers_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_port_identifiers_part1(VerilogPrimeParser.List_of_port_identifiers_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_udp_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_udp_port_identifiers(VerilogPrimeParser.List_of_udp_port_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_udp_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_udp_port_identifiers(VerilogPrimeParser.List_of_udp_port_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_specparam_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_specparam_assignments(VerilogPrimeParser.List_of_specparam_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_specparam_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_specparam_assignments(VerilogPrimeParser.List_of_specparam_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_tf_variable_identifiers(VerilogPrimeParser.List_of_tf_variable_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_tf_variable_identifiers(VerilogPrimeParser.List_of_tf_variable_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_tf_variable_identifiers_part1(VerilogPrimeParser.List_of_tf_variable_identifiers_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_tf_variable_identifiers_part1(VerilogPrimeParser.List_of_tf_variable_identifiers_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_type_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_type_assignments(VerilogPrimeParser.List_of_type_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_type_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_type_assignments(VerilogPrimeParser.List_of_type_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_decl_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_decl_assignments(VerilogPrimeParser.List_of_variable_decl_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_decl_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_decl_assignments(VerilogPrimeParser.List_of_variable_decl_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_identifiers(VerilogPrimeParser.List_of_variable_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_identifiers(VerilogPrimeParser.List_of_variable_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_identifiers_part1(VerilogPrimeParser.List_of_variable_identifiers_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_identifiers_part1(VerilogPrimeParser.List_of_variable_identifiers_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_port_identifiers(VerilogPrimeParser.List_of_variable_port_identifiersContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_port_identifiers(VerilogPrimeParser.List_of_variable_port_identifiersContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_port_identifiers_part1(VerilogPrimeParser.List_of_variable_port_identifiers_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_port_identifiers_part1(VerilogPrimeParser.List_of_variable_port_identifiers_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl}.
	 * @param ctx the parse tree
	 */
	void enterList_of_virtual_interface_decl(VerilogPrimeParser.List_of_virtual_interface_declContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl}.
	 * @param ctx the parse tree
	 */
	void exitList_of_virtual_interface_decl(VerilogPrimeParser.List_of_virtual_interface_declContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_virtual_interface_decl_part1(VerilogPrimeParser.List_of_virtual_interface_decl_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_virtual_interface_decl_part1(VerilogPrimeParser.List_of_virtual_interface_decl_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#defparam_assignment}.
	 * @param ctx the parse tree
	 */
	void enterDefparam_assignment(VerilogPrimeParser.Defparam_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#defparam_assignment}.
	 * @param ctx the parse tree
	 */
	void exitDefparam_assignment(VerilogPrimeParser.Defparam_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_net_decl_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_net_decl_assignments(VerilogPrimeParser.List_of_net_decl_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_net_decl_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_net_decl_assignments(VerilogPrimeParser.List_of_net_decl_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_decl_assignment}.
	 * @param ctx the parse tree
	 */
	void enterNet_decl_assignment(VerilogPrimeParser.Net_decl_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_decl_assignment}.
	 * @param ctx the parse tree
	 */
	void exitNet_decl_assignment(VerilogPrimeParser.Net_decl_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#param_assignment}.
	 * @param ctx the parse tree
	 */
	void enterParam_assignment(VerilogPrimeParser.Param_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#param_assignment}.
	 * @param ctx the parse tree
	 */
	void exitParam_assignment(VerilogPrimeParser.Param_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specparam_assignment}.
	 * @param ctx the parse tree
	 */
	void enterSpecparam_assignment(VerilogPrimeParser.Specparam_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specparam_assignment}.
	 * @param ctx the parse tree
	 */
	void exitSpecparam_assignment(VerilogPrimeParser.Specparam_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#type_assignment}.
	 * @param ctx the parse tree
	 */
	void enterType_assignment(VerilogPrimeParser.Type_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#type_assignment}.
	 * @param ctx the parse tree
	 */
	void exitType_assignment(VerilogPrimeParser.Type_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulse_control_specparam}.
	 * @param ctx the parse tree
	 */
	void enterPulse_control_specparam(VerilogPrimeParser.Pulse_control_specparamContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulse_control_specparam}.
	 * @param ctx the parse tree
	 */
	void exitPulse_control_specparam(VerilogPrimeParser.Pulse_control_specparamContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#error_limit_value}.
	 * @param ctx the parse tree
	 */
	void enterError_limit_value(VerilogPrimeParser.Error_limit_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#error_limit_value}.
	 * @param ctx the parse tree
	 */
	void exitError_limit_value(VerilogPrimeParser.Error_limit_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#reject_limit_value}.
	 * @param ctx the parse tree
	 */
	void enterReject_limit_value(VerilogPrimeParser.Reject_limit_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#reject_limit_value}.
	 * @param ctx the parse tree
	 */
	void exitReject_limit_value(VerilogPrimeParser.Reject_limit_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#limit_value}.
	 * @param ctx the parse tree
	 */
	void enterLimit_value(VerilogPrimeParser.Limit_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#limit_value}.
	 * @param ctx the parse tree
	 */
	void exitLimit_value(VerilogPrimeParser.Limit_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_decl_assignment}.
	 * @param ctx the parse tree
	 */
	void enterVariable_decl_assignment(VerilogPrimeParser.Variable_decl_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_decl_assignment}.
	 * @param ctx the parse tree
	 */
	void exitVariable_decl_assignment(VerilogPrimeParser.Variable_decl_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_new}.
	 * @param ctx the parse tree
	 */
	void enterClass_new(VerilogPrimeParser.Class_newContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_new}.
	 * @param ctx the parse tree
	 */
	void exitClass_new(VerilogPrimeParser.Class_newContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dynamic_array_new}.
	 * @param ctx the parse tree
	 */
	void enterDynamic_array_new(VerilogPrimeParser.Dynamic_array_newContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dynamic_array_new}.
	 * @param ctx the parse tree
	 */
	void exitDynamic_array_new(VerilogPrimeParser.Dynamic_array_newContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unpacked_dimension}.
	 * @param ctx the parse tree
	 */
	void enterUnpacked_dimension(VerilogPrimeParser.Unpacked_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unpacked_dimension}.
	 * @param ctx the parse tree
	 */
	void exitUnpacked_dimension(VerilogPrimeParser.Unpacked_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#packed_dimension}.
	 * @param ctx the parse tree
	 */
	void enterPacked_dimension(VerilogPrimeParser.Packed_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#packed_dimension}.
	 * @param ctx the parse tree
	 */
	void exitPacked_dimension(VerilogPrimeParser.Packed_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#associative_dimension}.
	 * @param ctx the parse tree
	 */
	void enterAssociative_dimension(VerilogPrimeParser.Associative_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#associative_dimension}.
	 * @param ctx the parse tree
	 */
	void exitAssociative_dimension(VerilogPrimeParser.Associative_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_dimension}.
	 * @param ctx the parse tree
	 */
	void enterVariable_dimension(VerilogPrimeParser.Variable_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_dimension}.
	 * @param ctx the parse tree
	 */
	void exitVariable_dimension(VerilogPrimeParser.Variable_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#queue_dimension}.
	 * @param ctx the parse tree
	 */
	void enterQueue_dimension(VerilogPrimeParser.Queue_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#queue_dimension}.
	 * @param ctx the parse tree
	 */
	void exitQueue_dimension(VerilogPrimeParser.Queue_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unsized_dimension}.
	 * @param ctx the parse tree
	 */
	void enterUnsized_dimension(VerilogPrimeParser.Unsized_dimensionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unsized_dimension}.
	 * @param ctx the parse tree
	 */
	void exitUnsized_dimension(VerilogPrimeParser.Unsized_dimensionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_data_type_or_implicit}.
	 * @param ctx the parse tree
	 */
	void enterFunction_data_type_or_implicit(VerilogPrimeParser.Function_data_type_or_implicitContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_data_type_or_implicit}.
	 * @param ctx the parse tree
	 */
	void exitFunction_data_type_or_implicit(VerilogPrimeParser.Function_data_type_or_implicitContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_declaration}.
	 * @param ctx the parse tree
	 */
	void enterFunction_declaration(VerilogPrimeParser.Function_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_declaration}.
	 * @param ctx the parse tree
	 */
	void exitFunction_declaration(VerilogPrimeParser.Function_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_body_declaration}.
	 * @param ctx the parse tree
	 */
	void enterFunction_body_declaration(VerilogPrimeParser.Function_body_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_body_declaration}.
	 * @param ctx the parse tree
	 */
	void exitFunction_body_declaration(VerilogPrimeParser.Function_body_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_prototype}.
	 * @param ctx the parse tree
	 */
	void enterFunction_prototype(VerilogPrimeParser.Function_prototypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_prototype}.
	 * @param ctx the parse tree
	 */
	void exitFunction_prototype(VerilogPrimeParser.Function_prototypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_import_export}.
	 * @param ctx the parse tree
	 */
	void enterDpi_import_export(VerilogPrimeParser.Dpi_import_exportContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_import_export}.
	 * @param ctx the parse tree
	 */
	void exitDpi_import_export(VerilogPrimeParser.Dpi_import_exportContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_spec_string}.
	 * @param ctx the parse tree
	 */
	void enterDpi_spec_string(VerilogPrimeParser.Dpi_spec_stringContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_string}.
	 * @param ctx the parse tree
	 */
	void exitDpi_spec_string(VerilogPrimeParser.Dpi_spec_stringContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_function_import_property}.
	 * @param ctx the parse tree
	 */
	void enterDpi_function_import_property(VerilogPrimeParser.Dpi_function_import_propertyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_function_import_property}.
	 * @param ctx the parse tree
	 */
	void exitDpi_function_import_property(VerilogPrimeParser.Dpi_function_import_propertyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_task_import_property}.
	 * @param ctx the parse tree
	 */
	void enterDpi_task_import_property(VerilogPrimeParser.Dpi_task_import_propertyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_task_import_property}.
	 * @param ctx the parse tree
	 */
	void exitDpi_task_import_property(VerilogPrimeParser.Dpi_task_import_propertyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_function_proto}.
	 * @param ctx the parse tree
	 */
	void enterDpi_function_proto(VerilogPrimeParser.Dpi_function_protoContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_function_proto}.
	 * @param ctx the parse tree
	 */
	void exitDpi_function_proto(VerilogPrimeParser.Dpi_function_protoContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_task_proto}.
	 * @param ctx the parse tree
	 */
	void enterDpi_task_proto(VerilogPrimeParser.Dpi_task_protoContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_task_proto}.
	 * @param ctx the parse tree
	 */
	void exitDpi_task_proto(VerilogPrimeParser.Dpi_task_protoContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#task_declaration}.
	 * @param ctx the parse tree
	 */
	void enterTask_declaration(VerilogPrimeParser.Task_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#task_declaration}.
	 * @param ctx the parse tree
	 */
	void exitTask_declaration(VerilogPrimeParser.Task_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#task_body_declaration}.
	 * @param ctx the parse tree
	 */
	void enterTask_body_declaration(VerilogPrimeParser.Task_body_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#task_body_declaration}.
	 * @param ctx the parse tree
	 */
	void exitTask_body_declaration(VerilogPrimeParser.Task_body_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterTf_item_declaration(VerilogPrimeParser.Tf_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitTf_item_declaration(VerilogPrimeParser.Tf_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_port_list}.
	 * @param ctx the parse tree
	 */
	void enterTf_port_list(VerilogPrimeParser.Tf_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_port_list}.
	 * @param ctx the parse tree
	 */
	void exitTf_port_list(VerilogPrimeParser.Tf_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_port_item}.
	 * @param ctx the parse tree
	 */
	void enterTf_port_item(VerilogPrimeParser.Tf_port_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_port_item}.
	 * @param ctx the parse tree
	 */
	void exitTf_port_item(VerilogPrimeParser.Tf_port_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_port_direction}.
	 * @param ctx the parse tree
	 */
	void enterTf_port_direction(VerilogPrimeParser.Tf_port_directionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_port_direction}.
	 * @param ctx the parse tree
	 */
	void exitTf_port_direction(VerilogPrimeParser.Tf_port_directionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterTf_port_declaration(VerilogPrimeParser.Tf_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitTf_port_declaration(VerilogPrimeParser.Tf_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#task_prototype}.
	 * @param ctx the parse tree
	 */
	void enterTask_prototype(VerilogPrimeParser.Task_prototypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#task_prototype}.
	 * @param ctx the parse tree
	 */
	void exitTask_prototype(VerilogPrimeParser.Task_prototypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#block_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterBlock_item_declaration(VerilogPrimeParser.Block_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#block_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitBlock_item_declaration(VerilogPrimeParser.Block_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#overload_declaration}.
	 * @param ctx the parse tree
	 */
	void enterOverload_declaration(VerilogPrimeParser.Overload_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#overload_declaration}.
	 * @param ctx the parse tree
	 */
	void exitOverload_declaration(VerilogPrimeParser.Overload_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#overload_operator}.
	 * @param ctx the parse tree
	 */
	void enterOverload_operator(VerilogPrimeParser.Overload_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#overload_operator}.
	 * @param ctx the parse tree
	 */
	void exitOverload_operator(VerilogPrimeParser.Overload_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#overload_proto_formals}.
	 * @param ctx the parse tree
	 */
	void enterOverload_proto_formals(VerilogPrimeParser.Overload_proto_formalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#overload_proto_formals}.
	 * @param ctx the parse tree
	 */
	void exitOverload_proto_formals(VerilogPrimeParser.Overload_proto_formalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#virtual_interface_declaration}.
	 * @param ctx the parse tree
	 */
	void enterVirtual_interface_declaration(VerilogPrimeParser.Virtual_interface_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#virtual_interface_declaration}.
	 * @param ctx the parse tree
	 */
	void exitVirtual_interface_declaration(VerilogPrimeParser.Virtual_interface_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModport_declaration(VerilogPrimeParser.Modport_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModport_declaration(VerilogPrimeParser.Modport_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_item}.
	 * @param ctx the parse tree
	 */
	void enterModport_item(VerilogPrimeParser.Modport_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_item}.
	 * @param ctx the parse tree
	 */
	void exitModport_item(VerilogPrimeParser.Modport_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModport_ports_declaration(VerilogPrimeParser.Modport_ports_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModport_ports_declaration(VerilogPrimeParser.Modport_ports_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_clocking_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModport_clocking_declaration(VerilogPrimeParser.Modport_clocking_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_clocking_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModport_clocking_declaration(VerilogPrimeParser.Modport_clocking_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_simple_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModport_simple_ports_declaration(VerilogPrimeParser.Modport_simple_ports_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_simple_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModport_simple_ports_declaration(VerilogPrimeParser.Modport_simple_ports_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_simple_port}.
	 * @param ctx the parse tree
	 */
	void enterModport_simple_port(VerilogPrimeParser.Modport_simple_portContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_simple_port}.
	 * @param ctx the parse tree
	 */
	void exitModport_simple_port(VerilogPrimeParser.Modport_simple_portContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_tf_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void enterModport_tf_ports_declaration(VerilogPrimeParser.Modport_tf_ports_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_tf_ports_declaration}.
	 * @param ctx the parse tree
	 */
	void exitModport_tf_ports_declaration(VerilogPrimeParser.Modport_tf_ports_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_tf_port}.
	 * @param ctx the parse tree
	 */
	void enterModport_tf_port(VerilogPrimeParser.Modport_tf_portContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_tf_port}.
	 * @param ctx the parse tree
	 */
	void exitModport_tf_port(VerilogPrimeParser.Modport_tf_portContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#import_export}.
	 * @param ctx the parse tree
	 */
	void enterImport_export(VerilogPrimeParser.Import_exportContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#import_export}.
	 * @param ctx the parse tree
	 */
	void exitImport_export(VerilogPrimeParser.Import_exportContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_item}.
	 * @param ctx the parse tree
	 */
	void enterConcurrent_assertion_item(VerilogPrimeParser.Concurrent_assertion_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_item}.
	 * @param ctx the parse tree
	 */
	void exitConcurrent_assertion_item(VerilogPrimeParser.Concurrent_assertion_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void enterConcurrent_assertion_statement(VerilogPrimeParser.Concurrent_assertion_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void exitConcurrent_assertion_statement(VerilogPrimeParser.Concurrent_assertion_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assert_property_statement}.
	 * @param ctx the parse tree
	 */
	void enterAssert_property_statement(VerilogPrimeParser.Assert_property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assert_property_statement}.
	 * @param ctx the parse tree
	 */
	void exitAssert_property_statement(VerilogPrimeParser.Assert_property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assume_property_statement}.
	 * @param ctx the parse tree
	 */
	void enterAssume_property_statement(VerilogPrimeParser.Assume_property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assume_property_statement}.
	 * @param ctx the parse tree
	 */
	void exitAssume_property_statement(VerilogPrimeParser.Assume_property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cover_property_statement}.
	 * @param ctx the parse tree
	 */
	void enterCover_property_statement(VerilogPrimeParser.Cover_property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cover_property_statement}.
	 * @param ctx the parse tree
	 */
	void exitCover_property_statement(VerilogPrimeParser.Cover_property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#expect_property_statement}.
	 * @param ctx the parse tree
	 */
	void enterExpect_property_statement(VerilogPrimeParser.Expect_property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#expect_property_statement}.
	 * @param ctx the parse tree
	 */
	void exitExpect_property_statement(VerilogPrimeParser.Expect_property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cover_sequence_statement}.
	 * @param ctx the parse tree
	 */
	void enterCover_sequence_statement(VerilogPrimeParser.Cover_sequence_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cover_sequence_statement}.
	 * @param ctx the parse tree
	 */
	void exitCover_sequence_statement(VerilogPrimeParser.Cover_sequence_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#restrict_property_statement}.
	 * @param ctx the parse tree
	 */
	void enterRestrict_property_statement(VerilogPrimeParser.Restrict_property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#restrict_property_statement}.
	 * @param ctx the parse tree
	 */
	void exitRestrict_property_statement(VerilogPrimeParser.Restrict_property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_instance}.
	 * @param ctx the parse tree
	 */
	void enterProperty_instance(VerilogPrimeParser.Property_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_instance}.
	 * @param ctx the parse tree
	 */
	void exitProperty_instance(VerilogPrimeParser.Property_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void enterProperty_list_of_arguments(VerilogPrimeParser.Property_list_of_argumentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void exitProperty_list_of_arguments(VerilogPrimeParser.Property_list_of_argumentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void enterProperty_list_of_arguments_part1(VerilogPrimeParser.Property_list_of_arguments_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void exitProperty_list_of_arguments_part1(VerilogPrimeParser.Property_list_of_arguments_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void enterProperty_list_of_arguments_part2(VerilogPrimeParser.Property_list_of_arguments_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void exitProperty_list_of_arguments_part2(VerilogPrimeParser.Property_list_of_arguments_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_actual_arg}.
	 * @param ctx the parse tree
	 */
	void enterProperty_actual_arg(VerilogPrimeParser.Property_actual_argContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_actual_arg}.
	 * @param ctx the parse tree
	 */
	void exitProperty_actual_arg(VerilogPrimeParser.Property_actual_argContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assertion_item_declaration}.
	 * @param ctx the parse tree
	 */
	void enterAssertion_item_declaration(VerilogPrimeParser.Assertion_item_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assertion_item_declaration}.
	 * @param ctx the parse tree
	 */
	void exitAssertion_item_declaration(VerilogPrimeParser.Assertion_item_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_declaration}.
	 * @param ctx the parse tree
	 */
	void enterProperty_declaration(VerilogPrimeParser.Property_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_declaration}.
	 * @param ctx the parse tree
	 */
	void exitProperty_declaration(VerilogPrimeParser.Property_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_port_list}.
	 * @param ctx the parse tree
	 */
	void enterProperty_port_list(VerilogPrimeParser.Property_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_port_list}.
	 * @param ctx the parse tree
	 */
	void exitProperty_port_list(VerilogPrimeParser.Property_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_port_item}.
	 * @param ctx the parse tree
	 */
	void enterProperty_port_item(VerilogPrimeParser.Property_port_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_port_item}.
	 * @param ctx the parse tree
	 */
	void exitProperty_port_item(VerilogPrimeParser.Property_port_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_lvar_port_direction}.
	 * @param ctx the parse tree
	 */
	void enterProperty_lvar_port_direction(VerilogPrimeParser.Property_lvar_port_directionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_lvar_port_direction}.
	 * @param ctx the parse tree
	 */
	void exitProperty_lvar_port_direction(VerilogPrimeParser.Property_lvar_port_directionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_formal_type}.
	 * @param ctx the parse tree
	 */
	void enterProperty_formal_type(VerilogPrimeParser.Property_formal_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_formal_type}.
	 * @param ctx the parse tree
	 */
	void exitProperty_formal_type(VerilogPrimeParser.Property_formal_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_spec}.
	 * @param ctx the parse tree
	 */
	void enterProperty_spec(VerilogPrimeParser.Property_specContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_spec}.
	 * @param ctx the parse tree
	 */
	void exitProperty_spec(VerilogPrimeParser.Property_specContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_statement_spec}.
	 * @param ctx the parse tree
	 */
	void enterProperty_statement_spec(VerilogPrimeParser.Property_statement_specContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_statement_spec}.
	 * @param ctx the parse tree
	 */
	void exitProperty_statement_spec(VerilogPrimeParser.Property_statement_specContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_statement}.
	 * @param ctx the parse tree
	 */
	void enterProperty_statement(VerilogPrimeParser.Property_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_statement}.
	 * @param ctx the parse tree
	 */
	void exitProperty_statement(VerilogPrimeParser.Property_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_case_item}.
	 * @param ctx the parse tree
	 */
	void enterProperty_case_item(VerilogPrimeParser.Property_case_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_case_item}.
	 * @param ctx the parse tree
	 */
	void exitProperty_case_item(VerilogPrimeParser.Property_case_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_expr}.
	 * @param ctx the parse tree
	 */
	void enterProperty_expr(VerilogPrimeParser.Property_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_expr}.
	 * @param ctx the parse tree
	 */
	void exitProperty_expr(VerilogPrimeParser.Property_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_declaration}.
	 * @param ctx the parse tree
	 */
	void enterSequence_declaration(VerilogPrimeParser.Sequence_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_declaration}.
	 * @param ctx the parse tree
	 */
	void exitSequence_declaration(VerilogPrimeParser.Sequence_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_port_list}.
	 * @param ctx the parse tree
	 */
	void enterSequence_port_list(VerilogPrimeParser.Sequence_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_port_list}.
	 * @param ctx the parse tree
	 */
	void exitSequence_port_list(VerilogPrimeParser.Sequence_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_port_item}.
	 * @param ctx the parse tree
	 */
	void enterSequence_port_item(VerilogPrimeParser.Sequence_port_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_port_item}.
	 * @param ctx the parse tree
	 */
	void exitSequence_port_item(VerilogPrimeParser.Sequence_port_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_lvar_port_direction}.
	 * @param ctx the parse tree
	 */
	void enterSequence_lvar_port_direction(VerilogPrimeParser.Sequence_lvar_port_directionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_lvar_port_direction}.
	 * @param ctx the parse tree
	 */
	void exitSequence_lvar_port_direction(VerilogPrimeParser.Sequence_lvar_port_directionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_formal_type}.
	 * @param ctx the parse tree
	 */
	void enterSequence_formal_type(VerilogPrimeParser.Sequence_formal_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_formal_type}.
	 * @param ctx the parse tree
	 */
	void exitSequence_formal_type(VerilogPrimeParser.Sequence_formal_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_expr}.
	 * @param ctx the parse tree
	 */
	void enterSequence_expr(VerilogPrimeParser.Sequence_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_expr}.
	 * @param ctx the parse tree
	 */
	void exitSequence_expr(VerilogPrimeParser.Sequence_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cycle_delay_range}.
	 * @param ctx the parse tree
	 */
	void enterCycle_delay_range(VerilogPrimeParser.Cycle_delay_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cycle_delay_range}.
	 * @param ctx the parse tree
	 */
	void exitCycle_delay_range(VerilogPrimeParser.Cycle_delay_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_method_call}.
	 * @param ctx the parse tree
	 */
	void enterSequence_method_call(VerilogPrimeParser.Sequence_method_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_method_call}.
	 * @param ctx the parse tree
	 */
	void exitSequence_method_call(VerilogPrimeParser.Sequence_method_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_match_item}.
	 * @param ctx the parse tree
	 */
	void enterSequence_match_item(VerilogPrimeParser.Sequence_match_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_match_item}.
	 * @param ctx the parse tree
	 */
	void exitSequence_match_item(VerilogPrimeParser.Sequence_match_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_instance}.
	 * @param ctx the parse tree
	 */
	void enterSequence_instance(VerilogPrimeParser.Sequence_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_instance}.
	 * @param ctx the parse tree
	 */
	void exitSequence_instance(VerilogPrimeParser.Sequence_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void enterSequence_list_of_arguments(VerilogPrimeParser.Sequence_list_of_argumentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void exitSequence_list_of_arguments(VerilogPrimeParser.Sequence_list_of_argumentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void enterSequence_list_of_arguments_part1(VerilogPrimeParser.Sequence_list_of_arguments_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void exitSequence_list_of_arguments_part1(VerilogPrimeParser.Sequence_list_of_arguments_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void enterSequence_list_of_arguments_part2(VerilogPrimeParser.Sequence_list_of_arguments_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void exitSequence_list_of_arguments_part2(VerilogPrimeParser.Sequence_list_of_arguments_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_actual_arg}.
	 * @param ctx the parse tree
	 */
	void enterSequence_actual_arg(VerilogPrimeParser.Sequence_actual_argContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_actual_arg}.
	 * @param ctx the parse tree
	 */
	void exitSequence_actual_arg(VerilogPrimeParser.Sequence_actual_argContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#boolean_abbrev}.
	 * @param ctx the parse tree
	 */
	void enterBoolean_abbrev(VerilogPrimeParser.Boolean_abbrevContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#boolean_abbrev}.
	 * @param ctx the parse tree
	 */
	void exitBoolean_abbrev(VerilogPrimeParser.Boolean_abbrevContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_abbrev}.
	 * @param ctx the parse tree
	 */
	void enterSequence_abbrev(VerilogPrimeParser.Sequence_abbrevContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_abbrev}.
	 * @param ctx the parse tree
	 */
	void exitSequence_abbrev(VerilogPrimeParser.Sequence_abbrevContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#consecutive_repetition}.
	 * @param ctx the parse tree
	 */
	void enterConsecutive_repetition(VerilogPrimeParser.Consecutive_repetitionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#consecutive_repetition}.
	 * @param ctx the parse tree
	 */
	void exitConsecutive_repetition(VerilogPrimeParser.Consecutive_repetitionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#non_consecutive_repetition}.
	 * @param ctx the parse tree
	 */
	void enterNon_consecutive_repetition(VerilogPrimeParser.Non_consecutive_repetitionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#non_consecutive_repetition}.
	 * @param ctx the parse tree
	 */
	void exitNon_consecutive_repetition(VerilogPrimeParser.Non_consecutive_repetitionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#goto_repetition}.
	 * @param ctx the parse tree
	 */
	void enterGoto_repetition(VerilogPrimeParser.Goto_repetitionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#goto_repetition}.
	 * @param ctx the parse tree
	 */
	void exitGoto_repetition(VerilogPrimeParser.Goto_repetitionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#const_or_range_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_or_range_expression(VerilogPrimeParser.Const_or_range_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#const_or_range_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_or_range_expression(VerilogPrimeParser.Const_or_range_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cycle_delay_const_range_expression}.
	 * @param ctx the parse tree
	 */
	void enterCycle_delay_const_range_expression(VerilogPrimeParser.Cycle_delay_const_range_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cycle_delay_const_range_expression}.
	 * @param ctx the parse tree
	 */
	void exitCycle_delay_const_range_expression(VerilogPrimeParser.Cycle_delay_const_range_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#expression_or_dist}.
	 * @param ctx the parse tree
	 */
	void enterExpression_or_dist(VerilogPrimeParser.Expression_or_distContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#expression_or_dist}.
	 * @param ctx the parse tree
	 */
	void exitExpression_or_dist(VerilogPrimeParser.Expression_or_distContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assertion_variable_declaration}.
	 * @param ctx the parse tree
	 */
	void enterAssertion_variable_declaration(VerilogPrimeParser.Assertion_variable_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assertion_variable_declaration}.
	 * @param ctx the parse tree
	 */
	void exitAssertion_variable_declaration(VerilogPrimeParser.Assertion_variable_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_declaration}.
	 * @param ctx the parse tree
	 */
	void enterLet_declaration(VerilogPrimeParser.Let_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_declaration}.
	 * @param ctx the parse tree
	 */
	void exitLet_declaration(VerilogPrimeParser.Let_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_identifier}.
	 * @param ctx the parse tree
	 */
	void enterLet_identifier(VerilogPrimeParser.Let_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_identifier}.
	 * @param ctx the parse tree
	 */
	void exitLet_identifier(VerilogPrimeParser.Let_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_port_list}.
	 * @param ctx the parse tree
	 */
	void enterLet_port_list(VerilogPrimeParser.Let_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_port_list}.
	 * @param ctx the parse tree
	 */
	void exitLet_port_list(VerilogPrimeParser.Let_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_port_item}.
	 * @param ctx the parse tree
	 */
	void enterLet_port_item(VerilogPrimeParser.Let_port_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_port_item}.
	 * @param ctx the parse tree
	 */
	void exitLet_port_item(VerilogPrimeParser.Let_port_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_formal_type}.
	 * @param ctx the parse tree
	 */
	void enterLet_formal_type(VerilogPrimeParser.Let_formal_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_formal_type}.
	 * @param ctx the parse tree
	 */
	void exitLet_formal_type(VerilogPrimeParser.Let_formal_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_expression}.
	 * @param ctx the parse tree
	 */
	void enterLet_expression(VerilogPrimeParser.Let_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_expression}.
	 * @param ctx the parse tree
	 */
	void exitLet_expression(VerilogPrimeParser.Let_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void enterLet_list_of_arguments(VerilogPrimeParser.Let_list_of_argumentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void exitLet_list_of_arguments(VerilogPrimeParser.Let_list_of_argumentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void enterLet_list_of_arguments_part1(VerilogPrimeParser.Let_list_of_arguments_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void exitLet_list_of_arguments_part1(VerilogPrimeParser.Let_list_of_arguments_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void enterLet_list_of_arguments_part2(VerilogPrimeParser.Let_list_of_arguments_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void exitLet_list_of_arguments_part2(VerilogPrimeParser.Let_list_of_arguments_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#let_actual_arg}.
	 * @param ctx the parse tree
	 */
	void enterLet_actual_arg(VerilogPrimeParser.Let_actual_argContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#let_actual_arg}.
	 * @param ctx the parse tree
	 */
	void exitLet_actual_arg(VerilogPrimeParser.Let_actual_argContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#covergroup_declaration}.
	 * @param ctx the parse tree
	 */
	void enterCovergroup_declaration(VerilogPrimeParser.Covergroup_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#covergroup_declaration}.
	 * @param ctx the parse tree
	 */
	void exitCovergroup_declaration(VerilogPrimeParser.Covergroup_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverage_spec_or_option}.
	 * @param ctx the parse tree
	 */
	void enterCoverage_spec_or_option(VerilogPrimeParser.Coverage_spec_or_optionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverage_spec_or_option}.
	 * @param ctx the parse tree
	 */
	void exitCoverage_spec_or_option(VerilogPrimeParser.Coverage_spec_or_optionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverage_option}.
	 * @param ctx the parse tree
	 */
	void enterCoverage_option(VerilogPrimeParser.Coverage_optionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverage_option}.
	 * @param ctx the parse tree
	 */
	void exitCoverage_option(VerilogPrimeParser.Coverage_optionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverage_spec}.
	 * @param ctx the parse tree
	 */
	void enterCoverage_spec(VerilogPrimeParser.Coverage_specContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverage_spec}.
	 * @param ctx the parse tree
	 */
	void exitCoverage_spec(VerilogPrimeParser.Coverage_specContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverage_event}.
	 * @param ctx the parse tree
	 */
	void enterCoverage_event(VerilogPrimeParser.Coverage_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverage_event}.
	 * @param ctx the parse tree
	 */
	void exitCoverage_event(VerilogPrimeParser.Coverage_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#block_event_expression}.
	 * @param ctx the parse tree
	 */
	void enterBlock_event_expression(VerilogPrimeParser.Block_event_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#block_event_expression}.
	 * @param ctx the parse tree
	 */
	void exitBlock_event_expression(VerilogPrimeParser.Block_event_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_btf_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_btf_identifier(VerilogPrimeParser.Hierarchical_btf_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_btf_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_btf_identifier(VerilogPrimeParser.Hierarchical_btf_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cover_point}.
	 * @param ctx the parse tree
	 */
	void enterCover_point(VerilogPrimeParser.Cover_pointContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cover_point}.
	 * @param ctx the parse tree
	 */
	void exitCover_point(VerilogPrimeParser.Cover_pointContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_or_empty}.
	 * @param ctx the parse tree
	 */
	void enterBins_or_empty(VerilogPrimeParser.Bins_or_emptyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_or_empty}.
	 * @param ctx the parse tree
	 */
	void exitBins_or_empty(VerilogPrimeParser.Bins_or_emptyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_or_options}.
	 * @param ctx the parse tree
	 */
	void enterBins_or_options(VerilogPrimeParser.Bins_or_optionsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_or_options}.
	 * @param ctx the parse tree
	 */
	void exitBins_or_options(VerilogPrimeParser.Bins_or_optionsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_or_options_part1}.
	 * @param ctx the parse tree
	 */
	void enterBins_or_options_part1(VerilogPrimeParser.Bins_or_options_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_or_options_part1}.
	 * @param ctx the parse tree
	 */
	void exitBins_or_options_part1(VerilogPrimeParser.Bins_or_options_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_keyword}.
	 * @param ctx the parse tree
	 */
	void enterBins_keyword(VerilogPrimeParser.Bins_keywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_keyword}.
	 * @param ctx the parse tree
	 */
	void exitBins_keyword(VerilogPrimeParser.Bins_keywordContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#range_list}.
	 * @param ctx the parse tree
	 */
	void enterRange_list(VerilogPrimeParser.Range_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#range_list}.
	 * @param ctx the parse tree
	 */
	void exitRange_list(VerilogPrimeParser.Range_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#trans_list}.
	 * @param ctx the parse tree
	 */
	void enterTrans_list(VerilogPrimeParser.Trans_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#trans_list}.
	 * @param ctx the parse tree
	 */
	void exitTrans_list(VerilogPrimeParser.Trans_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#trans_set}.
	 * @param ctx the parse tree
	 */
	void enterTrans_set(VerilogPrimeParser.Trans_setContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#trans_set}.
	 * @param ctx the parse tree
	 */
	void exitTrans_set(VerilogPrimeParser.Trans_setContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#trans_range_list}.
	 * @param ctx the parse tree
	 */
	void enterTrans_range_list(VerilogPrimeParser.Trans_range_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#trans_range_list}.
	 * @param ctx the parse tree
	 */
	void exitTrans_range_list(VerilogPrimeParser.Trans_range_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#trans_item}.
	 * @param ctx the parse tree
	 */
	void enterTrans_item(VerilogPrimeParser.Trans_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#trans_item}.
	 * @param ctx the parse tree
	 */
	void exitTrans_item(VerilogPrimeParser.Trans_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#repeat_range}.
	 * @param ctx the parse tree
	 */
	void enterRepeat_range(VerilogPrimeParser.Repeat_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#repeat_range}.
	 * @param ctx the parse tree
	 */
	void exitRepeat_range(VerilogPrimeParser.Repeat_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cover_cross}.
	 * @param ctx the parse tree
	 */
	void enterCover_cross(VerilogPrimeParser.Cover_crossContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cover_cross}.
	 * @param ctx the parse tree
	 */
	void exitCover_cross(VerilogPrimeParser.Cover_crossContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_coverpoints}.
	 * @param ctx the parse tree
	 */
	void enterList_of_coverpoints(VerilogPrimeParser.List_of_coverpointsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_coverpoints}.
	 * @param ctx the parse tree
	 */
	void exitList_of_coverpoints(VerilogPrimeParser.List_of_coverpointsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cross_item}.
	 * @param ctx the parse tree
	 */
	void enterCross_item(VerilogPrimeParser.Cross_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cross_item}.
	 * @param ctx the parse tree
	 */
	void exitCross_item(VerilogPrimeParser.Cross_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#select_bins_or_empty}.
	 * @param ctx the parse tree
	 */
	void enterSelect_bins_or_empty(VerilogPrimeParser.Select_bins_or_emptyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#select_bins_or_empty}.
	 * @param ctx the parse tree
	 */
	void exitSelect_bins_or_empty(VerilogPrimeParser.Select_bins_or_emptyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_selection_or_option}.
	 * @param ctx the parse tree
	 */
	void enterBins_selection_or_option(VerilogPrimeParser.Bins_selection_or_optionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_selection_or_option}.
	 * @param ctx the parse tree
	 */
	void exitBins_selection_or_option(VerilogPrimeParser.Bins_selection_or_optionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_selection}.
	 * @param ctx the parse tree
	 */
	void enterBins_selection(VerilogPrimeParser.Bins_selectionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_selection}.
	 * @param ctx the parse tree
	 */
	void exitBins_selection(VerilogPrimeParser.Bins_selectionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#select_expression}.
	 * @param ctx the parse tree
	 */
	void enterSelect_expression(VerilogPrimeParser.Select_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#select_expression}.
	 * @param ctx the parse tree
	 */
	void exitSelect_expression(VerilogPrimeParser.Select_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#select_expression_part1}.
	 * @param ctx the parse tree
	 */
	void enterSelect_expression_part1(VerilogPrimeParser.Select_expression_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#select_expression_part1}.
	 * @param ctx the parse tree
	 */
	void exitSelect_expression_part1(VerilogPrimeParser.Select_expression_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#select_condition}.
	 * @param ctx the parse tree
	 */
	void enterSelect_condition(VerilogPrimeParser.Select_conditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#select_condition}.
	 * @param ctx the parse tree
	 */
	void exitSelect_condition(VerilogPrimeParser.Select_conditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_expression}.
	 * @param ctx the parse tree
	 */
	void enterBins_expression(VerilogPrimeParser.Bins_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_expression}.
	 * @param ctx the parse tree
	 */
	void exitBins_expression(VerilogPrimeParser.Bins_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#open_range_list}.
	 * @param ctx the parse tree
	 */
	void enterOpen_range_list(VerilogPrimeParser.Open_range_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#open_range_list}.
	 * @param ctx the parse tree
	 */
	void exitOpen_range_list(VerilogPrimeParser.Open_range_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#open_value_range}.
	 * @param ctx the parse tree
	 */
	void enterOpen_value_range(VerilogPrimeParser.Open_value_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#open_value_range}.
	 * @param ctx the parse tree
	 */
	void exitOpen_value_range(VerilogPrimeParser.Open_value_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#gate_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterGate_instantiation(VerilogPrimeParser.Gate_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#gate_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitGate_instantiation(VerilogPrimeParser.Gate_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cmos_switch_instance}.
	 * @param ctx the parse tree
	 */
	void enterCmos_switch_instance(VerilogPrimeParser.Cmos_switch_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cmos_switch_instance}.
	 * @param ctx the parse tree
	 */
	void exitCmos_switch_instance(VerilogPrimeParser.Cmos_switch_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enable_gate_instance}.
	 * @param ctx the parse tree
	 */
	void enterEnable_gate_instance(VerilogPrimeParser.Enable_gate_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enable_gate_instance}.
	 * @param ctx the parse tree
	 */
	void exitEnable_gate_instance(VerilogPrimeParser.Enable_gate_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#mos_switch_instance}.
	 * @param ctx the parse tree
	 */
	void enterMos_switch_instance(VerilogPrimeParser.Mos_switch_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#mos_switch_instance}.
	 * @param ctx the parse tree
	 */
	void exitMos_switch_instance(VerilogPrimeParser.Mos_switch_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#n_input_gate_instance}.
	 * @param ctx the parse tree
	 */
	void enterN_input_gate_instance(VerilogPrimeParser.N_input_gate_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#n_input_gate_instance}.
	 * @param ctx the parse tree
	 */
	void exitN_input_gate_instance(VerilogPrimeParser.N_input_gate_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#n_output_gate_instance}.
	 * @param ctx the parse tree
	 */
	void enterN_output_gate_instance(VerilogPrimeParser.N_output_gate_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#n_output_gate_instance}.
	 * @param ctx the parse tree
	 */
	void exitN_output_gate_instance(VerilogPrimeParser.N_output_gate_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pass_switch_instance}.
	 * @param ctx the parse tree
	 */
	void enterPass_switch_instance(VerilogPrimeParser.Pass_switch_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pass_switch_instance}.
	 * @param ctx the parse tree
	 */
	void exitPass_switch_instance(VerilogPrimeParser.Pass_switch_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pass_enable_switch_instance}.
	 * @param ctx the parse tree
	 */
	void enterPass_enable_switch_instance(VerilogPrimeParser.Pass_enable_switch_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pass_enable_switch_instance}.
	 * @param ctx the parse tree
	 */
	void exitPass_enable_switch_instance(VerilogPrimeParser.Pass_enable_switch_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pull_gate_instance}.
	 * @param ctx the parse tree
	 */
	void enterPull_gate_instance(VerilogPrimeParser.Pull_gate_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pull_gate_instance}.
	 * @param ctx the parse tree
	 */
	void exitPull_gate_instance(VerilogPrimeParser.Pull_gate_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulldown_strength}.
	 * @param ctx the parse tree
	 */
	void enterPulldown_strength(VerilogPrimeParser.Pulldown_strengthContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulldown_strength}.
	 * @param ctx the parse tree
	 */
	void exitPulldown_strength(VerilogPrimeParser.Pulldown_strengthContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pullup_strength}.
	 * @param ctx the parse tree
	 */
	void enterPullup_strength(VerilogPrimeParser.Pullup_strengthContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pullup_strength}.
	 * @param ctx the parse tree
	 */
	void exitPullup_strength(VerilogPrimeParser.Pullup_strengthContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enable_terminal}.
	 * @param ctx the parse tree
	 */
	void enterEnable_terminal(VerilogPrimeParser.Enable_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enable_terminal}.
	 * @param ctx the parse tree
	 */
	void exitEnable_terminal(VerilogPrimeParser.Enable_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inout_terminal}.
	 * @param ctx the parse tree
	 */
	void enterInout_terminal(VerilogPrimeParser.Inout_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inout_terminal}.
	 * @param ctx the parse tree
	 */
	void exitInout_terminal(VerilogPrimeParser.Inout_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#input_terminal}.
	 * @param ctx the parse tree
	 */
	void enterInput_terminal(VerilogPrimeParser.Input_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#input_terminal}.
	 * @param ctx the parse tree
	 */
	void exitInput_terminal(VerilogPrimeParser.Input_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ncontrol_terminal}.
	 * @param ctx the parse tree
	 */
	void enterNcontrol_terminal(VerilogPrimeParser.Ncontrol_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ncontrol_terminal}.
	 * @param ctx the parse tree
	 */
	void exitNcontrol_terminal(VerilogPrimeParser.Ncontrol_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#output_terminal}.
	 * @param ctx the parse tree
	 */
	void enterOutput_terminal(VerilogPrimeParser.Output_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#output_terminal}.
	 * @param ctx the parse tree
	 */
	void exitOutput_terminal(VerilogPrimeParser.Output_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pcontrol_terminal}.
	 * @param ctx the parse tree
	 */
	void enterPcontrol_terminal(VerilogPrimeParser.Pcontrol_terminalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pcontrol_terminal}.
	 * @param ctx the parse tree
	 */
	void exitPcontrol_terminal(VerilogPrimeParser.Pcontrol_terminalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cmos_switchtype}.
	 * @param ctx the parse tree
	 */
	void enterCmos_switchtype(VerilogPrimeParser.Cmos_switchtypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cmos_switchtype}.
	 * @param ctx the parse tree
	 */
	void exitCmos_switchtype(VerilogPrimeParser.Cmos_switchtypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enable_gatetype}.
	 * @param ctx the parse tree
	 */
	void enterEnable_gatetype(VerilogPrimeParser.Enable_gatetypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enable_gatetype}.
	 * @param ctx the parse tree
	 */
	void exitEnable_gatetype(VerilogPrimeParser.Enable_gatetypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#mos_switchtype}.
	 * @param ctx the parse tree
	 */
	void enterMos_switchtype(VerilogPrimeParser.Mos_switchtypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#mos_switchtype}.
	 * @param ctx the parse tree
	 */
	void exitMos_switchtype(VerilogPrimeParser.Mos_switchtypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#n_input_gatetype}.
	 * @param ctx the parse tree
	 */
	void enterN_input_gatetype(VerilogPrimeParser.N_input_gatetypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#n_input_gatetype}.
	 * @param ctx the parse tree
	 */
	void exitN_input_gatetype(VerilogPrimeParser.N_input_gatetypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#n_output_gatetype}.
	 * @param ctx the parse tree
	 */
	void enterN_output_gatetype(VerilogPrimeParser.N_output_gatetypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#n_output_gatetype}.
	 * @param ctx the parse tree
	 */
	void exitN_output_gatetype(VerilogPrimeParser.N_output_gatetypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pass_en_switchtype}.
	 * @param ctx the parse tree
	 */
	void enterPass_en_switchtype(VerilogPrimeParser.Pass_en_switchtypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pass_en_switchtype}.
	 * @param ctx the parse tree
	 */
	void exitPass_en_switchtype(VerilogPrimeParser.Pass_en_switchtypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pass_switchtype}.
	 * @param ctx the parse tree
	 */
	void enterPass_switchtype(VerilogPrimeParser.Pass_switchtypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pass_switchtype}.
	 * @param ctx the parse tree
	 */
	void exitPass_switchtype(VerilogPrimeParser.Pass_switchtypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterModule_instantiation(VerilogPrimeParser.Module_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitModule_instantiation(VerilogPrimeParser.Module_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_value_assignment}.
	 * @param ctx the parse tree
	 */
	void enterParameter_value_assignment(VerilogPrimeParser.Parameter_value_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_value_assignment}.
	 * @param ctx the parse tree
	 */
	void exitParameter_value_assignment(VerilogPrimeParser.Parameter_value_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_parameter_assignments(VerilogPrimeParser.List_of_parameter_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_parameter_assignments(VerilogPrimeParser.List_of_parameter_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ordered_parameter_assignment}.
	 * @param ctx the parse tree
	 */
	void enterOrdered_parameter_assignment(VerilogPrimeParser.Ordered_parameter_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ordered_parameter_assignment}.
	 * @param ctx the parse tree
	 */
	void exitOrdered_parameter_assignment(VerilogPrimeParser.Ordered_parameter_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#named_parameter_assignment}.
	 * @param ctx the parse tree
	 */
	void enterNamed_parameter_assignment(VerilogPrimeParser.Named_parameter_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#named_parameter_assignment}.
	 * @param ctx the parse tree
	 */
	void exitNamed_parameter_assignment(VerilogPrimeParser.Named_parameter_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_instance}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_instance(VerilogPrimeParser.Hierarchical_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_instance}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_instance(VerilogPrimeParser.Hierarchical_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#name_of_instance}.
	 * @param ctx the parse tree
	 */
	void enterName_of_instance(VerilogPrimeParser.Name_of_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#name_of_instance}.
	 * @param ctx the parse tree
	 */
	void exitName_of_instance(VerilogPrimeParser.Name_of_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_port_connections}.
	 * @param ctx the parse tree
	 */
	void enterList_of_port_connections(VerilogPrimeParser.List_of_port_connectionsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_port_connections}.
	 * @param ctx the parse tree
	 */
	void exitList_of_port_connections(VerilogPrimeParser.List_of_port_connectionsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ordered_port_connection}.
	 * @param ctx the parse tree
	 */
	void enterOrdered_port_connection(VerilogPrimeParser.Ordered_port_connectionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ordered_port_connection}.
	 * @param ctx the parse tree
	 */
	void exitOrdered_port_connection(VerilogPrimeParser.Ordered_port_connectionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#named_port_connection}.
	 * @param ctx the parse tree
	 */
	void enterNamed_port_connection(VerilogPrimeParser.Named_port_connectionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#named_port_connection}.
	 * @param ctx the parse tree
	 */
	void exitNamed_port_connection(VerilogPrimeParser.Named_port_connectionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterInterface_instantiation(VerilogPrimeParser.Interface_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitInterface_instantiation(VerilogPrimeParser.Interface_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterProgram_instantiation(VerilogPrimeParser.Program_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitProgram_instantiation(VerilogPrimeParser.Program_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterChecker_instantiation(VerilogPrimeParser.Checker_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitChecker_instantiation(VerilogPrimeParser.Checker_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_checker_port_connections}.
	 * @param ctx the parse tree
	 */
	void enterList_of_checker_port_connections(VerilogPrimeParser.List_of_checker_port_connectionsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_checker_port_connections}.
	 * @param ctx the parse tree
	 */
	void exitList_of_checker_port_connections(VerilogPrimeParser.List_of_checker_port_connectionsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ordered_checker_port_connection}.
	 * @param ctx the parse tree
	 */
	void enterOrdered_checker_port_connection(VerilogPrimeParser.Ordered_checker_port_connectionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ordered_checker_port_connection}.
	 * @param ctx the parse tree
	 */
	void exitOrdered_checker_port_connection(VerilogPrimeParser.Ordered_checker_port_connectionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#named_checker_port_connection}.
	 * @param ctx the parse tree
	 */
	void enterNamed_checker_port_connection(VerilogPrimeParser.Named_checker_port_connectionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#named_checker_port_connection}.
	 * @param ctx the parse tree
	 */
	void exitNamed_checker_port_connection(VerilogPrimeParser.Named_checker_port_connectionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_region}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_region(VerilogPrimeParser.Generate_regionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_region}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_region(VerilogPrimeParser.Generate_regionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#loop_generate_construct}.
	 * @param ctx the parse tree
	 */
	void enterLoop_generate_construct(VerilogPrimeParser.Loop_generate_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#loop_generate_construct}.
	 * @param ctx the parse tree
	 */
	void exitLoop_generate_construct(VerilogPrimeParser.Loop_generate_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvar_initialization}.
	 * @param ctx the parse tree
	 */
	void enterGenvar_initialization(VerilogPrimeParser.Genvar_initializationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvar_initialization}.
	 * @param ctx the parse tree
	 */
	void exitGenvar_initialization(VerilogPrimeParser.Genvar_initializationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#conditional_generate_construct}.
	 * @param ctx the parse tree
	 */
	void enterConditional_generate_construct(VerilogPrimeParser.Conditional_generate_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#conditional_generate_construct}.
	 * @param ctx the parse tree
	 */
	void exitConditional_generate_construct(VerilogPrimeParser.Conditional_generate_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#if_generate_construct}.
	 * @param ctx the parse tree
	 */
	void enterIf_generate_construct(VerilogPrimeParser.If_generate_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#if_generate_construct}.
	 * @param ctx the parse tree
	 */
	void exitIf_generate_construct(VerilogPrimeParser.If_generate_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_generate_construct}.
	 * @param ctx the parse tree
	 */
	void enterCase_generate_construct(VerilogPrimeParser.Case_generate_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_generate_construct}.
	 * @param ctx the parse tree
	 */
	void exitCase_generate_construct(VerilogPrimeParser.Case_generate_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_generate_item}.
	 * @param ctx the parse tree
	 */
	void enterCase_generate_item(VerilogPrimeParser.Case_generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_generate_item}.
	 * @param ctx the parse tree
	 */
	void exitCase_generate_item(VerilogPrimeParser.Case_generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_block}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_block(VerilogPrimeParser.Generate_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_block}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_block(VerilogPrimeParser.Generate_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_block_part1}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_block_part1(VerilogPrimeParser.Generate_block_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_block_part1}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_block_part1(VerilogPrimeParser.Generate_block_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_block_part2}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_block_part2(VerilogPrimeParser.Generate_block_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_block_part2}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_block_part2(VerilogPrimeParser.Generate_block_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_block_part3}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_block_part3(VerilogPrimeParser.Generate_block_part3Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_block_part3}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_block_part3(VerilogPrimeParser.Generate_block_part3Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_item}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_item(VerilogPrimeParser.Generate_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_item}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_item(VerilogPrimeParser.Generate_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_nonansi_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_nonansi_declaration(VerilogPrimeParser.Udp_nonansi_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_nonansi_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_nonansi_declaration(VerilogPrimeParser.Udp_nonansi_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvar_iteration}.
	 * @param ctx the parse tree
	 */
	void enterGenvar_iteration(VerilogPrimeParser.Genvar_iterationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvar_iteration}.
	 * @param ctx the parse tree
	 */
	void exitGenvar_iteration(VerilogPrimeParser.Genvar_iterationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_ansi_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_ansi_declaration(VerilogPrimeParser.Udp_ansi_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_ansi_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_ansi_declaration(VerilogPrimeParser.Udp_ansi_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_declaration(VerilogPrimeParser.Udp_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_declaration(VerilogPrimeParser.Udp_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_port_list}.
	 * @param ctx the parse tree
	 */
	void enterUdp_port_list(VerilogPrimeParser.Udp_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_port_list}.
	 * @param ctx the parse tree
	 */
	void exitUdp_port_list(VerilogPrimeParser.Udp_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_declaration_port_list}.
	 * @param ctx the parse tree
	 */
	void enterUdp_declaration_port_list(VerilogPrimeParser.Udp_declaration_port_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_declaration_port_list}.
	 * @param ctx the parse tree
	 */
	void exitUdp_declaration_port_list(VerilogPrimeParser.Udp_declaration_port_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_port_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_port_declaration(VerilogPrimeParser.Udp_port_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_port_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_port_declaration(VerilogPrimeParser.Udp_port_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_output_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_output_declaration(VerilogPrimeParser.Udp_output_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_output_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_output_declaration(VerilogPrimeParser.Udp_output_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_input_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_input_declaration(VerilogPrimeParser.Udp_input_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_input_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_input_declaration(VerilogPrimeParser.Udp_input_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_reg_declaration}.
	 * @param ctx the parse tree
	 */
	void enterUdp_reg_declaration(VerilogPrimeParser.Udp_reg_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_reg_declaration}.
	 * @param ctx the parse tree
	 */
	void exitUdp_reg_declaration(VerilogPrimeParser.Udp_reg_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_body}.
	 * @param ctx the parse tree
	 */
	void enterUdp_body(VerilogPrimeParser.Udp_bodyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_body}.
	 * @param ctx the parse tree
	 */
	void exitUdp_body(VerilogPrimeParser.Udp_bodyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#combinational_body}.
	 * @param ctx the parse tree
	 */
	void enterCombinational_body(VerilogPrimeParser.Combinational_bodyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#combinational_body}.
	 * @param ctx the parse tree
	 */
	void exitCombinational_body(VerilogPrimeParser.Combinational_bodyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#combinational_entry}.
	 * @param ctx the parse tree
	 */
	void enterCombinational_entry(VerilogPrimeParser.Combinational_entryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#combinational_entry}.
	 * @param ctx the parse tree
	 */
	void exitCombinational_entry(VerilogPrimeParser.Combinational_entryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequential_body}.
	 * @param ctx the parse tree
	 */
	void enterSequential_body(VerilogPrimeParser.Sequential_bodyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequential_body}.
	 * @param ctx the parse tree
	 */
	void exitSequential_body(VerilogPrimeParser.Sequential_bodyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_initial_statement}.
	 * @param ctx the parse tree
	 */
	void enterUdp_initial_statement(VerilogPrimeParser.Udp_initial_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_initial_statement}.
	 * @param ctx the parse tree
	 */
	void exitUdp_initial_statement(VerilogPrimeParser.Udp_initial_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#init_val}.
	 * @param ctx the parse tree
	 */
	void enterInit_val(VerilogPrimeParser.Init_valContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#init_val}.
	 * @param ctx the parse tree
	 */
	void exitInit_val(VerilogPrimeParser.Init_valContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequential_entry}.
	 * @param ctx the parse tree
	 */
	void enterSequential_entry(VerilogPrimeParser.Sequential_entryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequential_entry}.
	 * @param ctx the parse tree
	 */
	void exitSequential_entry(VerilogPrimeParser.Sequential_entryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#seq_input_list}.
	 * @param ctx the parse tree
	 */
	void enterSeq_input_list(VerilogPrimeParser.Seq_input_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#seq_input_list}.
	 * @param ctx the parse tree
	 */
	void exitSeq_input_list(VerilogPrimeParser.Seq_input_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#level_input_list}.
	 * @param ctx the parse tree
	 */
	void enterLevel_input_list(VerilogPrimeParser.Level_input_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#level_input_list}.
	 * @param ctx the parse tree
	 */
	void exitLevel_input_list(VerilogPrimeParser.Level_input_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_input_list}.
	 * @param ctx the parse tree
	 */
	void enterEdge_input_list(VerilogPrimeParser.Edge_input_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_input_list}.
	 * @param ctx the parse tree
	 */
	void exitEdge_input_list(VerilogPrimeParser.Edge_input_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_input_list_part1}.
	 * @param ctx the parse tree
	 */
	void enterEdge_input_list_part1(VerilogPrimeParser.Edge_input_list_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_input_list_part1}.
	 * @param ctx the parse tree
	 */
	void exitEdge_input_list_part1(VerilogPrimeParser.Edge_input_list_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_indicator}.
	 * @param ctx the parse tree
	 */
	void enterEdge_indicator(VerilogPrimeParser.Edge_indicatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_indicator}.
	 * @param ctx the parse tree
	 */
	void exitEdge_indicator(VerilogPrimeParser.Edge_indicatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#current_state}.
	 * @param ctx the parse tree
	 */
	void enterCurrent_state(VerilogPrimeParser.Current_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#current_state}.
	 * @param ctx the parse tree
	 */
	void exitCurrent_state(VerilogPrimeParser.Current_stateContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#next_state}.
	 * @param ctx the parse tree
	 */
	void enterNext_state(VerilogPrimeParser.Next_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#next_state}.
	 * @param ctx the parse tree
	 */
	void exitNext_state(VerilogPrimeParser.Next_stateContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#output_symbol}.
	 * @param ctx the parse tree
	 */
	void enterOutput_symbol(VerilogPrimeParser.Output_symbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#output_symbol}.
	 * @param ctx the parse tree
	 */
	void exitOutput_symbol(VerilogPrimeParser.Output_symbolContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#level_symbol}.
	 * @param ctx the parse tree
	 */
	void enterLevel_symbol(VerilogPrimeParser.Level_symbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#level_symbol}.
	 * @param ctx the parse tree
	 */
	void exitLevel_symbol(VerilogPrimeParser.Level_symbolContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_symbol}.
	 * @param ctx the parse tree
	 */
	void enterEdge_symbol(VerilogPrimeParser.Edge_symbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_symbol}.
	 * @param ctx the parse tree
	 */
	void exitEdge_symbol(VerilogPrimeParser.Edge_symbolContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_instantiation}.
	 * @param ctx the parse tree
	 */
	void enterUdp_instantiation(VerilogPrimeParser.Udp_instantiationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_instantiation}.
	 * @param ctx the parse tree
	 */
	void exitUdp_instantiation(VerilogPrimeParser.Udp_instantiationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_instance}.
	 * @param ctx the parse tree
	 */
	void enterUdp_instance(VerilogPrimeParser.Udp_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_instance}.
	 * @param ctx the parse tree
	 */
	void exitUdp_instance(VerilogPrimeParser.Udp_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#continuous_assign}.
	 * @param ctx the parse tree
	 */
	void enterContinuous_assign(VerilogPrimeParser.Continuous_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#continuous_assign}.
	 * @param ctx the parse tree
	 */
	void exitContinuous_assign(VerilogPrimeParser.Continuous_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_net_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_net_assignments(VerilogPrimeParser.List_of_net_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_net_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_net_assignments(VerilogPrimeParser.List_of_net_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_variable_assignments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_variable_assignments(VerilogPrimeParser.List_of_variable_assignmentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_assignments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_variable_assignments(VerilogPrimeParser.List_of_variable_assignmentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_alias}.
	 * @param ctx the parse tree
	 */
	void enterNet_alias(VerilogPrimeParser.Net_aliasContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_alias}.
	 * @param ctx the parse tree
	 */
	void exitNet_alias(VerilogPrimeParser.Net_aliasContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_assignment}.
	 * @param ctx the parse tree
	 */
	void enterNet_assignment(VerilogPrimeParser.Net_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_assignment}.
	 * @param ctx the parse tree
	 */
	void exitNet_assignment(VerilogPrimeParser.Net_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#initial_construct}.
	 * @param ctx the parse tree
	 */
	void enterInitial_construct(VerilogPrimeParser.Initial_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#initial_construct}.
	 * @param ctx the parse tree
	 */
	void exitInitial_construct(VerilogPrimeParser.Initial_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#always_construct}.
	 * @param ctx the parse tree
	 */
	void enterAlways_construct(VerilogPrimeParser.Always_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#always_construct}.
	 * @param ctx the parse tree
	 */
	void exitAlways_construct(VerilogPrimeParser.Always_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#always_keyword}.
	 * @param ctx the parse tree
	 */
	void enterAlways_keyword(VerilogPrimeParser.Always_keywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#always_keyword}.
	 * @param ctx the parse tree
	 */
	void exitAlways_keyword(VerilogPrimeParser.Always_keywordContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#final_construct}.
	 * @param ctx the parse tree
	 */
	void enterFinal_construct(VerilogPrimeParser.Final_constructContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#final_construct}.
	 * @param ctx the parse tree
	 */
	void exitFinal_construct(VerilogPrimeParser.Final_constructContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#blocking_assignment}.
	 * @param ctx the parse tree
	 */
	void enterBlocking_assignment(VerilogPrimeParser.Blocking_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#blocking_assignment}.
	 * @param ctx the parse tree
	 */
	void exitBlocking_assignment(VerilogPrimeParser.Blocking_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#operator_assignment}.
	 * @param ctx the parse tree
	 */
	void enterOperator_assignment(VerilogPrimeParser.Operator_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#operator_assignment}.
	 * @param ctx the parse tree
	 */
	void exitOperator_assignment(VerilogPrimeParser.Operator_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_operator}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_operator(VerilogPrimeParser.Assignment_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_operator}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_operator(VerilogPrimeParser.Assignment_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nonblocking_assignment}.
	 * @param ctx the parse tree
	 */
	void enterNonblocking_assignment(VerilogPrimeParser.Nonblocking_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nonblocking_assignment}.
	 * @param ctx the parse tree
	 */
	void exitNonblocking_assignment(VerilogPrimeParser.Nonblocking_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#procedural_continuous_assignment}.
	 * @param ctx the parse tree
	 */
	void enterProcedural_continuous_assignment(VerilogPrimeParser.Procedural_continuous_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#procedural_continuous_assignment}.
	 * @param ctx the parse tree
	 */
	void exitProcedural_continuous_assignment(VerilogPrimeParser.Procedural_continuous_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#action_block}.
	 * @param ctx the parse tree
	 */
	void enterAction_block(VerilogPrimeParser.Action_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#action_block}.
	 * @param ctx the parse tree
	 */
	void exitAction_block(VerilogPrimeParser.Action_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#seq_block}.
	 * @param ctx the parse tree
	 */
	void enterSeq_block(VerilogPrimeParser.Seq_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#seq_block}.
	 * @param ctx the parse tree
	 */
	void exitSeq_block(VerilogPrimeParser.Seq_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#seq_block_part1}.
	 * @param ctx the parse tree
	 */
	void enterSeq_block_part1(VerilogPrimeParser.Seq_block_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#seq_block_part1}.
	 * @param ctx the parse tree
	 */
	void exitSeq_block_part1(VerilogPrimeParser.Seq_block_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#par_block}.
	 * @param ctx the parse tree
	 */
	void enterPar_block(VerilogPrimeParser.Par_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#par_block}.
	 * @param ctx the parse tree
	 */
	void exitPar_block(VerilogPrimeParser.Par_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#par_block_part1}.
	 * @param ctx the parse tree
	 */
	void enterPar_block_part1(VerilogPrimeParser.Par_block_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#par_block_part1}.
	 * @param ctx the parse tree
	 */
	void exitPar_block_part1(VerilogPrimeParser.Par_block_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#join_keyword}.
	 * @param ctx the parse tree
	 */
	void enterJoin_keyword(VerilogPrimeParser.Join_keywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#join_keyword}.
	 * @param ctx the parse tree
	 */
	void exitJoin_keyword(VerilogPrimeParser.Join_keywordContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#statement_or_null}.
	 * @param ctx the parse tree
	 */
	void enterStatement_or_null(VerilogPrimeParser.Statement_or_nullContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#statement_or_null}.
	 * @param ctx the parse tree
	 */
	void exitStatement_or_null(VerilogPrimeParser.Statement_or_nullContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(VerilogPrimeParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(VerilogPrimeParser.StatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#statement_item}.
	 * @param ctx the parse tree
	 */
	void enterStatement_item(VerilogPrimeParser.Statement_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#statement_item}.
	 * @param ctx the parse tree
	 */
	void exitStatement_item(VerilogPrimeParser.Statement_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_statement}.
	 * @param ctx the parse tree
	 */
	void enterFunction_statement(VerilogPrimeParser.Function_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_statement}.
	 * @param ctx the parse tree
	 */
	void exitFunction_statement(VerilogPrimeParser.Function_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_statement_or_null}.
	 * @param ctx the parse tree
	 */
	void enterFunction_statement_or_null(VerilogPrimeParser.Function_statement_or_nullContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_statement_or_null}.
	 * @param ctx the parse tree
	 */
	void exitFunction_statement_or_null(VerilogPrimeParser.Function_statement_or_nullContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_identifier_list}.
	 * @param ctx the parse tree
	 */
	void enterVariable_identifier_list(VerilogPrimeParser.Variable_identifier_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_identifier_list}.
	 * @param ctx the parse tree
	 */
	void exitVariable_identifier_list(VerilogPrimeParser.Variable_identifier_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control_statement}.
	 * @param ctx the parse tree
	 */
	void enterProcedural_timing_control_statement(VerilogPrimeParser.Procedural_timing_control_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control_statement}.
	 * @param ctx the parse tree
	 */
	void exitProcedural_timing_control_statement(VerilogPrimeParser.Procedural_timing_control_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delay_or_event_control}.
	 * @param ctx the parse tree
	 */
	void enterDelay_or_event_control(VerilogPrimeParser.Delay_or_event_controlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delay_or_event_control}.
	 * @param ctx the parse tree
	 */
	void exitDelay_or_event_control(VerilogPrimeParser.Delay_or_event_controlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delay_control}.
	 * @param ctx the parse tree
	 */
	void enterDelay_control(VerilogPrimeParser.Delay_controlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delay_control}.
	 * @param ctx the parse tree
	 */
	void exitDelay_control(VerilogPrimeParser.Delay_controlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#event_control}.
	 * @param ctx the parse tree
	 */
	void enterEvent_control(VerilogPrimeParser.Event_controlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#event_control}.
	 * @param ctx the parse tree
	 */
	void exitEvent_control(VerilogPrimeParser.Event_controlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#event_expression}.
	 * @param ctx the parse tree
	 */
	void enterEvent_expression(VerilogPrimeParser.Event_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#event_expression}.
	 * @param ctx the parse tree
	 */
	void exitEvent_expression(VerilogPrimeParser.Event_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control}.
	 * @param ctx the parse tree
	 */
	void enterProcedural_timing_control(VerilogPrimeParser.Procedural_timing_controlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control}.
	 * @param ctx the parse tree
	 */
	void exitProcedural_timing_control(VerilogPrimeParser.Procedural_timing_controlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#jump_statement}.
	 * @param ctx the parse tree
	 */
	void enterJump_statement(VerilogPrimeParser.Jump_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#jump_statement}.
	 * @param ctx the parse tree
	 */
	void exitJump_statement(VerilogPrimeParser.Jump_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#wait_statement}.
	 * @param ctx the parse tree
	 */
	void enterWait_statement(VerilogPrimeParser.Wait_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#wait_statement}.
	 * @param ctx the parse tree
	 */
	void exitWait_statement(VerilogPrimeParser.Wait_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#event_trigger}.
	 * @param ctx the parse tree
	 */
	void enterEvent_trigger(VerilogPrimeParser.Event_triggerContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#event_trigger}.
	 * @param ctx the parse tree
	 */
	void exitEvent_trigger(VerilogPrimeParser.Event_triggerContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#disable_statement}.
	 * @param ctx the parse tree
	 */
	void enterDisable_statement(VerilogPrimeParser.Disable_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#disable_statement}.
	 * @param ctx the parse tree
	 */
	void exitDisable_statement(VerilogPrimeParser.Disable_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#conditional_statement}.
	 * @param ctx the parse tree
	 */
	void enterConditional_statement(VerilogPrimeParser.Conditional_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#conditional_statement}.
	 * @param ctx the parse tree
	 */
	void exitConditional_statement(VerilogPrimeParser.Conditional_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unique_priority}.
	 * @param ctx the parse tree
	 */
	void enterUnique_priority(VerilogPrimeParser.Unique_priorityContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unique_priority}.
	 * @param ctx the parse tree
	 */
	void exitUnique_priority(VerilogPrimeParser.Unique_priorityContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_statement}.
	 * @param ctx the parse tree
	 */
	void enterCase_statement(VerilogPrimeParser.Case_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_statement}.
	 * @param ctx the parse tree
	 */
	void exitCase_statement(VerilogPrimeParser.Case_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_keyword}.
	 * @param ctx the parse tree
	 */
	void enterCase_keyword(VerilogPrimeParser.Case_keywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_keyword}.
	 * @param ctx the parse tree
	 */
	void exitCase_keyword(VerilogPrimeParser.Case_keywordContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_expression}.
	 * @param ctx the parse tree
	 */
	void enterCase_expression(VerilogPrimeParser.Case_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_expression}.
	 * @param ctx the parse tree
	 */
	void exitCase_expression(VerilogPrimeParser.Case_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_item}.
	 * @param ctx the parse tree
	 */
	void enterCase_item(VerilogPrimeParser.Case_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_item}.
	 * @param ctx the parse tree
	 */
	void exitCase_item(VerilogPrimeParser.Case_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_pattern_item}.
	 * @param ctx the parse tree
	 */
	void enterCase_pattern_item(VerilogPrimeParser.Case_pattern_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_pattern_item}.
	 * @param ctx the parse tree
	 */
	void exitCase_pattern_item(VerilogPrimeParser.Case_pattern_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_inside_item}.
	 * @param ctx the parse tree
	 */
	void enterCase_inside_item(VerilogPrimeParser.Case_inside_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_inside_item}.
	 * @param ctx the parse tree
	 */
	void exitCase_inside_item(VerilogPrimeParser.Case_inside_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_item_expression}.
	 * @param ctx the parse tree
	 */
	void enterCase_item_expression(VerilogPrimeParser.Case_item_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_item_expression}.
	 * @param ctx the parse tree
	 */
	void exitCase_item_expression(VerilogPrimeParser.Case_item_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randcase_statement}.
	 * @param ctx the parse tree
	 */
	void enterRandcase_statement(VerilogPrimeParser.Randcase_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randcase_statement}.
	 * @param ctx the parse tree
	 */
	void exitRandcase_statement(VerilogPrimeParser.Randcase_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randcase_item}.
	 * @param ctx the parse tree
	 */
	void enterRandcase_item(VerilogPrimeParser.Randcase_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randcase_item}.
	 * @param ctx the parse tree
	 */
	void exitRandcase_item(VerilogPrimeParser.Randcase_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pattern}.
	 * @param ctx the parse tree
	 */
	void enterPattern(VerilogPrimeParser.PatternContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pattern}.
	 * @param ctx the parse tree
	 */
	void exitPattern(VerilogPrimeParser.PatternContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern(VerilogPrimeParser.Assignment_patternContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern(VerilogPrimeParser.Assignment_patternContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#structure_pattern_key}.
	 * @param ctx the parse tree
	 */
	void enterStructure_pattern_key(VerilogPrimeParser.Structure_pattern_keyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#structure_pattern_key}.
	 * @param ctx the parse tree
	 */
	void exitStructure_pattern_key(VerilogPrimeParser.Structure_pattern_keyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#array_pattern_key}.
	 * @param ctx the parse tree
	 */
	void enterArray_pattern_key(VerilogPrimeParser.Array_pattern_keyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#array_pattern_key}.
	 * @param ctx the parse tree
	 */
	void exitArray_pattern_key(VerilogPrimeParser.Array_pattern_keyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_key}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern_key(VerilogPrimeParser.Assignment_pattern_keyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_key}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern_key(VerilogPrimeParser.Assignment_pattern_keyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_assignment}.
	 * @param ctx the parse tree
	 */
	void enterVariable_assignment(VerilogPrimeParser.Variable_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_assignment}.
	 * @param ctx the parse tree
	 */
	void exitVariable_assignment(VerilogPrimeParser.Variable_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern_expression(VerilogPrimeParser.Assignment_pattern_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern_expression(VerilogPrimeParser.Assignment_pattern_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression_type}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern_expression_type(VerilogPrimeParser.Assignment_pattern_expression_typeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression_type}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern_expression_type(VerilogPrimeParser.Assignment_pattern_expression_typeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_assignment_pattern_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstant_assignment_pattern_expression(VerilogPrimeParser.Constant_assignment_pattern_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_assignment_pattern_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstant_assignment_pattern_expression(VerilogPrimeParser.Constant_assignment_pattern_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_net_lvalue}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern_net_lvalue(VerilogPrimeParser.Assignment_pattern_net_lvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_net_lvalue}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern_net_lvalue(VerilogPrimeParser.Assignment_pattern_net_lvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void enterAssignment_pattern_variable_lvalue(VerilogPrimeParser.Assignment_pattern_variable_lvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void exitAssignment_pattern_variable_lvalue(VerilogPrimeParser.Assignment_pattern_variable_lvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#loop_statement}.
	 * @param ctx the parse tree
	 */
	void enterLoop_statement(VerilogPrimeParser.Loop_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#loop_statement}.
	 * @param ctx the parse tree
	 */
	void exitLoop_statement(VerilogPrimeParser.Loop_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#for_initialization}.
	 * @param ctx the parse tree
	 */
	void enterFor_initialization(VerilogPrimeParser.For_initializationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#for_initialization}.
	 * @param ctx the parse tree
	 */
	void exitFor_initialization(VerilogPrimeParser.For_initializationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#for_variable_declaration}.
	 * @param ctx the parse tree
	 */
	void enterFor_variable_declaration(VerilogPrimeParser.For_variable_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#for_variable_declaration}.
	 * @param ctx the parse tree
	 */
	void exitFor_variable_declaration(VerilogPrimeParser.For_variable_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#for_step}.
	 * @param ctx the parse tree
	 */
	void enterFor_step(VerilogPrimeParser.For_stepContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#for_step}.
	 * @param ctx the parse tree
	 */
	void exitFor_step(VerilogPrimeParser.For_stepContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#for_step_assignment}.
	 * @param ctx the parse tree
	 */
	void enterFor_step_assignment(VerilogPrimeParser.For_step_assignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#for_step_assignment}.
	 * @param ctx the parse tree
	 */
	void exitFor_step_assignment(VerilogPrimeParser.For_step_assignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#loop_variables}.
	 * @param ctx the parse tree
	 */
	void enterLoop_variables(VerilogPrimeParser.Loop_variablesContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#loop_variables}.
	 * @param ctx the parse tree
	 */
	void exitLoop_variables(VerilogPrimeParser.Loop_variablesContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#loop_variables_part1}.
	 * @param ctx the parse tree
	 */
	void enterLoop_variables_part1(VerilogPrimeParser.Loop_variables_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#loop_variables_part1}.
	 * @param ctx the parse tree
	 */
	void exitLoop_variables_part1(VerilogPrimeParser.Loop_variables_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#subroutine_call_statement}.
	 * @param ctx the parse tree
	 */
	void enterSubroutine_call_statement(VerilogPrimeParser.Subroutine_call_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#subroutine_call_statement}.
	 * @param ctx the parse tree
	 */
	void exitSubroutine_call_statement(VerilogPrimeParser.Subroutine_call_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assertion_item}.
	 * @param ctx the parse tree
	 */
	void enterAssertion_item(VerilogPrimeParser.Assertion_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assertion_item}.
	 * @param ctx the parse tree
	 */
	void exitAssertion_item(VerilogPrimeParser.Assertion_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_item}.
	 * @param ctx the parse tree
	 */
	void enterDeferred_immediate_assertion_item(VerilogPrimeParser.Deferred_immediate_assertion_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_item}.
	 * @param ctx the parse tree
	 */
	void exitDeferred_immediate_assertion_item(VerilogPrimeParser.Deferred_immediate_assertion_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#procedural_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void enterProcedural_assertion_statement(VerilogPrimeParser.Procedural_assertion_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#procedural_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void exitProcedural_assertion_statement(VerilogPrimeParser.Procedural_assertion_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void enterImmediate_assertion_statement(VerilogPrimeParser.Immediate_assertion_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void exitImmediate_assertion_statement(VerilogPrimeParser.Immediate_assertion_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void enterSimple_immediate_assertion_statement(VerilogPrimeParser.Simple_immediate_assertion_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void exitSimple_immediate_assertion_statement(VerilogPrimeParser.Simple_immediate_assertion_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assert_statement}.
	 * @param ctx the parse tree
	 */
	void enterSimple_immediate_assert_statement(VerilogPrimeParser.Simple_immediate_assert_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assert_statement}.
	 * @param ctx the parse tree
	 */
	void exitSimple_immediate_assert_statement(VerilogPrimeParser.Simple_immediate_assert_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assume_statement}.
	 * @param ctx the parse tree
	 */
	void enterSimple_immediate_assume_statement(VerilogPrimeParser.Simple_immediate_assume_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assume_statement}.
	 * @param ctx the parse tree
	 */
	void exitSimple_immediate_assume_statement(VerilogPrimeParser.Simple_immediate_assume_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_immediate_cover_statement}.
	 * @param ctx the parse tree
	 */
	void enterSimple_immediate_cover_statement(VerilogPrimeParser.Simple_immediate_cover_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_cover_statement}.
	 * @param ctx the parse tree
	 */
	void exitSimple_immediate_cover_statement(VerilogPrimeParser.Simple_immediate_cover_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void enterDeferred_immediate_assertion_statement(VerilogPrimeParser.Deferred_immediate_assertion_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 */
	void exitDeferred_immediate_assertion_statement(VerilogPrimeParser.Deferred_immediate_assertion_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assert_statement}.
	 * @param ctx the parse tree
	 */
	void enterDeferred_immediate_assert_statement(VerilogPrimeParser.Deferred_immediate_assert_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assert_statement}.
	 * @param ctx the parse tree
	 */
	void exitDeferred_immediate_assert_statement(VerilogPrimeParser.Deferred_immediate_assert_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assume_statement}.
	 * @param ctx the parse tree
	 */
	void enterDeferred_immediate_assume_statement(VerilogPrimeParser.Deferred_immediate_assume_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assume_statement}.
	 * @param ctx the parse tree
	 */
	void exitDeferred_immediate_assume_statement(VerilogPrimeParser.Deferred_immediate_assume_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_cover_statement}.
	 * @param ctx the parse tree
	 */
	void enterDeferred_immediate_cover_statement(VerilogPrimeParser.Deferred_immediate_cover_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_cover_statement}.
	 * @param ctx the parse tree
	 */
	void exitDeferred_immediate_cover_statement(VerilogPrimeParser.Deferred_immediate_cover_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_declaration}.
	 * @param ctx the parse tree
	 */
	void enterClocking_declaration(VerilogPrimeParser.Clocking_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_declaration}.
	 * @param ctx the parse tree
	 */
	void exitClocking_declaration(VerilogPrimeParser.Clocking_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void enterClocking_declaration_part1(VerilogPrimeParser.Clocking_declaration_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_declaration_part1}.
	 * @param ctx the parse tree
	 */
	void exitClocking_declaration_part1(VerilogPrimeParser.Clocking_declaration_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_event}.
	 * @param ctx the parse tree
	 */
	void enterClocking_event(VerilogPrimeParser.Clocking_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_event}.
	 * @param ctx the parse tree
	 */
	void exitClocking_event(VerilogPrimeParser.Clocking_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_item}.
	 * @param ctx the parse tree
	 */
	void enterClocking_item(VerilogPrimeParser.Clocking_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_item}.
	 * @param ctx the parse tree
	 */
	void exitClocking_item(VerilogPrimeParser.Clocking_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#default_skew}.
	 * @param ctx the parse tree
	 */
	void enterDefault_skew(VerilogPrimeParser.Default_skewContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#default_skew}.
	 * @param ctx the parse tree
	 */
	void exitDefault_skew(VerilogPrimeParser.Default_skewContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_direction}.
	 * @param ctx the parse tree
	 */
	void enterClocking_direction(VerilogPrimeParser.Clocking_directionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_direction}.
	 * @param ctx the parse tree
	 */
	void exitClocking_direction(VerilogPrimeParser.Clocking_directionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_direction_part1}.
	 * @param ctx the parse tree
	 */
	void enterClocking_direction_part1(VerilogPrimeParser.Clocking_direction_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_direction_part1}.
	 * @param ctx the parse tree
	 */
	void exitClocking_direction_part1(VerilogPrimeParser.Clocking_direction_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_clocking_decl_assign}.
	 * @param ctx the parse tree
	 */
	void enterList_of_clocking_decl_assign(VerilogPrimeParser.List_of_clocking_decl_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_clocking_decl_assign}.
	 * @param ctx the parse tree
	 */
	void exitList_of_clocking_decl_assign(VerilogPrimeParser.List_of_clocking_decl_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_decl_assign}.
	 * @param ctx the parse tree
	 */
	void enterClocking_decl_assign(VerilogPrimeParser.Clocking_decl_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_decl_assign}.
	 * @param ctx the parse tree
	 */
	void exitClocking_decl_assign(VerilogPrimeParser.Clocking_decl_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_skew}.
	 * @param ctx the parse tree
	 */
	void enterClocking_skew(VerilogPrimeParser.Clocking_skewContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_skew}.
	 * @param ctx the parse tree
	 */
	void exitClocking_skew(VerilogPrimeParser.Clocking_skewContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_drive}.
	 * @param ctx the parse tree
	 */
	void enterClocking_drive(VerilogPrimeParser.Clocking_driveContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_drive}.
	 * @param ctx the parse tree
	 */
	void exitClocking_drive(VerilogPrimeParser.Clocking_driveContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cycle_delay}.
	 * @param ctx the parse tree
	 */
	void enterCycle_delay(VerilogPrimeParser.Cycle_delayContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cycle_delay}.
	 * @param ctx the parse tree
	 */
	void exitCycle_delay(VerilogPrimeParser.Cycle_delayContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clockvar}.
	 * @param ctx the parse tree
	 */
	void enterClockvar(VerilogPrimeParser.ClockvarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clockvar}.
	 * @param ctx the parse tree
	 */
	void exitClockvar(VerilogPrimeParser.ClockvarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clockvar_expression}.
	 * @param ctx the parse tree
	 */
	void enterClockvar_expression(VerilogPrimeParser.Clockvar_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clockvar_expression}.
	 * @param ctx the parse tree
	 */
	void exitClockvar_expression(VerilogPrimeParser.Clockvar_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randsequence_statement}.
	 * @param ctx the parse tree
	 */
	void enterRandsequence_statement(VerilogPrimeParser.Randsequence_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randsequence_statement}.
	 * @param ctx the parse tree
	 */
	void exitRandsequence_statement(VerilogPrimeParser.Randsequence_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#production}.
	 * @param ctx the parse tree
	 */
	void enterProduction(VerilogPrimeParser.ProductionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#production}.
	 * @param ctx the parse tree
	 */
	void exitProduction(VerilogPrimeParser.ProductionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_rule}.
	 * @param ctx the parse tree
	 */
	void enterRs_rule(VerilogPrimeParser.Rs_ruleContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_rule}.
	 * @param ctx the parse tree
	 */
	void exitRs_rule(VerilogPrimeParser.Rs_ruleContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_production_list}.
	 * @param ctx the parse tree
	 */
	void enterRs_production_list(VerilogPrimeParser.Rs_production_listContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_production_list}.
	 * @param ctx the parse tree
	 */
	void exitRs_production_list(VerilogPrimeParser.Rs_production_listContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#weight_specification}.
	 * @param ctx the parse tree
	 */
	void enterWeight_specification(VerilogPrimeParser.Weight_specificationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#weight_specification}.
	 * @param ctx the parse tree
	 */
	void exitWeight_specification(VerilogPrimeParser.Weight_specificationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_code_block}.
	 * @param ctx the parse tree
	 */
	void enterRs_code_block(VerilogPrimeParser.Rs_code_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_code_block}.
	 * @param ctx the parse tree
	 */
	void exitRs_code_block(VerilogPrimeParser.Rs_code_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_prod}.
	 * @param ctx the parse tree
	 */
	void enterRs_prod(VerilogPrimeParser.Rs_prodContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_prod}.
	 * @param ctx the parse tree
	 */
	void exitRs_prod(VerilogPrimeParser.Rs_prodContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#production_item}.
	 * @param ctx the parse tree
	 */
	void enterProduction_item(VerilogPrimeParser.Production_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#production_item}.
	 * @param ctx the parse tree
	 */
	void exitProduction_item(VerilogPrimeParser.Production_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_if_else}.
	 * @param ctx the parse tree
	 */
	void enterRs_if_else(VerilogPrimeParser.Rs_if_elseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_if_else}.
	 * @param ctx the parse tree
	 */
	void exitRs_if_else(VerilogPrimeParser.Rs_if_elseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_repeat}.
	 * @param ctx the parse tree
	 */
	void enterRs_repeat(VerilogPrimeParser.Rs_repeatContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_repeat}.
	 * @param ctx the parse tree
	 */
	void exitRs_repeat(VerilogPrimeParser.Rs_repeatContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_case}.
	 * @param ctx the parse tree
	 */
	void enterRs_case(VerilogPrimeParser.Rs_caseContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_case}.
	 * @param ctx the parse tree
	 */
	void exitRs_case(VerilogPrimeParser.Rs_caseContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rs_case_item}.
	 * @param ctx the parse tree
	 */
	void enterRs_case_item(VerilogPrimeParser.Rs_case_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rs_case_item}.
	 * @param ctx the parse tree
	 */
	void exitRs_case_item(VerilogPrimeParser.Rs_case_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specify_block}.
	 * @param ctx the parse tree
	 */
	void enterSpecify_block(VerilogPrimeParser.Specify_blockContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specify_block}.
	 * @param ctx the parse tree
	 */
	void exitSpecify_block(VerilogPrimeParser.Specify_blockContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specify_item}.
	 * @param ctx the parse tree
	 */
	void enterSpecify_item(VerilogPrimeParser.Specify_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specify_item}.
	 * @param ctx the parse tree
	 */
	void exitSpecify_item(VerilogPrimeParser.Specify_itemContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulsestyle_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPulsestyle_declaration(VerilogPrimeParser.Pulsestyle_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPulsestyle_declaration(VerilogPrimeParser.Pulsestyle_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#showcancelled_declaration}.
	 * @param ctx the parse tree
	 */
	void enterShowcancelled_declaration(VerilogPrimeParser.Showcancelled_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#showcancelled_declaration}.
	 * @param ctx the parse tree
	 */
	void exitShowcancelled_declaration(VerilogPrimeParser.Showcancelled_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#path_declaration}.
	 * @param ctx the parse tree
	 */
	void enterPath_declaration(VerilogPrimeParser.Path_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#path_declaration}.
	 * @param ctx the parse tree
	 */
	void exitPath_declaration(VerilogPrimeParser.Path_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_path_declaration}.
	 * @param ctx the parse tree
	 */
	void enterSimple_path_declaration(VerilogPrimeParser.Simple_path_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_path_declaration}.
	 * @param ctx the parse tree
	 */
	void exitSimple_path_declaration(VerilogPrimeParser.Simple_path_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parallel_path_description}.
	 * @param ctx the parse tree
	 */
	void enterParallel_path_description(VerilogPrimeParser.Parallel_path_descriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parallel_path_description}.
	 * @param ctx the parse tree
	 */
	void exitParallel_path_description(VerilogPrimeParser.Parallel_path_descriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#full_path_description}.
	 * @param ctx the parse tree
	 */
	void enterFull_path_description(VerilogPrimeParser.Full_path_descriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#full_path_description}.
	 * @param ctx the parse tree
	 */
	void exitFull_path_description(VerilogPrimeParser.Full_path_descriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_path_inputs}.
	 * @param ctx the parse tree
	 */
	void enterList_of_path_inputs(VerilogPrimeParser.List_of_path_inputsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_path_inputs}.
	 * @param ctx the parse tree
	 */
	void exitList_of_path_inputs(VerilogPrimeParser.List_of_path_inputsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_path_outputs}.
	 * @param ctx the parse tree
	 */
	void enterList_of_path_outputs(VerilogPrimeParser.List_of_path_outputsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_path_outputs}.
	 * @param ctx the parse tree
	 */
	void exitList_of_path_outputs(VerilogPrimeParser.List_of_path_outputsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specify_input_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void enterSpecify_input_terminal_descriptor(VerilogPrimeParser.Specify_input_terminal_descriptorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specify_input_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void exitSpecify_input_terminal_descriptor(VerilogPrimeParser.Specify_input_terminal_descriptorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specify_output_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void enterSpecify_output_terminal_descriptor(VerilogPrimeParser.Specify_output_terminal_descriptorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specify_output_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void exitSpecify_output_terminal_descriptor(VerilogPrimeParser.Specify_output_terminal_descriptorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#input_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInput_identifier(VerilogPrimeParser.Input_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#input_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInput_identifier(VerilogPrimeParser.Input_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#output_identifier}.
	 * @param ctx the parse tree
	 */
	void enterOutput_identifier(VerilogPrimeParser.Output_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#output_identifier}.
	 * @param ctx the parse tree
	 */
	void exitOutput_identifier(VerilogPrimeParser.Output_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#path_delay_value}.
	 * @param ctx the parse tree
	 */
	void enterPath_delay_value(VerilogPrimeParser.Path_delay_valueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#path_delay_value}.
	 * @param ctx the parse tree
	 */
	void exitPath_delay_value(VerilogPrimeParser.Path_delay_valueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_path_delay_expressions}.
	 * @param ctx the parse tree
	 */
	void enterList_of_path_delay_expressions(VerilogPrimeParser.List_of_path_delay_expressionsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_path_delay_expressions}.
	 * @param ctx the parse tree
	 */
	void exitList_of_path_delay_expressions(VerilogPrimeParser.List_of_path_delay_expressionsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT_path_delay_expression(VerilogPrimeParser.T_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT_path_delay_expression(VerilogPrimeParser.T_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#trise_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTrise_path_delay_expression(VerilogPrimeParser.Trise_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#trise_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTrise_path_delay_expression(VerilogPrimeParser.Trise_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tfall_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTfall_path_delay_expression(VerilogPrimeParser.Tfall_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tfall_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTfall_path_delay_expression(VerilogPrimeParser.Tfall_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tz_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTz_path_delay_expression(VerilogPrimeParser.Tz_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tz_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTz_path_delay_expression(VerilogPrimeParser.Tz_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t01_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT01_path_delay_expression(VerilogPrimeParser.T01_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t01_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT01_path_delay_expression(VerilogPrimeParser.T01_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t10_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT10_path_delay_expression(VerilogPrimeParser.T10_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t10_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT10_path_delay_expression(VerilogPrimeParser.T10_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t0z_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT0z_path_delay_expression(VerilogPrimeParser.T0z_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t0z_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT0z_path_delay_expression(VerilogPrimeParser.T0z_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tz1_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTz1_path_delay_expression(VerilogPrimeParser.Tz1_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tz1_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTz1_path_delay_expression(VerilogPrimeParser.Tz1_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t1z_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT1z_path_delay_expression(VerilogPrimeParser.T1z_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t1z_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT1z_path_delay_expression(VerilogPrimeParser.T1z_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tz0_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTz0_path_delay_expression(VerilogPrimeParser.Tz0_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tz0_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTz0_path_delay_expression(VerilogPrimeParser.Tz0_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t0x_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT0x_path_delay_expression(VerilogPrimeParser.T0x_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t0x_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT0x_path_delay_expression(VerilogPrimeParser.T0x_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tx1_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTx1_path_delay_expression(VerilogPrimeParser.Tx1_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tx1_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTx1_path_delay_expression(VerilogPrimeParser.Tx1_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#t1x_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterT1x_path_delay_expression(VerilogPrimeParser.T1x_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#t1x_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitT1x_path_delay_expression(VerilogPrimeParser.T1x_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tx0_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTx0_path_delay_expression(VerilogPrimeParser.Tx0_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tx0_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTx0_path_delay_expression(VerilogPrimeParser.Tx0_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#txz_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTxz_path_delay_expression(VerilogPrimeParser.Txz_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#txz_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTxz_path_delay_expression(VerilogPrimeParser.Txz_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tzx_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterTzx_path_delay_expression(VerilogPrimeParser.Tzx_path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tzx_path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitTzx_path_delay_expression(VerilogPrimeParser.Tzx_path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void enterPath_delay_expression(VerilogPrimeParser.Path_delay_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#path_delay_expression}.
	 * @param ctx the parse tree
	 */
	void exitPath_delay_expression(VerilogPrimeParser.Path_delay_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_sensitive_path_declaration}.
	 * @param ctx the parse tree
	 */
	void enterEdge_sensitive_path_declaration(VerilogPrimeParser.Edge_sensitive_path_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_sensitive_path_declaration}.
	 * @param ctx the parse tree
	 */
	void exitEdge_sensitive_path_declaration(VerilogPrimeParser.Edge_sensitive_path_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parallel_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 */
	void enterParallel_edge_sensitive_path_description(VerilogPrimeParser.Parallel_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parallel_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 */
	void exitParallel_edge_sensitive_path_description(VerilogPrimeParser.Parallel_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#full_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 */
	void enterFull_edge_sensitive_path_description(VerilogPrimeParser.Full_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#full_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 */
	void exitFull_edge_sensitive_path_description(VerilogPrimeParser.Full_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_source_expression}.
	 * @param ctx the parse tree
	 */
	void enterData_source_expression(VerilogPrimeParser.Data_source_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_source_expression}.
	 * @param ctx the parse tree
	 */
	void exitData_source_expression(VerilogPrimeParser.Data_source_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_identifier}.
	 * @param ctx the parse tree
	 */
	void enterEdge_identifier(VerilogPrimeParser.Edge_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_identifier}.
	 * @param ctx the parse tree
	 */
	void exitEdge_identifier(VerilogPrimeParser.Edge_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#state_dependent_path_declaration}.
	 * @param ctx the parse tree
	 */
	void enterState_dependent_path_declaration(VerilogPrimeParser.State_dependent_path_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#state_dependent_path_declaration}.
	 * @param ctx the parse tree
	 */
	void exitState_dependent_path_declaration(VerilogPrimeParser.State_dependent_path_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#polarity_operator}.
	 * @param ctx the parse tree
	 */
	void enterPolarity_operator(VerilogPrimeParser.Polarity_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#polarity_operator}.
	 * @param ctx the parse tree
	 */
	void exitPolarity_operator(VerilogPrimeParser.Polarity_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#system_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterSystem_timing_check(VerilogPrimeParser.System_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#system_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitSystem_timing_check(VerilogPrimeParser.System_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#setup_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterSetup_timing_check(VerilogPrimeParser.Setup_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#setup_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitSetup_timing_check(VerilogPrimeParser.Setup_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hold_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterHold_timing_check(VerilogPrimeParser.Hold_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hold_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitHold_timing_check(VerilogPrimeParser.Hold_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#setuphold_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterSetuphold_timing_check(VerilogPrimeParser.Setuphold_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#setuphold_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitSetuphold_timing_check(VerilogPrimeParser.Setuphold_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#recovery_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterRecovery_timing_check(VerilogPrimeParser.Recovery_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#recovery_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitRecovery_timing_check(VerilogPrimeParser.Recovery_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#removal_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterRemoval_timing_check(VerilogPrimeParser.Removal_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#removal_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitRemoval_timing_check(VerilogPrimeParser.Removal_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#recrem_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterRecrem_timing_check(VerilogPrimeParser.Recrem_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#recrem_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitRecrem_timing_check(VerilogPrimeParser.Recrem_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#skew_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterSkew_timing_check(VerilogPrimeParser.Skew_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#skew_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitSkew_timing_check(VerilogPrimeParser.Skew_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timeskew_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterTimeskew_timing_check(VerilogPrimeParser.Timeskew_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timeskew_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitTimeskew_timing_check(VerilogPrimeParser.Timeskew_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#fullskew_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterFullskew_timing_check(VerilogPrimeParser.Fullskew_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#fullskew_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitFullskew_timing_check(VerilogPrimeParser.Fullskew_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#period_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterPeriod_timing_check(VerilogPrimeParser.Period_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#period_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitPeriod_timing_check(VerilogPrimeParser.Period_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#width_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterWidth_timing_check(VerilogPrimeParser.Width_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#width_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitWidth_timing_check(VerilogPrimeParser.Width_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nochange_timing_check}.
	 * @param ctx the parse tree
	 */
	void enterNochange_timing_check(VerilogPrimeParser.Nochange_timing_checkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nochange_timing_check}.
	 * @param ctx the parse tree
	 */
	void exitNochange_timing_check(VerilogPrimeParser.Nochange_timing_checkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timecheck_condition}.
	 * @param ctx the parse tree
	 */
	void enterTimecheck_condition(VerilogPrimeParser.Timecheck_conditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timecheck_condition}.
	 * @param ctx the parse tree
	 */
	void exitTimecheck_condition(VerilogPrimeParser.Timecheck_conditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#controlled_reference_event}.
	 * @param ctx the parse tree
	 */
	void enterControlled_reference_event(VerilogPrimeParser.Controlled_reference_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#controlled_reference_event}.
	 * @param ctx the parse tree
	 */
	void exitControlled_reference_event(VerilogPrimeParser.Controlled_reference_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#data_event}.
	 * @param ctx the parse tree
	 */
	void enterData_event(VerilogPrimeParser.Data_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#data_event}.
	 * @param ctx the parse tree
	 */
	void exitData_event(VerilogPrimeParser.Data_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delayed_data}.
	 * @param ctx the parse tree
	 */
	void enterDelayed_data(VerilogPrimeParser.Delayed_dataContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delayed_data}.
	 * @param ctx the parse tree
	 */
	void exitDelayed_data(VerilogPrimeParser.Delayed_dataContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#delayed_reference}.
	 * @param ctx the parse tree
	 */
	void enterDelayed_reference(VerilogPrimeParser.Delayed_referenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#delayed_reference}.
	 * @param ctx the parse tree
	 */
	void exitDelayed_reference(VerilogPrimeParser.Delayed_referenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#end_edge_offset}.
	 * @param ctx the parse tree
	 */
	void enterEnd_edge_offset(VerilogPrimeParser.End_edge_offsetContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#end_edge_offset}.
	 * @param ctx the parse tree
	 */
	void exitEnd_edge_offset(VerilogPrimeParser.End_edge_offsetContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#event_based_flag}.
	 * @param ctx the parse tree
	 */
	void enterEvent_based_flag(VerilogPrimeParser.Event_based_flagContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#event_based_flag}.
	 * @param ctx the parse tree
	 */
	void exitEvent_based_flag(VerilogPrimeParser.Event_based_flagContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#notifier}.
	 * @param ctx the parse tree
	 */
	void enterNotifier(VerilogPrimeParser.NotifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#notifier}.
	 * @param ctx the parse tree
	 */
	void exitNotifier(VerilogPrimeParser.NotifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#reference_event}.
	 * @param ctx the parse tree
	 */
	void enterReference_event(VerilogPrimeParser.Reference_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#reference_event}.
	 * @param ctx the parse tree
	 */
	void exitReference_event(VerilogPrimeParser.Reference_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#remain_active_flag}.
	 * @param ctx the parse tree
	 */
	void enterRemain_active_flag(VerilogPrimeParser.Remain_active_flagContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#remain_active_flag}.
	 * @param ctx the parse tree
	 */
	void exitRemain_active_flag(VerilogPrimeParser.Remain_active_flagContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timestamp_condition}.
	 * @param ctx the parse tree
	 */
	void enterTimestamp_condition(VerilogPrimeParser.Timestamp_conditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timestamp_condition}.
	 * @param ctx the parse tree
	 */
	void exitTimestamp_condition(VerilogPrimeParser.Timestamp_conditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#start_edge_offset}.
	 * @param ctx the parse tree
	 */
	void enterStart_edge_offset(VerilogPrimeParser.Start_edge_offsetContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#start_edge_offset}.
	 * @param ctx the parse tree
	 */
	void exitStart_edge_offset(VerilogPrimeParser.Start_edge_offsetContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#threshold}.
	 * @param ctx the parse tree
	 */
	void enterThreshold(VerilogPrimeParser.ThresholdContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#threshold}.
	 * @param ctx the parse tree
	 */
	void exitThreshold(VerilogPrimeParser.ThresholdContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timing_check_limit}.
	 * @param ctx the parse tree
	 */
	void enterTiming_check_limit(VerilogPrimeParser.Timing_check_limitContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timing_check_limit}.
	 * @param ctx the parse tree
	 */
	void exitTiming_check_limit(VerilogPrimeParser.Timing_check_limitContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timing_check_event}.
	 * @param ctx the parse tree
	 */
	void enterTiming_check_event(VerilogPrimeParser.Timing_check_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timing_check_event}.
	 * @param ctx the parse tree
	 */
	void exitTiming_check_event(VerilogPrimeParser.Timing_check_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#controlled_timing_check_event}.
	 * @param ctx the parse tree
	 */
	void enterControlled_timing_check_event(VerilogPrimeParser.Controlled_timing_check_eventContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#controlled_timing_check_event}.
	 * @param ctx the parse tree
	 */
	void exitControlled_timing_check_event(VerilogPrimeParser.Controlled_timing_check_eventContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timing_check_event_control}.
	 * @param ctx the parse tree
	 */
	void enterTiming_check_event_control(VerilogPrimeParser.Timing_check_event_controlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timing_check_event_control}.
	 * @param ctx the parse tree
	 */
	void exitTiming_check_event_control(VerilogPrimeParser.Timing_check_event_controlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specify_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void enterSpecify_terminal_descriptor(VerilogPrimeParser.Specify_terminal_descriptorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specify_terminal_descriptor}.
	 * @param ctx the parse tree
	 */
	void exitSpecify_terminal_descriptor(VerilogPrimeParser.Specify_terminal_descriptorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_control_specifier}.
	 * @param ctx the parse tree
	 */
	void enterEdge_control_specifier(VerilogPrimeParser.Edge_control_specifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_control_specifier}.
	 * @param ctx the parse tree
	 */
	void exitEdge_control_specifier(VerilogPrimeParser.Edge_control_specifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_descriptor}.
	 * @param ctx the parse tree
	 */
	void enterEdge_descriptor(VerilogPrimeParser.Edge_descriptorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_descriptor}.
	 * @param ctx the parse tree
	 */
	void exitEdge_descriptor(VerilogPrimeParser.Edge_descriptorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timing_check_condition}.
	 * @param ctx the parse tree
	 */
	void enterTiming_check_condition(VerilogPrimeParser.Timing_check_conditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timing_check_condition}.
	 * @param ctx the parse tree
	 */
	void exitTiming_check_condition(VerilogPrimeParser.Timing_check_conditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#scalar_timing_check_condition}.
	 * @param ctx the parse tree
	 */
	void enterScalar_timing_check_condition(VerilogPrimeParser.Scalar_timing_check_conditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#scalar_timing_check_condition}.
	 * @param ctx the parse tree
	 */
	void exitScalar_timing_check_condition(VerilogPrimeParser.Scalar_timing_check_conditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#scalar_constant}.
	 * @param ctx the parse tree
	 */
	void enterScalar_constant(VerilogPrimeParser.Scalar_constantContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#scalar_constant}.
	 * @param ctx the parse tree
	 */
	void exitScalar_constant(VerilogPrimeParser.Scalar_constantContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#concatenation}.
	 * @param ctx the parse tree
	 */
	void enterConcatenation(VerilogPrimeParser.ConcatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#concatenation}.
	 * @param ctx the parse tree
	 */
	void exitConcatenation(VerilogPrimeParser.ConcatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterConstant_concatenation(VerilogPrimeParser.Constant_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitConstant_concatenation(VerilogPrimeParser.Constant_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterConstant_multiple_concatenation(VerilogPrimeParser.Constant_multiple_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitConstant_multiple_concatenation(VerilogPrimeParser.Constant_multiple_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_concatenation(VerilogPrimeParser.Module_path_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_concatenation(VerilogPrimeParser.Module_path_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_multiple_concatenation(VerilogPrimeParser.Module_path_multiple_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_multiple_concatenation(VerilogPrimeParser.Module_path_multiple_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterMultiple_concatenation(VerilogPrimeParser.Multiple_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#multiple_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitMultiple_concatenation(VerilogPrimeParser.Multiple_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#streaming_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterStreaming_concatenation(VerilogPrimeParser.Streaming_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#streaming_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitStreaming_concatenation(VerilogPrimeParser.Streaming_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stream_operator}.
	 * @param ctx the parse tree
	 */
	void enterStream_operator(VerilogPrimeParser.Stream_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stream_operator}.
	 * @param ctx the parse tree
	 */
	void exitStream_operator(VerilogPrimeParser.Stream_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#slice_size}.
	 * @param ctx the parse tree
	 */
	void enterSlice_size(VerilogPrimeParser.Slice_sizeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#slice_size}.
	 * @param ctx the parse tree
	 */
	void exitSlice_size(VerilogPrimeParser.Slice_sizeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stream_concatenation}.
	 * @param ctx the parse tree
	 */
	void enterStream_concatenation(VerilogPrimeParser.Stream_concatenationContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stream_concatenation}.
	 * @param ctx the parse tree
	 */
	void exitStream_concatenation(VerilogPrimeParser.Stream_concatenationContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stream_expression}.
	 * @param ctx the parse tree
	 */
	void enterStream_expression(VerilogPrimeParser.Stream_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stream_expression}.
	 * @param ctx the parse tree
	 */
	void exitStream_expression(VerilogPrimeParser.Stream_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#array_range_expression}.
	 * @param ctx the parse tree
	 */
	void enterArray_range_expression(VerilogPrimeParser.Array_range_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#array_range_expression}.
	 * @param ctx the parse tree
	 */
	void exitArray_range_expression(VerilogPrimeParser.Array_range_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#empty_queue}.
	 * @param ctx the parse tree
	 */
	void enterEmpty_queue(VerilogPrimeParser.Empty_queueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#empty_queue}.
	 * @param ctx the parse tree
	 */
	void exitEmpty_queue(VerilogPrimeParser.Empty_queueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_function_call}.
	 * @param ctx the parse tree
	 */
	void enterConstant_function_call(VerilogPrimeParser.Constant_function_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_function_call}.
	 * @param ctx the parse tree
	 */
	void exitConstant_function_call(VerilogPrimeParser.Constant_function_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_call}.
	 * @param ctx the parse tree
	 */
	void enterTf_call(VerilogPrimeParser.Tf_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_call}.
	 * @param ctx the parse tree
	 */
	void exitTf_call(VerilogPrimeParser.Tf_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#system_tf_call}.
	 * @param ctx the parse tree
	 */
	void enterSystem_tf_call(VerilogPrimeParser.System_tf_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#system_tf_call}.
	 * @param ctx the parse tree
	 */
	void exitSystem_tf_call(VerilogPrimeParser.System_tf_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#subroutine_call}.
	 * @param ctx the parse tree
	 */
	void enterSubroutine_call(VerilogPrimeParser.Subroutine_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#subroutine_call}.
	 * @param ctx the parse tree
	 */
	void exitSubroutine_call(VerilogPrimeParser.Subroutine_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_subroutine_call}.
	 * @param ctx the parse tree
	 */
	void enterFunction_subroutine_call(VerilogPrimeParser.Function_subroutine_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_subroutine_call}.
	 * @param ctx the parse tree
	 */
	void exitFunction_subroutine_call(VerilogPrimeParser.Function_subroutine_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void enterList_of_arguments(VerilogPrimeParser.List_of_argumentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments}.
	 * @param ctx the parse tree
	 */
	void exitList_of_arguments(VerilogPrimeParser.List_of_argumentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void enterList_of_arguments_part1(VerilogPrimeParser.List_of_arguments_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part1}.
	 * @param ctx the parse tree
	 */
	void exitList_of_arguments_part1(VerilogPrimeParser.List_of_arguments_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void enterList_of_arguments_part2(VerilogPrimeParser.List_of_arguments_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part2}.
	 * @param ctx the parse tree
	 */
	void exitList_of_arguments_part2(VerilogPrimeParser.List_of_arguments_part2Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_call}.
	 * @param ctx the parse tree
	 */
	void enterMethod_call(VerilogPrimeParser.Method_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_call}.
	 * @param ctx the parse tree
	 */
	void exitMethod_call(VerilogPrimeParser.Method_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_call_body}.
	 * @param ctx the parse tree
	 */
	void enterMethod_call_body(VerilogPrimeParser.Method_call_bodyContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_call_body}.
	 * @param ctx the parse tree
	 */
	void exitMethod_call_body(VerilogPrimeParser.Method_call_bodyContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#built_in_method_call}.
	 * @param ctx the parse tree
	 */
	void enterBuilt_in_method_call(VerilogPrimeParser.Built_in_method_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#built_in_method_call}.
	 * @param ctx the parse tree
	 */
	void exitBuilt_in_method_call(VerilogPrimeParser.Built_in_method_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#array_manipulation_call}.
	 * @param ctx the parse tree
	 */
	void enterArray_manipulation_call(VerilogPrimeParser.Array_manipulation_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#array_manipulation_call}.
	 * @param ctx the parse tree
	 */
	void exitArray_manipulation_call(VerilogPrimeParser.Array_manipulation_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randomize_call}.
	 * @param ctx the parse tree
	 */
	void enterRandomize_call(VerilogPrimeParser.Randomize_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randomize_call}.
	 * @param ctx the parse tree
	 */
	void exitRandomize_call(VerilogPrimeParser.Randomize_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_call_root}.
	 * @param ctx the parse tree
	 */
	void enterMethod_call_root(VerilogPrimeParser.Method_call_rootContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_call_root}.
	 * @param ctx the parse tree
	 */
	void exitMethod_call_root(VerilogPrimeParser.Method_call_rootContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#array_method_name}.
	 * @param ctx the parse tree
	 */
	void enterArray_method_name(VerilogPrimeParser.Array_method_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#array_method_name}.
	 * @param ctx the parse tree
	 */
	void exitArray_method_name(VerilogPrimeParser.Array_method_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression}.
	 * @param ctx the parse tree
	 */
	void enterInc_or_dec_expression(VerilogPrimeParser.Inc_or_dec_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression}.
	 * @param ctx the parse tree
	 */
	void exitInc_or_dec_expression(VerilogPrimeParser.Inc_or_dec_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part1}.
	 * @param ctx the parse tree
	 */
	void enterInc_or_dec_expression_part1(VerilogPrimeParser.Inc_or_dec_expression_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part1}.
	 * @param ctx the parse tree
	 */
	void exitInc_or_dec_expression_part1(VerilogPrimeParser.Inc_or_dec_expression_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part2}.
	 * @param ctx the parse tree
	 */
	void enterInc_or_dec_expression_part2(VerilogPrimeParser.Inc_or_dec_expression_part2Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part2}.
	 * @param ctx the parse tree
	 */
	void exitInc_or_dec_expression_part2(VerilogPrimeParser.Inc_or_dec_expression_part2Context ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_st_st(VerilogPrimeParser.Const_expr_st_stContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_st_st(VerilogPrimeParser.Const_expr_st_stContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_equality}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_equality(VerilogPrimeParser.Const_expr_equalityContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_equality}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_equality(VerilogPrimeParser.Const_expr_equalityContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_binary_xor(VerilogPrimeParser.Const_expr_binary_xorContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_binary_xor(VerilogPrimeParser.Const_expr_binary_xorContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_unary_op(VerilogPrimeParser.Const_expr_unary_opContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_unary_op(VerilogPrimeParser.Const_expr_unary_opContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_comp}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_comp(VerilogPrimeParser.Const_expr_compContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_comp}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_comp(VerilogPrimeParser.Const_expr_compContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_binary_or(VerilogPrimeParser.Const_expr_binary_orContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_binary_or(VerilogPrimeParser.Const_expr_binary_orContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_log_or(VerilogPrimeParser.Const_expr_log_orContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_log_or(VerilogPrimeParser.Const_expr_log_orContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_log_and(VerilogPrimeParser.Const_expr_log_andContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_log_and(VerilogPrimeParser.Const_expr_log_andContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_binary_and(VerilogPrimeParser.Const_expr_binary_andContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_binary_and(VerilogPrimeParser.Const_expr_binary_andContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_conditional}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_conditional(VerilogPrimeParser.Const_expr_conditionalContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_conditional}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_conditional(VerilogPrimeParser.Const_expr_conditionalContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_mutl}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_mutl(VerilogPrimeParser.Const_expr_mutlContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_mutl}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_mutl(VerilogPrimeParser.Const_expr_mutlContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_add}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_add(VerilogPrimeParser.Const_expr_addContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_add}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_add(VerilogPrimeParser.Const_expr_addContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_only_primary(VerilogPrimeParser.Const_expr_only_primaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_only_primary(VerilogPrimeParser.Const_expr_only_primaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code const_expr_shift}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expr_shift(VerilogPrimeParser.Const_expr_shiftContext ctx);
	/**
	 * Exit a parse tree produced by the {@code const_expr_shift}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expr_shift(VerilogPrimeParser.Const_expr_shiftContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstant_mintypmax_expression(VerilogPrimeParser.Constant_mintypmax_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstant_mintypmax_expression(VerilogPrimeParser.Constant_mintypmax_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_param_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstant_param_expression(VerilogPrimeParser.Constant_param_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_param_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstant_param_expression(VerilogPrimeParser.Constant_param_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#param_expression}.
	 * @param ctx the parse tree
	 */
	void enterParam_expression(VerilogPrimeParser.Param_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#param_expression}.
	 * @param ctx the parse tree
	 */
	void exitParam_expression(VerilogPrimeParser.Param_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_range_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstant_range_expression(VerilogPrimeParser.Constant_range_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_range_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstant_range_expression(VerilogPrimeParser.Constant_range_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_part_select_range}.
	 * @param ctx the parse tree
	 */
	void enterConstant_part_select_range(VerilogPrimeParser.Constant_part_select_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_part_select_range}.
	 * @param ctx the parse tree
	 */
	void exitConstant_part_select_range(VerilogPrimeParser.Constant_part_select_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_range}.
	 * @param ctx the parse tree
	 */
	void enterConstant_range(VerilogPrimeParser.Constant_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_range}.
	 * @param ctx the parse tree
	 */
	void exitConstant_range(VerilogPrimeParser.Constant_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_indexed_range}.
	 * @param ctx the parse tree
	 */
	void enterConstant_indexed_range(VerilogPrimeParser.Constant_indexed_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_indexed_range}.
	 * @param ctx the parse tree
	 */
	void exitConstant_indexed_range(VerilogPrimeParser.Constant_indexed_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#expr_}.
	 * @param ctx the parse tree
	 */
	void enterExpr_(VerilogPrimeParser.Expr_Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#expr_}.
	 * @param ctx the parse tree
	 */
	void exitExpr_(VerilogPrimeParser.Expr_Context ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_shift}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_shift(VerilogPrimeParser.Expression_shiftContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_shift}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_shift(VerilogPrimeParser.Expression_shiftContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_binary_or(VerilogPrimeParser.Expression_binary_orContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_binary_or(VerilogPrimeParser.Expression_binary_orContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_mult}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_mult(VerilogPrimeParser.Expression_multContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_mult}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_mult(VerilogPrimeParser.Expression_multContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_only_primary(VerilogPrimeParser.Expression_only_primaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_only_primary(VerilogPrimeParser.Expression_only_primaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_log_and(VerilogPrimeParser.Expression_log_andContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_log_and(VerilogPrimeParser.Expression_log_andContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_inside_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_inside_exp(VerilogPrimeParser.Expression_inside_expContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_inside_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_inside_exp(VerilogPrimeParser.Expression_inside_expContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_op_assign}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_op_assign(VerilogPrimeParser.Expression_op_assignContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_op_assign}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_op_assign(VerilogPrimeParser.Expression_op_assignContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_comp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_comp(VerilogPrimeParser.Expression_compContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_comp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_comp(VerilogPrimeParser.Expression_compContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_tagged_union}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_tagged_union(VerilogPrimeParser.Expression_tagged_unionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_tagged_union}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_tagged_union(VerilogPrimeParser.Expression_tagged_unionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_equality}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_equality(VerilogPrimeParser.Expression_equalityContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_equality}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_equality(VerilogPrimeParser.Expression_equalityContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_log_or(VerilogPrimeParser.Expression_log_orContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_log_or(VerilogPrimeParser.Expression_log_orContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_add}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_add(VerilogPrimeParser.Expression_addContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_add}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_add(VerilogPrimeParser.Expression_addContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_inc_or_dec}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_inc_or_dec(VerilogPrimeParser.Expression_inc_or_decContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_inc_or_dec}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_inc_or_dec(VerilogPrimeParser.Expression_inc_or_decContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_st_st(VerilogPrimeParser.Expression_st_stContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_st_st(VerilogPrimeParser.Expression_st_stContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_binary_and(VerilogPrimeParser.Expression_binary_andContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_binary_and(VerilogPrimeParser.Expression_binary_andContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_conditional_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_conditional_exp(VerilogPrimeParser.Expression_conditional_expContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_conditional_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_conditional_exp(VerilogPrimeParser.Expression_conditional_expContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_binary_xor(VerilogPrimeParser.Expression_binary_xorContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_binary_xor(VerilogPrimeParser.Expression_binary_xorContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_unary_op(VerilogPrimeParser.Expression_unary_opContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_unary_op(VerilogPrimeParser.Expression_unary_opContext ctx);
	/**
	 * Enter a parse tree produced by the {@code expression_static_casting}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression_static_casting(VerilogPrimeParser.Expression_static_castingContext ctx);
	/**
	 * Exit a parse tree produced by the {@code expression_static_casting}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression_static_casting(VerilogPrimeParser.Expression_static_castingContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#matches_pattern}.
	 * @param ctx the parse tree
	 */
	void enterMatches_pattern(VerilogPrimeParser.Matches_patternContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#matches_pattern}.
	 * @param ctx the parse tree
	 */
	void exitMatches_pattern(VerilogPrimeParser.Matches_patternContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tagged_union_expression}.
	 * @param ctx the parse tree
	 */
	void enterTagged_union_expression(VerilogPrimeParser.Tagged_union_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tagged_union_expression}.
	 * @param ctx the parse tree
	 */
	void exitTagged_union_expression(VerilogPrimeParser.Tagged_union_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#value_range}.
	 * @param ctx the parse tree
	 */
	void enterValue_range(VerilogPrimeParser.Value_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#value_range}.
	 * @param ctx the parse tree
	 */
	void exitValue_range(VerilogPrimeParser.Value_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void enterMintypmax_expression(VerilogPrimeParser.Mintypmax_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void exitMintypmax_expression(VerilogPrimeParser.Mintypmax_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_expression}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_expression(VerilogPrimeParser.Module_path_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_expression}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_expression(VerilogPrimeParser.Module_path_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_conditional_expression}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_conditional_expression(VerilogPrimeParser.Module_path_conditional_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_conditional_expression}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_conditional_expression(VerilogPrimeParser.Module_path_conditional_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_binary_expression}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_binary_expression(VerilogPrimeParser.Module_path_binary_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_binary_expression}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_binary_expression(VerilogPrimeParser.Module_path_binary_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_unary_expression}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_unary_expression(VerilogPrimeParser.Module_path_unary_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_unary_expression}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_unary_expression(VerilogPrimeParser.Module_path_unary_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_mintypmax_expression(VerilogPrimeParser.Module_path_mintypmax_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_mintypmax_expression}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_mintypmax_expression(VerilogPrimeParser.Module_path_mintypmax_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#part_select_range}.
	 * @param ctx the parse tree
	 */
	void enterPart_select_range(VerilogPrimeParser.Part_select_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#part_select_range}.
	 * @param ctx the parse tree
	 */
	void exitPart_select_range(VerilogPrimeParser.Part_select_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#indexed_range}.
	 * @param ctx the parse tree
	 */
	void enterIndexed_range(VerilogPrimeParser.Indexed_rangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#indexed_range}.
	 * @param ctx the parse tree
	 */
	void exitIndexed_range(VerilogPrimeParser.Indexed_rangeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvar_expression}.
	 * @param ctx the parse tree
	 */
	void enterGenvar_expression(VerilogPrimeParser.Genvar_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvar_expression}.
	 * @param ctx the parse tree
	 */
	void exitGenvar_expression(VerilogPrimeParser.Genvar_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_primary}.
	 * @param ctx the parse tree
	 */
	void enterConstant_primary(VerilogPrimeParser.Constant_primaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_primary}.
	 * @param ctx the parse tree
	 */
	void exitConstant_primary(VerilogPrimeParser.Constant_primaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_path_primary}.
	 * @param ctx the parse tree
	 */
	void enterModule_path_primary(VerilogPrimeParser.Module_path_primaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_path_primary}.
	 * @param ctx the parse tree
	 */
	void exitModule_path_primary(VerilogPrimeParser.Module_path_primaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#primary_no_function_call}.
	 * @param ctx the parse tree
	 */
	void enterPrimary_no_function_call(VerilogPrimeParser.Primary_no_function_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#primary_no_function_call}.
	 * @param ctx the parse tree
	 */
	void exitPrimary_no_function_call(VerilogPrimeParser.Primary_no_function_callContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#primary}.
	 * @param ctx the parse tree
	 */
	void enterPrimary(VerilogPrimeParser.PrimaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#primary}.
	 * @param ctx the parse tree
	 */
	void exitPrimary(VerilogPrimeParser.PrimaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_qualifier}.
	 * @param ctx the parse tree
	 */
	void enterClass_qualifier(VerilogPrimeParser.Class_qualifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_qualifier}.
	 * @param ctx the parse tree
	 */
	void exitClass_qualifier(VerilogPrimeParser.Class_qualifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#range_expression}.
	 * @param ctx the parse tree
	 */
	void enterRange_expression(VerilogPrimeParser.Range_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#range_expression}.
	 * @param ctx the parse tree
	 */
	void exitRange_expression(VerilogPrimeParser.Range_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#primary_literal}.
	 * @param ctx the parse tree
	 */
	void enterPrimary_literal(VerilogPrimeParser.Primary_literalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#primary_literal}.
	 * @param ctx the parse tree
	 */
	void exitPrimary_literal(VerilogPrimeParser.Primary_literalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#time_literal}.
	 * @param ctx the parse tree
	 */
	void enterTime_literal(VerilogPrimeParser.Time_literalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#time_literal}.
	 * @param ctx the parse tree
	 */
	void exitTime_literal(VerilogPrimeParser.Time_literalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#implicit_class_handle}.
	 * @param ctx the parse tree
	 */
	void enterImplicit_class_handle(VerilogPrimeParser.Implicit_class_handleContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#implicit_class_handle}.
	 * @param ctx the parse tree
	 */
	void exitImplicit_class_handle(VerilogPrimeParser.Implicit_class_handleContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bit_select}.
	 * @param ctx the parse tree
	 */
	void enterBit_select(VerilogPrimeParser.Bit_selectContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bit_select}.
	 * @param ctx the parse tree
	 */
	void exitBit_select(VerilogPrimeParser.Bit_selectContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#select}.
	 * @param ctx the parse tree
	 */
	void enterSelect(VerilogPrimeParser.SelectContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#select}.
	 * @param ctx the parse tree
	 */
	void exitSelect(VerilogPrimeParser.SelectContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nonrange_select}.
	 * @param ctx the parse tree
	 */
	void enterNonrange_select(VerilogPrimeParser.Nonrange_selectContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nonrange_select}.
	 * @param ctx the parse tree
	 */
	void exitNonrange_select(VerilogPrimeParser.Nonrange_selectContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_bit_select}.
	 * @param ctx the parse tree
	 */
	void enterConstant_bit_select(VerilogPrimeParser.Constant_bit_selectContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_bit_select}.
	 * @param ctx the parse tree
	 */
	void exitConstant_bit_select(VerilogPrimeParser.Constant_bit_selectContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_select}.
	 * @param ctx the parse tree
	 */
	void enterConstant_select(VerilogPrimeParser.Constant_selectContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_select}.
	 * @param ctx the parse tree
	 */
	void exitConstant_select(VerilogPrimeParser.Constant_selectContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_cast}.
	 * @param ctx the parse tree
	 */
	void enterConstant_cast(VerilogPrimeParser.Constant_castContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_cast}.
	 * @param ctx the parse tree
	 */
	void exitConstant_cast(VerilogPrimeParser.Constant_castContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constant_let_expression}.
	 * @param ctx the parse tree
	 */
	void enterConstant_let_expression(VerilogPrimeParser.Constant_let_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constant_let_expression}.
	 * @param ctx the parse tree
	 */
	void exitConstant_let_expression(VerilogPrimeParser.Constant_let_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cast}.
	 * @param ctx the parse tree
	 */
	void enterCast(VerilogPrimeParser.CastContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cast}.
	 * @param ctx the parse tree
	 */
	void exitCast(VerilogPrimeParser.CastContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_lvalue}.
	 * @param ctx the parse tree
	 */
	void enterNet_lvalue(VerilogPrimeParser.Net_lvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_lvalue}.
	 * @param ctx the parse tree
	 */
	void exitNet_lvalue(VerilogPrimeParser.Net_lvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void enterVariable_lvalue(VerilogPrimeParser.Variable_lvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void exitVariable_lvalue(VerilogPrimeParser.Variable_lvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nonrange_variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void enterNonrange_variable_lvalue(VerilogPrimeParser.Nonrange_variable_lvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nonrange_variable_lvalue}.
	 * @param ctx the parse tree
	 */
	void exitNonrange_variable_lvalue(VerilogPrimeParser.Nonrange_variable_lvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unary_operator}.
	 * @param ctx the parse tree
	 */
	void enterUnary_operator(VerilogPrimeParser.Unary_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unary_operator}.
	 * @param ctx the parse tree
	 */
	void exitUnary_operator(VerilogPrimeParser.Unary_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#binary_operator}.
	 * @param ctx the parse tree
	 */
	void enterBinary_operator(VerilogPrimeParser.Binary_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#binary_operator}.
	 * @param ctx the parse tree
	 */
	void exitBinary_operator(VerilogPrimeParser.Binary_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_operator}.
	 * @param ctx the parse tree
	 */
	void enterInc_or_dec_operator(VerilogPrimeParser.Inc_or_dec_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_operator}.
	 * @param ctx the parse tree
	 */
	void exitInc_or_dec_operator(VerilogPrimeParser.Inc_or_dec_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#increment}.
	 * @param ctx the parse tree
	 */
	void enterIncrement(VerilogPrimeParser.IncrementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#increment}.
	 * @param ctx the parse tree
	 */
	void exitIncrement(VerilogPrimeParser.IncrementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#decrement}.
	 * @param ctx the parse tree
	 */
	void enterDecrement(VerilogPrimeParser.DecrementContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#decrement}.
	 * @param ctx the parse tree
	 */
	void exitDecrement(VerilogPrimeParser.DecrementContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unary_module_path_operator}.
	 * @param ctx the parse tree
	 */
	void enterUnary_module_path_operator(VerilogPrimeParser.Unary_module_path_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unary_module_path_operator}.
	 * @param ctx the parse tree
	 */
	void exitUnary_module_path_operator(VerilogPrimeParser.Unary_module_path_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#binary_module_path_operator}.
	 * @param ctx the parse tree
	 */
	void enterBinary_module_path_operator(VerilogPrimeParser.Binary_module_path_operatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#binary_module_path_operator}.
	 * @param ctx the parse tree
	 */
	void exitBinary_module_path_operator(VerilogPrimeParser.Binary_module_path_operatorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unbased_unsized_literal}.
	 * @param ctx the parse tree
	 */
	void enterUnbased_unsized_literal(VerilogPrimeParser.Unbased_unsized_literalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unbased_unsized_literal}.
	 * @param ctx the parse tree
	 */
	void exitUnbased_unsized_literal(VerilogPrimeParser.Unbased_unsized_literalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#string_literal}.
	 * @param ctx the parse tree
	 */
	void enterString_literal(VerilogPrimeParser.String_literalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#string_literal}.
	 * @param ctx the parse tree
	 */
	void exitString_literal(VerilogPrimeParser.String_literalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attribute_instance}.
	 * @param ctx the parse tree
	 */
	void enterAttribute_instance(VerilogPrimeParser.Attribute_instanceContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attribute_instance}.
	 * @param ctx the parse tree
	 */
	void exitAttribute_instance(VerilogPrimeParser.Attribute_instanceContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attr_spec}.
	 * @param ctx the parse tree
	 */
	void enterAttr_spec(VerilogPrimeParser.Attr_specContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attr_spec}.
	 * @param ctx the parse tree
	 */
	void exitAttr_spec(VerilogPrimeParser.Attr_specContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attr_name}.
	 * @param ctx the parse tree
	 */
	void enterAttr_name(VerilogPrimeParser.Attr_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attr_name}.
	 * @param ctx the parse tree
	 */
	void exitAttr_name(VerilogPrimeParser.Attr_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#array_identifier}.
	 * @param ctx the parse tree
	 */
	void enterArray_identifier(VerilogPrimeParser.Array_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#array_identifier}.
	 * @param ctx the parse tree
	 */
	void exitArray_identifier(VerilogPrimeParser.Array_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#block_identifier}.
	 * @param ctx the parse tree
	 */
	void enterBlock_identifier(VerilogPrimeParser.Block_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#block_identifier}.
	 * @param ctx the parse tree
	 */
	void exitBlock_identifier(VerilogPrimeParser.Block_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bin_identifier}.
	 * @param ctx the parse tree
	 */
	void enterBin_identifier(VerilogPrimeParser.Bin_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bin_identifier}.
	 * @param ctx the parse tree
	 */
	void exitBin_identifier(VerilogPrimeParser.Bin_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#c_identifier}.
	 * @param ctx the parse tree
	 */
	void enterC_identifier(VerilogPrimeParser.C_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#c_identifier}.
	 * @param ctx the parse tree
	 */
	void exitC_identifier(VerilogPrimeParser.C_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cell_identifier}.
	 * @param ctx the parse tree
	 */
	void enterCell_identifier(VerilogPrimeParser.Cell_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cell_identifier}.
	 * @param ctx the parse tree
	 */
	void exitCell_identifier(VerilogPrimeParser.Cell_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checker_identifier}.
	 * @param ctx the parse tree
	 */
	void enterChecker_identifier(VerilogPrimeParser.Checker_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checker_identifier}.
	 * @param ctx the parse tree
	 */
	void exitChecker_identifier(VerilogPrimeParser.Checker_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_identifier}.
	 * @param ctx the parse tree
	 */
	void enterClass_identifier(VerilogPrimeParser.Class_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_identifier}.
	 * @param ctx the parse tree
	 */
	void exitClass_identifier(VerilogPrimeParser.Class_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#class_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterClass_variable_identifier(VerilogPrimeParser.Class_variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#class_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitClass_variable_identifier(VerilogPrimeParser.Class_variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clocking_identifier}.
	 * @param ctx the parse tree
	 */
	void enterClocking_identifier(VerilogPrimeParser.Clocking_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clocking_identifier}.
	 * @param ctx the parse tree
	 */
	void exitClocking_identifier(VerilogPrimeParser.Clocking_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#config_identifier}.
	 * @param ctx the parse tree
	 */
	void enterConfig_identifier(VerilogPrimeParser.Config_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#config_identifier}.
	 * @param ctx the parse tree
	 */
	void exitConfig_identifier(VerilogPrimeParser.Config_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#const_identifier}.
	 * @param ctx the parse tree
	 */
	void enterConst_identifier(VerilogPrimeParser.Const_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#const_identifier}.
	 * @param ctx the parse tree
	 */
	void exitConst_identifier(VerilogPrimeParser.Const_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraint_identifier}.
	 * @param ctx the parse tree
	 */
	void enterConstraint_identifier(VerilogPrimeParser.Constraint_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraint_identifier}.
	 * @param ctx the parse tree
	 */
	void exitConstraint_identifier(VerilogPrimeParser.Constraint_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#covergroup_identifier}.
	 * @param ctx the parse tree
	 */
	void enterCovergroup_identifier(VerilogPrimeParser.Covergroup_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#covergroup_identifier}.
	 * @param ctx the parse tree
	 */
	void exitCovergroup_identifier(VerilogPrimeParser.Covergroup_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#covergroup_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterCovergroup_variable_identifier(VerilogPrimeParser.Covergroup_variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#covergroup_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitCovergroup_variable_identifier(VerilogPrimeParser.Covergroup_variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cover_point_identifier}.
	 * @param ctx the parse tree
	 */
	void enterCover_point_identifier(VerilogPrimeParser.Cover_point_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cover_point_identifier}.
	 * @param ctx the parse tree
	 */
	void exitCover_point_identifier(VerilogPrimeParser.Cover_point_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cross_identifier}.
	 * @param ctx the parse tree
	 */
	void enterCross_identifier(VerilogPrimeParser.Cross_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cross_identifier}.
	 * @param ctx the parse tree
	 */
	void exitCross_identifier(VerilogPrimeParser.Cross_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dynamic_array_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterDynamic_array_variable_identifier(VerilogPrimeParser.Dynamic_array_variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dynamic_array_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitDynamic_array_variable_identifier(VerilogPrimeParser.Dynamic_array_variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enum_identifier}.
	 * @param ctx the parse tree
	 */
	void enterEnum_identifier(VerilogPrimeParser.Enum_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enum_identifier}.
	 * @param ctx the parse tree
	 */
	void exitEnum_identifier(VerilogPrimeParser.Enum_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#escaped_identifier}.
	 * @param ctx the parse tree
	 */
	void enterEscaped_identifier(VerilogPrimeParser.Escaped_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#escaped_identifier}.
	 * @param ctx the parse tree
	 */
	void exitEscaped_identifier(VerilogPrimeParser.Escaped_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#formal_identifier}.
	 * @param ctx the parse tree
	 */
	void enterFormal_identifier(VerilogPrimeParser.Formal_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#formal_identifier}.
	 * @param ctx the parse tree
	 */
	void exitFormal_identifier(VerilogPrimeParser.Formal_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#function_identifier}.
	 * @param ctx the parse tree
	 */
	void enterFunction_identifier(VerilogPrimeParser.Function_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#function_identifier}.
	 * @param ctx the parse tree
	 */
	void exitFunction_identifier(VerilogPrimeParser.Function_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generate_block_identifier}.
	 * @param ctx the parse tree
	 */
	void enterGenerate_block_identifier(VerilogPrimeParser.Generate_block_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generate_block_identifier}.
	 * @param ctx the parse tree
	 */
	void exitGenerate_block_identifier(VerilogPrimeParser.Generate_block_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvar_identifier}.
	 * @param ctx the parse tree
	 */
	void enterGenvar_identifier(VerilogPrimeParser.Genvar_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvar_identifier}.
	 * @param ctx the parse tree
	 */
	void exitGenvar_identifier(VerilogPrimeParser.Genvar_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_array_identifier(VerilogPrimeParser.Hierarchical_array_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_array_identifier(VerilogPrimeParser.Hierarchical_array_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_block_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_block_identifier(VerilogPrimeParser.Hierarchical_block_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_block_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_block_identifier(VerilogPrimeParser.Hierarchical_block_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_event_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_event_identifier(VerilogPrimeParser.Hierarchical_event_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_event_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_event_identifier(VerilogPrimeParser.Hierarchical_event_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_identifier(VerilogPrimeParser.Hierarchical_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_identifier(VerilogPrimeParser.Hierarchical_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_net_identifier(VerilogPrimeParser.Hierarchical_net_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_net_identifier(VerilogPrimeParser.Hierarchical_net_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_parameter_identifier(VerilogPrimeParser.Hierarchical_parameter_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_parameter_identifier(VerilogPrimeParser.Hierarchical_parameter_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_property_identifier(VerilogPrimeParser.Hierarchical_property_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_property_identifier(VerilogPrimeParser.Hierarchical_property_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_sequence_identifier(VerilogPrimeParser.Hierarchical_sequence_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_sequence_identifier(VerilogPrimeParser.Hierarchical_sequence_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_task_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_task_identifier(VerilogPrimeParser.Hierarchical_task_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_task_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_task_identifier(VerilogPrimeParser.Hierarchical_task_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_tf_identifier(VerilogPrimeParser.Hierarchical_tf_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_tf_identifier(VerilogPrimeParser.Hierarchical_tf_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hierarchical_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterHierarchical_variable_identifier(VerilogPrimeParser.Hierarchical_variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hierarchical_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitHierarchical_variable_identifier(VerilogPrimeParser.Hierarchical_variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#identifier}.
	 * @param ctx the parse tree
	 */
	void enterIdentifier(VerilogPrimeParser.IdentifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#identifier}.
	 * @param ctx the parse tree
	 */
	void exitIdentifier(VerilogPrimeParser.IdentifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#index_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterIndex_variable_identifier(VerilogPrimeParser.Index_variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#index_variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitIndex_variable_identifier(VerilogPrimeParser.Index_variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInterface_identifier(VerilogPrimeParser.Interface_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInterface_identifier(VerilogPrimeParser.Interface_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interface_instance_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInterface_instance_identifier(VerilogPrimeParser.Interface_instance_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interface_instance_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInterface_instance_identifier(VerilogPrimeParser.Interface_instance_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inout_port_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInout_port_identifier(VerilogPrimeParser.Inout_port_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inout_port_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInout_port_identifier(VerilogPrimeParser.Inout_port_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#input_port_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInput_port_identifier(VerilogPrimeParser.Input_port_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#input_port_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInput_port_identifier(VerilogPrimeParser.Input_port_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#instance_identifier}.
	 * @param ctx the parse tree
	 */
	void enterInstance_identifier(VerilogPrimeParser.Instance_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#instance_identifier}.
	 * @param ctx the parse tree
	 */
	void exitInstance_identifier(VerilogPrimeParser.Instance_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#library_identifier}.
	 * @param ctx the parse tree
	 */
	void enterLibrary_identifier(VerilogPrimeParser.Library_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#library_identifier}.
	 * @param ctx the parse tree
	 */
	void exitLibrary_identifier(VerilogPrimeParser.Library_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#member_identifier}.
	 * @param ctx the parse tree
	 */
	void enterMember_identifier(VerilogPrimeParser.Member_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#member_identifier}.
	 * @param ctx the parse tree
	 */
	void exitMember_identifier(VerilogPrimeParser.Member_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#method_identifier}.
	 * @param ctx the parse tree
	 */
	void enterMethod_identifier(VerilogPrimeParser.Method_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#method_identifier}.
	 * @param ctx the parse tree
	 */
	void exitMethod_identifier(VerilogPrimeParser.Method_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modport_identifier}.
	 * @param ctx the parse tree
	 */
	void enterModport_identifier(VerilogPrimeParser.Modport_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modport_identifier}.
	 * @param ctx the parse tree
	 */
	void exitModport_identifier(VerilogPrimeParser.Modport_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#module_identifier}.
	 * @param ctx the parse tree
	 */
	void enterModule_identifier(VerilogPrimeParser.Module_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#module_identifier}.
	 * @param ctx the parse tree
	 */
	void exitModule_identifier(VerilogPrimeParser.Module_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#net_identifier}.
	 * @param ctx the parse tree
	 */
	void enterNet_identifier(VerilogPrimeParser.Net_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#net_identifier}.
	 * @param ctx the parse tree
	 */
	void exitNet_identifier(VerilogPrimeParser.Net_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#output_port_identifier}.
	 * @param ctx the parse tree
	 */
	void enterOutput_port_identifier(VerilogPrimeParser.Output_port_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#output_port_identifier}.
	 * @param ctx the parse tree
	 */
	void exitOutput_port_identifier(VerilogPrimeParser.Output_port_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPackage_identifier(VerilogPrimeParser.Package_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPackage_identifier(VerilogPrimeParser.Package_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#package_scope}.
	 * @param ctx the parse tree
	 */
	void enterPackage_scope(VerilogPrimeParser.Package_scopeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#package_scope}.
	 * @param ctx the parse tree
	 */
	void exitPackage_scope(VerilogPrimeParser.Package_scopeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void enterParameter_identifier(VerilogPrimeParser.Parameter_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void exitParameter_identifier(VerilogPrimeParser.Parameter_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#port_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPort_identifier(VerilogPrimeParser.Port_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#port_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPort_identifier(VerilogPrimeParser.Port_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#production_identifier}.
	 * @param ctx the parse tree
	 */
	void enterProduction_identifier(VerilogPrimeParser.Production_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#production_identifier}.
	 * @param ctx the parse tree
	 */
	void exitProduction_identifier(VerilogPrimeParser.Production_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#program_identifier}.
	 * @param ctx the parse tree
	 */
	void enterProgram_identifier(VerilogPrimeParser.Program_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#program_identifier}.
	 * @param ctx the parse tree
	 */
	void exitProgram_identifier(VerilogPrimeParser.Program_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#property_identifier}.
	 * @param ctx the parse tree
	 */
	void enterProperty_identifier(VerilogPrimeParser.Property_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#property_identifier}.
	 * @param ctx the parse tree
	 */
	void exitProperty_identifier(VerilogPrimeParser.Property_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_class_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_class_identifier(VerilogPrimeParser.Ps_class_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_class_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_class_identifier(VerilogPrimeParser.Ps_class_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_covergroup_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_covergroup_identifier(VerilogPrimeParser.Ps_covergroup_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_covergroup_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_covergroup_identifier(VerilogPrimeParser.Ps_covergroup_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_identifier(VerilogPrimeParser.Ps_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_identifier(VerilogPrimeParser.Ps_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_array_identifier(VerilogPrimeParser.Ps_or_hierarchical_array_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_array_identifier(VerilogPrimeParser.Ps_or_hierarchical_array_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier_part1}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_array_identifier_part1(VerilogPrimeParser.Ps_or_hierarchical_array_identifier_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier_part1}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_array_identifier_part1(VerilogPrimeParser.Ps_or_hierarchical_array_identifier_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_net_identifier(VerilogPrimeParser.Ps_or_hierarchical_net_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_net_identifier(VerilogPrimeParser.Ps_or_hierarchical_net_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_property_identifier(VerilogPrimeParser.Ps_or_hierarchical_property_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_property_identifier(VerilogPrimeParser.Ps_or_hierarchical_property_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_sequence_identifier(VerilogPrimeParser.Ps_or_hierarchical_sequence_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_sequence_identifier(VerilogPrimeParser.Ps_or_hierarchical_sequence_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_or_hierarchical_tf_identifier(VerilogPrimeParser.Ps_or_hierarchical_tf_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_or_hierarchical_tf_identifier(VerilogPrimeParser.Ps_or_hierarchical_tf_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_parameter_identifier(VerilogPrimeParser.Ps_parameter_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_parameter_identifier(VerilogPrimeParser.Ps_parameter_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier_part1}.
	 * @param ctx the parse tree
	 */
	void enterPs_parameter_identifier_part1(VerilogPrimeParser.Ps_parameter_identifier_part1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier_part1}.
	 * @param ctx the parse tree
	 */
	void exitPs_parameter_identifier_part1(VerilogPrimeParser.Ps_parameter_identifier_part1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ps_type_identifier}.
	 * @param ctx the parse tree
	 */
	void enterPs_type_identifier(VerilogPrimeParser.Ps_type_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ps_type_identifier}.
	 * @param ctx the parse tree
	 */
	void exitPs_type_identifier(VerilogPrimeParser.Ps_type_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSequence_identifier(VerilogPrimeParser.Sequence_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequence_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSequence_identifier(VerilogPrimeParser.Sequence_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#signal_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSignal_identifier(VerilogPrimeParser.Signal_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#signal_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSignal_identifier(VerilogPrimeParser.Signal_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#simple_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSimple_identifier(VerilogPrimeParser.Simple_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#simple_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSimple_identifier(VerilogPrimeParser.Simple_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specparam_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSpecparam_identifier(VerilogPrimeParser.Specparam_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specparam_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSpecparam_identifier(VerilogPrimeParser.Specparam_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#system_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void enterSystem_tf_identifier(VerilogPrimeParser.System_tf_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#system_tf_identifier}.
	 * @param ctx the parse tree
	 */
	void exitSystem_tf_identifier(VerilogPrimeParser.System_tf_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#task_identifier}.
	 * @param ctx the parse tree
	 */
	void enterTask_identifier(VerilogPrimeParser.Task_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#task_identifier}.
	 * @param ctx the parse tree
	 */
	void exitTask_identifier(VerilogPrimeParser.Task_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_identifier}.
	 * @param ctx the parse tree
	 */
	void enterTf_identifier(VerilogPrimeParser.Tf_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_identifier}.
	 * @param ctx the parse tree
	 */
	void exitTf_identifier(VerilogPrimeParser.Tf_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#terminal_identifier}.
	 * @param ctx the parse tree
	 */
	void enterTerminal_identifier(VerilogPrimeParser.Terminal_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#terminal_identifier}.
	 * @param ctx the parse tree
	 */
	void exitTerminal_identifier(VerilogPrimeParser.Terminal_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#topmodule_identifier}.
	 * @param ctx the parse tree
	 */
	void enterTopmodule_identifier(VerilogPrimeParser.Topmodule_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#topmodule_identifier}.
	 * @param ctx the parse tree
	 */
	void exitTopmodule_identifier(VerilogPrimeParser.Topmodule_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#type_identifier}.
	 * @param ctx the parse tree
	 */
	void enterType_identifier(VerilogPrimeParser.Type_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#type_identifier}.
	 * @param ctx the parse tree
	 */
	void exitType_identifier(VerilogPrimeParser.Type_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#udp_identifier}.
	 * @param ctx the parse tree
	 */
	void enterUdp_identifier(VerilogPrimeParser.Udp_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#udp_identifier}.
	 * @param ctx the parse tree
	 */
	void exitUdp_identifier(VerilogPrimeParser.Udp_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bins_identifier}.
	 * @param ctx the parse tree
	 */
	void enterBins_identifier(VerilogPrimeParser.Bins_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bins_identifier}.
	 * @param ctx the parse tree
	 */
	void exitBins_identifier(VerilogPrimeParser.Bins_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#variable_identifier}.
	 * @param ctx the parse tree
	 */
	void enterVariable_identifier(VerilogPrimeParser.Variable_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#variable_identifier}.
	 * @param ctx the parse tree
	 */
	void exitVariable_identifier(VerilogPrimeParser.Variable_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#number}.
	 * @param ctx the parse tree
	 */
	void enterNumber(VerilogPrimeParser.NumberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#number}.
	 * @param ctx the parse tree
	 */
	void exitNumber(VerilogPrimeParser.NumberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#eof}.
	 * @param ctx the parse tree
	 */
	void enterEof(VerilogPrimeParser.EofContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#eof}.
	 * @param ctx the parse tree
	 */
	void exitEof(VerilogPrimeParser.EofContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endmodulestr}.
	 * @param ctx the parse tree
	 */
	void enterEndmodulestr(VerilogPrimeParser.EndmodulestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endmodulestr}.
	 * @param ctx the parse tree
	 */
	void exitEndmodulestr(VerilogPrimeParser.EndmodulestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#colon}.
	 * @param ctx the parse tree
	 */
	void enterColon(VerilogPrimeParser.ColonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#colon}.
	 * @param ctx the parse tree
	 */
	void exitColon(VerilogPrimeParser.ColonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#externstr}.
	 * @param ctx the parse tree
	 */
	void enterExternstr(VerilogPrimeParser.ExternstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#externstr}.
	 * @param ctx the parse tree
	 */
	void exitExternstr(VerilogPrimeParser.ExternstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#semi}.
	 * @param ctx the parse tree
	 */
	void enterSemi(VerilogPrimeParser.SemiContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#semi}.
	 * @param ctx the parse tree
	 */
	void exitSemi(VerilogPrimeParser.SemiContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modulestr}.
	 * @param ctx the parse tree
	 */
	void enterModulestr(VerilogPrimeParser.ModulestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modulestr}.
	 * @param ctx the parse tree
	 */
	void exitModulestr(VerilogPrimeParser.ModulestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#macromodulestr}.
	 * @param ctx the parse tree
	 */
	void enterMacromodulestr(VerilogPrimeParser.MacromodulestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#macromodulestr}.
	 * @param ctx the parse tree
	 */
	void exitMacromodulestr(VerilogPrimeParser.MacromodulestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endinterfacestr}.
	 * @param ctx the parse tree
	 */
	void enterEndinterfacestr(VerilogPrimeParser.EndinterfacestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endinterfacestr}.
	 * @param ctx the parse tree
	 */
	void exitEndinterfacestr(VerilogPrimeParser.EndinterfacestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#interfacestr}.
	 * @param ctx the parse tree
	 */
	void enterInterfacestr(VerilogPrimeParser.InterfacestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#interfacestr}.
	 * @param ctx the parse tree
	 */
	void exitInterfacestr(VerilogPrimeParser.InterfacestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lparen}.
	 * @param ctx the parse tree
	 */
	void enterLparen(VerilogPrimeParser.LparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lparen}.
	 * @param ctx the parse tree
	 */
	void exitLparen(VerilogPrimeParser.LparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dotstar}.
	 * @param ctx the parse tree
	 */
	void enterDotstar(VerilogPrimeParser.DotstarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dotstar}.
	 * @param ctx the parse tree
	 */
	void exitDotstar(VerilogPrimeParser.DotstarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rparen}.
	 * @param ctx the parse tree
	 */
	void enterRparen(VerilogPrimeParser.RparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rparen}.
	 * @param ctx the parse tree
	 */
	void exitRparen(VerilogPrimeParser.RparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endprogramstr}.
	 * @param ctx the parse tree
	 */
	void enterEndprogramstr(VerilogPrimeParser.EndprogramstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endprogramstr}.
	 * @param ctx the parse tree
	 */
	void exitEndprogramstr(VerilogPrimeParser.EndprogramstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#programstr}.
	 * @param ctx the parse tree
	 */
	void enterProgramstr(VerilogPrimeParser.ProgramstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#programstr}.
	 * @param ctx the parse tree
	 */
	void exitProgramstr(VerilogPrimeParser.ProgramstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#checkerstr}.
	 * @param ctx the parse tree
	 */
	void enterCheckerstr(VerilogPrimeParser.CheckerstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#checkerstr}.
	 * @param ctx the parse tree
	 */
	void exitCheckerstr(VerilogPrimeParser.CheckerstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endcheckerstr}.
	 * @param ctx the parse tree
	 */
	void enterEndcheckerstr(VerilogPrimeParser.EndcheckerstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endcheckerstr}.
	 * @param ctx the parse tree
	 */
	void exitEndcheckerstr(VerilogPrimeParser.EndcheckerstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#virtualstr}.
	 * @param ctx the parse tree
	 */
	void enterVirtualstr(VerilogPrimeParser.VirtualstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#virtualstr}.
	 * @param ctx the parse tree
	 */
	void exitVirtualstr(VerilogPrimeParser.VirtualstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#classstr}.
	 * @param ctx the parse tree
	 */
	void enterClassstr(VerilogPrimeParser.ClassstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#classstr}.
	 * @param ctx the parse tree
	 */
	void exitClassstr(VerilogPrimeParser.ClassstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#extendsstr}.
	 * @param ctx the parse tree
	 */
	void enterExtendsstr(VerilogPrimeParser.ExtendsstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#extendsstr}.
	 * @param ctx the parse tree
	 */
	void exitExtendsstr(VerilogPrimeParser.ExtendsstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endclassstr}.
	 * @param ctx the parse tree
	 */
	void enterEndclassstr(VerilogPrimeParser.EndclassstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endclassstr}.
	 * @param ctx the parse tree
	 */
	void exitEndclassstr(VerilogPrimeParser.EndclassstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#packagestr}.
	 * @param ctx the parse tree
	 */
	void enterPackagestr(VerilogPrimeParser.PackagestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#packagestr}.
	 * @param ctx the parse tree
	 */
	void exitPackagestr(VerilogPrimeParser.PackagestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endpackagestr}.
	 * @param ctx the parse tree
	 */
	void enterEndpackagestr(VerilogPrimeParser.EndpackagestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endpackagestr}.
	 * @param ctx the parse tree
	 */
	void exitEndpackagestr(VerilogPrimeParser.EndpackagestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timeunit}.
	 * @param ctx the parse tree
	 */
	void enterTimeunit(VerilogPrimeParser.TimeunitContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timeunit}.
	 * @param ctx the parse tree
	 */
	void exitTimeunit(VerilogPrimeParser.TimeunitContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#div}.
	 * @param ctx the parse tree
	 */
	void enterDiv(VerilogPrimeParser.DivContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#div}.
	 * @param ctx the parse tree
	 */
	void exitDiv(VerilogPrimeParser.DivContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hash}.
	 * @param ctx the parse tree
	 */
	void enterHash(VerilogPrimeParser.HashContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hash}.
	 * @param ctx the parse tree
	 */
	void exitHash(VerilogPrimeParser.HashContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#comma}.
	 * @param ctx the parse tree
	 */
	void enterComma(VerilogPrimeParser.CommaContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#comma}.
	 * @param ctx the parse tree
	 */
	void exitComma(VerilogPrimeParser.CommaContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#typestr}.
	 * @param ctx the parse tree
	 */
	void enterTypestr(VerilogPrimeParser.TypestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#typestr}.
	 * @param ctx the parse tree
	 */
	void exitTypestr(VerilogPrimeParser.TypestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dot}.
	 * @param ctx the parse tree
	 */
	void enterDot(VerilogPrimeParser.DotContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dot}.
	 * @param ctx the parse tree
	 */
	void exitDot(VerilogPrimeParser.DotContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lcurl}.
	 * @param ctx the parse tree
	 */
	void enterLcurl(VerilogPrimeParser.LcurlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lcurl}.
	 * @param ctx the parse tree
	 */
	void exitLcurl(VerilogPrimeParser.LcurlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rcurl}.
	 * @param ctx the parse tree
	 */
	void enterRcurl(VerilogPrimeParser.RcurlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rcurl}.
	 * @param ctx the parse tree
	 */
	void exitRcurl(VerilogPrimeParser.RcurlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inputstr}.
	 * @param ctx the parse tree
	 */
	void enterInputstr(VerilogPrimeParser.InputstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inputstr}.
	 * @param ctx the parse tree
	 */
	void exitInputstr(VerilogPrimeParser.InputstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#outputstr}.
	 * @param ctx the parse tree
	 */
	void enterOutputstr(VerilogPrimeParser.OutputstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#outputstr}.
	 * @param ctx the parse tree
	 */
	void exitOutputstr(VerilogPrimeParser.OutputstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#inoutstr}.
	 * @param ctx the parse tree
	 */
	void enterInoutstr(VerilogPrimeParser.InoutstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#inoutstr}.
	 * @param ctx the parse tree
	 */
	void exitInoutstr(VerilogPrimeParser.InoutstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#refstr}.
	 * @param ctx the parse tree
	 */
	void enterRefstr(VerilogPrimeParser.RefstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#refstr}.
	 * @param ctx the parse tree
	 */
	void exitRefstr(VerilogPrimeParser.RefstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assign}.
	 * @param ctx the parse tree
	 */
	void enterAssign(VerilogPrimeParser.AssignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assign}.
	 * @param ctx the parse tree
	 */
	void exitAssign(VerilogPrimeParser.AssignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarfatalstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarfatalstr(VerilogPrimeParser.DollarfatalstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarfatalstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarfatalstr(VerilogPrimeParser.DollarfatalstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarerrorstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarerrorstr(VerilogPrimeParser.DollarerrorstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarerrorstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarerrorstr(VerilogPrimeParser.DollarerrorstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarwarningstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarwarningstr(VerilogPrimeParser.DollarwarningstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarwarningstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarwarningstr(VerilogPrimeParser.DollarwarningstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarinfostr}.
	 * @param ctx the parse tree
	 */
	void enterDollarinfostr(VerilogPrimeParser.DollarinfostrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarinfostr}.
	 * @param ctx the parse tree
	 */
	void exitDollarinfostr(VerilogPrimeParser.DollarinfostrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#defparamstr}.
	 * @param ctx the parse tree
	 */
	void enterDefparamstr(VerilogPrimeParser.DefparamstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#defparamstr}.
	 * @param ctx the parse tree
	 */
	void exitDefparamstr(VerilogPrimeParser.DefparamstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bindstr}.
	 * @param ctx the parse tree
	 */
	void enterBindstr(VerilogPrimeParser.BindstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bindstr}.
	 * @param ctx the parse tree
	 */
	void exitBindstr(VerilogPrimeParser.BindstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#configstr}.
	 * @param ctx the parse tree
	 */
	void enterConfigstr(VerilogPrimeParser.ConfigstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#configstr}.
	 * @param ctx the parse tree
	 */
	void exitConfigstr(VerilogPrimeParser.ConfigstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endconfigstr}.
	 * @param ctx the parse tree
	 */
	void enterEndconfigstr(VerilogPrimeParser.EndconfigstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endconfigstr}.
	 * @param ctx the parse tree
	 */
	void exitEndconfigstr(VerilogPrimeParser.EndconfigstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#designstr}.
	 * @param ctx the parse tree
	 */
	void enterDesignstr(VerilogPrimeParser.DesignstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#designstr}.
	 * @param ctx the parse tree
	 */
	void exitDesignstr(VerilogPrimeParser.DesignstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#defaultstr}.
	 * @param ctx the parse tree
	 */
	void enterDefaultstr(VerilogPrimeParser.DefaultstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#defaultstr}.
	 * @param ctx the parse tree
	 */
	void exitDefaultstr(VerilogPrimeParser.DefaultstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#instancestr}.
	 * @param ctx the parse tree
	 */
	void enterInstancestr(VerilogPrimeParser.InstancestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#instancestr}.
	 * @param ctx the parse tree
	 */
	void exitInstancestr(VerilogPrimeParser.InstancestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cellstr}.
	 * @param ctx the parse tree
	 */
	void enterCellstr(VerilogPrimeParser.CellstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cellstr}.
	 * @param ctx the parse tree
	 */
	void exitCellstr(VerilogPrimeParser.CellstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#libliststr}.
	 * @param ctx the parse tree
	 */
	void enterLibliststr(VerilogPrimeParser.LibliststrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#libliststr}.
	 * @param ctx the parse tree
	 */
	void exitLibliststr(VerilogPrimeParser.LibliststrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#usestr}.
	 * @param ctx the parse tree
	 */
	void enterUsestr(VerilogPrimeParser.UsestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#usestr}.
	 * @param ctx the parse tree
	 */
	void exitUsestr(VerilogPrimeParser.UsestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#clockingstr}.
	 * @param ctx the parse tree
	 */
	void enterClockingstr(VerilogPrimeParser.ClockingstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#clockingstr}.
	 * @param ctx the parse tree
	 */
	void exitClockingstr(VerilogPrimeParser.ClockingstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#disablestr}.
	 * @param ctx the parse tree
	 */
	void enterDisablestr(VerilogPrimeParser.DisablestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#disablestr}.
	 * @param ctx the parse tree
	 */
	void exitDisablestr(VerilogPrimeParser.DisablestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#iffstr}.
	 * @param ctx the parse tree
	 */
	void enterIffstr(VerilogPrimeParser.IffstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#iffstr}.
	 * @param ctx the parse tree
	 */
	void exitIffstr(VerilogPrimeParser.IffstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#forkjoinstr}.
	 * @param ctx the parse tree
	 */
	void enterForkjoinstr(VerilogPrimeParser.ForkjoinstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#forkjoinstr}.
	 * @param ctx the parse tree
	 */
	void exitForkjoinstr(VerilogPrimeParser.ForkjoinstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#alwaysstr}.
	 * @param ctx the parse tree
	 */
	void enterAlwaysstr(VerilogPrimeParser.AlwaysstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#alwaysstr}.
	 * @param ctx the parse tree
	 */
	void exitAlwaysstr(VerilogPrimeParser.AlwaysstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#conststr}.
	 * @param ctx the parse tree
	 */
	void enterConststr(VerilogPrimeParser.ConststrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#conststr}.
	 * @param ctx the parse tree
	 */
	void exitConststr(VerilogPrimeParser.ConststrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#functionstr}.
	 * @param ctx the parse tree
	 */
	void enterFunctionstr(VerilogPrimeParser.FunctionstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#functionstr}.
	 * @param ctx the parse tree
	 */
	void exitFunctionstr(VerilogPrimeParser.FunctionstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#newstr}.
	 * @param ctx the parse tree
	 */
	void enterNewstr(VerilogPrimeParser.NewstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#newstr}.
	 * @param ctx the parse tree
	 */
	void exitNewstr(VerilogPrimeParser.NewstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#staticstr}.
	 * @param ctx the parse tree
	 */
	void enterStaticstr(VerilogPrimeParser.StaticstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#staticstr}.
	 * @param ctx the parse tree
	 */
	void exitStaticstr(VerilogPrimeParser.StaticstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#protectedstr}.
	 * @param ctx the parse tree
	 */
	void enterProtectedstr(VerilogPrimeParser.ProtectedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#protectedstr}.
	 * @param ctx the parse tree
	 */
	void exitProtectedstr(VerilogPrimeParser.ProtectedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#localstr}.
	 * @param ctx the parse tree
	 */
	void enterLocalstr(VerilogPrimeParser.LocalstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#localstr}.
	 * @param ctx the parse tree
	 */
	void exitLocalstr(VerilogPrimeParser.LocalstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randstr}.
	 * @param ctx the parse tree
	 */
	void enterRandstr(VerilogPrimeParser.RandstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randstr}.
	 * @param ctx the parse tree
	 */
	void exitRandstr(VerilogPrimeParser.RandstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randcstr}.
	 * @param ctx the parse tree
	 */
	void enterRandcstr(VerilogPrimeParser.RandcstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randcstr}.
	 * @param ctx the parse tree
	 */
	void exitRandcstr(VerilogPrimeParser.RandcstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#purestr}.
	 * @param ctx the parse tree
	 */
	void enterPurestr(VerilogPrimeParser.PurestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#purestr}.
	 * @param ctx the parse tree
	 */
	void exitPurestr(VerilogPrimeParser.PurestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#superstr}.
	 * @param ctx the parse tree
	 */
	void enterSuperstr(VerilogPrimeParser.SuperstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#superstr}.
	 * @param ctx the parse tree
	 */
	void exitSuperstr(VerilogPrimeParser.SuperstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endfunctionstr}.
	 * @param ctx the parse tree
	 */
	void enterEndfunctionstr(VerilogPrimeParser.EndfunctionstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endfunctionstr}.
	 * @param ctx the parse tree
	 */
	void exitEndfunctionstr(VerilogPrimeParser.EndfunctionstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#constraintstr}.
	 * @param ctx the parse tree
	 */
	void enterConstraintstr(VerilogPrimeParser.ConstraintstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#constraintstr}.
	 * @param ctx the parse tree
	 */
	void exitConstraintstr(VerilogPrimeParser.ConstraintstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#solvestr}.
	 * @param ctx the parse tree
	 */
	void enterSolvestr(VerilogPrimeParser.SolvestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#solvestr}.
	 * @param ctx the parse tree
	 */
	void exitSolvestr(VerilogPrimeParser.SolvestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#beforestr}.
	 * @param ctx the parse tree
	 */
	void enterBeforestr(VerilogPrimeParser.BeforestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#beforestr}.
	 * @param ctx the parse tree
	 */
	void exitBeforestr(VerilogPrimeParser.BeforestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#derive}.
	 * @param ctx the parse tree
	 */
	void enterDerive(VerilogPrimeParser.DeriveContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#derive}.
	 * @param ctx the parse tree
	 */
	void exitDerive(VerilogPrimeParser.DeriveContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ifstr}.
	 * @param ctx the parse tree
	 */
	void enterIfstr(VerilogPrimeParser.IfstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ifstr}.
	 * @param ctx the parse tree
	 */
	void exitIfstr(VerilogPrimeParser.IfstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#elsestr}.
	 * @param ctx the parse tree
	 */
	void enterElsestr(VerilogPrimeParser.ElsestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#elsestr}.
	 * @param ctx the parse tree
	 */
	void exitElsestr(VerilogPrimeParser.ElsestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#foreachstr}.
	 * @param ctx the parse tree
	 */
	void enterForeachstr(VerilogPrimeParser.ForeachstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#foreachstr}.
	 * @param ctx the parse tree
	 */
	void exitForeachstr(VerilogPrimeParser.ForeachstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lbrack}.
	 * @param ctx the parse tree
	 */
	void enterLbrack(VerilogPrimeParser.LbrackContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lbrack}.
	 * @param ctx the parse tree
	 */
	void exitLbrack(VerilogPrimeParser.LbrackContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rbrack}.
	 * @param ctx the parse tree
	 */
	void enterRbrack(VerilogPrimeParser.RbrackContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rbrack}.
	 * @param ctx the parse tree
	 */
	void exitRbrack(VerilogPrimeParser.RbrackContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#colonequals}.
	 * @param ctx the parse tree
	 */
	void enterColonequals(VerilogPrimeParser.ColonequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#colonequals}.
	 * @param ctx the parse tree
	 */
	void exitColonequals(VerilogPrimeParser.ColonequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#colonslash}.
	 * @param ctx the parse tree
	 */
	void enterColonslash(VerilogPrimeParser.ColonslashContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#colonslash}.
	 * @param ctx the parse tree
	 */
	void exitColonslash(VerilogPrimeParser.ColonslashContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#localparamstr}.
	 * @param ctx the parse tree
	 */
	void enterLocalparamstr(VerilogPrimeParser.LocalparamstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#localparamstr}.
	 * @param ctx the parse tree
	 */
	void exitLocalparamstr(VerilogPrimeParser.LocalparamstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#parameterstr}.
	 * @param ctx the parse tree
	 */
	void enterParameterstr(VerilogPrimeParser.ParameterstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#parameterstr}.
	 * @param ctx the parse tree
	 */
	void exitParameterstr(VerilogPrimeParser.ParameterstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specparamstr}.
	 * @param ctx the parse tree
	 */
	void enterSpecparamstr(VerilogPrimeParser.SpecparamstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specparamstr}.
	 * @param ctx the parse tree
	 */
	void exitSpecparamstr(VerilogPrimeParser.SpecparamstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#varstr}.
	 * @param ctx the parse tree
	 */
	void enterVarstr(VerilogPrimeParser.VarstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#varstr}.
	 * @param ctx the parse tree
	 */
	void exitVarstr(VerilogPrimeParser.VarstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#importstr}.
	 * @param ctx the parse tree
	 */
	void enterImportstr(VerilogPrimeParser.ImportstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#importstr}.
	 * @param ctx the parse tree
	 */
	void exitImportstr(VerilogPrimeParser.ImportstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coloncolon}.
	 * @param ctx the parse tree
	 */
	void enterColoncolon(VerilogPrimeParser.ColoncolonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coloncolon}.
	 * @param ctx the parse tree
	 */
	void exitColoncolon(VerilogPrimeParser.ColoncolonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#star}.
	 * @param ctx the parse tree
	 */
	void enterStar(VerilogPrimeParser.StarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#star}.
	 * @param ctx the parse tree
	 */
	void exitStar(VerilogPrimeParser.StarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#export}.
	 * @param ctx the parse tree
	 */
	void enterExport(VerilogPrimeParser.ExportContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#export}.
	 * @param ctx the parse tree
	 */
	void exitExport(VerilogPrimeParser.ExportContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#startcoloncolonstar}.
	 * @param ctx the parse tree
	 */
	void enterStartcoloncolonstar(VerilogPrimeParser.StartcoloncolonstarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#startcoloncolonstar}.
	 * @param ctx the parse tree
	 */
	void exitStartcoloncolonstar(VerilogPrimeParser.StartcoloncolonstarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#genvarstr}.
	 * @param ctx the parse tree
	 */
	void enterGenvarstr(VerilogPrimeParser.GenvarstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#genvarstr}.
	 * @param ctx the parse tree
	 */
	void exitGenvarstr(VerilogPrimeParser.GenvarstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#vectoredstr}.
	 * @param ctx the parse tree
	 */
	void enterVectoredstr(VerilogPrimeParser.VectoredstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#vectoredstr}.
	 * @param ctx the parse tree
	 */
	void exitVectoredstr(VerilogPrimeParser.VectoredstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#scalaredstr}.
	 * @param ctx the parse tree
	 */
	void enterScalaredstr(VerilogPrimeParser.ScalaredstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#scalaredstr}.
	 * @param ctx the parse tree
	 */
	void exitScalaredstr(VerilogPrimeParser.ScalaredstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#typedefstr}.
	 * @param ctx the parse tree
	 */
	void enterTypedefstr(VerilogPrimeParser.TypedefstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#typedefstr}.
	 * @param ctx the parse tree
	 */
	void exitTypedefstr(VerilogPrimeParser.TypedefstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#enumstr}.
	 * @param ctx the parse tree
	 */
	void enterEnumstr(VerilogPrimeParser.EnumstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#enumstr}.
	 * @param ctx the parse tree
	 */
	void exitEnumstr(VerilogPrimeParser.EnumstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#structstr}.
	 * @param ctx the parse tree
	 */
	void enterStructstr(VerilogPrimeParser.StructstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#structstr}.
	 * @param ctx the parse tree
	 */
	void exitStructstr(VerilogPrimeParser.StructstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unionstr}.
	 * @param ctx the parse tree
	 */
	void enterUnionstr(VerilogPrimeParser.UnionstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unionstr}.
	 * @param ctx the parse tree
	 */
	void exitUnionstr(VerilogPrimeParser.UnionstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#automaticstr}.
	 * @param ctx the parse tree
	 */
	void enterAutomaticstr(VerilogPrimeParser.AutomaticstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#automaticstr}.
	 * @param ctx the parse tree
	 */
	void exitAutomaticstr(VerilogPrimeParser.AutomaticstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stringstr}.
	 * @param ctx the parse tree
	 */
	void enterStringstr(VerilogPrimeParser.StringstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stringstr}.
	 * @param ctx the parse tree
	 */
	void exitStringstr(VerilogPrimeParser.StringstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#packedstr}.
	 * @param ctx the parse tree
	 */
	void enterPackedstr(VerilogPrimeParser.PackedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#packedstr}.
	 * @param ctx the parse tree
	 */
	void exitPackedstr(VerilogPrimeParser.PackedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#chandlestr}.
	 * @param ctx the parse tree
	 */
	void enterChandlestr(VerilogPrimeParser.ChandlestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#chandlestr}.
	 * @param ctx the parse tree
	 */
	void exitChandlestr(VerilogPrimeParser.ChandlestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#eventstr}.
	 * @param ctx the parse tree
	 */
	void enterEventstr(VerilogPrimeParser.EventstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#eventstr}.
	 * @param ctx the parse tree
	 */
	void exitEventstr(VerilogPrimeParser.EventstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#zero_or_one}.
	 * @param ctx the parse tree
	 */
	void enterZero_or_one(VerilogPrimeParser.Zero_or_oneContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#zero_or_one}.
	 * @param ctx the parse tree
	 */
	void exitZero_or_one(VerilogPrimeParser.Zero_or_oneContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edge_spec}.
	 * @param ctx the parse tree
	 */
	void enterEdge_spec(VerilogPrimeParser.Edge_specContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edge_spec}.
	 * @param ctx the parse tree
	 */
	void exitEdge_spec(VerilogPrimeParser.Edge_specContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#decimal_number}.
	 * @param ctx the parse tree
	 */
	void enterDecimal_number(VerilogPrimeParser.Decimal_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#decimal_number}.
	 * @param ctx the parse tree
	 */
	void exitDecimal_number(VerilogPrimeParser.Decimal_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bytestr}.
	 * @param ctx the parse tree
	 */
	void enterBytestr(VerilogPrimeParser.BytestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bytestr}.
	 * @param ctx the parse tree
	 */
	void exitBytestr(VerilogPrimeParser.BytestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#shortintstr}.
	 * @param ctx the parse tree
	 */
	void enterShortintstr(VerilogPrimeParser.ShortintstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#shortintstr}.
	 * @param ctx the parse tree
	 */
	void exitShortintstr(VerilogPrimeParser.ShortintstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#intstr}.
	 * @param ctx the parse tree
	 */
	void enterIntstr(VerilogPrimeParser.IntstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#intstr}.
	 * @param ctx the parse tree
	 */
	void exitIntstr(VerilogPrimeParser.IntstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#longintstr}.
	 * @param ctx the parse tree
	 */
	void enterLongintstr(VerilogPrimeParser.LongintstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#longintstr}.
	 * @param ctx the parse tree
	 */
	void exitLongintstr(VerilogPrimeParser.LongintstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#integerstr}.
	 * @param ctx the parse tree
	 */
	void enterIntegerstr(VerilogPrimeParser.IntegerstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#integerstr}.
	 * @param ctx the parse tree
	 */
	void exitIntegerstr(VerilogPrimeParser.IntegerstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#timestr}.
	 * @param ctx the parse tree
	 */
	void enterTimestr(VerilogPrimeParser.TimestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#timestr}.
	 * @param ctx the parse tree
	 */
	void exitTimestr(VerilogPrimeParser.TimestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bitstr}.
	 * @param ctx the parse tree
	 */
	void enterBitstr(VerilogPrimeParser.BitstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bitstr}.
	 * @param ctx the parse tree
	 */
	void exitBitstr(VerilogPrimeParser.BitstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#logicstr}.
	 * @param ctx the parse tree
	 */
	void enterLogicstr(VerilogPrimeParser.LogicstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#logicstr}.
	 * @param ctx the parse tree
	 */
	void exitLogicstr(VerilogPrimeParser.LogicstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#regstr}.
	 * @param ctx the parse tree
	 */
	void enterRegstr(VerilogPrimeParser.RegstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#regstr}.
	 * @param ctx the parse tree
	 */
	void exitRegstr(VerilogPrimeParser.RegstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#shortreal}.
	 * @param ctx the parse tree
	 */
	void enterShortreal(VerilogPrimeParser.ShortrealContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#shortreal}.
	 * @param ctx the parse tree
	 */
	void exitShortreal(VerilogPrimeParser.ShortrealContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#realstr}.
	 * @param ctx the parse tree
	 */
	void enterRealstr(VerilogPrimeParser.RealstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#realstr}.
	 * @param ctx the parse tree
	 */
	void exitRealstr(VerilogPrimeParser.RealstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#realtimestr}.
	 * @param ctx the parse tree
	 */
	void enterRealtimestr(VerilogPrimeParser.RealtimestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#realtimestr}.
	 * @param ctx the parse tree
	 */
	void exitRealtimestr(VerilogPrimeParser.RealtimestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#supply0str}.
	 * @param ctx the parse tree
	 */
	void enterSupply0str(VerilogPrimeParser.Supply0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#supply0str}.
	 * @param ctx the parse tree
	 */
	void exitSupply0str(VerilogPrimeParser.Supply0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#supply1str}.
	 * @param ctx the parse tree
	 */
	void enterSupply1str(VerilogPrimeParser.Supply1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#supply1str}.
	 * @param ctx the parse tree
	 */
	void exitSupply1str(VerilogPrimeParser.Supply1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tristr}.
	 * @param ctx the parse tree
	 */
	void enterTristr(VerilogPrimeParser.TristrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tristr}.
	 * @param ctx the parse tree
	 */
	void exitTristr(VerilogPrimeParser.TristrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#triandstr}.
	 * @param ctx the parse tree
	 */
	void enterTriandstr(VerilogPrimeParser.TriandstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#triandstr}.
	 * @param ctx the parse tree
	 */
	void exitTriandstr(VerilogPrimeParser.TriandstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#triorstr}.
	 * @param ctx the parse tree
	 */
	void enterTriorstr(VerilogPrimeParser.TriorstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#triorstr}.
	 * @param ctx the parse tree
	 */
	void exitTriorstr(VerilogPrimeParser.TriorstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#triregstr}.
	 * @param ctx the parse tree
	 */
	void enterTriregstr(VerilogPrimeParser.TriregstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#triregstr}.
	 * @param ctx the parse tree
	 */
	void exitTriregstr(VerilogPrimeParser.TriregstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tri0str}.
	 * @param ctx the parse tree
	 */
	void enterTri0str(VerilogPrimeParser.Tri0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tri0str}.
	 * @param ctx the parse tree
	 */
	void exitTri0str(VerilogPrimeParser.Tri0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tri1str}.
	 * @param ctx the parse tree
	 */
	void enterTri1str(VerilogPrimeParser.Tri1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tri1str}.
	 * @param ctx the parse tree
	 */
	void exitTri1str(VerilogPrimeParser.Tri1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#uwirestr}.
	 * @param ctx the parse tree
	 */
	void enterUwirestr(VerilogPrimeParser.UwirestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#uwirestr}.
	 * @param ctx the parse tree
	 */
	void exitUwirestr(VerilogPrimeParser.UwirestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#wirestr}.
	 * @param ctx the parse tree
	 */
	void enterWirestr(VerilogPrimeParser.WirestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#wirestr}.
	 * @param ctx the parse tree
	 */
	void exitWirestr(VerilogPrimeParser.WirestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#wandstr}.
	 * @param ctx the parse tree
	 */
	void enterWandstr(VerilogPrimeParser.WandstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#wandstr}.
	 * @param ctx the parse tree
	 */
	void exitWandstr(VerilogPrimeParser.WandstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#worstr}.
	 * @param ctx the parse tree
	 */
	void enterWorstr(VerilogPrimeParser.WorstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#worstr}.
	 * @param ctx the parse tree
	 */
	void exitWorstr(VerilogPrimeParser.WorstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#signedstr}.
	 * @param ctx the parse tree
	 */
	void enterSignedstr(VerilogPrimeParser.SignedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#signedstr}.
	 * @param ctx the parse tree
	 */
	void exitSignedstr(VerilogPrimeParser.SignedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unsignedstr}.
	 * @param ctx the parse tree
	 */
	void enterUnsignedstr(VerilogPrimeParser.UnsignedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unsignedstr}.
	 * @param ctx the parse tree
	 */
	void exitUnsignedstr(VerilogPrimeParser.UnsignedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#voidstr}.
	 * @param ctx the parse tree
	 */
	void enterVoidstr(VerilogPrimeParser.VoidstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#voidstr}.
	 * @param ctx the parse tree
	 */
	void exitVoidstr(VerilogPrimeParser.VoidstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#taggedstr}.
	 * @param ctx the parse tree
	 */
	void enterTaggedstr(VerilogPrimeParser.TaggedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#taggedstr}.
	 * @param ctx the parse tree
	 */
	void exitTaggedstr(VerilogPrimeParser.TaggedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#highz1str}.
	 * @param ctx the parse tree
	 */
	void enterHighz1str(VerilogPrimeParser.Highz1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#highz1str}.
	 * @param ctx the parse tree
	 */
	void exitHighz1str(VerilogPrimeParser.Highz1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#highz0str}.
	 * @param ctx the parse tree
	 */
	void enterHighz0str(VerilogPrimeParser.Highz0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#highz0str}.
	 * @param ctx the parse tree
	 */
	void exitHighz0str(VerilogPrimeParser.Highz0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#strong0}.
	 * @param ctx the parse tree
	 */
	void enterStrong0(VerilogPrimeParser.Strong0Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#strong0}.
	 * @param ctx the parse tree
	 */
	void exitStrong0(VerilogPrimeParser.Strong0Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pull0str}.
	 * @param ctx the parse tree
	 */
	void enterPull0str(VerilogPrimeParser.Pull0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pull0str}.
	 * @param ctx the parse tree
	 */
	void exitPull0str(VerilogPrimeParser.Pull0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#weak0str}.
	 * @param ctx the parse tree
	 */
	void enterWeak0str(VerilogPrimeParser.Weak0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#weak0str}.
	 * @param ctx the parse tree
	 */
	void exitWeak0str(VerilogPrimeParser.Weak0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#strong1}.
	 * @param ctx the parse tree
	 */
	void enterStrong1(VerilogPrimeParser.Strong1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#strong1}.
	 * @param ctx the parse tree
	 */
	void exitStrong1(VerilogPrimeParser.Strong1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pull1str}.
	 * @param ctx the parse tree
	 */
	void enterPull1str(VerilogPrimeParser.Pull1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pull1str}.
	 * @param ctx the parse tree
	 */
	void exitPull1str(VerilogPrimeParser.Pull1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#weak1str}.
	 * @param ctx the parse tree
	 */
	void enterWeak1str(VerilogPrimeParser.Weak1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#weak1str}.
	 * @param ctx the parse tree
	 */
	void exitWeak1str(VerilogPrimeParser.Weak1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#smallstr}.
	 * @param ctx the parse tree
	 */
	void enterSmallstr(VerilogPrimeParser.SmallstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#smallstr}.
	 * @param ctx the parse tree
	 */
	void exitSmallstr(VerilogPrimeParser.SmallstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#mediumstr}.
	 * @param ctx the parse tree
	 */
	void enterMediumstr(VerilogPrimeParser.MediumstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#mediumstr}.
	 * @param ctx the parse tree
	 */
	void exitMediumstr(VerilogPrimeParser.MediumstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#largestr}.
	 * @param ctx the parse tree
	 */
	void enterLargestr(VerilogPrimeParser.LargestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#largestr}.
	 * @param ctx the parse tree
	 */
	void exitLargestr(VerilogPrimeParser.LargestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#real_number}.
	 * @param ctx the parse tree
	 */
	void enterReal_number(VerilogPrimeParser.Real_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#real_number}.
	 * @param ctx the parse tree
	 */
	void exitReal_number(VerilogPrimeParser.Real_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#onestepstr}.
	 * @param ctx the parse tree
	 */
	void enterOnestepstr(VerilogPrimeParser.OnestepstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#onestepstr}.
	 * @param ctx the parse tree
	 */
	void exitOnestepstr(VerilogPrimeParser.OnestepstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pathpulsedollar}.
	 * @param ctx the parse tree
	 */
	void enterPathpulsedollar(VerilogPrimeParser.PathpulsedollarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pathpulsedollar}.
	 * @param ctx the parse tree
	 */
	void exitPathpulsedollar(VerilogPrimeParser.PathpulsedollarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollar}.
	 * @param ctx the parse tree
	 */
	void enterDollar(VerilogPrimeParser.DollarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollar}.
	 * @param ctx the parse tree
	 */
	void exitDollar(VerilogPrimeParser.DollarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#taskstr}.
	 * @param ctx the parse tree
	 */
	void enterTaskstr(VerilogPrimeParser.TaskstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#taskstr}.
	 * @param ctx the parse tree
	 */
	void exitTaskstr(VerilogPrimeParser.TaskstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing2str}.
	 * @param ctx the parse tree
	 */
	void enterDpi_spec_ing2str(VerilogPrimeParser.Dpi_spec_ing2strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing2str}.
	 * @param ctx the parse tree
	 */
	void exitDpi_spec_ing2str(VerilogPrimeParser.Dpi_spec_ing2strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing1str}.
	 * @param ctx the parse tree
	 */
	void enterDpi_spec_ing1str(VerilogPrimeParser.Dpi_spec_ing1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing1str}.
	 * @param ctx the parse tree
	 */
	void exitDpi_spec_ing1str(VerilogPrimeParser.Dpi_spec_ing1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#contextstr}.
	 * @param ctx the parse tree
	 */
	void enterContextstr(VerilogPrimeParser.ContextstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#contextstr}.
	 * @param ctx the parse tree
	 */
	void exitContextstr(VerilogPrimeParser.ContextstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endtaskstr}.
	 * @param ctx the parse tree
	 */
	void enterEndtaskstr(VerilogPrimeParser.EndtaskstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endtaskstr}.
	 * @param ctx the parse tree
	 */
	void exitEndtaskstr(VerilogPrimeParser.EndtaskstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#plus}.
	 * @param ctx the parse tree
	 */
	void enterPlus(VerilogPrimeParser.PlusContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#plus}.
	 * @param ctx the parse tree
	 */
	void exitPlus(VerilogPrimeParser.PlusContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#minus}.
	 * @param ctx the parse tree
	 */
	void enterMinus(VerilogPrimeParser.MinusContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#minus}.
	 * @param ctx the parse tree
	 */
	void exitMinus(VerilogPrimeParser.MinusContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#starstar}.
	 * @param ctx the parse tree
	 */
	void enterStarstar(VerilogPrimeParser.StarstarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#starstar}.
	 * @param ctx the parse tree
	 */
	void exitStarstar(VerilogPrimeParser.StarstarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modulo}.
	 * @param ctx the parse tree
	 */
	void enterModulo(VerilogPrimeParser.ModuloContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modulo}.
	 * @param ctx the parse tree
	 */
	void exitModulo(VerilogPrimeParser.ModuloContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#equals}.
	 * @param ctx the parse tree
	 */
	void enterEquals(VerilogPrimeParser.EqualsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#equals}.
	 * @param ctx the parse tree
	 */
	void exitEquals(VerilogPrimeParser.EqualsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#not_equals}.
	 * @param ctx the parse tree
	 */
	void enterNot_equals(VerilogPrimeParser.Not_equalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#not_equals}.
	 * @param ctx the parse tree
	 */
	void exitNot_equals(VerilogPrimeParser.Not_equalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lt}.
	 * @param ctx the parse tree
	 */
	void enterLt(VerilogPrimeParser.LtContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lt}.
	 * @param ctx the parse tree
	 */
	void exitLt(VerilogPrimeParser.LtContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#le}.
	 * @param ctx the parse tree
	 */
	void enterLe(VerilogPrimeParser.LeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#le}.
	 * @param ctx the parse tree
	 */
	void exitLe(VerilogPrimeParser.LeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#gt}.
	 * @param ctx the parse tree
	 */
	void enterGt(VerilogPrimeParser.GtContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#gt}.
	 * @param ctx the parse tree
	 */
	void exitGt(VerilogPrimeParser.GtContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ge}.
	 * @param ctx the parse tree
	 */
	void enterGe(VerilogPrimeParser.GeContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ge}.
	 * @param ctx the parse tree
	 */
	void exitGe(VerilogPrimeParser.GeContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#modportstr}.
	 * @param ctx the parse tree
	 */
	void enterModportstr(VerilogPrimeParser.ModportstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#modportstr}.
	 * @param ctx the parse tree
	 */
	void exitModportstr(VerilogPrimeParser.ModportstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assertstr}.
	 * @param ctx the parse tree
	 */
	void enterAssertstr(VerilogPrimeParser.AssertstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assertstr}.
	 * @param ctx the parse tree
	 */
	void exitAssertstr(VerilogPrimeParser.AssertstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#propertystr}.
	 * @param ctx the parse tree
	 */
	void enterPropertystr(VerilogPrimeParser.PropertystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#propertystr}.
	 * @param ctx the parse tree
	 */
	void exitPropertystr(VerilogPrimeParser.PropertystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assumestr}.
	 * @param ctx the parse tree
	 */
	void enterAssumestr(VerilogPrimeParser.AssumestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assumestr}.
	 * @param ctx the parse tree
	 */
	void exitAssumestr(VerilogPrimeParser.AssumestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverstr}.
	 * @param ctx the parse tree
	 */
	void enterCoverstr(VerilogPrimeParser.CoverstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverstr}.
	 * @param ctx the parse tree
	 */
	void exitCoverstr(VerilogPrimeParser.CoverstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#expectstr}.
	 * @param ctx the parse tree
	 */
	void enterExpectstr(VerilogPrimeParser.ExpectstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#expectstr}.
	 * @param ctx the parse tree
	 */
	void exitExpectstr(VerilogPrimeParser.ExpectstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#sequencestr}.
	 * @param ctx the parse tree
	 */
	void enterSequencestr(VerilogPrimeParser.SequencestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#sequencestr}.
	 * @param ctx the parse tree
	 */
	void exitSequencestr(VerilogPrimeParser.SequencestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#restrictstr}.
	 * @param ctx the parse tree
	 */
	void enterRestrictstr(VerilogPrimeParser.RestrictstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#restrictstr}.
	 * @param ctx the parse tree
	 */
	void exitRestrictstr(VerilogPrimeParser.RestrictstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endpropertystr}.
	 * @param ctx the parse tree
	 */
	void enterEndpropertystr(VerilogPrimeParser.EndpropertystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endpropertystr}.
	 * @param ctx the parse tree
	 */
	void exitEndpropertystr(VerilogPrimeParser.EndpropertystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#casestr}.
	 * @param ctx the parse tree
	 */
	void enterCasestr(VerilogPrimeParser.CasestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#casestr}.
	 * @param ctx the parse tree
	 */
	void exitCasestr(VerilogPrimeParser.CasestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endcasestr}.
	 * @param ctx the parse tree
	 */
	void enterEndcasestr(VerilogPrimeParser.EndcasestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endcasestr}.
	 * @param ctx the parse tree
	 */
	void exitEndcasestr(VerilogPrimeParser.EndcasestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#notstr}.
	 * @param ctx the parse tree
	 */
	void enterNotstr(VerilogPrimeParser.NotstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#notstr}.
	 * @param ctx the parse tree
	 */
	void exitNotstr(VerilogPrimeParser.NotstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#orstr}.
	 * @param ctx the parse tree
	 */
	void enterOrstr(VerilogPrimeParser.OrstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#orstr}.
	 * @param ctx the parse tree
	 */
	void exitOrstr(VerilogPrimeParser.OrstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#andstr}.
	 * @param ctx the parse tree
	 */
	void enterAndstr(VerilogPrimeParser.AndstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#andstr}.
	 * @param ctx the parse tree
	 */
	void exitAndstr(VerilogPrimeParser.AndstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#orderive}.
	 * @param ctx the parse tree
	 */
	void enterOrderive(VerilogPrimeParser.OrderiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#orderive}.
	 * @param ctx the parse tree
	 */
	void exitOrderive(VerilogPrimeParser.OrderiveContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#orimplies}.
	 * @param ctx the parse tree
	 */
	void enterOrimplies(VerilogPrimeParser.OrimpliesContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#orimplies}.
	 * @param ctx the parse tree
	 */
	void exitOrimplies(VerilogPrimeParser.OrimpliesContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endsequencestr}.
	 * @param ctx the parse tree
	 */
	void enterEndsequencestr(VerilogPrimeParser.EndsequencestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endsequencestr}.
	 * @param ctx the parse tree
	 */
	void exitEndsequencestr(VerilogPrimeParser.EndsequencestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#untypedstr}.
	 * @param ctx the parse tree
	 */
	void enterUntypedstr(VerilogPrimeParser.UntypedstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#untypedstr}.
	 * @param ctx the parse tree
	 */
	void exitUntypedstr(VerilogPrimeParser.UntypedstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#intersectstr}.
	 * @param ctx the parse tree
	 */
	void enterIntersectstr(VerilogPrimeParser.IntersectstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#intersectstr}.
	 * @param ctx the parse tree
	 */
	void exitIntersectstr(VerilogPrimeParser.IntersectstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#first_matchstr}.
	 * @param ctx the parse tree
	 */
	void enterFirst_matchstr(VerilogPrimeParser.First_matchstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#first_matchstr}.
	 * @param ctx the parse tree
	 */
	void exitFirst_matchstr(VerilogPrimeParser.First_matchstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#throughoutstr}.
	 * @param ctx the parse tree
	 */
	void enterThroughoutstr(VerilogPrimeParser.ThroughoutstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#throughoutstr}.
	 * @param ctx the parse tree
	 */
	void exitThroughoutstr(VerilogPrimeParser.ThroughoutstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#withinstr}.
	 * @param ctx the parse tree
	 */
	void enterWithinstr(VerilogPrimeParser.WithinstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#withinstr}.
	 * @param ctx the parse tree
	 */
	void exitWithinstr(VerilogPrimeParser.WithinstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#double_hash}.
	 * @param ctx the parse tree
	 */
	void enterDouble_hash(VerilogPrimeParser.Double_hashContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#double_hash}.
	 * @param ctx the parse tree
	 */
	void exitDouble_hash(VerilogPrimeParser.Double_hashContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#diststr}.
	 * @param ctx the parse tree
	 */
	void enterDiststr(VerilogPrimeParser.DiststrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#diststr}.
	 * @param ctx the parse tree
	 */
	void exitDiststr(VerilogPrimeParser.DiststrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#letstr}.
	 * @param ctx the parse tree
	 */
	void enterLetstr(VerilogPrimeParser.LetstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#letstr}.
	 * @param ctx the parse tree
	 */
	void exitLetstr(VerilogPrimeParser.LetstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#covergroupstr}.
	 * @param ctx the parse tree
	 */
	void enterCovergroupstr(VerilogPrimeParser.CovergroupstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#covergroupstr}.
	 * @param ctx the parse tree
	 */
	void exitCovergroupstr(VerilogPrimeParser.CovergroupstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endgroupstr}.
	 * @param ctx the parse tree
	 */
	void enterEndgroupstr(VerilogPrimeParser.EndgroupstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endgroupstr}.
	 * @param ctx the parse tree
	 */
	void exitEndgroupstr(VerilogPrimeParser.EndgroupstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#optiondot}.
	 * @param ctx the parse tree
	 */
	void enterOptiondot(VerilogPrimeParser.OptiondotContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#optiondot}.
	 * @param ctx the parse tree
	 */
	void exitOptiondot(VerilogPrimeParser.OptiondotContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#type_optiondot}.
	 * @param ctx the parse tree
	 */
	void enterType_optiondot(VerilogPrimeParser.Type_optiondotContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#type_optiondot}.
	 * @param ctx the parse tree
	 */
	void exitType_optiondot(VerilogPrimeParser.Type_optiondotContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#withstr}.
	 * @param ctx the parse tree
	 */
	void enterWithstr(VerilogPrimeParser.WithstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#withstr}.
	 * @param ctx the parse tree
	 */
	void exitWithstr(VerilogPrimeParser.WithstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#samplestr}.
	 * @param ctx the parse tree
	 */
	void enterSamplestr(VerilogPrimeParser.SamplestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#samplestr}.
	 * @param ctx the parse tree
	 */
	void exitSamplestr(VerilogPrimeParser.SamplestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attheratelparen}.
	 * @param ctx the parse tree
	 */
	void enterAttheratelparen(VerilogPrimeParser.AttheratelparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attheratelparen}.
	 * @param ctx the parse tree
	 */
	void exitAttheratelparen(VerilogPrimeParser.AttheratelparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#beginstr}.
	 * @param ctx the parse tree
	 */
	void enterBeginstr(VerilogPrimeParser.BeginstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#beginstr}.
	 * @param ctx the parse tree
	 */
	void exitBeginstr(VerilogPrimeParser.BeginstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endstr}.
	 * @param ctx the parse tree
	 */
	void enterEndstr(VerilogPrimeParser.EndstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endstr}.
	 * @param ctx the parse tree
	 */
	void exitEndstr(VerilogPrimeParser.EndstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#coverpointstr}.
	 * @param ctx the parse tree
	 */
	void enterCoverpointstr(VerilogPrimeParser.CoverpointstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#coverpointstr}.
	 * @param ctx the parse tree
	 */
	void exitCoverpointstr(VerilogPrimeParser.CoverpointstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#wildcardstr}.
	 * @param ctx the parse tree
	 */
	void enterWildcardstr(VerilogPrimeParser.WildcardstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#wildcardstr}.
	 * @param ctx the parse tree
	 */
	void exitWildcardstr(VerilogPrimeParser.WildcardstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#binsstr}.
	 * @param ctx the parse tree
	 */
	void enterBinsstr(VerilogPrimeParser.BinsstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#binsstr}.
	 * @param ctx the parse tree
	 */
	void exitBinsstr(VerilogPrimeParser.BinsstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#illegal_binsstr}.
	 * @param ctx the parse tree
	 */
	void enterIllegal_binsstr(VerilogPrimeParser.Illegal_binsstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#illegal_binsstr}.
	 * @param ctx the parse tree
	 */
	void exitIllegal_binsstr(VerilogPrimeParser.Illegal_binsstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ignore_binsstr}.
	 * @param ctx the parse tree
	 */
	void enterIgnore_binsstr(VerilogPrimeParser.Ignore_binsstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ignore_binsstr}.
	 * @param ctx the parse tree
	 */
	void exitIgnore_binsstr(VerilogPrimeParser.Ignore_binsstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#implies}.
	 * @param ctx the parse tree
	 */
	void enterImplies(VerilogPrimeParser.ImpliesContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#implies}.
	 * @param ctx the parse tree
	 */
	void exitImplies(VerilogPrimeParser.ImpliesContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#crossstr}.
	 * @param ctx the parse tree
	 */
	void enterCrossstr(VerilogPrimeParser.CrossstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#crossstr}.
	 * @param ctx the parse tree
	 */
	void exitCrossstr(VerilogPrimeParser.CrossstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#not}.
	 * @param ctx the parse tree
	 */
	void enterNot(VerilogPrimeParser.NotContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#not}.
	 * @param ctx the parse tree
	 */
	void exitNot(VerilogPrimeParser.NotContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#log_and}.
	 * @param ctx the parse tree
	 */
	void enterLog_and(VerilogPrimeParser.Log_andContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#log_and}.
	 * @param ctx the parse tree
	 */
	void exitLog_and(VerilogPrimeParser.Log_andContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#log_or}.
	 * @param ctx the parse tree
	 */
	void enterLog_or(VerilogPrimeParser.Log_orContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#log_or}.
	 * @param ctx the parse tree
	 */
	void exitLog_or(VerilogPrimeParser.Log_orContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#binsofstr}.
	 * @param ctx the parse tree
	 */
	void enterBinsofstr(VerilogPrimeParser.BinsofstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#binsofstr}.
	 * @param ctx the parse tree
	 */
	void exitBinsofstr(VerilogPrimeParser.BinsofstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulldownstr}.
	 * @param ctx the parse tree
	 */
	void enterPulldownstr(VerilogPrimeParser.PulldownstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulldownstr}.
	 * @param ctx the parse tree
	 */
	void exitPulldownstr(VerilogPrimeParser.PulldownstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pullupstr}.
	 * @param ctx the parse tree
	 */
	void enterPullupstr(VerilogPrimeParser.PullupstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pullupstr}.
	 * @param ctx the parse tree
	 */
	void exitPullupstr(VerilogPrimeParser.PullupstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#cmosstr}.
	 * @param ctx the parse tree
	 */
	void enterCmosstr(VerilogPrimeParser.CmosstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#cmosstr}.
	 * @param ctx the parse tree
	 */
	void exitCmosstr(VerilogPrimeParser.CmosstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rcmosstr}.
	 * @param ctx the parse tree
	 */
	void enterRcmosstr(VerilogPrimeParser.RcmosstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rcmosstr}.
	 * @param ctx the parse tree
	 */
	void exitRcmosstr(VerilogPrimeParser.RcmosstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bufif0str}.
	 * @param ctx the parse tree
	 */
	void enterBufif0str(VerilogPrimeParser.Bufif0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bufif0str}.
	 * @param ctx the parse tree
	 */
	void exitBufif0str(VerilogPrimeParser.Bufif0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bufif1str}.
	 * @param ctx the parse tree
	 */
	void enterBufif1str(VerilogPrimeParser.Bufif1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bufif1str}.
	 * @param ctx the parse tree
	 */
	void exitBufif1str(VerilogPrimeParser.Bufif1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#notif0str}.
	 * @param ctx the parse tree
	 */
	void enterNotif0str(VerilogPrimeParser.Notif0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#notif0str}.
	 * @param ctx the parse tree
	 */
	void exitNotif0str(VerilogPrimeParser.Notif0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#notif1str}.
	 * @param ctx the parse tree
	 */
	void enterNotif1str(VerilogPrimeParser.Notif1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#notif1str}.
	 * @param ctx the parse tree
	 */
	void exitNotif1str(VerilogPrimeParser.Notif1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nmosstr}.
	 * @param ctx the parse tree
	 */
	void enterNmosstr(VerilogPrimeParser.NmosstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nmosstr}.
	 * @param ctx the parse tree
	 */
	void exitNmosstr(VerilogPrimeParser.NmosstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pmos}.
	 * @param ctx the parse tree
	 */
	void enterPmos(VerilogPrimeParser.PmosContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pmos}.
	 * @param ctx the parse tree
	 */
	void exitPmos(VerilogPrimeParser.PmosContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rnmosstr}.
	 * @param ctx the parse tree
	 */
	void enterRnmosstr(VerilogPrimeParser.RnmosstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rnmosstr}.
	 * @param ctx the parse tree
	 */
	void exitRnmosstr(VerilogPrimeParser.RnmosstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rpmosstr}.
	 * @param ctx the parse tree
	 */
	void enterRpmosstr(VerilogPrimeParser.RpmosstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rpmosstr}.
	 * @param ctx the parse tree
	 */
	void exitRpmosstr(VerilogPrimeParser.RpmosstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nandstr}.
	 * @param ctx the parse tree
	 */
	void enterNandstr(VerilogPrimeParser.NandstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nandstr}.
	 * @param ctx the parse tree
	 */
	void exitNandstr(VerilogPrimeParser.NandstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#norstr}.
	 * @param ctx the parse tree
	 */
	void enterNorstr(VerilogPrimeParser.NorstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#norstr}.
	 * @param ctx the parse tree
	 */
	void exitNorstr(VerilogPrimeParser.NorstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xorstrstr}.
	 * @param ctx the parse tree
	 */
	void enterXorstrstr(VerilogPrimeParser.XorstrstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xorstrstr}.
	 * @param ctx the parse tree
	 */
	void exitXorstrstr(VerilogPrimeParser.XorstrstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xnorstr}.
	 * @param ctx the parse tree
	 */
	void enterXnorstr(VerilogPrimeParser.XnorstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xnorstr}.
	 * @param ctx the parse tree
	 */
	void exitXnorstr(VerilogPrimeParser.XnorstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#bufstr}.
	 * @param ctx the parse tree
	 */
	void enterBufstr(VerilogPrimeParser.BufstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#bufstr}.
	 * @param ctx the parse tree
	 */
	void exitBufstr(VerilogPrimeParser.BufstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tranif0str}.
	 * @param ctx the parse tree
	 */
	void enterTranif0str(VerilogPrimeParser.Tranif0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tranif0str}.
	 * @param ctx the parse tree
	 */
	void exitTranif0str(VerilogPrimeParser.Tranif0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tranif1str}.
	 * @param ctx the parse tree
	 */
	void enterTranif1str(VerilogPrimeParser.Tranif1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tranif1str}.
	 * @param ctx the parse tree
	 */
	void exitTranif1str(VerilogPrimeParser.Tranif1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rtranif1str}.
	 * @param ctx the parse tree
	 */
	void enterRtranif1str(VerilogPrimeParser.Rtranif1strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rtranif1str}.
	 * @param ctx the parse tree
	 */
	void exitRtranif1str(VerilogPrimeParser.Rtranif1strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rtranif0str}.
	 * @param ctx the parse tree
	 */
	void enterRtranif0str(VerilogPrimeParser.Rtranif0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rtranif0str}.
	 * @param ctx the parse tree
	 */
	void exitRtranif0str(VerilogPrimeParser.Rtranif0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#transtr}.
	 * @param ctx the parse tree
	 */
	void enterTranstr(VerilogPrimeParser.TranstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#transtr}.
	 * @param ctx the parse tree
	 */
	void exitTranstr(VerilogPrimeParser.TranstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rtranstr}.
	 * @param ctx the parse tree
	 */
	void enterRtranstr(VerilogPrimeParser.RtranstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rtranstr}.
	 * @param ctx the parse tree
	 */
	void exitRtranstr(VerilogPrimeParser.RtranstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#generatestr}.
	 * @param ctx the parse tree
	 */
	void enterGeneratestr(VerilogPrimeParser.GeneratestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#generatestr}.
	 * @param ctx the parse tree
	 */
	void exitGeneratestr(VerilogPrimeParser.GeneratestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endgeneratestr}.
	 * @param ctx the parse tree
	 */
	void enterEndgeneratestr(VerilogPrimeParser.EndgeneratestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endgeneratestr}.
	 * @param ctx the parse tree
	 */
	void exitEndgeneratestr(VerilogPrimeParser.EndgeneratestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#forstr}.
	 * @param ctx the parse tree
	 */
	void enterForstr(VerilogPrimeParser.ForstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#forstr}.
	 * @param ctx the parse tree
	 */
	void exitForstr(VerilogPrimeParser.ForstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#primitivestr}.
	 * @param ctx the parse tree
	 */
	void enterPrimitivestr(VerilogPrimeParser.PrimitivestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#primitivestr}.
	 * @param ctx the parse tree
	 */
	void exitPrimitivestr(VerilogPrimeParser.PrimitivestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endprimitivestr}.
	 * @param ctx the parse tree
	 */
	void enterEndprimitivestr(VerilogPrimeParser.EndprimitivestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endprimitivestr}.
	 * @param ctx the parse tree
	 */
	void exitEndprimitivestr(VerilogPrimeParser.EndprimitivestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tablestr}.
	 * @param ctx the parse tree
	 */
	void enterTablestr(VerilogPrimeParser.TablestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tablestr}.
	 * @param ctx the parse tree
	 */
	void exitTablestr(VerilogPrimeParser.TablestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endtablestr}.
	 * @param ctx the parse tree
	 */
	void enterEndtablestr(VerilogPrimeParser.EndtablestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endtablestr}.
	 * @param ctx the parse tree
	 */
	void exitEndtablestr(VerilogPrimeParser.EndtablestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#initialstr}.
	 * @param ctx the parse tree
	 */
	void enterInitialstr(VerilogPrimeParser.InitialstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#initialstr}.
	 * @param ctx the parse tree
	 */
	void exitInitialstr(VerilogPrimeParser.InitialstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#binary_number}.
	 * @param ctx the parse tree
	 */
	void enterBinary_number(VerilogPrimeParser.Binary_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#binary_number}.
	 * @param ctx the parse tree
	 */
	void exitBinary_number(VerilogPrimeParser.Binary_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#questinmark}.
	 * @param ctx the parse tree
	 */
	void enterQuestinmark(VerilogPrimeParser.QuestinmarkContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#questinmark}.
	 * @param ctx the parse tree
	 */
	void exitQuestinmark(VerilogPrimeParser.QuestinmarkContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#id}.
	 * @param ctx the parse tree
	 */
	void enterId(VerilogPrimeParser.IdContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#id}.
	 * @param ctx the parse tree
	 */
	void exitId(VerilogPrimeParser.IdContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#assignstrstr}.
	 * @param ctx the parse tree
	 */
	void enterAssignstrstr(VerilogPrimeParser.AssignstrstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#assignstrstr}.
	 * @param ctx the parse tree
	 */
	void exitAssignstrstr(VerilogPrimeParser.AssignstrstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#aliasstr}.
	 * @param ctx the parse tree
	 */
	void enterAliasstr(VerilogPrimeParser.AliasstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#aliasstr}.
	 * @param ctx the parse tree
	 */
	void exitAliasstr(VerilogPrimeParser.AliasstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#always_combstr}.
	 * @param ctx the parse tree
	 */
	void enterAlways_combstr(VerilogPrimeParser.Always_combstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#always_combstr}.
	 * @param ctx the parse tree
	 */
	void exitAlways_combstr(VerilogPrimeParser.Always_combstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#always_latchstr}.
	 * @param ctx the parse tree
	 */
	void enterAlways_latchstr(VerilogPrimeParser.Always_latchstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#always_latchstr}.
	 * @param ctx the parse tree
	 */
	void exitAlways_latchstr(VerilogPrimeParser.Always_latchstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#always_ffstr}.
	 * @param ctx the parse tree
	 */
	void enterAlways_ffstr(VerilogPrimeParser.Always_ffstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#always_ffstr}.
	 * @param ctx the parse tree
	 */
	void exitAlways_ffstr(VerilogPrimeParser.Always_ffstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#finalstr}.
	 * @param ctx the parse tree
	 */
	void enterFinalstr(VerilogPrimeParser.FinalstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#finalstr}.
	 * @param ctx the parse tree
	 */
	void exitFinalstr(VerilogPrimeParser.FinalstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#plusequals}.
	 * @param ctx the parse tree
	 */
	void enterPlusequals(VerilogPrimeParser.PlusequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#plusequals}.
	 * @param ctx the parse tree
	 */
	void exitPlusequals(VerilogPrimeParser.PlusequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#minusequals}.
	 * @param ctx the parse tree
	 */
	void enterMinusequals(VerilogPrimeParser.MinusequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#minusequals}.
	 * @param ctx the parse tree
	 */
	void exitMinusequals(VerilogPrimeParser.MinusequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#startequals}.
	 * @param ctx the parse tree
	 */
	void enterStartequals(VerilogPrimeParser.StartequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#startequals}.
	 * @param ctx the parse tree
	 */
	void exitStartequals(VerilogPrimeParser.StartequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#slashequals}.
	 * @param ctx the parse tree
	 */
	void enterSlashequals(VerilogPrimeParser.SlashequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#slashequals}.
	 * @param ctx the parse tree
	 */
	void exitSlashequals(VerilogPrimeParser.SlashequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#percentileequal}.
	 * @param ctx the parse tree
	 */
	void enterPercentileequal(VerilogPrimeParser.PercentileequalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#percentileequal}.
	 * @param ctx the parse tree
	 */
	void exitPercentileequal(VerilogPrimeParser.PercentileequalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#andequals}.
	 * @param ctx the parse tree
	 */
	void enterAndequals(VerilogPrimeParser.AndequalsContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#andequals}.
	 * @param ctx the parse tree
	 */
	void exitAndequals(VerilogPrimeParser.AndequalsContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#orequal}.
	 * @param ctx the parse tree
	 */
	void enterOrequal(VerilogPrimeParser.OrequalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#orequal}.
	 * @param ctx the parse tree
	 */
	void exitOrequal(VerilogPrimeParser.OrequalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xorequal}.
	 * @param ctx the parse tree
	 */
	void enterXorequal(VerilogPrimeParser.XorequalContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xorequal}.
	 * @param ctx the parse tree
	 */
	void exitXorequal(VerilogPrimeParser.XorequalContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lshift_assign}.
	 * @param ctx the parse tree
	 */
	void enterLshift_assign(VerilogPrimeParser.Lshift_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lshift_assign}.
	 * @param ctx the parse tree
	 */
	void exitLshift_assign(VerilogPrimeParser.Lshift_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rshift_assign}.
	 * @param ctx the parse tree
	 */
	void enterRshift_assign(VerilogPrimeParser.Rshift_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rshift_assign}.
	 * @param ctx the parse tree
	 */
	void exitRshift_assign(VerilogPrimeParser.Rshift_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unsigned_lshift_assign}.
	 * @param ctx the parse tree
	 */
	void enterUnsigned_lshift_assign(VerilogPrimeParser.Unsigned_lshift_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unsigned_lshift_assign}.
	 * @param ctx the parse tree
	 */
	void exitUnsigned_lshift_assign(VerilogPrimeParser.Unsigned_lshift_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unsigned_rshift_assign}.
	 * @param ctx the parse tree
	 */
	void enterUnsigned_rshift_assign(VerilogPrimeParser.Unsigned_rshift_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unsigned_rshift_assign}.
	 * @param ctx the parse tree
	 */
	void exitUnsigned_rshift_assign(VerilogPrimeParser.Unsigned_rshift_assignContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#deassignstr}.
	 * @param ctx the parse tree
	 */
	void enterDeassignstr(VerilogPrimeParser.DeassignstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#deassignstr}.
	 * @param ctx the parse tree
	 */
	void exitDeassignstr(VerilogPrimeParser.DeassignstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#forcestr}.
	 * @param ctx the parse tree
	 */
	void enterForcestr(VerilogPrimeParser.ForcestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#forcestr}.
	 * @param ctx the parse tree
	 */
	void exitForcestr(VerilogPrimeParser.ForcestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#releasestr}.
	 * @param ctx the parse tree
	 */
	void enterReleasestr(VerilogPrimeParser.ReleasestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#releasestr}.
	 * @param ctx the parse tree
	 */
	void exitReleasestr(VerilogPrimeParser.ReleasestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#forkstr}.
	 * @param ctx the parse tree
	 */
	void enterForkstr(VerilogPrimeParser.ForkstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#forkstr}.
	 * @param ctx the parse tree
	 */
	void exitForkstr(VerilogPrimeParser.ForkstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#joinstr}.
	 * @param ctx the parse tree
	 */
	void enterJoinstr(VerilogPrimeParser.JoinstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#joinstr}.
	 * @param ctx the parse tree
	 */
	void exitJoinstr(VerilogPrimeParser.JoinstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#join_anystr}.
	 * @param ctx the parse tree
	 */
	void enterJoin_anystr(VerilogPrimeParser.Join_anystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#join_anystr}.
	 * @param ctx the parse tree
	 */
	void exitJoin_anystr(VerilogPrimeParser.Join_anystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#join_namestr}.
	 * @param ctx the parse tree
	 */
	void enterJoin_namestr(VerilogPrimeParser.Join_namestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#join_namestr}.
	 * @param ctx the parse tree
	 */
	void exitJoin_namestr(VerilogPrimeParser.Join_namestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#repeatstr}.
	 * @param ctx the parse tree
	 */
	void enterRepeatstr(VerilogPrimeParser.RepeatstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#repeatstr}.
	 * @param ctx the parse tree
	 */
	void exitRepeatstr(VerilogPrimeParser.RepeatstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attherate}.
	 * @param ctx the parse tree
	 */
	void enterAttherate(VerilogPrimeParser.AttherateContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attherate}.
	 * @param ctx the parse tree
	 */
	void exitAttherate(VerilogPrimeParser.AttherateContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#attheratestar}.
	 * @param ctx the parse tree
	 */
	void enterAttheratestar(VerilogPrimeParser.AttheratestarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#attheratestar}.
	 * @param ctx the parse tree
	 */
	void exitAttheratestar(VerilogPrimeParser.AttheratestarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lparenstarrparen}.
	 * @param ctx the parse tree
	 */
	void enterLparenstarrparen(VerilogPrimeParser.LparenstarrparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lparenstarrparen}.
	 * @param ctx the parse tree
	 */
	void exitLparenstarrparen(VerilogPrimeParser.LparenstarrparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#returnstr}.
	 * @param ctx the parse tree
	 */
	void enterReturnstr(VerilogPrimeParser.ReturnstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#returnstr}.
	 * @param ctx the parse tree
	 */
	void exitReturnstr(VerilogPrimeParser.ReturnstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#breakstr}.
	 * @param ctx the parse tree
	 */
	void enterBreakstr(VerilogPrimeParser.BreakstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#breakstr}.
	 * @param ctx the parse tree
	 */
	void exitBreakstr(VerilogPrimeParser.BreakstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#continuestr}.
	 * @param ctx the parse tree
	 */
	void enterContinuestr(VerilogPrimeParser.ContinuestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#continuestr}.
	 * @param ctx the parse tree
	 */
	void exitContinuestr(VerilogPrimeParser.ContinuestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#waitstr}.
	 * @param ctx the parse tree
	 */
	void enterWaitstr(VerilogPrimeParser.WaitstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#waitstr}.
	 * @param ctx the parse tree
	 */
	void exitWaitstr(VerilogPrimeParser.WaitstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#wait_orderstr}.
	 * @param ctx the parse tree
	 */
	void enterWait_orderstr(VerilogPrimeParser.Wait_orderstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#wait_orderstr}.
	 * @param ctx the parse tree
	 */
	void exitWait_orderstr(VerilogPrimeParser.Wait_orderstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#derivegt}.
	 * @param ctx the parse tree
	 */
	void enterDerivegt(VerilogPrimeParser.DerivegtContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#derivegt}.
	 * @param ctx the parse tree
	 */
	void exitDerivegt(VerilogPrimeParser.DerivegtContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#uniquestr}.
	 * @param ctx the parse tree
	 */
	void enterUniquestr(VerilogPrimeParser.UniquestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#uniquestr}.
	 * @param ctx the parse tree
	 */
	void exitUniquestr(VerilogPrimeParser.UniquestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#unique0str}.
	 * @param ctx the parse tree
	 */
	void enterUnique0str(VerilogPrimeParser.Unique0strContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#unique0str}.
	 * @param ctx the parse tree
	 */
	void exitUnique0str(VerilogPrimeParser.Unique0strContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#prioritystr}.
	 * @param ctx the parse tree
	 */
	void enterPrioritystr(VerilogPrimeParser.PrioritystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#prioritystr}.
	 * @param ctx the parse tree
	 */
	void exitPrioritystr(VerilogPrimeParser.PrioritystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#matchesstr}.
	 * @param ctx the parse tree
	 */
	void enterMatchesstr(VerilogPrimeParser.MatchesstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#matchesstr}.
	 * @param ctx the parse tree
	 */
	void exitMatchesstr(VerilogPrimeParser.MatchesstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#insidestr}.
	 * @param ctx the parse tree
	 */
	void enterInsidestr(VerilogPrimeParser.InsidestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#insidestr}.
	 * @param ctx the parse tree
	 */
	void exitInsidestr(VerilogPrimeParser.InsidestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#casezstr}.
	 * @param ctx the parse tree
	 */
	void enterCasezstr(VerilogPrimeParser.CasezstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#casezstr}.
	 * @param ctx the parse tree
	 */
	void exitCasezstr(VerilogPrimeParser.CasezstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#casexstr}.
	 * @param ctx the parse tree
	 */
	void enterCasexstr(VerilogPrimeParser.CasexstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#casexstr}.
	 * @param ctx the parse tree
	 */
	void exitCasexstr(VerilogPrimeParser.CasexstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#andandand}.
	 * @param ctx the parse tree
	 */
	void enterAndandand(VerilogPrimeParser.AndandandContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#andandand}.
	 * @param ctx the parse tree
	 */
	void exitAndandand(VerilogPrimeParser.AndandandContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randcasestr}.
	 * @param ctx the parse tree
	 */
	void enterRandcasestr(VerilogPrimeParser.RandcasestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randcasestr}.
	 * @param ctx the parse tree
	 */
	void exitRandcasestr(VerilogPrimeParser.RandcasestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#escapelcurl}.
	 * @param ctx the parse tree
	 */
	void enterEscapelcurl(VerilogPrimeParser.EscapelcurlContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#escapelcurl}.
	 * @param ctx the parse tree
	 */
	void exitEscapelcurl(VerilogPrimeParser.EscapelcurlContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#foreverstr}.
	 * @param ctx the parse tree
	 */
	void enterForeverstr(VerilogPrimeParser.ForeverstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#foreverstr}.
	 * @param ctx the parse tree
	 */
	void exitForeverstr(VerilogPrimeParser.ForeverstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#whilestr}.
	 * @param ctx the parse tree
	 */
	void enterWhilestr(VerilogPrimeParser.WhilestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#whilestr}.
	 * @param ctx the parse tree
	 */
	void exitWhilestr(VerilogPrimeParser.WhilestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dostr}.
	 * @param ctx the parse tree
	 */
	void enterDostr(VerilogPrimeParser.DostrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dostr}.
	 * @param ctx the parse tree
	 */
	void exitDostr(VerilogPrimeParser.DostrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#escapequote}.
	 * @param ctx the parse tree
	 */
	void enterEscapequote(VerilogPrimeParser.EscapequoteContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#escapequote}.
	 * @param ctx the parse tree
	 */
	void exitEscapequote(VerilogPrimeParser.EscapequoteContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hash_zero}.
	 * @param ctx the parse tree
	 */
	void enterHash_zero(VerilogPrimeParser.Hash_zeroContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hash_zero}.
	 * @param ctx the parse tree
	 */
	void exitHash_zero(VerilogPrimeParser.Hash_zeroContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endclockingstr}.
	 * @param ctx the parse tree
	 */
	void enterEndclockingstr(VerilogPrimeParser.EndclockingstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endclockingstr}.
	 * @param ctx the parse tree
	 */
	void exitEndclockingstr(VerilogPrimeParser.EndclockingstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#globalstr}.
	 * @param ctx the parse tree
	 */
	void enterGlobalstr(VerilogPrimeParser.GlobalstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#globalstr}.
	 * @param ctx the parse tree
	 */
	void exitGlobalstr(VerilogPrimeParser.GlobalstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randsequencestr}.
	 * @param ctx the parse tree
	 */
	void enterRandsequencestr(VerilogPrimeParser.RandsequencestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randsequencestr}.
	 * @param ctx the parse tree
	 */
	void exitRandsequencestr(VerilogPrimeParser.RandsequencestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#or}.
	 * @param ctx the parse tree
	 */
	void enterOr(VerilogPrimeParser.OrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#or}.
	 * @param ctx the parse tree
	 */
	void exitOr(VerilogPrimeParser.OrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#specifystr}.
	 * @param ctx the parse tree
	 */
	void enterSpecifystr(VerilogPrimeParser.SpecifystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#specifystr}.
	 * @param ctx the parse tree
	 */
	void exitSpecifystr(VerilogPrimeParser.SpecifystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#endspecifystr}.
	 * @param ctx the parse tree
	 */
	void enterEndspecifystr(VerilogPrimeParser.EndspecifystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#endspecifystr}.
	 * @param ctx the parse tree
	 */
	void exitEndspecifystr(VerilogPrimeParser.EndspecifystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulsestyle_oneventstr}.
	 * @param ctx the parse tree
	 */
	void enterPulsestyle_oneventstr(VerilogPrimeParser.Pulsestyle_oneventstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_oneventstr}.
	 * @param ctx the parse tree
	 */
	void exitPulsestyle_oneventstr(VerilogPrimeParser.Pulsestyle_oneventstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pulsestyle_ondetectstr}.
	 * @param ctx the parse tree
	 */
	void enterPulsestyle_ondetectstr(VerilogPrimeParser.Pulsestyle_ondetectstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_ondetectstr}.
	 * @param ctx the parse tree
	 */
	void exitPulsestyle_ondetectstr(VerilogPrimeParser.Pulsestyle_ondetectstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#showcancelledstr}.
	 * @param ctx the parse tree
	 */
	void enterShowcancelledstr(VerilogPrimeParser.ShowcancelledstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#showcancelledstr}.
	 * @param ctx the parse tree
	 */
	void exitShowcancelledstr(VerilogPrimeParser.ShowcancelledstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#noshowcancelledstr}.
	 * @param ctx the parse tree
	 */
	void enterNoshowcancelledstr(VerilogPrimeParser.NoshowcancelledstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#noshowcancelledstr}.
	 * @param ctx the parse tree
	 */
	void exitNoshowcancelledstr(VerilogPrimeParser.NoshowcancelledstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stargt}.
	 * @param ctx the parse tree
	 */
	void enterStargt(VerilogPrimeParser.StargtContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stargt}.
	 * @param ctx the parse tree
	 */
	void exitStargt(VerilogPrimeParser.StargtContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#posedgestr}.
	 * @param ctx the parse tree
	 */
	void enterPosedgestr(VerilogPrimeParser.PosedgestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#posedgestr}.
	 * @param ctx the parse tree
	 */
	void exitPosedgestr(VerilogPrimeParser.PosedgestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#negedgestr}.
	 * @param ctx the parse tree
	 */
	void enterNegedgestr(VerilogPrimeParser.NegedgestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#negedgestr}.
	 * @param ctx the parse tree
	 */
	void exitNegedgestr(VerilogPrimeParser.NegedgestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#edgestr}.
	 * @param ctx the parse tree
	 */
	void enterEdgestr(VerilogPrimeParser.EdgestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#edgestr}.
	 * @param ctx the parse tree
	 */
	void exitEdgestr(VerilogPrimeParser.EdgestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#ifnonestr}.
	 * @param ctx the parse tree
	 */
	void enterIfnonestr(VerilogPrimeParser.IfnonestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#ifnonestr}.
	 * @param ctx the parse tree
	 */
	void exitIfnonestr(VerilogPrimeParser.IfnonestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarsetupstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarsetupstr(VerilogPrimeParser.DollarsetupstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarsetupstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarsetupstr(VerilogPrimeParser.DollarsetupstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarholdstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarholdstr(VerilogPrimeParser.DollarholdstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarholdstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarholdstr(VerilogPrimeParser.DollarholdstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarsetupholdstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarsetupholdstr(VerilogPrimeParser.DollarsetupholdstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarsetupholdstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarsetupholdstr(VerilogPrimeParser.DollarsetupholdstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarrecoverystr}.
	 * @param ctx the parse tree
	 */
	void enterDollarrecoverystr(VerilogPrimeParser.DollarrecoverystrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarrecoverystr}.
	 * @param ctx the parse tree
	 */
	void exitDollarrecoverystr(VerilogPrimeParser.DollarrecoverystrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarremovalstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarremovalstr(VerilogPrimeParser.DollarremovalstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarremovalstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarremovalstr(VerilogPrimeParser.DollarremovalstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarrecremstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarrecremstr(VerilogPrimeParser.DollarrecremstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarrecremstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarrecremstr(VerilogPrimeParser.DollarrecremstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarskewstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarskewstr(VerilogPrimeParser.DollarskewstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarskewstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarskewstr(VerilogPrimeParser.DollarskewstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollartimeskewstr}.
	 * @param ctx the parse tree
	 */
	void enterDollartimeskewstr(VerilogPrimeParser.DollartimeskewstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollartimeskewstr}.
	 * @param ctx the parse tree
	 */
	void exitDollartimeskewstr(VerilogPrimeParser.DollartimeskewstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarfullskewstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarfullskewstr(VerilogPrimeParser.DollarfullskewstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarfullskewstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarfullskewstr(VerilogPrimeParser.DollarfullskewstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarperiodstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarperiodstr(VerilogPrimeParser.DollarperiodstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarperiodstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarperiodstr(VerilogPrimeParser.DollarperiodstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollaewidthstr}.
	 * @param ctx the parse tree
	 */
	void enterDollaewidthstr(VerilogPrimeParser.DollaewidthstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollaewidthstr}.
	 * @param ctx the parse tree
	 */
	void exitDollaewidthstr(VerilogPrimeParser.DollaewidthstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarnochangestr}.
	 * @param ctx the parse tree
	 */
	void enterDollarnochangestr(VerilogPrimeParser.DollarnochangestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarnochangestr}.
	 * @param ctx the parse tree
	 */
	void exitDollarnochangestr(VerilogPrimeParser.DollarnochangestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#z_or_x}.
	 * @param ctx the parse tree
	 */
	void enterZ_or_x(VerilogPrimeParser.Z_or_xContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#z_or_x}.
	 * @param ctx the parse tree
	 */
	void exitZ_or_x(VerilogPrimeParser.Z_or_xContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#compliment}.
	 * @param ctx the parse tree
	 */
	void enterCompliment(VerilogPrimeParser.ComplimentContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#compliment}.
	 * @param ctx the parse tree
	 */
	void exitCompliment(VerilogPrimeParser.ComplimentContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_equality}.
	 * @param ctx the parse tree
	 */
	void enterCase_equality(VerilogPrimeParser.Case_equalityContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_equality}.
	 * @param ctx the parse tree
	 */
	void exitCase_equality(VerilogPrimeParser.Case_equalityContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_inequality}.
	 * @param ctx the parse tree
	 */
	void enterCase_inequality(VerilogPrimeParser.Case_inequalityContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_inequality}.
	 * @param ctx the parse tree
	 */
	void exitCase_inequality(VerilogPrimeParser.Case_inequalityContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#rshift}.
	 * @param ctx the parse tree
	 */
	void enterRshift(VerilogPrimeParser.RshiftContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#rshift}.
	 * @param ctx the parse tree
	 */
	void exitRshift(VerilogPrimeParser.RshiftContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lshift}.
	 * @param ctx the parse tree
	 */
	void enterLshift(VerilogPrimeParser.LshiftContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lshift}.
	 * @param ctx the parse tree
	 */
	void exitLshift(VerilogPrimeParser.LshiftContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#pluscolon}.
	 * @param ctx the parse tree
	 */
	void enterPluscolon(VerilogPrimeParser.PluscolonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#pluscolon}.
	 * @param ctx the parse tree
	 */
	void exitPluscolon(VerilogPrimeParser.PluscolonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#minuscolon}.
	 * @param ctx the parse tree
	 */
	void enterMinuscolon(VerilogPrimeParser.MinuscolonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#minuscolon}.
	 * @param ctx the parse tree
	 */
	void exitMinuscolon(VerilogPrimeParser.MinuscolonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#stdcoloncolon}.
	 * @param ctx the parse tree
	 */
	void enterStdcoloncolon(VerilogPrimeParser.StdcoloncolonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#stdcoloncolon}.
	 * @param ctx the parse tree
	 */
	void exitStdcoloncolon(VerilogPrimeParser.StdcoloncolonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#randomizestr}.
	 * @param ctx the parse tree
	 */
	void enterRandomizestr(VerilogPrimeParser.RandomizestrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#randomizestr}.
	 * @param ctx the parse tree
	 */
	void exitRandomizestr(VerilogPrimeParser.RandomizestrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nullstr}.
	 * @param ctx the parse tree
	 */
	void enterNullstr(VerilogPrimeParser.NullstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nullstr}.
	 * @param ctx the parse tree
	 */
	void exitNullstr(VerilogPrimeParser.NullstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#alshift}.
	 * @param ctx the parse tree
	 */
	void enterAlshift(VerilogPrimeParser.AlshiftContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#alshift}.
	 * @param ctx the parse tree
	 */
	void exitAlshift(VerilogPrimeParser.AlshiftContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#arshift}.
	 * @param ctx the parse tree
	 */
	void enterArshift(VerilogPrimeParser.ArshiftContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#arshift}.
	 * @param ctx the parse tree
	 */
	void exitArshift(VerilogPrimeParser.ArshiftContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#case_q}.
	 * @param ctx the parse tree
	 */
	void enterCase_q(VerilogPrimeParser.Case_qContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#case_q}.
	 * @param ctx the parse tree
	 */
	void exitCase_q(VerilogPrimeParser.Case_qContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#not_case_q}.
	 * @param ctx the parse tree
	 */
	void enterNot_case_q(VerilogPrimeParser.Not_case_qContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#not_case_q}.
	 * @param ctx the parse tree
	 */
	void exitNot_case_q(VerilogPrimeParser.Not_case_qContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#and}.
	 * @param ctx the parse tree
	 */
	void enterAnd(VerilogPrimeParser.AndContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#and}.
	 * @param ctx the parse tree
	 */
	void exitAnd(VerilogPrimeParser.AndContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xor}.
	 * @param ctx the parse tree
	 */
	void enterXor(VerilogPrimeParser.XorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xor}.
	 * @param ctx the parse tree
	 */
	void exitXor(VerilogPrimeParser.XorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xnor}.
	 * @param ctx the parse tree
	 */
	void enterXnor(VerilogPrimeParser.XnorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xnor}.
	 * @param ctx the parse tree
	 */
	void exitXnor(VerilogPrimeParser.XnorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#xorn}.
	 * @param ctx the parse tree
	 */
	void enterXorn(VerilogPrimeParser.XornContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#xorn}.
	 * @param ctx the parse tree
	 */
	void exitXorn(VerilogPrimeParser.XornContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#thisstr}.
	 * @param ctx the parse tree
	 */
	void enterThisstr(VerilogPrimeParser.ThisstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#thisstr}.
	 * @param ctx the parse tree
	 */
	void exitThisstr(VerilogPrimeParser.ThisstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#localcoloncolon}.
	 * @param ctx the parse tree
	 */
	void enterLocalcoloncolon(VerilogPrimeParser.LocalcoloncolonContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#localcoloncolon}.
	 * @param ctx the parse tree
	 */
	void exitLocalcoloncolon(VerilogPrimeParser.LocalcoloncolonContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#time_unit}.
	 * @param ctx the parse tree
	 */
	void enterTime_unit(VerilogPrimeParser.Time_unitContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#time_unit}.
	 * @param ctx the parse tree
	 */
	void exitTime_unit(VerilogPrimeParser.Time_unitContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nand}.
	 * @param ctx the parse tree
	 */
	void enterNand(VerilogPrimeParser.NandContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nand}.
	 * @param ctx the parse tree
	 */
	void exitNand(VerilogPrimeParser.NandContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#nor}.
	 * @param ctx the parse tree
	 */
	void enterNor(VerilogPrimeParser.NorContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#nor}.
	 * @param ctx the parse tree
	 */
	void exitNor(VerilogPrimeParser.NorContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dderive}.
	 * @param ctx the parse tree
	 */
	void enterDderive(VerilogPrimeParser.DderiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dderive}.
	 * @param ctx the parse tree
	 */
	void exitDderive(VerilogPrimeParser.DderiveContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#scalar_constant0}.
	 * @param ctx the parse tree
	 */
	void enterScalar_constant0(VerilogPrimeParser.Scalar_constant0Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#scalar_constant0}.
	 * @param ctx the parse tree
	 */
	void exitScalar_constant0(VerilogPrimeParser.Scalar_constant0Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#scalar_constant1}.
	 * @param ctx the parse tree
	 */
	void enterScalar_constant1(VerilogPrimeParser.Scalar_constant1Context ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#scalar_constant1}.
	 * @param ctx the parse tree
	 */
	void exitScalar_constant1(VerilogPrimeParser.Scalar_constant1Context ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#string}.
	 * @param ctx the parse tree
	 */
	void enterString(VerilogPrimeParser.StringContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#string}.
	 * @param ctx the parse tree
	 */
	void exitString(VerilogPrimeParser.StringContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#lparenstar}.
	 * @param ctx the parse tree
	 */
	void enterLparenstar(VerilogPrimeParser.LparenstarContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#lparenstar}.
	 * @param ctx the parse tree
	 */
	void exitLparenstar(VerilogPrimeParser.LparenstarContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#starrparen}.
	 * @param ctx the parse tree
	 */
	void enterStarrparen(VerilogPrimeParser.StarrparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#starrparen}.
	 * @param ctx the parse tree
	 */
	void exitStarrparen(VerilogPrimeParser.StarrparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#esc_identifier}.
	 * @param ctx the parse tree
	 */
	void enterEsc_identifier(VerilogPrimeParser.Esc_identifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#esc_identifier}.
	 * @param ctx the parse tree
	 */
	void exitEsc_identifier(VerilogPrimeParser.Esc_identifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarrootstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarrootstr(VerilogPrimeParser.DollarrootstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarrootstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarrootstr(VerilogPrimeParser.DollarrootstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#dollarunitstr}.
	 * @param ctx the parse tree
	 */
	void enterDollarunitstr(VerilogPrimeParser.DollarunitstrContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#dollarunitstr}.
	 * @param ctx the parse tree
	 */
	void exitDollarunitstr(VerilogPrimeParser.DollarunitstrContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#tf_id}.
	 * @param ctx the parse tree
	 */
	void enterTf_id(VerilogPrimeParser.Tf_idContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#tf_id}.
	 * @param ctx the parse tree
	 */
	void exitTf_id(VerilogPrimeParser.Tf_idContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#octal_number}.
	 * @param ctx the parse tree
	 */
	void enterOctal_number(VerilogPrimeParser.Octal_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#octal_number}.
	 * @param ctx the parse tree
	 */
	void exitOctal_number(VerilogPrimeParser.Octal_numberContext ctx);
	/**
	 * Enter a parse tree produced by {@link VerilogPrimeParser#hex_number}.
	 * @param ctx the parse tree
	 */
	void enterHex_number(VerilogPrimeParser.Hex_numberContext ctx);
	/**
	 * Exit a parse tree produced by {@link VerilogPrimeParser#hex_number}.
	 * @param ctx the parse tree
	 */
	void exitHex_number(VerilogPrimeParser.Hex_numberContext ctx);
}