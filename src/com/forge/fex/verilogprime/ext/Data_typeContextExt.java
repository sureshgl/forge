package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Data_typeContextExt extends AbstractBaseExt {

	public Data_typeContextExt(Data_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_typeContext getContext() {
		return (Data_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Data_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}