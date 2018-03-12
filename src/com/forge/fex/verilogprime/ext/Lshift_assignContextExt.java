package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Lshift_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Lshift_assignContextExt extends AbstractBaseExt {

	public Lshift_assignContextExt(Lshift_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Lshift_assignContext getContext() {
		return (Lshift_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lshift_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Lshift_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Lshift_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}