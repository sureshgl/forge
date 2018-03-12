package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NoshowcancelledstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NoshowcancelledstrContextExt extends AbstractBaseExt {

	public NoshowcancelledstrContextExt(NoshowcancelledstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NoshowcancelledstrContext getContext() {
		return (NoshowcancelledstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).noshowcancelledstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NoshowcancelledstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ NoshowcancelledstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}