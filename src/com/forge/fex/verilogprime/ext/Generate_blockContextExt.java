package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Generate_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Generate_blockContextExt extends AbstractBaseExt {

	public Generate_blockContextExt(Generate_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Generate_blockContext getContext() {
		return (Generate_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).generate_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Generate_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Generate_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}