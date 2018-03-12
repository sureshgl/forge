package com.forge.parser;

import java.util.Map;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_addContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_binary_andContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_binary_orContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_binary_xorContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_compContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_conditionalContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_equalityContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_log_andContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_log_orContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_mutlContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_only_primaryContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_shiftContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_st_stContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_expr_unary_opContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_primaryContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_addContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_binary_andContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_binary_orContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_binary_xorContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_compContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_conditional_expContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_equalityContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_inc_or_decContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_inside_expContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_log_andContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_log_orContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_multContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_only_primaryContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_op_assignContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_shiftContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_st_stContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_tagged_unionContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_unary_opContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NumberContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PrimaryContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Simple_identifierContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.System_tf_callContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParserBaseVisitor;

public class EvaluateVisitor extends VerilogPrimeParserBaseVisitor<String> {

	Map<String,String> symbolTable;

	public EvaluateVisitor(Map<String,String> symbolTable){
		this.symbolTable = symbolTable;
	}

	public void setSymbolTable(Map<String,String> symbolTable){
		this.symbolTable = symbolTable;
	}

	public Map<String, String> getSymbolTable(){
		return symbolTable;
	}

	@Override public String visitConst_expr_binary_and(Const_expr_binary_andContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = e1_i & e2_i;
		return ret.toString();
	}

	@Override public String visitConst_expr_mutl(Const_expr_mutlContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.star() != null){
			ret = e1_i * e2_i;
		} else if(ctx.div() != null){
			ret = e1_i / e2_i;
		} else if(ctx.modulo() != null){
			ret = e1_i % e2_i;
		}
		return ret.toString();
	}

	@Override public String visitConst_expr_add(Const_expr_addContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.plus() != null){
			ret = e1_i + e2_i;
		} else if(ctx.minus() != null){
			ret = e1_i - e2_i;
		}
		return ret.toString();
	}

	@Override public String visitConst_expr_equality(Const_expr_equalityContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		String ret = ctx.extendedContext.getFormattedText();
		if(ctx.equals() != null){
			ret = (e2_i.equals(e1_i)) ? "1":"0";
		} else if(ctx.not_equals() != null){
			ret = (!e2_i.equals(e1_i))? "1" : "0" ;
		}
		return ret;
	}

	@Override public String visitConst_expr_comp(Const_expr_compContext ctx) {
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		String ret = ctx.extendedContext.getFormattedText();
		if(ctx.le() != null){
			ret = e1_i <= e2_i ? "1" : "0";
		} else if(ctx.lt() != null){
			ret = e1_i < e2_i ? "1" : "0";
		} else if(ctx.ge() != null){
			ret = e1_i >= e2_i ? "1" : "0";
		}else if(ctx.gt() != null){
			ret = e1_i > e2_i ? "1" : "0";
		}
		return ret;
	}

	@Override public String visitConst_expr_log_or(Const_expr_log_orContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Boolean ret = (e1_i>0) || (e2_i>0);
		return ret.toString();
	}

	@Override public String visitConst_expr_binary_or(Const_expr_binary_orContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret =  e1_i.intValue() | e2_i.intValue();
		return ret.toString();
	}

	@Override public String visitConst_expr_only_primary(Const_expr_only_primaryContext ctx) { 
		String ret = super.visit(ctx.constant_primary());
		if(symbolTable.containsKey(ret)){
			return symbolTable.get(ret);
		} else {
			return ret;
		}
	}

	@Override public String visitConst_expr_binary_xor(Const_expr_binary_xorContext ctx) {
		return ctx.extendedContext.getFormattedText();
	}

	@Override public String visitConst_expr_log_and(Const_expr_log_andContext ctx) {
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Boolean ret = (e1_i>0) && (e2_i>0);
		return ret.toString();
	}

	@Override public String visitConst_expr_shift(Const_expr_shiftContext ctx) {
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.lshift() != null){
			ret = e1_i << e2_i;
		} else if(ctx.rshift() != null){
			ret = e1_i >> e2_i;
		} else if(ctx.arshift() != null){
			ret = e1_i >>> e2_i;
		} else {
			ctx.extendedContext.getFormattedText();
		}
		return ret.toString();
	}

	@Override public String visitConst_expr_st_st(Const_expr_st_stContext ctx) {
		String e1 = visit(ctx.constant_expression(0));
		String e2 = visit(ctx.constant_expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = new Double(Math.pow(e1_i,e2_i)).intValue();
		return ret.toString();
	}

	@Override public String visitConst_expr_conditional(Const_expr_conditionalContext ctx) { 
		String e1 = visit(ctx.constant_expression(0));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		Integer e1_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		if(e1_i != 0){
			return visit(ctx.constant_expression(1));
		} else {
			return visit(ctx.constant_expression(2));
		}
	}

	@Override public String visitConst_expr_unary_op(Const_expr_unary_opContext ctx) { 
		String e1 = visit(ctx.constant_primary());
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		Integer e1_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		if(ctx.unary_operator().plus() != null){
			return e1_i.toString();
		} else if(ctx.unary_operator().minus() != null){
			return "-"+e1_i.toString();
		} else if(ctx.unary_operator().compliment() != null){
			return Integer.toString(~e1_i);
		} else if(ctx.unary_operator().not() != null){
			return (e1_i>0)?"0":"1";
		} else {
			return ctx.extendedContext.getFormattedText();
		}
	}


	//primary
	@Override
	public String visitExpression_only_primary(Expression_only_primaryContext ctx){
		String text = super.visit(ctx.primary());
		if(symbolTable.containsKey(text)){
			return symbolTable.get(text);
		} else {
			return text;
		}
	}

	//inc_or_dec_expression
	@Override
	public String visitExpression_inc_or_dec (Expression_inc_or_decContext  ctx) { 
		return ctx.extendedContext.getFormattedText();
	}

	//tagged_union_expression      
	@Override
	public String visitExpression_tagged_union(Expression_tagged_unionContext ctx){
		return ctx.extendedContext.getFormattedText();
	}

	//unary_operator attribute_instance* primary 
	@Override 
	public String visitExpression_unary_op(Expression_unary_opContext ctx){
		String e1 = visit(ctx.primary());
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		Integer e1_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		if(ctx.unary_operator().plus() != null){
			return e1_i.toString();
		} else if(ctx.unary_operator().minus() != null){
			return "-"+e1_i.toString();
		} else if(ctx.unary_operator().compliment() != null){
			return Integer.toString(~e1_i);
		} else if(ctx.unary_operator().not() != null){
			return (e1_i>0)?"0":"1";
		} else {
			return ctx.extendedContext.getFormattedText();
		}
	}

	//LPAREN operator_assignment RPAREN   
	@Override 
	public String visitExpression_op_assign(Expression_op_assignContext ctx){
		return ctx.extendedContext.getFormattedText();
	}

	//expression STARSTAR attribute_instance* expression
	@Override 
	public String visitExpression_st_st(Expression_st_stContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = new Double(Math.pow(e1_i,e2_i)).intValue();
		return ret.toString();
	}

	//expression (STAR| DIV| MODULO) attribute_instance* expression 
	@Override 
	public String visitExpression_mult(Expression_multContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.star() != null){
			ret = e1_i * e2_i;
		} else if(ctx.div() != null){
			ret = e1_i / e2_i;
		} else if(ctx.modulo() != null){
			ret = e1_i % e2_i;
		}
		return ret.toString();
	}

	//expression (PLUS| MINUS) attribute_instance* expression
	@Override 
	public String visitExpression_add(Expression_addContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.plus() != null){
			ret = e1_i + e2_i;
		} else if(ctx.minus() != null){
			ret = e1_i - e2_i;
		}
		return ret.toString();
	}

	/*expression (LSHIFT| RSHIFT| ALSHIFT| ARSHIFT) attribute_instance* expression*/ 
	@Override 
	public String visitExpression_shift(Expression_shiftContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = null;
		if(ctx.lshift() != null){
			ret = e1_i << e2_i;
		} else if(ctx.rshift() != null){
			ret = e1_i >> e2_i;
		} else if(ctx.arshift() != null){
			ret = e1_i >>> e2_i;
		} else {
			ctx.extendedContext.getFormattedText();
		}
		return ret.toString();
	}

	//expression (LT| GT| LE| GE) attribute_instance* expression 
	@Override 
	public String visitExpression_comp(Expression_compContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		String ret = ctx.extendedContext.getFormattedText();
		if(ctx.le() != null){
			ret = e1_i <= e2_i ? "1" : "0";
		} else if(ctx.lt() != null){
			ret = e1_i < e2_i ? "1" : "0";
		} else if(ctx.ge() != null){
			ret = e1_i >= e2_i ? "1" : "0";
		}else if(ctx.gt() != null){
			ret = e1_i > e2_i ? "1" : "0";
		}
		return ret;
	}

	@Override 
	public String visitExpression_inside_exp(Expression_inside_expContext ctx){
		return ctx.extendedContext.getFormattedText();
	}

	/*
	 * expression (EQUALS| NOT_EQUALS| CASE_EQUALITY| CASE_INEQUALITY| CASE_Q| NOT_CASE_Q) 
	                attribute_instance* expression        
	 */
	@Override 
	public String visitExpression_equality(Expression_equalityContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		String ret = ctx.extendedContext.getFormattedText();
		if(ctx.equals() != null){
			ret = (e2_i.equals(e1_i)) ? "1":"0";
		} else if(ctx.not_equals() != null){
			ret = (!e2_i.equals(e1_i))? "1" : "0" ;
		}
		return ret;
	}

	//expression (AND) attribute_instance* expression  
	@Override 
	public String visitExpression_binary_and(Expression_binary_andContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret = e1_i & e2_i;
		return ret.toString();
	}

	//expression (XOR| XNOR|XORN) attribute_instance* expression 
	@Override 
	public String visitExpression_binary_xor(Expression_binary_xorContext ctx){
		return ctx.extendedContext.getFormattedText();
	}

	//expression (OR) attribute_instance* expression   
	@Override 
	public String visitExpression_binary_or(Expression_binary_orContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Integer ret =  e1_i.intValue() | e2_i.intValue();
		return ret.toString();
	}

	//expression (LOG_AND) attribute_instance* expression               #expression_log_and
	@Override 
	public String visitExpression_log_and(Expression_log_andContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Boolean ret = (e1_i>0) && (e2_i>0);

		return ret.toString();
	}

	@Override public String  visitExpression_conditional_exp(Expression_conditional_expContext ctx) {
		String e1 = visit(ctx.expression(0));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		Integer e1_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		if(e1_i != 0){
			return visit(ctx.expression(1));
		} else {
			return visit(ctx.expression(2));
		}
	}

	//expression (LOG_OR) attribute_instance* expression  
	@Override 
	public String visitExpression_log_or(Expression_log_orContext ctx){
		String e1 = visit(ctx.expression(0));
		String e2 = visit(ctx.expression(1));
		if(symbolTable.containsKey(e1)){
			e1 = symbolTable.get(e1);
		}
		if(symbolTable.containsKey(e2)){
			e2 = symbolTable.get(e2);
		}
		Integer e1_i = null;
		Integer e2_i = null;
		try{
			e1_i = Integer.parseInt(e1);
		} catch(NumberFormatException exception1){
			return ctx.extendedContext.getFormattedText();
		}
		try{
			e2_i = Integer.parseInt(e2);
		} catch(NumberFormatException exception2){
			return ctx.extendedContext.getFormattedText();
		}
		Boolean ret = (e1_i>0) || (e2_i>0);
		return ret.toString();
	}

	@Override public String visitPrimary(PrimaryContext ctx) { 
		String text = ctx.extendedContext.getFormattedText();
		if(symbolTable.containsKey(text)){
			return symbolTable.get(text);
		} else {
			if(ctx.primary_no_function_call() != null){
				text = visit(ctx.primary_no_function_call());
			} else if(ctx.function_subroutine_call() != null){
				text = visit(ctx.function_subroutine_call());
			} 
			return text;
		}
	}


	@Override public String visitConstant_primary(Constant_primaryContext ctx) { 
		String text = ctx.extendedContext.getFormattedText();
		if(symbolTable.containsKey(text)){
			return symbolTable.get(text);
		} else {
			if(ctx.primary_literal() != null){
				text = visit(ctx.primary_literal());
			} else if(ctx.constant_function_call() != null){
				text = visit(ctx.constant_function_call());
			} else if(ctx.ps_parameter_identifier() != null){
				text = visit(ctx.ps_parameter_identifier());
			} else if(ctx.constant_mintypmax_expression() != null){
				text = visit(ctx.constant_mintypmax_expression());
			}
		}
		return text;
	}

	@Override
	public String visitSimple_identifier(Simple_identifierContext ctx){
		String text =  ctx.extendedContext.getFormattedText();
		if(symbolTable.containsKey(text)){
			return symbolTable.get(text);
		} else {
			return text;
		}
	}

	@Override
	public String visitNumber(NumberContext ctx){
		return ctx.extendedContext.intValue();
	}

	@Override 
	public String visitSystem_tf_call(System_tf_callContext ctx){
		if(ctx.system_tf_identifier().extendedContext.getFormattedText().contains("clog2")){
			String s = visit(ctx.list_of_arguments().expression());
			Integer num = null;
			try{
				num = Integer.parseInt(s);
			} catch(NumberFormatException e){
				return ctx.extendedContext.getFormattedText();
			}
			return log2(num).toString();
		} else {
			return super.visitSystem_tf_call(ctx);
		}
	}

	private Integer log2(Integer i){
		return (int) Math.ceil(Math.log10(i) / Math.log10(2));
	}
}
