package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Implicit_data_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Implicit_data_typeContextExt extends AbstractBaseExt {

	public Implicit_data_typeContextExt(Implicit_data_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Implicit_data_typeContext getContext() {
		return (Implicit_data_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).implicit_data_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Implicit_data_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Implicit_data_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}