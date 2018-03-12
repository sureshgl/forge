package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Specify_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Specify_blockContextExt extends AbstractBaseExt {

	public Specify_blockContextExt(Specify_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Specify_blockContext getContext() {
		return (Specify_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).specify_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Specify_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Specify_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}