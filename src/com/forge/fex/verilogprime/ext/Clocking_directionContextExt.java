package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_directionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_directionContextExt extends AbstractBaseExt {

	public Clocking_directionContextExt(Clocking_directionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_directionContext getContext() {
		return (Clocking_directionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_direction());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_directionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_directionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}