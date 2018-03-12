package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.N_input_gatetypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class N_input_gatetypeContextExt extends AbstractBaseExt {

	public N_input_gatetypeContextExt(N_input_gatetypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public N_input_gatetypeContext getContext() {
		return (N_input_gatetypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).n_input_gatetype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof N_input_gatetypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ N_input_gatetypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}