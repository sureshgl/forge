package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rs_code_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rs_code_blockContextExt extends AbstractBaseExt {

	public Rs_code_blockContextExt(Rs_code_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rs_code_blockContext getContext() {
		return (Rs_code_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rs_code_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rs_code_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rs_code_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}