package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Weak1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Weak1strContextExt extends AbstractBaseExt {

	public Weak1strContextExt(Weak1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Weak1strContext getContext() {
		return (Weak1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).weak1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Weak1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Weak1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}