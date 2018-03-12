package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Seq_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Seq_blockContextExt extends AbstractBaseExt {

	public Seq_blockContextExt(Seq_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Seq_blockContext getContext() {
		return (Seq_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).seq_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Seq_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Seq_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}