package com.forge.fex.verilogprime.ext;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NumberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NumberContextExt extends AbstractBaseExt {

	public NumberContextExt(NumberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NumberContext getContext() {
		return (NumberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NumberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NumberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	public String intValue(){
		NumberContext ctx = getContext();
		String text  = getFormattedText();
		if(ctx.binary_number() != null){
			Pattern p = Pattern.compile("([1-9][0-9_]*)'[sS]?[bB]([zZxX01][zZxX01_]*)");
			Matcher m = p.matcher(text);
			if(m.matches()){
				String size = m.group(1);
				String value = m.group(2).replaceAll("_", "");
				Integer size_i = null;
				try{
					size_i = Integer.parseInt(size);
				} catch(NumberFormatException e){
					throw new RuntimeException("Size of the binary number "+text+" isnt parsable");
				}
				if(value.length() <= size_i){
					try{
						return String.valueOf(Integer.parseInt(value, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("binary number "+text+" isnt parsable");
					}
				} else {
					String value_subStr = new StringBuilder(value).reverse().toString().substring(0, size_i);
					String val_rev = new StringBuilder(value_subStr).reverse().toString();
					try{
						return String.valueOf(Integer.parseInt(val_rev, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("binary number "+text+" isnt parsable");
					}
				}
			}
		} else if (ctx.hex_number() != null){
			Pattern p = Pattern.compile("([1-9][0-9_]*)'[sS]?[hH]([zZxX0-9a-fA-F][zZxX0-9a-fA-F_]*)");
			Matcher m = p.matcher(text);
			if(m.matches()){
				String size = m.group(1);
				String value = m.group(2).replaceAll("_", "");
				Integer size_i = null;
				try{
					size_i = Integer.parseInt(size);
				} catch(NumberFormatException e){
					throw new RuntimeException("Size of the hex number "+text+" isnt parsable");
				}
				Integer intValue = null;
				try{
					intValue = Integer.parseInt(value,16);
				} catch(NumberFormatException e){
					throw new RuntimeException("Cannot parse the hex text in number "+text);
				}
				String binaryVal = Integer.toBinaryString(intValue);
				if(binaryVal.length() <= size_i){
					try{
						return String.valueOf(Integer.parseInt(binaryVal, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("hex number "+text+" isnt parsable");
					}
				} else {
					String value_subStr = new StringBuilder(binaryVal).reverse().toString().substring(0, size_i);
					String val_rev = new StringBuilder(value_subStr).reverse().toString();
					try{
						return String.valueOf(Integer.parseInt(val_rev, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("binary number "+text+" isnt parsable");
					}
				}
			}
		}else if (ctx.octal_number() != null){
			Pattern p = Pattern.compile("([1-9][0-9_]*)'[sS]?[oO]([zZxX0-7][zZxX0-7_]*)");
			Matcher m = p.matcher(text);
			if(m.matches()){
				String size = m.group(1);
				String value = m.group(2).replaceAll("_", "");
				Integer size_i = null;
				try{
					size_i = Integer.parseInt(size);
				} catch(NumberFormatException e){
					throw new RuntimeException("Size of the octal number "+text+" isnt parsable");
				}
				Integer intValue = null;
				try{
					intValue = Integer.parseInt(value,8);
				} catch(NumberFormatException e){
					throw new RuntimeException("Cannot parse the octal text in number "+text);
				}
				String binaryVal = Integer.toBinaryString(intValue);
				if(binaryVal.length() <= size_i){
					try{
						return String.valueOf(Integer.parseInt(binaryVal, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("hex number "+text+" isnt parsable");
					}
				} else {
					String value_subStr = new StringBuilder(binaryVal).reverse().toString().substring(0, size_i);
					String val_rev = new StringBuilder(value_subStr).reverse().toString();
					try{
						return String.valueOf(Integer.parseInt(val_rev, 2));
					}	catch(NumberFormatException e){
						throw new RuntimeException("binary number "+text+" isnt parsable");
					}
				}
			}
		} else if(ctx.decimal_number() != null){
			Pattern p = Pattern.compile("([1-9][0-9_]*)?'[sS]?[dD]([zZxX0-7][zZxX0-7_]*)");
			Matcher m = p.matcher(text);
			if(m.matches()){
				String size = m.group(1);
				String value = m.group(2).replaceAll("_", "");
				if(size != null && !size.equals("")){
					Integer size_i = null;
					try{
						size_i = Integer.parseInt(size);
					} catch(NumberFormatException e){
						throw new RuntimeException("Size of the decimal number "+text+" isnt parsable");
					}
					Integer intValue = null;
					try{
						intValue = Integer.parseInt(value);
					} catch(NumberFormatException e){
						throw new RuntimeException("Cannot parse the deciaml text in number "+text);
					}
					String binaryVal = Integer.toBinaryString(intValue);
					if(binaryVal.length() <= size_i){
						try{
							return String.valueOf(Integer.parseInt(binaryVal, 2));
						}	catch(NumberFormatException e){
							throw new RuntimeException("octal number "+text+" isnt parsable");
						}
					} else {
						String value_subStr = new StringBuilder(binaryVal).reverse().toString().substring(0, size_i);
						String val_rev = new StringBuilder(value_subStr).reverse().toString();
						try{
							return String.valueOf(Integer.parseInt(val_rev, 2));
						}	catch(NumberFormatException e){
							throw new RuntimeException("octal number "+text+" isnt parsable");
						}
					}
				} else {
					return value;
				}
			} else if(text.contains("x") || text.contains("X") || text.contains("z")  || text.contains("Z") ){
				L.error("cant get the int value of "+text);
			} else {
				return text;
			}
		}
		return text;
	}
}