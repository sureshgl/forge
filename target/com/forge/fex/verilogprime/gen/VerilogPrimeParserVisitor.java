// Generated from VerilogPrimeParser.g4 by ANTLR 4.5
package com.forge.fex.verilogprime.gen;

    import com.forge.fex.verilogprime.ext.*;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link VerilogPrimeParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface VerilogPrimeParserVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#source_text}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSource_text(VerilogPrimeParser.Source_textContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDescription(VerilogPrimeParser.DescriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_declaration(VerilogPrimeParser.Module_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_nonansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_nonansi_header(VerilogPrimeParser.Module_nonansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_ansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_ansi_header(VerilogPrimeParser.Module_ansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_keyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_keyword(VerilogPrimeParser.Module_keywordContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_declaration(VerilogPrimeParser.Interface_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_nonansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_nonansi_header(VerilogPrimeParser.Interface_nonansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_ansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_ansi_header(VerilogPrimeParser.Interface_ansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_declaration(VerilogPrimeParser.Program_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_nonansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_nonansi_header(VerilogPrimeParser.Program_nonansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_ansi_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_ansi_header(VerilogPrimeParser.Program_ansi_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_declaration(VerilogPrimeParser.Checker_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_declaration(VerilogPrimeParser.Class_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_declaration(VerilogPrimeParser.Package_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_declaration_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_declaration_part1(VerilogPrimeParser.Package_declaration_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timeunits_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimeunits_declaration(VerilogPrimeParser.Timeunits_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_port_list(VerilogPrimeParser.Parameter_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_parameter_port_declaration(VerilogPrimeParser.List_of_parameter_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_port_declaration(VerilogPrimeParser.Parameter_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_ports}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_ports(VerilogPrimeParser.List_of_portsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_port_declarations(VerilogPrimeParser.List_of_port_declarationsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_port_declarations_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_port_declarations_part1(VerilogPrimeParser.List_of_port_declarations_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_declaration(VerilogPrimeParser.Port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort(VerilogPrimeParser.PortContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_expression(VerilogPrimeParser.Port_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port_reference}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_reference(VerilogPrimeParser.Port_referenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port_direction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_direction(VerilogPrimeParser.Port_directionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_port_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_port_header(VerilogPrimeParser.Net_port_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_port_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_port_header(VerilogPrimeParser.Variable_port_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_port_header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_port_header(VerilogPrimeParser.Interface_port_headerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ansi_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnsi_port_declaration(VerilogPrimeParser.Ansi_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#elaboration_system_task}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElaboration_system_task(VerilogPrimeParser.Elaboration_system_taskContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#finish_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFinish_number(VerilogPrimeParser.Finish_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_common_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_common_item(VerilogPrimeParser.Module_common_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_item(VerilogPrimeParser.Module_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_or_generate_item(VerilogPrimeParser.Module_or_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#non_port_module_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNon_port_module_item(VerilogPrimeParser.Non_port_module_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_override}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_override(VerilogPrimeParser.Parameter_overrideContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bind_directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBind_directive(VerilogPrimeParser.Bind_directiveContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bind_target_scope}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBind_target_scope(VerilogPrimeParser.Bind_target_scopeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bind_target_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBind_target_instance(VerilogPrimeParser.Bind_target_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bind_target_instance_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBind_target_instance_list(VerilogPrimeParser.Bind_target_instance_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bind_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBind_instantiation(VerilogPrimeParser.Bind_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#config_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConfig_declaration(VerilogPrimeParser.Config_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#design_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDesign_statement(VerilogPrimeParser.Design_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#design_statement_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDesign_statement_part1(VerilogPrimeParser.Design_statement_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#config_rule_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConfig_rule_statement(VerilogPrimeParser.Config_rule_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#default_clause}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefault_clause(VerilogPrimeParser.Default_clauseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inst_clause}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInst_clause(VerilogPrimeParser.Inst_clauseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inst_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInst_name(VerilogPrimeParser.Inst_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cell_clause}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCell_clause(VerilogPrimeParser.Cell_clauseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#liblist_clause}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLiblist_clause(VerilogPrimeParser.Liblist_clauseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#use_clause}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUse_clause(VerilogPrimeParser.Use_clauseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_or_generate_item_declaration(VerilogPrimeParser.Module_or_generate_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_or_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_or_generate_item(VerilogPrimeParser.Interface_or_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#extern_tf_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExtern_tf_declaration(VerilogPrimeParser.Extern_tf_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_item(VerilogPrimeParser.Interface_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#non_port_interface_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNon_port_interface_item(VerilogPrimeParser.Non_port_interface_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_item(VerilogPrimeParser.Program_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#non_port_program_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNon_port_program_item(VerilogPrimeParser.Non_port_program_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_generate_item(VerilogPrimeParser.Program_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_port_list(VerilogPrimeParser.Checker_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_port_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_port_item(VerilogPrimeParser.Checker_port_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_or_generate_item(VerilogPrimeParser.Checker_or_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_or_generate_item_declaration(VerilogPrimeParser.Checker_or_generate_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_generate_item(VerilogPrimeParser.Checker_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_always_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_always_construct(VerilogPrimeParser.Checker_always_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_item(VerilogPrimeParser.Class_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_property}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_property(VerilogPrimeParser.Class_propertyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_method}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_method(VerilogPrimeParser.Class_methodContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_constructor_prototype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_constructor_prototype(VerilogPrimeParser.Class_constructor_prototypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_constraint}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_constraint(VerilogPrimeParser.Class_constraintContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_item_qualifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_item_qualifier(VerilogPrimeParser.Class_item_qualifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_qualifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_qualifier(VerilogPrimeParser.Property_qualifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#random_qualifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandom_qualifier(VerilogPrimeParser.Random_qualifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_qualifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_qualifier(VerilogPrimeParser.Method_qualifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_prototype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_prototype(VerilogPrimeParser.Method_prototypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_constructor_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_constructor_declaration(VerilogPrimeParser.Class_constructor_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_declaration(VerilogPrimeParser.Constraint_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_block(VerilogPrimeParser.Constraint_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_block_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_block_item(VerilogPrimeParser.Constraint_block_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#solve_before_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSolve_before_list(VerilogPrimeParser.Solve_before_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#solve_before_primary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSolve_before_primary(VerilogPrimeParser.Solve_before_primaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_expression(VerilogPrimeParser.Constraint_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_set}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_set(VerilogPrimeParser.Constraint_setContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dist_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDist_list(VerilogPrimeParser.Dist_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dist_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDist_item(VerilogPrimeParser.Dist_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dist_weight}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDist_weight(VerilogPrimeParser.Dist_weightContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_prototype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_prototype(VerilogPrimeParser.Constraint_prototypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#extern_constraint_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExtern_constraint_declaration(VerilogPrimeParser.Extern_constraint_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#identifier_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifier_list(VerilogPrimeParser.Identifier_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_item(VerilogPrimeParser.Package_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_or_generate_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_or_generate_item_declaration(VerilogPrimeParser.Package_or_generate_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#anonymous_program}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnonymous_program(VerilogPrimeParser.Anonymous_programContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#anonymous_program_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnonymous_program_item(VerilogPrimeParser.Anonymous_program_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#local_parameter_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocal_parameter_declaration(VerilogPrimeParser.Local_parameter_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_declaration(VerilogPrimeParser.Parameter_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specparam_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecparam_declaration(VerilogPrimeParser.Specparam_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inout_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInout_declaration(VerilogPrimeParser.Inout_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#input_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInput_declaration(VerilogPrimeParser.Input_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#output_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutput_declaration(VerilogPrimeParser.Output_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_port_declaration(VerilogPrimeParser.Interface_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ref_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRef_declaration(VerilogPrimeParser.Ref_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_declaration(VerilogPrimeParser.Data_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_import_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_import_declaration(VerilogPrimeParser.Package_import_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_import_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_import_item(VerilogPrimeParser.Package_import_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_export_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_export_declaration(VerilogPrimeParser.Package_export_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvar_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvar_declaration(VerilogPrimeParser.Genvar_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_declaration(VerilogPrimeParser.Net_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#type_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_declaration(VerilogPrimeParser.Type_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lifetime}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLifetime(VerilogPrimeParser.LifetimeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#casting_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCasting_type(VerilogPrimeParser.Casting_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_type(VerilogPrimeParser.Data_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_type_or_implicit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_type_or_implicit(VerilogPrimeParser.Data_type_or_implicitContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#implicit_data_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImplicit_data_type(VerilogPrimeParser.Implicit_data_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enum_base_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_base_type(VerilogPrimeParser.Enum_base_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_name_declaration(VerilogPrimeParser.Enum_name_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enum_name_declaration_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_name_declaration_part1(VerilogPrimeParser.Enum_name_declaration_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_scope}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_scope(VerilogPrimeParser.Class_scopeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_type(VerilogPrimeParser.Class_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_type_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_type_part1(VerilogPrimeParser.Class_type_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#integer_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInteger_type(VerilogPrimeParser.Integer_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#integer_atom_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInteger_atom_type(VerilogPrimeParser.Integer_atom_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#integer_vector_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInteger_vector_type(VerilogPrimeParser.Integer_vector_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#non_integer_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNon_integer_type(VerilogPrimeParser.Non_integer_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_type(VerilogPrimeParser.Net_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_port_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_port_type(VerilogPrimeParser.Net_port_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_port_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_port_type(VerilogPrimeParser.Variable_port_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#var_data_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVar_data_type(VerilogPrimeParser.Var_data_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#signing}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSigning(VerilogPrimeParser.SigningContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_type(VerilogPrimeParser.Simple_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#struct_union_member}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStruct_union_member(VerilogPrimeParser.Struct_union_memberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_type_or_void}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_type_or_void(VerilogPrimeParser.Data_type_or_voidContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#struct_union}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStruct_union(VerilogPrimeParser.Struct_unionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#type_reference}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_reference(VerilogPrimeParser.Type_referenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#drive_strength}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDrive_strength(VerilogPrimeParser.Drive_strengthContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#strength0}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStrength0(VerilogPrimeParser.Strength0Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#strength1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStrength1(VerilogPrimeParser.Strength1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#charge_strength}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCharge_strength(VerilogPrimeParser.Charge_strengthContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delay3}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelay3(VerilogPrimeParser.Delay3Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delay2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelay2(VerilogPrimeParser.Delay2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delay_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelay_value(VerilogPrimeParser.Delay_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_defparam_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_defparam_assignments(VerilogPrimeParser.List_of_defparam_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_genvar_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_genvar_identifiers(VerilogPrimeParser.List_of_genvar_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_interface_identifiers(VerilogPrimeParser.List_of_interface_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_interface_identifiers_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_interface_identifiers_part1(VerilogPrimeParser.List_of_interface_identifiers_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_param_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_param_assignments(VerilogPrimeParser.List_of_param_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_port_identifiers(VerilogPrimeParser.List_of_port_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_port_identifiers_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_port_identifiers_part1(VerilogPrimeParser.List_of_port_identifiers_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_udp_port_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_udp_port_identifiers(VerilogPrimeParser.List_of_udp_port_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_specparam_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_specparam_assignments(VerilogPrimeParser.List_of_specparam_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_tf_variable_identifiers(VerilogPrimeParser.List_of_tf_variable_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_tf_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_tf_variable_identifiers_part1(VerilogPrimeParser.List_of_tf_variable_identifiers_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_type_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_type_assignments(VerilogPrimeParser.List_of_type_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_decl_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_decl_assignments(VerilogPrimeParser.List_of_variable_decl_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_identifiers(VerilogPrimeParser.List_of_variable_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_identifiers_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_identifiers_part1(VerilogPrimeParser.List_of_variable_identifiers_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_port_identifiers(VerilogPrimeParser.List_of_variable_port_identifiersContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_port_identifiers_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_port_identifiers_part1(VerilogPrimeParser.List_of_variable_port_identifiers_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_virtual_interface_decl(VerilogPrimeParser.List_of_virtual_interface_declContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_virtual_interface_decl_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_virtual_interface_decl_part1(VerilogPrimeParser.List_of_virtual_interface_decl_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#defparam_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefparam_assignment(VerilogPrimeParser.Defparam_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_net_decl_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_net_decl_assignments(VerilogPrimeParser.List_of_net_decl_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_decl_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_decl_assignment(VerilogPrimeParser.Net_decl_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#param_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParam_assignment(VerilogPrimeParser.Param_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specparam_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecparam_assignment(VerilogPrimeParser.Specparam_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#type_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_assignment(VerilogPrimeParser.Type_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulse_control_specparam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulse_control_specparam(VerilogPrimeParser.Pulse_control_specparamContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#error_limit_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitError_limit_value(VerilogPrimeParser.Error_limit_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#reject_limit_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReject_limit_value(VerilogPrimeParser.Reject_limit_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#limit_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLimit_value(VerilogPrimeParser.Limit_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_decl_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_decl_assignment(VerilogPrimeParser.Variable_decl_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_new}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_new(VerilogPrimeParser.Class_newContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dynamic_array_new}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDynamic_array_new(VerilogPrimeParser.Dynamic_array_newContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unpacked_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnpacked_dimension(VerilogPrimeParser.Unpacked_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#packed_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPacked_dimension(VerilogPrimeParser.Packed_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#associative_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssociative_dimension(VerilogPrimeParser.Associative_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_dimension(VerilogPrimeParser.Variable_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#queue_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitQueue_dimension(VerilogPrimeParser.Queue_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unsized_dimension}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnsized_dimension(VerilogPrimeParser.Unsized_dimensionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_data_type_or_implicit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_data_type_or_implicit(VerilogPrimeParser.Function_data_type_or_implicitContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_declaration(VerilogPrimeParser.Function_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_body_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_body_declaration(VerilogPrimeParser.Function_body_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_prototype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_prototype(VerilogPrimeParser.Function_prototypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_import_export}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_import_export(VerilogPrimeParser.Dpi_import_exportContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_string}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_spec_string(VerilogPrimeParser.Dpi_spec_stringContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_function_import_property}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_function_import_property(VerilogPrimeParser.Dpi_function_import_propertyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_task_import_property}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_task_import_property(VerilogPrimeParser.Dpi_task_import_propertyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_function_proto}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_function_proto(VerilogPrimeParser.Dpi_function_protoContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_task_proto}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_task_proto(VerilogPrimeParser.Dpi_task_protoContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#task_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTask_declaration(VerilogPrimeParser.Task_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#task_body_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTask_body_declaration(VerilogPrimeParser.Task_body_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_item_declaration(VerilogPrimeParser.Tf_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_port_list(VerilogPrimeParser.Tf_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_port_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_port_item(VerilogPrimeParser.Tf_port_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_port_direction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_port_direction(VerilogPrimeParser.Tf_port_directionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_port_declaration(VerilogPrimeParser.Tf_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#task_prototype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTask_prototype(VerilogPrimeParser.Task_prototypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#block_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock_item_declaration(VerilogPrimeParser.Block_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#overload_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOverload_declaration(VerilogPrimeParser.Overload_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#overload_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOverload_operator(VerilogPrimeParser.Overload_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#overload_proto_formals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOverload_proto_formals(VerilogPrimeParser.Overload_proto_formalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#virtual_interface_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVirtual_interface_declaration(VerilogPrimeParser.Virtual_interface_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_declaration(VerilogPrimeParser.Modport_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_item(VerilogPrimeParser.Modport_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_ports_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_ports_declaration(VerilogPrimeParser.Modport_ports_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_clocking_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_clocking_declaration(VerilogPrimeParser.Modport_clocking_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_simple_ports_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_simple_ports_declaration(VerilogPrimeParser.Modport_simple_ports_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_simple_port}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_simple_port(VerilogPrimeParser.Modport_simple_portContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_tf_ports_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_tf_ports_declaration(VerilogPrimeParser.Modport_tf_ports_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_tf_port}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_tf_port(VerilogPrimeParser.Modport_tf_portContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#import_export}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImport_export(VerilogPrimeParser.Import_exportContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConcurrent_assertion_item(VerilogPrimeParser.Concurrent_assertion_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#concurrent_assertion_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConcurrent_assertion_statement(VerilogPrimeParser.Concurrent_assertion_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assert_property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssert_property_statement(VerilogPrimeParser.Assert_property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assume_property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssume_property_statement(VerilogPrimeParser.Assume_property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cover_property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCover_property_statement(VerilogPrimeParser.Cover_property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#expect_property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpect_property_statement(VerilogPrimeParser.Expect_property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cover_sequence_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCover_sequence_statement(VerilogPrimeParser.Cover_sequence_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#restrict_property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRestrict_property_statement(VerilogPrimeParser.Restrict_property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_instance(VerilogPrimeParser.Property_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_list_of_arguments(VerilogPrimeParser.Property_list_of_argumentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_list_of_arguments_part1(VerilogPrimeParser.Property_list_of_arguments_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_list_of_arguments_part2(VerilogPrimeParser.Property_list_of_arguments_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_actual_arg}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_actual_arg(VerilogPrimeParser.Property_actual_argContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assertion_item_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertion_item_declaration(VerilogPrimeParser.Assertion_item_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_declaration(VerilogPrimeParser.Property_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_port_list(VerilogPrimeParser.Property_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_port_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_port_item(VerilogPrimeParser.Property_port_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_lvar_port_direction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_lvar_port_direction(VerilogPrimeParser.Property_lvar_port_directionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_formal_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_formal_type(VerilogPrimeParser.Property_formal_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_spec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_spec(VerilogPrimeParser.Property_specContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_statement_spec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_statement_spec(VerilogPrimeParser.Property_statement_specContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_statement(VerilogPrimeParser.Property_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_case_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_case_item(VerilogPrimeParser.Property_case_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_expr(VerilogPrimeParser.Property_exprContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_declaration(VerilogPrimeParser.Sequence_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_port_list(VerilogPrimeParser.Sequence_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_port_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_port_item(VerilogPrimeParser.Sequence_port_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_lvar_port_direction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_lvar_port_direction(VerilogPrimeParser.Sequence_lvar_port_directionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_formal_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_formal_type(VerilogPrimeParser.Sequence_formal_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_expr(VerilogPrimeParser.Sequence_exprContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cycle_delay_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCycle_delay_range(VerilogPrimeParser.Cycle_delay_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_method_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_method_call(VerilogPrimeParser.Sequence_method_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_match_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_match_item(VerilogPrimeParser.Sequence_match_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_instance(VerilogPrimeParser.Sequence_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_list_of_arguments(VerilogPrimeParser.Sequence_list_of_argumentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_list_of_arguments_part1(VerilogPrimeParser.Sequence_list_of_arguments_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_list_of_arguments_part2(VerilogPrimeParser.Sequence_list_of_arguments_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_actual_arg}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_actual_arg(VerilogPrimeParser.Sequence_actual_argContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#boolean_abbrev}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBoolean_abbrev(VerilogPrimeParser.Boolean_abbrevContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_abbrev}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_abbrev(VerilogPrimeParser.Sequence_abbrevContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#consecutive_repetition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConsecutive_repetition(VerilogPrimeParser.Consecutive_repetitionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#non_consecutive_repetition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNon_consecutive_repetition(VerilogPrimeParser.Non_consecutive_repetitionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#goto_repetition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGoto_repetition(VerilogPrimeParser.Goto_repetitionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#const_or_range_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_or_range_expression(VerilogPrimeParser.Const_or_range_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cycle_delay_const_range_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCycle_delay_const_range_expression(VerilogPrimeParser.Cycle_delay_const_range_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#expression_or_dist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_or_dist(VerilogPrimeParser.Expression_or_distContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assertion_variable_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertion_variable_declaration(VerilogPrimeParser.Assertion_variable_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_declaration(VerilogPrimeParser.Let_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_identifier(VerilogPrimeParser.Let_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_port_list(VerilogPrimeParser.Let_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_port_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_port_item(VerilogPrimeParser.Let_port_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_formal_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_formal_type(VerilogPrimeParser.Let_formal_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_expression(VerilogPrimeParser.Let_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_list_of_arguments(VerilogPrimeParser.Let_list_of_argumentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_list_of_arguments_part1(VerilogPrimeParser.Let_list_of_arguments_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_list_of_arguments_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_list_of_arguments_part2(VerilogPrimeParser.Let_list_of_arguments_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#let_actual_arg}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLet_actual_arg(VerilogPrimeParser.Let_actual_argContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#covergroup_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCovergroup_declaration(VerilogPrimeParser.Covergroup_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverage_spec_or_option}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverage_spec_or_option(VerilogPrimeParser.Coverage_spec_or_optionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverage_option}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverage_option(VerilogPrimeParser.Coverage_optionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverage_spec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverage_spec(VerilogPrimeParser.Coverage_specContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverage_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverage_event(VerilogPrimeParser.Coverage_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#block_event_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock_event_expression(VerilogPrimeParser.Block_event_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_btf_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_btf_identifier(VerilogPrimeParser.Hierarchical_btf_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cover_point}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCover_point(VerilogPrimeParser.Cover_pointContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_or_empty}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_or_empty(VerilogPrimeParser.Bins_or_emptyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_or_options}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_or_options(VerilogPrimeParser.Bins_or_optionsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_or_options_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_or_options_part1(VerilogPrimeParser.Bins_or_options_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_keyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_keyword(VerilogPrimeParser.Bins_keywordContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#range_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRange_list(VerilogPrimeParser.Range_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#trans_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrans_list(VerilogPrimeParser.Trans_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#trans_set}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrans_set(VerilogPrimeParser.Trans_setContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#trans_range_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrans_range_list(VerilogPrimeParser.Trans_range_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#trans_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrans_item(VerilogPrimeParser.Trans_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#repeat_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeat_range(VerilogPrimeParser.Repeat_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cover_cross}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCover_cross(VerilogPrimeParser.Cover_crossContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_coverpoints}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_coverpoints(VerilogPrimeParser.List_of_coverpointsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cross_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCross_item(VerilogPrimeParser.Cross_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#select_bins_or_empty}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSelect_bins_or_empty(VerilogPrimeParser.Select_bins_or_emptyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_selection_or_option}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_selection_or_option(VerilogPrimeParser.Bins_selection_or_optionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_selection}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_selection(VerilogPrimeParser.Bins_selectionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#select_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSelect_expression(VerilogPrimeParser.Select_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#select_expression_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSelect_expression_part1(VerilogPrimeParser.Select_expression_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#select_condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSelect_condition(VerilogPrimeParser.Select_conditionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_expression(VerilogPrimeParser.Bins_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#open_range_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOpen_range_list(VerilogPrimeParser.Open_range_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#open_value_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOpen_value_range(VerilogPrimeParser.Open_value_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#gate_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGate_instantiation(VerilogPrimeParser.Gate_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cmos_switch_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCmos_switch_instance(VerilogPrimeParser.Cmos_switch_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enable_gate_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnable_gate_instance(VerilogPrimeParser.Enable_gate_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#mos_switch_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMos_switch_instance(VerilogPrimeParser.Mos_switch_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#n_input_gate_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitN_input_gate_instance(VerilogPrimeParser.N_input_gate_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#n_output_gate_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitN_output_gate_instance(VerilogPrimeParser.N_output_gate_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pass_switch_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPass_switch_instance(VerilogPrimeParser.Pass_switch_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pass_enable_switch_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPass_enable_switch_instance(VerilogPrimeParser.Pass_enable_switch_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pull_gate_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPull_gate_instance(VerilogPrimeParser.Pull_gate_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulldown_strength}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulldown_strength(VerilogPrimeParser.Pulldown_strengthContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pullup_strength}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPullup_strength(VerilogPrimeParser.Pullup_strengthContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enable_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnable_terminal(VerilogPrimeParser.Enable_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inout_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInout_terminal(VerilogPrimeParser.Inout_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#input_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInput_terminal(VerilogPrimeParser.Input_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ncontrol_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNcontrol_terminal(VerilogPrimeParser.Ncontrol_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#output_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutput_terminal(VerilogPrimeParser.Output_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pcontrol_terminal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPcontrol_terminal(VerilogPrimeParser.Pcontrol_terminalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cmos_switchtype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCmos_switchtype(VerilogPrimeParser.Cmos_switchtypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enable_gatetype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnable_gatetype(VerilogPrimeParser.Enable_gatetypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#mos_switchtype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMos_switchtype(VerilogPrimeParser.Mos_switchtypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#n_input_gatetype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitN_input_gatetype(VerilogPrimeParser.N_input_gatetypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#n_output_gatetype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitN_output_gatetype(VerilogPrimeParser.N_output_gatetypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pass_en_switchtype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPass_en_switchtype(VerilogPrimeParser.Pass_en_switchtypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pass_switchtype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPass_switchtype(VerilogPrimeParser.Pass_switchtypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_instantiation(VerilogPrimeParser.Module_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_value_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_value_assignment(VerilogPrimeParser.Parameter_value_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_parameter_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_parameter_assignments(VerilogPrimeParser.List_of_parameter_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ordered_parameter_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrdered_parameter_assignment(VerilogPrimeParser.Ordered_parameter_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#named_parameter_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNamed_parameter_assignment(VerilogPrimeParser.Named_parameter_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_instance(VerilogPrimeParser.Hierarchical_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#name_of_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitName_of_instance(VerilogPrimeParser.Name_of_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_port_connections}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_port_connections(VerilogPrimeParser.List_of_port_connectionsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ordered_port_connection}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrdered_port_connection(VerilogPrimeParser.Ordered_port_connectionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#named_port_connection}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNamed_port_connection(VerilogPrimeParser.Named_port_connectionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_instantiation(VerilogPrimeParser.Interface_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_instantiation(VerilogPrimeParser.Program_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_instantiation(VerilogPrimeParser.Checker_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_checker_port_connections}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_checker_port_connections(VerilogPrimeParser.List_of_checker_port_connectionsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ordered_checker_port_connection}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrdered_checker_port_connection(VerilogPrimeParser.Ordered_checker_port_connectionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#named_checker_port_connection}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNamed_checker_port_connection(VerilogPrimeParser.Named_checker_port_connectionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_region}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_region(VerilogPrimeParser.Generate_regionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#loop_generate_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop_generate_construct(VerilogPrimeParser.Loop_generate_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvar_initialization}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvar_initialization(VerilogPrimeParser.Genvar_initializationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#conditional_generate_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConditional_generate_construct(VerilogPrimeParser.Conditional_generate_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#if_generate_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIf_generate_construct(VerilogPrimeParser.If_generate_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_generate_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_generate_construct(VerilogPrimeParser.Case_generate_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_generate_item(VerilogPrimeParser.Case_generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_block(VerilogPrimeParser.Generate_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_block_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_block_part1(VerilogPrimeParser.Generate_block_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_block_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_block_part2(VerilogPrimeParser.Generate_block_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_block_part3}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_block_part3(VerilogPrimeParser.Generate_block_part3Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_item(VerilogPrimeParser.Generate_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_nonansi_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_nonansi_declaration(VerilogPrimeParser.Udp_nonansi_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvar_iteration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvar_iteration(VerilogPrimeParser.Genvar_iterationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_ansi_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_ansi_declaration(VerilogPrimeParser.Udp_ansi_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_declaration(VerilogPrimeParser.Udp_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_port_list(VerilogPrimeParser.Udp_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_declaration_port_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_declaration_port_list(VerilogPrimeParser.Udp_declaration_port_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_port_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_port_declaration(VerilogPrimeParser.Udp_port_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_output_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_output_declaration(VerilogPrimeParser.Udp_output_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_input_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_input_declaration(VerilogPrimeParser.Udp_input_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_reg_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_reg_declaration(VerilogPrimeParser.Udp_reg_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_body(VerilogPrimeParser.Udp_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#combinational_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCombinational_body(VerilogPrimeParser.Combinational_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#combinational_entry}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCombinational_entry(VerilogPrimeParser.Combinational_entryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequential_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequential_body(VerilogPrimeParser.Sequential_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_initial_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_initial_statement(VerilogPrimeParser.Udp_initial_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#init_val}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInit_val(VerilogPrimeParser.Init_valContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequential_entry}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequential_entry(VerilogPrimeParser.Sequential_entryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#seq_input_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSeq_input_list(VerilogPrimeParser.Seq_input_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#level_input_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLevel_input_list(VerilogPrimeParser.Level_input_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_input_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_input_list(VerilogPrimeParser.Edge_input_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_input_list_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_input_list_part1(VerilogPrimeParser.Edge_input_list_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_indicator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_indicator(VerilogPrimeParser.Edge_indicatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#current_state}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCurrent_state(VerilogPrimeParser.Current_stateContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#next_state}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNext_state(VerilogPrimeParser.Next_stateContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#output_symbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutput_symbol(VerilogPrimeParser.Output_symbolContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#level_symbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLevel_symbol(VerilogPrimeParser.Level_symbolContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_symbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_symbol(VerilogPrimeParser.Edge_symbolContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_instantiation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_instantiation(VerilogPrimeParser.Udp_instantiationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_instance(VerilogPrimeParser.Udp_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#continuous_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitContinuous_assign(VerilogPrimeParser.Continuous_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_net_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_net_assignments(VerilogPrimeParser.List_of_net_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_variable_assignments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_variable_assignments(VerilogPrimeParser.List_of_variable_assignmentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_alias}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_alias(VerilogPrimeParser.Net_aliasContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_assignment(VerilogPrimeParser.Net_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#initial_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInitial_construct(VerilogPrimeParser.Initial_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#always_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlways_construct(VerilogPrimeParser.Always_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#always_keyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlways_keyword(VerilogPrimeParser.Always_keywordContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#final_construct}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFinal_construct(VerilogPrimeParser.Final_constructContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#blocking_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlocking_assignment(VerilogPrimeParser.Blocking_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#operator_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOperator_assignment(VerilogPrimeParser.Operator_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_operator(VerilogPrimeParser.Assignment_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nonblocking_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNonblocking_assignment(VerilogPrimeParser.Nonblocking_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#procedural_continuous_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcedural_continuous_assignment(VerilogPrimeParser.Procedural_continuous_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#action_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAction_block(VerilogPrimeParser.Action_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#seq_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSeq_block(VerilogPrimeParser.Seq_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#seq_block_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSeq_block_part1(VerilogPrimeParser.Seq_block_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#par_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPar_block(VerilogPrimeParser.Par_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#par_block_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPar_block_part1(VerilogPrimeParser.Par_block_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#join_keyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJoin_keyword(VerilogPrimeParser.Join_keywordContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#statement_or_null}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement_or_null(VerilogPrimeParser.Statement_or_nullContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement(VerilogPrimeParser.StatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#statement_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement_item(VerilogPrimeParser.Statement_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_statement(VerilogPrimeParser.Function_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_statement_or_null}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_statement_or_null(VerilogPrimeParser.Function_statement_or_nullContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_identifier_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_identifier_list(VerilogPrimeParser.Variable_identifier_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcedural_timing_control_statement(VerilogPrimeParser.Procedural_timing_control_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delay_or_event_control}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelay_or_event_control(VerilogPrimeParser.Delay_or_event_controlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delay_control}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelay_control(VerilogPrimeParser.Delay_controlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#event_control}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEvent_control(VerilogPrimeParser.Event_controlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#event_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEvent_expression(VerilogPrimeParser.Event_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#procedural_timing_control}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcedural_timing_control(VerilogPrimeParser.Procedural_timing_controlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#jump_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJump_statement(VerilogPrimeParser.Jump_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#wait_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWait_statement(VerilogPrimeParser.Wait_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#event_trigger}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEvent_trigger(VerilogPrimeParser.Event_triggerContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#disable_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDisable_statement(VerilogPrimeParser.Disable_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#conditional_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConditional_statement(VerilogPrimeParser.Conditional_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unique_priority}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnique_priority(VerilogPrimeParser.Unique_priorityContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_statement(VerilogPrimeParser.Case_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_keyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_keyword(VerilogPrimeParser.Case_keywordContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_expression(VerilogPrimeParser.Case_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_item(VerilogPrimeParser.Case_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_pattern_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_pattern_item(VerilogPrimeParser.Case_pattern_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_inside_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_inside_item(VerilogPrimeParser.Case_inside_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_item_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_item_expression(VerilogPrimeParser.Case_item_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randcase_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandcase_statement(VerilogPrimeParser.Randcase_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randcase_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandcase_item(VerilogPrimeParser.Randcase_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pattern}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPattern(VerilogPrimeParser.PatternContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern(VerilogPrimeParser.Assignment_patternContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#structure_pattern_key}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStructure_pattern_key(VerilogPrimeParser.Structure_pattern_keyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#array_pattern_key}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray_pattern_key(VerilogPrimeParser.Array_pattern_keyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_key}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern_key(VerilogPrimeParser.Assignment_pattern_keyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_assignment(VerilogPrimeParser.Variable_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern_expression(VerilogPrimeParser.Assignment_pattern_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_expression_type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern_expression_type(VerilogPrimeParser.Assignment_pattern_expression_typeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_assignment_pattern_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_assignment_pattern_expression(VerilogPrimeParser.Constant_assignment_pattern_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_net_lvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern_net_lvalue(VerilogPrimeParser.Assignment_pattern_net_lvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignment_pattern_variable_lvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment_pattern_variable_lvalue(VerilogPrimeParser.Assignment_pattern_variable_lvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#loop_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop_statement(VerilogPrimeParser.Loop_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#for_initialization}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor_initialization(VerilogPrimeParser.For_initializationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#for_variable_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor_variable_declaration(VerilogPrimeParser.For_variable_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#for_step}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor_step(VerilogPrimeParser.For_stepContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#for_step_assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor_step_assignment(VerilogPrimeParser.For_step_assignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#loop_variables}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop_variables(VerilogPrimeParser.Loop_variablesContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#loop_variables_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop_variables_part1(VerilogPrimeParser.Loop_variables_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#subroutine_call_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubroutine_call_statement(VerilogPrimeParser.Subroutine_call_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assertion_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertion_item(VerilogPrimeParser.Assertion_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeferred_immediate_assertion_item(VerilogPrimeParser.Deferred_immediate_assertion_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#procedural_assertion_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcedural_assertion_statement(VerilogPrimeParser.Procedural_assertion_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#immediate_assertion_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImmediate_assertion_statement(VerilogPrimeParser.Immediate_assertion_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_immediate_assertion_statement(VerilogPrimeParser.Simple_immediate_assertion_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assert_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_immediate_assert_statement(VerilogPrimeParser.Simple_immediate_assert_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_assume_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_immediate_assume_statement(VerilogPrimeParser.Simple_immediate_assume_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_immediate_cover_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_immediate_cover_statement(VerilogPrimeParser.Simple_immediate_cover_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assertion_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeferred_immediate_assertion_statement(VerilogPrimeParser.Deferred_immediate_assertion_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assert_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeferred_immediate_assert_statement(VerilogPrimeParser.Deferred_immediate_assert_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_assume_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeferred_immediate_assume_statement(VerilogPrimeParser.Deferred_immediate_assume_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deferred_immediate_cover_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeferred_immediate_cover_statement(VerilogPrimeParser.Deferred_immediate_cover_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_declaration(VerilogPrimeParser.Clocking_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_declaration_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_declaration_part1(VerilogPrimeParser.Clocking_declaration_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_event(VerilogPrimeParser.Clocking_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_item(VerilogPrimeParser.Clocking_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#default_skew}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefault_skew(VerilogPrimeParser.Default_skewContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_direction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_direction(VerilogPrimeParser.Clocking_directionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_direction_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_direction_part1(VerilogPrimeParser.Clocking_direction_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_clocking_decl_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_clocking_decl_assign(VerilogPrimeParser.List_of_clocking_decl_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_decl_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_decl_assign(VerilogPrimeParser.Clocking_decl_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_skew}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_skew(VerilogPrimeParser.Clocking_skewContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_drive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_drive(VerilogPrimeParser.Clocking_driveContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cycle_delay}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCycle_delay(VerilogPrimeParser.Cycle_delayContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clockvar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClockvar(VerilogPrimeParser.ClockvarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clockvar_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClockvar_expression(VerilogPrimeParser.Clockvar_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randsequence_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandsequence_statement(VerilogPrimeParser.Randsequence_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#production}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProduction(VerilogPrimeParser.ProductionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_rule}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_rule(VerilogPrimeParser.Rs_ruleContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_production_list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_production_list(VerilogPrimeParser.Rs_production_listContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#weight_specification}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWeight_specification(VerilogPrimeParser.Weight_specificationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_code_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_code_block(VerilogPrimeParser.Rs_code_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_prod}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_prod(VerilogPrimeParser.Rs_prodContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#production_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProduction_item(VerilogPrimeParser.Production_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_if_else}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_if_else(VerilogPrimeParser.Rs_if_elseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_repeat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_repeat(VerilogPrimeParser.Rs_repeatContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_case}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_case(VerilogPrimeParser.Rs_caseContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rs_case_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRs_case_item(VerilogPrimeParser.Rs_case_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specify_block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecify_block(VerilogPrimeParser.Specify_blockContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specify_item}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecify_item(VerilogPrimeParser.Specify_itemContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulsestyle_declaration(VerilogPrimeParser.Pulsestyle_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#showcancelled_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitShowcancelled_declaration(VerilogPrimeParser.Showcancelled_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#path_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPath_declaration(VerilogPrimeParser.Path_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_path_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_path_declaration(VerilogPrimeParser.Simple_path_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parallel_path_description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParallel_path_description(VerilogPrimeParser.Parallel_path_descriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#full_path_description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFull_path_description(VerilogPrimeParser.Full_path_descriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_path_inputs}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_path_inputs(VerilogPrimeParser.List_of_path_inputsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_path_outputs}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_path_outputs(VerilogPrimeParser.List_of_path_outputsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specify_input_terminal_descriptor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecify_input_terminal_descriptor(VerilogPrimeParser.Specify_input_terminal_descriptorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specify_output_terminal_descriptor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecify_output_terminal_descriptor(VerilogPrimeParser.Specify_output_terminal_descriptorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#input_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInput_identifier(VerilogPrimeParser.Input_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#output_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutput_identifier(VerilogPrimeParser.Output_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#path_delay_value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPath_delay_value(VerilogPrimeParser.Path_delay_valueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_path_delay_expressions}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_path_delay_expressions(VerilogPrimeParser.List_of_path_delay_expressionsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT_path_delay_expression(VerilogPrimeParser.T_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#trise_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTrise_path_delay_expression(VerilogPrimeParser.Trise_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tfall_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTfall_path_delay_expression(VerilogPrimeParser.Tfall_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tz_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTz_path_delay_expression(VerilogPrimeParser.Tz_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t01_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT01_path_delay_expression(VerilogPrimeParser.T01_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t10_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT10_path_delay_expression(VerilogPrimeParser.T10_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t0z_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT0z_path_delay_expression(VerilogPrimeParser.T0z_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tz1_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTz1_path_delay_expression(VerilogPrimeParser.Tz1_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t1z_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT1z_path_delay_expression(VerilogPrimeParser.T1z_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tz0_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTz0_path_delay_expression(VerilogPrimeParser.Tz0_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t0x_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT0x_path_delay_expression(VerilogPrimeParser.T0x_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tx1_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTx1_path_delay_expression(VerilogPrimeParser.Tx1_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#t1x_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitT1x_path_delay_expression(VerilogPrimeParser.T1x_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tx0_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTx0_path_delay_expression(VerilogPrimeParser.Tx0_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#txz_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTxz_path_delay_expression(VerilogPrimeParser.Txz_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tzx_path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTzx_path_delay_expression(VerilogPrimeParser.Tzx_path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#path_delay_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPath_delay_expression(VerilogPrimeParser.Path_delay_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_sensitive_path_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_sensitive_path_declaration(VerilogPrimeParser.Edge_sensitive_path_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parallel_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParallel_edge_sensitive_path_description(VerilogPrimeParser.Parallel_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#full_edge_sensitive_path_description}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFull_edge_sensitive_path_description(VerilogPrimeParser.Full_edge_sensitive_path_descriptionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_source_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_source_expression(VerilogPrimeParser.Data_source_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_identifier(VerilogPrimeParser.Edge_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#state_dependent_path_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitState_dependent_path_declaration(VerilogPrimeParser.State_dependent_path_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#polarity_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPolarity_operator(VerilogPrimeParser.Polarity_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#system_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSystem_timing_check(VerilogPrimeParser.System_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#setup_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSetup_timing_check(VerilogPrimeParser.Setup_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hold_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHold_timing_check(VerilogPrimeParser.Hold_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#setuphold_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSetuphold_timing_check(VerilogPrimeParser.Setuphold_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#recovery_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRecovery_timing_check(VerilogPrimeParser.Recovery_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#removal_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRemoval_timing_check(VerilogPrimeParser.Removal_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#recrem_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRecrem_timing_check(VerilogPrimeParser.Recrem_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#skew_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSkew_timing_check(VerilogPrimeParser.Skew_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timeskew_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimeskew_timing_check(VerilogPrimeParser.Timeskew_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#fullskew_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFullskew_timing_check(VerilogPrimeParser.Fullskew_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#period_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPeriod_timing_check(VerilogPrimeParser.Period_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#width_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWidth_timing_check(VerilogPrimeParser.Width_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nochange_timing_check}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNochange_timing_check(VerilogPrimeParser.Nochange_timing_checkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timecheck_condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimecheck_condition(VerilogPrimeParser.Timecheck_conditionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#controlled_reference_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitControlled_reference_event(VerilogPrimeParser.Controlled_reference_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#data_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitData_event(VerilogPrimeParser.Data_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delayed_data}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelayed_data(VerilogPrimeParser.Delayed_dataContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#delayed_reference}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDelayed_reference(VerilogPrimeParser.Delayed_referenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#end_edge_offset}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnd_edge_offset(VerilogPrimeParser.End_edge_offsetContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#event_based_flag}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEvent_based_flag(VerilogPrimeParser.Event_based_flagContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#notifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotifier(VerilogPrimeParser.NotifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#reference_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReference_event(VerilogPrimeParser.Reference_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#remain_active_flag}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRemain_active_flag(VerilogPrimeParser.Remain_active_flagContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timestamp_condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimestamp_condition(VerilogPrimeParser.Timestamp_conditionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#start_edge_offset}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStart_edge_offset(VerilogPrimeParser.Start_edge_offsetContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#threshold}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThreshold(VerilogPrimeParser.ThresholdContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timing_check_limit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTiming_check_limit(VerilogPrimeParser.Timing_check_limitContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timing_check_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTiming_check_event(VerilogPrimeParser.Timing_check_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#controlled_timing_check_event}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitControlled_timing_check_event(VerilogPrimeParser.Controlled_timing_check_eventContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timing_check_event_control}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTiming_check_event_control(VerilogPrimeParser.Timing_check_event_controlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specify_terminal_descriptor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecify_terminal_descriptor(VerilogPrimeParser.Specify_terminal_descriptorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_control_specifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_control_specifier(VerilogPrimeParser.Edge_control_specifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_descriptor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_descriptor(VerilogPrimeParser.Edge_descriptorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timing_check_condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTiming_check_condition(VerilogPrimeParser.Timing_check_conditionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#scalar_timing_check_condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitScalar_timing_check_condition(VerilogPrimeParser.Scalar_timing_check_conditionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#scalar_constant}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitScalar_constant(VerilogPrimeParser.Scalar_constantContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConcatenation(VerilogPrimeParser.ConcatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_concatenation(VerilogPrimeParser.Constant_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_multiple_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_multiple_concatenation(VerilogPrimeParser.Constant_multiple_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_concatenation(VerilogPrimeParser.Module_path_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_multiple_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_multiple_concatenation(VerilogPrimeParser.Module_path_multiple_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#multiple_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMultiple_concatenation(VerilogPrimeParser.Multiple_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#streaming_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStreaming_concatenation(VerilogPrimeParser.Streaming_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stream_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStream_operator(VerilogPrimeParser.Stream_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#slice_size}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlice_size(VerilogPrimeParser.Slice_sizeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stream_concatenation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStream_concatenation(VerilogPrimeParser.Stream_concatenationContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stream_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStream_expression(VerilogPrimeParser.Stream_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#array_range_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray_range_expression(VerilogPrimeParser.Array_range_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#empty_queue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEmpty_queue(VerilogPrimeParser.Empty_queueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_function_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_function_call(VerilogPrimeParser.Constant_function_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_call(VerilogPrimeParser.Tf_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#system_tf_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSystem_tf_call(VerilogPrimeParser.System_tf_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#subroutine_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubroutine_call(VerilogPrimeParser.Subroutine_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_subroutine_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_subroutine_call(VerilogPrimeParser.Function_subroutine_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_arguments(VerilogPrimeParser.List_of_argumentsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_arguments_part1(VerilogPrimeParser.List_of_arguments_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#list_of_arguments_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList_of_arguments_part2(VerilogPrimeParser.List_of_arguments_part2Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_call(VerilogPrimeParser.Method_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_call_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_call_body(VerilogPrimeParser.Method_call_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#built_in_method_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBuilt_in_method_call(VerilogPrimeParser.Built_in_method_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#array_manipulation_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray_manipulation_call(VerilogPrimeParser.Array_manipulation_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randomize_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandomize_call(VerilogPrimeParser.Randomize_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_call_root}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_call_root(VerilogPrimeParser.Method_call_rootContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#array_method_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray_method_name(VerilogPrimeParser.Array_method_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInc_or_dec_expression(VerilogPrimeParser.Inc_or_dec_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInc_or_dec_expression_part1(VerilogPrimeParser.Inc_or_dec_expression_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_expression_part2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInc_or_dec_expression_part2(VerilogPrimeParser.Inc_or_dec_expression_part2Context ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_st_st(VerilogPrimeParser.Const_expr_st_stContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_equality}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_equality(VerilogPrimeParser.Const_expr_equalityContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_binary_xor(VerilogPrimeParser.Const_expr_binary_xorContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_unary_op(VerilogPrimeParser.Const_expr_unary_opContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_comp}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_comp(VerilogPrimeParser.Const_expr_compContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_binary_or(VerilogPrimeParser.Const_expr_binary_orContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_log_or(VerilogPrimeParser.Const_expr_log_orContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_log_and(VerilogPrimeParser.Const_expr_log_andContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_binary_and(VerilogPrimeParser.Const_expr_binary_andContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_conditional}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_conditional(VerilogPrimeParser.Const_expr_conditionalContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_mutl}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_mutl(VerilogPrimeParser.Const_expr_mutlContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_add}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_add(VerilogPrimeParser.Const_expr_addContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_only_primary(VerilogPrimeParser.Const_expr_only_primaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code const_expr_shift}
	 * labeled alternative in {@link VerilogPrimeParser#constant_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expr_shift(VerilogPrimeParser.Const_expr_shiftContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_mintypmax_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_mintypmax_expression(VerilogPrimeParser.Constant_mintypmax_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_param_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_param_expression(VerilogPrimeParser.Constant_param_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#param_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParam_expression(VerilogPrimeParser.Param_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_range_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_range_expression(VerilogPrimeParser.Constant_range_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_part_select_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_part_select_range(VerilogPrimeParser.Constant_part_select_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_range(VerilogPrimeParser.Constant_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_indexed_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_indexed_range(VerilogPrimeParser.Constant_indexed_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#expr_}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpr_(VerilogPrimeParser.Expr_Context ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_shift}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_shift(VerilogPrimeParser.Expression_shiftContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_binary_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_binary_or(VerilogPrimeParser.Expression_binary_orContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_mult}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_mult(VerilogPrimeParser.Expression_multContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_only_primary}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_only_primary(VerilogPrimeParser.Expression_only_primaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_log_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_log_and(VerilogPrimeParser.Expression_log_andContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_inside_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_inside_exp(VerilogPrimeParser.Expression_inside_expContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_op_assign}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_op_assign(VerilogPrimeParser.Expression_op_assignContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_comp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_comp(VerilogPrimeParser.Expression_compContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_tagged_union}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_tagged_union(VerilogPrimeParser.Expression_tagged_unionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_equality}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_equality(VerilogPrimeParser.Expression_equalityContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_log_or}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_log_or(VerilogPrimeParser.Expression_log_orContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_add}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_add(VerilogPrimeParser.Expression_addContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_inc_or_dec}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_inc_or_dec(VerilogPrimeParser.Expression_inc_or_decContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_st_st}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_st_st(VerilogPrimeParser.Expression_st_stContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_binary_and}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_binary_and(VerilogPrimeParser.Expression_binary_andContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_conditional_exp}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_conditional_exp(VerilogPrimeParser.Expression_conditional_expContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_binary_xor}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_binary_xor(VerilogPrimeParser.Expression_binary_xorContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_unary_op}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_unary_op(VerilogPrimeParser.Expression_unary_opContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expression_static_casting}
	 * labeled alternative in {@link VerilogPrimeParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression_static_casting(VerilogPrimeParser.Expression_static_castingContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#matches_pattern}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMatches_pattern(VerilogPrimeParser.Matches_patternContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tagged_union_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTagged_union_expression(VerilogPrimeParser.Tagged_union_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#value_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitValue_range(VerilogPrimeParser.Value_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#mintypmax_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMintypmax_expression(VerilogPrimeParser.Mintypmax_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_expression(VerilogPrimeParser.Module_path_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_conditional_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_conditional_expression(VerilogPrimeParser.Module_path_conditional_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_binary_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_binary_expression(VerilogPrimeParser.Module_path_binary_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_unary_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_unary_expression(VerilogPrimeParser.Module_path_unary_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_mintypmax_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_mintypmax_expression(VerilogPrimeParser.Module_path_mintypmax_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#part_select_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPart_select_range(VerilogPrimeParser.Part_select_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#indexed_range}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIndexed_range(VerilogPrimeParser.Indexed_rangeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvar_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvar_expression(VerilogPrimeParser.Genvar_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_primary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_primary(VerilogPrimeParser.Constant_primaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_path_primary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_path_primary(VerilogPrimeParser.Module_path_primaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#primary_no_function_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrimary_no_function_call(VerilogPrimeParser.Primary_no_function_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#primary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrimary(VerilogPrimeParser.PrimaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_qualifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_qualifier(VerilogPrimeParser.Class_qualifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#range_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRange_expression(VerilogPrimeParser.Range_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#primary_literal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrimary_literal(VerilogPrimeParser.Primary_literalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#time_literal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTime_literal(VerilogPrimeParser.Time_literalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#implicit_class_handle}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImplicit_class_handle(VerilogPrimeParser.Implicit_class_handleContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bit_select}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBit_select(VerilogPrimeParser.Bit_selectContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#select}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSelect(VerilogPrimeParser.SelectContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nonrange_select}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNonrange_select(VerilogPrimeParser.Nonrange_selectContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_bit_select}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_bit_select(VerilogPrimeParser.Constant_bit_selectContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_select}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_select(VerilogPrimeParser.Constant_selectContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_cast}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_cast(VerilogPrimeParser.Constant_castContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constant_let_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstant_let_expression(VerilogPrimeParser.Constant_let_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cast}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCast(VerilogPrimeParser.CastContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_lvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_lvalue(VerilogPrimeParser.Net_lvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_lvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_lvalue(VerilogPrimeParser.Variable_lvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nonrange_variable_lvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNonrange_variable_lvalue(VerilogPrimeParser.Nonrange_variable_lvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unary_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnary_operator(VerilogPrimeParser.Unary_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#binary_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBinary_operator(VerilogPrimeParser.Binary_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inc_or_dec_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInc_or_dec_operator(VerilogPrimeParser.Inc_or_dec_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#increment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIncrement(VerilogPrimeParser.IncrementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#decrement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecrement(VerilogPrimeParser.DecrementContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unary_module_path_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnary_module_path_operator(VerilogPrimeParser.Unary_module_path_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#binary_module_path_operator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBinary_module_path_operator(VerilogPrimeParser.Binary_module_path_operatorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unbased_unsized_literal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnbased_unsized_literal(VerilogPrimeParser.Unbased_unsized_literalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#string_literal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitString_literal(VerilogPrimeParser.String_literalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attribute_instance}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttribute_instance(VerilogPrimeParser.Attribute_instanceContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attr_spec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttr_spec(VerilogPrimeParser.Attr_specContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attr_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttr_name(VerilogPrimeParser.Attr_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#array_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray_identifier(VerilogPrimeParser.Array_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#block_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock_identifier(VerilogPrimeParser.Block_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bin_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBin_identifier(VerilogPrimeParser.Bin_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#c_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitC_identifier(VerilogPrimeParser.C_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cell_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCell_identifier(VerilogPrimeParser.Cell_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checker_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChecker_identifier(VerilogPrimeParser.Checker_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_identifier(VerilogPrimeParser.Class_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#class_variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_variable_identifier(VerilogPrimeParser.Class_variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clocking_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClocking_identifier(VerilogPrimeParser.Clocking_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#config_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConfig_identifier(VerilogPrimeParser.Config_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#const_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_identifier(VerilogPrimeParser.Const_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraint_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraint_identifier(VerilogPrimeParser.Constraint_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#covergroup_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCovergroup_identifier(VerilogPrimeParser.Covergroup_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#covergroup_variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCovergroup_variable_identifier(VerilogPrimeParser.Covergroup_variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cover_point_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCover_point_identifier(VerilogPrimeParser.Cover_point_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cross_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCross_identifier(VerilogPrimeParser.Cross_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dynamic_array_variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDynamic_array_variable_identifier(VerilogPrimeParser.Dynamic_array_variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enum_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnum_identifier(VerilogPrimeParser.Enum_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#escaped_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEscaped_identifier(VerilogPrimeParser.Escaped_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#formal_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFormal_identifier(VerilogPrimeParser.Formal_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#function_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunction_identifier(VerilogPrimeParser.Function_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generate_block_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenerate_block_identifier(VerilogPrimeParser.Generate_block_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvar_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvar_identifier(VerilogPrimeParser.Genvar_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_array_identifier(VerilogPrimeParser.Hierarchical_array_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_block_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_block_identifier(VerilogPrimeParser.Hierarchical_block_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_event_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_event_identifier(VerilogPrimeParser.Hierarchical_event_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_identifier(VerilogPrimeParser.Hierarchical_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_net_identifier(VerilogPrimeParser.Hierarchical_net_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_parameter_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_parameter_identifier(VerilogPrimeParser.Hierarchical_parameter_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_property_identifier(VerilogPrimeParser.Hierarchical_property_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_sequence_identifier(VerilogPrimeParser.Hierarchical_sequence_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_task_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_task_identifier(VerilogPrimeParser.Hierarchical_task_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_tf_identifier(VerilogPrimeParser.Hierarchical_tf_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hierarchical_variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHierarchical_variable_identifier(VerilogPrimeParser.Hierarchical_variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifier(VerilogPrimeParser.IdentifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#index_variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIndex_variable_identifier(VerilogPrimeParser.Index_variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_identifier(VerilogPrimeParser.Interface_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interface_instance_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterface_instance_identifier(VerilogPrimeParser.Interface_instance_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inout_port_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInout_port_identifier(VerilogPrimeParser.Inout_port_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#input_port_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInput_port_identifier(VerilogPrimeParser.Input_port_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#instance_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstance_identifier(VerilogPrimeParser.Instance_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#library_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLibrary_identifier(VerilogPrimeParser.Library_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#member_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMember_identifier(VerilogPrimeParser.Member_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#method_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethod_identifier(VerilogPrimeParser.Method_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modport_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModport_identifier(VerilogPrimeParser.Modport_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#module_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModule_identifier(VerilogPrimeParser.Module_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#net_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNet_identifier(VerilogPrimeParser.Net_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#output_port_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutput_port_identifier(VerilogPrimeParser.Output_port_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_identifier(VerilogPrimeParser.Package_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#package_scope}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackage_scope(VerilogPrimeParser.Package_scopeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameter_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter_identifier(VerilogPrimeParser.Parameter_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#port_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPort_identifier(VerilogPrimeParser.Port_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#production_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProduction_identifier(VerilogPrimeParser.Production_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#program_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram_identifier(VerilogPrimeParser.Program_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#property_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProperty_identifier(VerilogPrimeParser.Property_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_class_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_class_identifier(VerilogPrimeParser.Ps_class_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_covergroup_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_covergroup_identifier(VerilogPrimeParser.Ps_covergroup_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_identifier(VerilogPrimeParser.Ps_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_array_identifier(VerilogPrimeParser.Ps_or_hierarchical_array_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_array_identifier_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_array_identifier_part1(VerilogPrimeParser.Ps_or_hierarchical_array_identifier_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_net_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_net_identifier(VerilogPrimeParser.Ps_or_hierarchical_net_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_property_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_property_identifier(VerilogPrimeParser.Ps_or_hierarchical_property_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_sequence_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_sequence_identifier(VerilogPrimeParser.Ps_or_hierarchical_sequence_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_or_hierarchical_tf_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_or_hierarchical_tf_identifier(VerilogPrimeParser.Ps_or_hierarchical_tf_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_parameter_identifier(VerilogPrimeParser.Ps_parameter_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_parameter_identifier_part1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_parameter_identifier_part1(VerilogPrimeParser.Ps_parameter_identifier_part1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ps_type_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPs_type_identifier(VerilogPrimeParser.Ps_type_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequence_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequence_identifier(VerilogPrimeParser.Sequence_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#signal_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSignal_identifier(VerilogPrimeParser.Signal_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#simple_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimple_identifier(VerilogPrimeParser.Simple_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specparam_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecparam_identifier(VerilogPrimeParser.Specparam_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#system_tf_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSystem_tf_identifier(VerilogPrimeParser.System_tf_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#task_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTask_identifier(VerilogPrimeParser.Task_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_identifier(VerilogPrimeParser.Tf_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#terminal_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTerminal_identifier(VerilogPrimeParser.Terminal_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#topmodule_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTopmodule_identifier(VerilogPrimeParser.Topmodule_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#type_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_identifier(VerilogPrimeParser.Type_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#udp_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUdp_identifier(VerilogPrimeParser.Udp_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bins_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBins_identifier(VerilogPrimeParser.Bins_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#variable_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable_identifier(VerilogPrimeParser.Variable_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumber(VerilogPrimeParser.NumberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#eof}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEof(VerilogPrimeParser.EofContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endmodulestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndmodulestr(VerilogPrimeParser.EndmodulestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#colon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitColon(VerilogPrimeParser.ColonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#externstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExternstr(VerilogPrimeParser.ExternstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#semi}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSemi(VerilogPrimeParser.SemiContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modulestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModulestr(VerilogPrimeParser.ModulestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#macromodulestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMacromodulestr(VerilogPrimeParser.MacromodulestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endinterfacestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndinterfacestr(VerilogPrimeParser.EndinterfacestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#interfacestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterfacestr(VerilogPrimeParser.InterfacestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLparen(VerilogPrimeParser.LparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dotstar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDotstar(VerilogPrimeParser.DotstarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRparen(VerilogPrimeParser.RparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endprogramstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndprogramstr(VerilogPrimeParser.EndprogramstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#programstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgramstr(VerilogPrimeParser.ProgramstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#checkerstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCheckerstr(VerilogPrimeParser.CheckerstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endcheckerstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndcheckerstr(VerilogPrimeParser.EndcheckerstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#virtualstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVirtualstr(VerilogPrimeParser.VirtualstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#classstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClassstr(VerilogPrimeParser.ClassstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#extendsstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExtendsstr(VerilogPrimeParser.ExtendsstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endclassstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndclassstr(VerilogPrimeParser.EndclassstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#packagestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackagestr(VerilogPrimeParser.PackagestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endpackagestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndpackagestr(VerilogPrimeParser.EndpackagestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timeunit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimeunit(VerilogPrimeParser.TimeunitContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#div}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDiv(VerilogPrimeParser.DivContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hash}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash(VerilogPrimeParser.HashContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#comma}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComma(VerilogPrimeParser.CommaContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#typestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypestr(VerilogPrimeParser.TypestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dot}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDot(VerilogPrimeParser.DotContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lcurl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLcurl(VerilogPrimeParser.LcurlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rcurl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRcurl(VerilogPrimeParser.RcurlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inputstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInputstr(VerilogPrimeParser.InputstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#outputstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOutputstr(VerilogPrimeParser.OutputstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#inoutstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInoutstr(VerilogPrimeParser.InoutstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#refstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRefstr(VerilogPrimeParser.RefstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssign(VerilogPrimeParser.AssignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarfatalstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarfatalstr(VerilogPrimeParser.DollarfatalstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarerrorstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarerrorstr(VerilogPrimeParser.DollarerrorstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarwarningstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarwarningstr(VerilogPrimeParser.DollarwarningstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarinfostr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarinfostr(VerilogPrimeParser.DollarinfostrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#defparamstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefparamstr(VerilogPrimeParser.DefparamstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bindstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBindstr(VerilogPrimeParser.BindstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#configstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConfigstr(VerilogPrimeParser.ConfigstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endconfigstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndconfigstr(VerilogPrimeParser.EndconfigstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#designstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDesignstr(VerilogPrimeParser.DesignstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#defaultstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefaultstr(VerilogPrimeParser.DefaultstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#instancestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstancestr(VerilogPrimeParser.InstancestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cellstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCellstr(VerilogPrimeParser.CellstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#libliststr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLibliststr(VerilogPrimeParser.LibliststrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#usestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUsestr(VerilogPrimeParser.UsestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#clockingstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClockingstr(VerilogPrimeParser.ClockingstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#disablestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDisablestr(VerilogPrimeParser.DisablestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#iffstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIffstr(VerilogPrimeParser.IffstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#forkjoinstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForkjoinstr(VerilogPrimeParser.ForkjoinstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#alwaysstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlwaysstr(VerilogPrimeParser.AlwaysstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#conststr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConststr(VerilogPrimeParser.ConststrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#functionstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionstr(VerilogPrimeParser.FunctionstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#newstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNewstr(VerilogPrimeParser.NewstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#staticstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStaticstr(VerilogPrimeParser.StaticstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#protectedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProtectedstr(VerilogPrimeParser.ProtectedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#localstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalstr(VerilogPrimeParser.LocalstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandstr(VerilogPrimeParser.RandstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randcstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandcstr(VerilogPrimeParser.RandcstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#purestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPurestr(VerilogPrimeParser.PurestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#superstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSuperstr(VerilogPrimeParser.SuperstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endfunctionstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndfunctionstr(VerilogPrimeParser.EndfunctionstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#constraintstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstraintstr(VerilogPrimeParser.ConstraintstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#solvestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSolvestr(VerilogPrimeParser.SolvestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#beforestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBeforestr(VerilogPrimeParser.BeforestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#derive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDerive(VerilogPrimeParser.DeriveContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ifstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfstr(VerilogPrimeParser.IfstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#elsestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElsestr(VerilogPrimeParser.ElsestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#foreachstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForeachstr(VerilogPrimeParser.ForeachstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lbrack}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLbrack(VerilogPrimeParser.LbrackContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rbrack}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRbrack(VerilogPrimeParser.RbrackContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#colonequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitColonequals(VerilogPrimeParser.ColonequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#colonslash}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitColonslash(VerilogPrimeParser.ColonslashContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#localparamstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalparamstr(VerilogPrimeParser.LocalparamstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#parameterstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterstr(VerilogPrimeParser.ParameterstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specparamstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecparamstr(VerilogPrimeParser.SpecparamstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#varstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVarstr(VerilogPrimeParser.VarstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#importstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImportstr(VerilogPrimeParser.ImportstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coloncolon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitColoncolon(VerilogPrimeParser.ColoncolonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#star}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStar(VerilogPrimeParser.StarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#export}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExport(VerilogPrimeParser.ExportContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#startcoloncolonstar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStartcoloncolonstar(VerilogPrimeParser.StartcoloncolonstarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#genvarstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGenvarstr(VerilogPrimeParser.GenvarstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#vectoredstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVectoredstr(VerilogPrimeParser.VectoredstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#scalaredstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitScalaredstr(VerilogPrimeParser.ScalaredstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#typedefstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypedefstr(VerilogPrimeParser.TypedefstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#enumstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnumstr(VerilogPrimeParser.EnumstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#structstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStructstr(VerilogPrimeParser.StructstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unionstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnionstr(VerilogPrimeParser.UnionstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#automaticstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAutomaticstr(VerilogPrimeParser.AutomaticstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stringstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStringstr(VerilogPrimeParser.StringstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#packedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPackedstr(VerilogPrimeParser.PackedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#chandlestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitChandlestr(VerilogPrimeParser.ChandlestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#eventstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEventstr(VerilogPrimeParser.EventstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#zero_or_one}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitZero_or_one(VerilogPrimeParser.Zero_or_oneContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edge_spec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdge_spec(VerilogPrimeParser.Edge_specContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#decimal_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecimal_number(VerilogPrimeParser.Decimal_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bytestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBytestr(VerilogPrimeParser.BytestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#shortintstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitShortintstr(VerilogPrimeParser.ShortintstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#intstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIntstr(VerilogPrimeParser.IntstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#longintstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLongintstr(VerilogPrimeParser.LongintstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#integerstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIntegerstr(VerilogPrimeParser.IntegerstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#timestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTimestr(VerilogPrimeParser.TimestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bitstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBitstr(VerilogPrimeParser.BitstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#logicstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLogicstr(VerilogPrimeParser.LogicstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#regstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRegstr(VerilogPrimeParser.RegstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#shortreal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitShortreal(VerilogPrimeParser.ShortrealContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#realstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRealstr(VerilogPrimeParser.RealstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#realtimestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRealtimestr(VerilogPrimeParser.RealtimestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#supply0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSupply0str(VerilogPrimeParser.Supply0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#supply1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSupply1str(VerilogPrimeParser.Supply1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tristr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTristr(VerilogPrimeParser.TristrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#triandstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTriandstr(VerilogPrimeParser.TriandstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#triorstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTriorstr(VerilogPrimeParser.TriorstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#triregstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTriregstr(VerilogPrimeParser.TriregstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tri0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTri0str(VerilogPrimeParser.Tri0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tri1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTri1str(VerilogPrimeParser.Tri1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#uwirestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUwirestr(VerilogPrimeParser.UwirestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#wirestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWirestr(VerilogPrimeParser.WirestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#wandstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWandstr(VerilogPrimeParser.WandstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#worstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWorstr(VerilogPrimeParser.WorstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#signedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSignedstr(VerilogPrimeParser.SignedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unsignedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnsignedstr(VerilogPrimeParser.UnsignedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#voidstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVoidstr(VerilogPrimeParser.VoidstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#taggedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTaggedstr(VerilogPrimeParser.TaggedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#highz1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHighz1str(VerilogPrimeParser.Highz1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#highz0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHighz0str(VerilogPrimeParser.Highz0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#strong0}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStrong0(VerilogPrimeParser.Strong0Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pull0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPull0str(VerilogPrimeParser.Pull0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#weak0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWeak0str(VerilogPrimeParser.Weak0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#strong1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStrong1(VerilogPrimeParser.Strong1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pull1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPull1str(VerilogPrimeParser.Pull1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#weak1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWeak1str(VerilogPrimeParser.Weak1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#smallstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSmallstr(VerilogPrimeParser.SmallstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#mediumstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMediumstr(VerilogPrimeParser.MediumstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#largestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLargestr(VerilogPrimeParser.LargestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#real_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReal_number(VerilogPrimeParser.Real_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#onestepstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOnestepstr(VerilogPrimeParser.OnestepstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pathpulsedollar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPathpulsedollar(VerilogPrimeParser.PathpulsedollarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollar(VerilogPrimeParser.DollarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#taskstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTaskstr(VerilogPrimeParser.TaskstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing2str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_spec_ing2str(VerilogPrimeParser.Dpi_spec_ing2strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dpi_spec_ing1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDpi_spec_ing1str(VerilogPrimeParser.Dpi_spec_ing1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#contextstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitContextstr(VerilogPrimeParser.ContextstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endtaskstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndtaskstr(VerilogPrimeParser.EndtaskstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#plus}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPlus(VerilogPrimeParser.PlusContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#minus}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMinus(VerilogPrimeParser.MinusContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#starstar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStarstar(VerilogPrimeParser.StarstarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modulo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModulo(VerilogPrimeParser.ModuloContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#equals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEquals(VerilogPrimeParser.EqualsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#not_equals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNot_equals(VerilogPrimeParser.Not_equalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLt(VerilogPrimeParser.LtContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#le}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLe(VerilogPrimeParser.LeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#gt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGt(VerilogPrimeParser.GtContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ge}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGe(VerilogPrimeParser.GeContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#modportstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModportstr(VerilogPrimeParser.ModportstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assertstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertstr(VerilogPrimeParser.AssertstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#propertystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPropertystr(VerilogPrimeParser.PropertystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assumestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssumestr(VerilogPrimeParser.AssumestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverstr(VerilogPrimeParser.CoverstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#expectstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpectstr(VerilogPrimeParser.ExpectstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#sequencestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSequencestr(VerilogPrimeParser.SequencestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#restrictstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRestrictstr(VerilogPrimeParser.RestrictstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endpropertystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndpropertystr(VerilogPrimeParser.EndpropertystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#casestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCasestr(VerilogPrimeParser.CasestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endcasestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndcasestr(VerilogPrimeParser.EndcasestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#notstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotstr(VerilogPrimeParser.NotstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#orstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrstr(VerilogPrimeParser.OrstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#andstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAndstr(VerilogPrimeParser.AndstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#orderive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrderive(VerilogPrimeParser.OrderiveContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#orimplies}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrimplies(VerilogPrimeParser.OrimpliesContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endsequencestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndsequencestr(VerilogPrimeParser.EndsequencestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#untypedstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUntypedstr(VerilogPrimeParser.UntypedstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#intersectstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIntersectstr(VerilogPrimeParser.IntersectstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#first_matchstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFirst_matchstr(VerilogPrimeParser.First_matchstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#throughoutstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThroughoutstr(VerilogPrimeParser.ThroughoutstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#withinstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWithinstr(VerilogPrimeParser.WithinstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#double_hash}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDouble_hash(VerilogPrimeParser.Double_hashContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#diststr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDiststr(VerilogPrimeParser.DiststrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#letstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLetstr(VerilogPrimeParser.LetstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#covergroupstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCovergroupstr(VerilogPrimeParser.CovergroupstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endgroupstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndgroupstr(VerilogPrimeParser.EndgroupstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#optiondot}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOptiondot(VerilogPrimeParser.OptiondotContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#type_optiondot}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_optiondot(VerilogPrimeParser.Type_optiondotContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#withstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWithstr(VerilogPrimeParser.WithstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#samplestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSamplestr(VerilogPrimeParser.SamplestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attheratelparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttheratelparen(VerilogPrimeParser.AttheratelparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#beginstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBeginstr(VerilogPrimeParser.BeginstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndstr(VerilogPrimeParser.EndstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#coverpointstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCoverpointstr(VerilogPrimeParser.CoverpointstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#wildcardstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWildcardstr(VerilogPrimeParser.WildcardstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#binsstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBinsstr(VerilogPrimeParser.BinsstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#illegal_binsstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIllegal_binsstr(VerilogPrimeParser.Illegal_binsstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ignore_binsstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIgnore_binsstr(VerilogPrimeParser.Ignore_binsstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#implies}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImplies(VerilogPrimeParser.ImpliesContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#crossstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCrossstr(VerilogPrimeParser.CrossstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#not}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNot(VerilogPrimeParser.NotContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#log_and}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLog_and(VerilogPrimeParser.Log_andContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#log_or}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLog_or(VerilogPrimeParser.Log_orContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#binsofstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBinsofstr(VerilogPrimeParser.BinsofstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulldownstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulldownstr(VerilogPrimeParser.PulldownstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pullupstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPullupstr(VerilogPrimeParser.PullupstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#cmosstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCmosstr(VerilogPrimeParser.CmosstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rcmosstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRcmosstr(VerilogPrimeParser.RcmosstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bufif0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBufif0str(VerilogPrimeParser.Bufif0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bufif1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBufif1str(VerilogPrimeParser.Bufif1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#notif0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotif0str(VerilogPrimeParser.Notif0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#notif1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotif1str(VerilogPrimeParser.Notif1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nmosstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNmosstr(VerilogPrimeParser.NmosstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pmos}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPmos(VerilogPrimeParser.PmosContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rnmosstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRnmosstr(VerilogPrimeParser.RnmosstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rpmosstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRpmosstr(VerilogPrimeParser.RpmosstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nandstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNandstr(VerilogPrimeParser.NandstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#norstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNorstr(VerilogPrimeParser.NorstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xorstrstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXorstrstr(VerilogPrimeParser.XorstrstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xnorstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXnorstr(VerilogPrimeParser.XnorstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#bufstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBufstr(VerilogPrimeParser.BufstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tranif0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTranif0str(VerilogPrimeParser.Tranif0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tranif1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTranif1str(VerilogPrimeParser.Tranif1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rtranif1str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRtranif1str(VerilogPrimeParser.Rtranif1strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rtranif0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRtranif0str(VerilogPrimeParser.Rtranif0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#transtr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTranstr(VerilogPrimeParser.TranstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rtranstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRtranstr(VerilogPrimeParser.RtranstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#generatestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGeneratestr(VerilogPrimeParser.GeneratestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endgeneratestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndgeneratestr(VerilogPrimeParser.EndgeneratestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#forstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForstr(VerilogPrimeParser.ForstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#primitivestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrimitivestr(VerilogPrimeParser.PrimitivestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endprimitivestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndprimitivestr(VerilogPrimeParser.EndprimitivestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tablestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTablestr(VerilogPrimeParser.TablestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endtablestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndtablestr(VerilogPrimeParser.EndtablestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#initialstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInitialstr(VerilogPrimeParser.InitialstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#binary_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBinary_number(VerilogPrimeParser.Binary_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#questinmark}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitQuestinmark(VerilogPrimeParser.QuestinmarkContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#id}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitId(VerilogPrimeParser.IdContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#assignstrstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignstrstr(VerilogPrimeParser.AssignstrstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#aliasstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAliasstr(VerilogPrimeParser.AliasstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#always_combstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlways_combstr(VerilogPrimeParser.Always_combstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#always_latchstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlways_latchstr(VerilogPrimeParser.Always_latchstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#always_ffstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlways_ffstr(VerilogPrimeParser.Always_ffstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#finalstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFinalstr(VerilogPrimeParser.FinalstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#plusequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPlusequals(VerilogPrimeParser.PlusequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#minusequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMinusequals(VerilogPrimeParser.MinusequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#startequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStartequals(VerilogPrimeParser.StartequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#slashequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSlashequals(VerilogPrimeParser.SlashequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#percentileequal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPercentileequal(VerilogPrimeParser.PercentileequalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#andequals}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAndequals(VerilogPrimeParser.AndequalsContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#orequal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrequal(VerilogPrimeParser.OrequalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xorequal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXorequal(VerilogPrimeParser.XorequalContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lshift_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLshift_assign(VerilogPrimeParser.Lshift_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rshift_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRshift_assign(VerilogPrimeParser.Rshift_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unsigned_lshift_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnsigned_lshift_assign(VerilogPrimeParser.Unsigned_lshift_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unsigned_rshift_assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnsigned_rshift_assign(VerilogPrimeParser.Unsigned_rshift_assignContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#deassignstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeassignstr(VerilogPrimeParser.DeassignstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#forcestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForcestr(VerilogPrimeParser.ForcestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#releasestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReleasestr(VerilogPrimeParser.ReleasestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#forkstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForkstr(VerilogPrimeParser.ForkstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#joinstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJoinstr(VerilogPrimeParser.JoinstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#join_anystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJoin_anystr(VerilogPrimeParser.Join_anystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#join_namestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJoin_namestr(VerilogPrimeParser.Join_namestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#repeatstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeatstr(VerilogPrimeParser.RepeatstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attherate}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttherate(VerilogPrimeParser.AttherateContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#attheratestar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttheratestar(VerilogPrimeParser.AttheratestarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lparenstarrparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLparenstarrparen(VerilogPrimeParser.LparenstarrparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#returnstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReturnstr(VerilogPrimeParser.ReturnstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#breakstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBreakstr(VerilogPrimeParser.BreakstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#continuestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitContinuestr(VerilogPrimeParser.ContinuestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#waitstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWaitstr(VerilogPrimeParser.WaitstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#wait_orderstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWait_orderstr(VerilogPrimeParser.Wait_orderstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#derivegt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDerivegt(VerilogPrimeParser.DerivegtContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#uniquestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUniquestr(VerilogPrimeParser.UniquestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#unique0str}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnique0str(VerilogPrimeParser.Unique0strContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#prioritystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrioritystr(VerilogPrimeParser.PrioritystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#matchesstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMatchesstr(VerilogPrimeParser.MatchesstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#insidestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInsidestr(VerilogPrimeParser.InsidestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#casezstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCasezstr(VerilogPrimeParser.CasezstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#casexstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCasexstr(VerilogPrimeParser.CasexstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#andandand}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAndandand(VerilogPrimeParser.AndandandContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randcasestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandcasestr(VerilogPrimeParser.RandcasestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#escapelcurl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEscapelcurl(VerilogPrimeParser.EscapelcurlContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#foreverstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForeverstr(VerilogPrimeParser.ForeverstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#whilestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhilestr(VerilogPrimeParser.WhilestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dostr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDostr(VerilogPrimeParser.DostrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#escapequote}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEscapequote(VerilogPrimeParser.EscapequoteContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hash_zero}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHash_zero(VerilogPrimeParser.Hash_zeroContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endclockingstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndclockingstr(VerilogPrimeParser.EndclockingstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#globalstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGlobalstr(VerilogPrimeParser.GlobalstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randsequencestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandsequencestr(VerilogPrimeParser.RandsequencestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#or}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOr(VerilogPrimeParser.OrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#specifystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecifystr(VerilogPrimeParser.SpecifystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#endspecifystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEndspecifystr(VerilogPrimeParser.EndspecifystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_oneventstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulsestyle_oneventstr(VerilogPrimeParser.Pulsestyle_oneventstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pulsestyle_ondetectstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPulsestyle_ondetectstr(VerilogPrimeParser.Pulsestyle_ondetectstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#showcancelledstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitShowcancelledstr(VerilogPrimeParser.ShowcancelledstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#noshowcancelledstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNoshowcancelledstr(VerilogPrimeParser.NoshowcancelledstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stargt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStargt(VerilogPrimeParser.StargtContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#posedgestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPosedgestr(VerilogPrimeParser.PosedgestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#negedgestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNegedgestr(VerilogPrimeParser.NegedgestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#edgestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEdgestr(VerilogPrimeParser.EdgestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#ifnonestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfnonestr(VerilogPrimeParser.IfnonestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarsetupstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarsetupstr(VerilogPrimeParser.DollarsetupstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarholdstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarholdstr(VerilogPrimeParser.DollarholdstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarsetupholdstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarsetupholdstr(VerilogPrimeParser.DollarsetupholdstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarrecoverystr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarrecoverystr(VerilogPrimeParser.DollarrecoverystrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarremovalstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarremovalstr(VerilogPrimeParser.DollarremovalstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarrecremstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarrecremstr(VerilogPrimeParser.DollarrecremstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarskewstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarskewstr(VerilogPrimeParser.DollarskewstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollartimeskewstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollartimeskewstr(VerilogPrimeParser.DollartimeskewstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarfullskewstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarfullskewstr(VerilogPrimeParser.DollarfullskewstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarperiodstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarperiodstr(VerilogPrimeParser.DollarperiodstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollaewidthstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollaewidthstr(VerilogPrimeParser.DollaewidthstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarnochangestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarnochangestr(VerilogPrimeParser.DollarnochangestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#z_or_x}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitZ_or_x(VerilogPrimeParser.Z_or_xContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#compliment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCompliment(VerilogPrimeParser.ComplimentContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_equality}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_equality(VerilogPrimeParser.Case_equalityContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_inequality}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_inequality(VerilogPrimeParser.Case_inequalityContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#rshift}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRshift(VerilogPrimeParser.RshiftContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lshift}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLshift(VerilogPrimeParser.LshiftContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#pluscolon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPluscolon(VerilogPrimeParser.PluscolonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#minuscolon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMinuscolon(VerilogPrimeParser.MinuscolonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#stdcoloncolon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStdcoloncolon(VerilogPrimeParser.StdcoloncolonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#randomizestr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRandomizestr(VerilogPrimeParser.RandomizestrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nullstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNullstr(VerilogPrimeParser.NullstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#alshift}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAlshift(VerilogPrimeParser.AlshiftContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#arshift}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArshift(VerilogPrimeParser.ArshiftContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#case_q}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCase_q(VerilogPrimeParser.Case_qContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#not_case_q}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNot_case_q(VerilogPrimeParser.Not_case_qContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#and}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnd(VerilogPrimeParser.AndContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXor(VerilogPrimeParser.XorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xnor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXnor(VerilogPrimeParser.XnorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#xorn}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXorn(VerilogPrimeParser.XornContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#thisstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThisstr(VerilogPrimeParser.ThisstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#localcoloncolon}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocalcoloncolon(VerilogPrimeParser.LocalcoloncolonContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#time_unit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTime_unit(VerilogPrimeParser.Time_unitContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nand}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNand(VerilogPrimeParser.NandContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#nor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNor(VerilogPrimeParser.NorContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dderive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDderive(VerilogPrimeParser.DderiveContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#scalar_constant0}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitScalar_constant0(VerilogPrimeParser.Scalar_constant0Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#scalar_constant1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitScalar_constant1(VerilogPrimeParser.Scalar_constant1Context ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#string}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitString(VerilogPrimeParser.StringContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#lparenstar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLparenstar(VerilogPrimeParser.LparenstarContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#starrparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStarrparen(VerilogPrimeParser.StarrparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#esc_identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEsc_identifier(VerilogPrimeParser.Esc_identifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarrootstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarrootstr(VerilogPrimeParser.DollarrootstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#dollarunitstr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDollarunitstr(VerilogPrimeParser.DollarunitstrContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#tf_id}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTf_id(VerilogPrimeParser.Tf_idContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#octal_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOctal_number(VerilogPrimeParser.Octal_numberContext ctx);
	/**
	 * Visit a parse tree produced by {@link VerilogPrimeParser#hex_number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHex_number(VerilogPrimeParser.Hex_numberContext ctx);
}