package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Highz0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Highz0strContextExt extends AbstractBaseExt {

	public Highz0strContextExt(Highz0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Highz0strContext getContext() {
		return (Highz0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).highz0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Highz0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Highz0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}