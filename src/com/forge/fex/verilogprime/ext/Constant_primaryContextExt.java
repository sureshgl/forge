package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_primaryContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_primaryContextExt extends AbstractBaseExt {

	public Constant_primaryContextExt(Constant_primaryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_primaryContext getContext() {
		return (Constant_primaryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_primary());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_primaryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_primaryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}