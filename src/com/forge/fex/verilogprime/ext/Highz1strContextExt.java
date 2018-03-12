package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Highz1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Highz1strContextExt extends AbstractBaseExt {

	public Highz1strContextExt(Highz1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Highz1strContext getContext() {
		return (Highz1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).highz1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Highz1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Highz1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}