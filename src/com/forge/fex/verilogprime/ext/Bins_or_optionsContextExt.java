package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bins_or_optionsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bins_or_optionsContextExt extends AbstractBaseExt {

	public Bins_or_optionsContextExt(Bins_or_optionsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bins_or_optionsContext getContext() {
		return (Bins_or_optionsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bins_or_options());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bins_or_optionsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bins_or_optionsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}