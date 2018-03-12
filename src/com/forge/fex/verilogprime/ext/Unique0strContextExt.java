package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unique0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unique0strContextExt extends AbstractBaseExt {

	public Unique0strContextExt(Unique0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unique0strContext getContext() {
		return (Unique0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unique0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unique0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Unique0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}