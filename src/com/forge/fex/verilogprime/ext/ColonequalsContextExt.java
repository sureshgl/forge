package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ColonequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ColonequalsContextExt extends AbstractBaseExt {

	public ColonequalsContextExt(ColonequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ColonequalsContext getContext() {
		return (ColonequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).colonequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ColonequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ColonequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}