package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tranif0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tranif0strContextExt extends AbstractBaseExt {

	public Tranif0strContextExt(Tranif0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tranif0strContext getContext() {
		return (Tranif0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tranif0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tranif0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tranif0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}