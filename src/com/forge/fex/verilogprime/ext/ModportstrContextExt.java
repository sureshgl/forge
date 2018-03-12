package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ModportstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ModportstrContextExt extends AbstractBaseExt {

	public ModportstrContextExt(ModportstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ModportstrContext getContext() {
		return (ModportstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).modportstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ModportstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ModportstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}