package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tri1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tri1strContextExt extends AbstractBaseExt {

	public Tri1strContextExt(Tri1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tri1strContext getContext() {
		return (Tri1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tri1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tri1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tri1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}