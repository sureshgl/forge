package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rshift_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rshift_assignContextExt extends AbstractBaseExt {

	public Rshift_assignContextExt(Rshift_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rshift_assignContext getContext() {
		return (Rshift_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rshift_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rshift_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rshift_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}