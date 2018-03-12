package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Level_symbolContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Level_symbolContextExt extends AbstractBaseExt {

	public Level_symbolContextExt(Level_symbolContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Level_symbolContext getContext() {
		return (Level_symbolContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).level_symbol());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Level_symbolContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Level_symbolContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}