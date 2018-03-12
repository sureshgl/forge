package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Notif0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Notif0strContextExt extends AbstractBaseExt {

	public Notif0strContextExt(Notif0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Notif0strContext getContext() {
		return (Notif0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).notif0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Notif0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Notif0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}