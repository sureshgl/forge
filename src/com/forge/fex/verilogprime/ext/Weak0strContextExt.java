package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Weak0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Weak0strContextExt extends AbstractBaseExt {

	public Weak0strContextExt(Weak0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Weak0strContext getContext() {
		return (Weak0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).weak0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Weak0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Weak0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}