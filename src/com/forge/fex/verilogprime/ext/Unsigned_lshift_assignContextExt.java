package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unsigned_lshift_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unsigned_lshift_assignContextExt extends AbstractBaseExt {

	public Unsigned_lshift_assignContextExt(Unsigned_lshift_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unsigned_lshift_assignContext getContext() {
		return (Unsigned_lshift_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unsigned_lshift_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unsigned_lshift_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unsigned_lshift_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}