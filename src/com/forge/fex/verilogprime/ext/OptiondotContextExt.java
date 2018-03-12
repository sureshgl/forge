package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OptiondotContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OptiondotContextExt extends AbstractBaseExt {

	public OptiondotContextExt(OptiondotContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OptiondotContext getContext() {
		return (OptiondotContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).optiondot());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OptiondotContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OptiondotContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}