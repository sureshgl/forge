package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_type_or_implicitContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Data_type_or_implicitContextExt extends AbstractBaseExt {

	public Data_type_or_implicitContextExt(Data_type_or_implicitContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_type_or_implicitContext getContext() {
		return (Data_type_or_implicitContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_type_or_implicit());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_type_or_implicitContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Data_type_or_implicitContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}