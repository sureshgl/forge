package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tri0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tri0strContextExt extends AbstractBaseExt {

	public Tri0strContextExt(Tri0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tri0strContext getContext() {
		return (Tri0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tri0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tri0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tri0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}