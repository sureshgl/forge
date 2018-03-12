package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PluscolonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PluscolonContextExt extends AbstractBaseExt {

	public PluscolonContextExt(PluscolonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PluscolonContext getContext() {
		return (PluscolonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pluscolon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PluscolonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PluscolonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}