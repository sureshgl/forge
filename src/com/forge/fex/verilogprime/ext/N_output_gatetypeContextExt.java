package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.N_output_gatetypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class N_output_gatetypeContextExt extends AbstractBaseExt {

	public N_output_gatetypeContextExt(N_output_gatetypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public N_output_gatetypeContext getContext() {
		return (N_output_gatetypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).n_output_gatetype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof N_output_gatetypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ N_output_gatetypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}