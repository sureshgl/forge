package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Continuous_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Continuous_assignContextExt extends AbstractBaseExt {

	public Continuous_assignContextExt(Continuous_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Continuous_assignContext getContext() {
		return (Continuous_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).continuous_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Continuous_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Continuous_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}