package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Notif1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Notif1strContextExt extends AbstractBaseExt {

	public Notif1strContextExt(Notif1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Notif1strContext getContext() {
		return (Notif1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).notif1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Notif1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Notif1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}