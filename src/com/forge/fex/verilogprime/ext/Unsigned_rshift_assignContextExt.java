package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unsigned_rshift_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unsigned_rshift_assignContextExt extends AbstractBaseExt {

	public Unsigned_rshift_assignContextExt(Unsigned_rshift_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unsigned_rshift_assignContext getContext() {
		return (Unsigned_rshift_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unsigned_rshift_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unsigned_rshift_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unsigned_rshift_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}