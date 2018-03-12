package com.forge.parser;

import java.util.HashMap;
import java.util.Map;

import com.forge.parser.gen.ForgeParser;
import com.forge.parser.gen.ForgeParserBaseVisitor;

public class EvaluateVisitorForForge extends ForgeParserBaseVisitor<String>{

	Map<String,String> symbolTable;

	public EvaluateVisitorForForge(Map<String,String> symbolTable){
		this.symbolTable = symbolTable;
	}
	public EvaluateVisitorForForge(){
		this.symbolTable = new HashMap<String,String>();
	}

	public void setSymbolTable(Map<String,String> symbolTable){
		this.symbolTable = symbolTable;
	}

	public Map<String, String> getSymbolTable(){
		return symbolTable;
	}

	@Override public String visitSubtraction_expression(ForgeParser.Subtraction_expressionContext ctx) { 
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
		ret = e1_i - e2_i;
		return ret.toString();
	}


	@Override public String visitDivision_expression(ForgeParser.Division_expressionContext ctx) { 
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
		ret = e1_i / e2_i;
		return ret.toString();
	}
	@Override public String visitAddition_expression(ForgeParser.Addition_expressionContext ctx) { 
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
		ret = e1_i + e2_i;
		return ret.toString();
	}
	
	@Override public String visitMultiplication_expression(ForgeParser.Multiplication_expressionContext ctx) {
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
		ret = e1_i + e2_i;
		return ret.toString();
	}
	
	@Override public String visitNumber_only_expression(ForgeParser.Number_only_expressionContext ctx) {
		return ctx.number().extendedContext.intValue();
	}
	
	@Override public String visitModulo_expression(ForgeParser.Modulo_expressionContext ctx) { 
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
		ret = e1_i % e2_i;
		return ret.toString();
	}
	
	@Override public String visitId_only_expression(ForgeParser.Id_only_expressionContext ctx) { 
		String text = ctx.extendedContext.getFormattedText();
		if(symbolTable.containsKey(text)){
			return symbolTable.get(text);
		} else {
			return text;
		}
	}

}
