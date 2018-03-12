package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SlashequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SlashequalsContextExt extends AbstractBaseExt {

	public SlashequalsContextExt(SlashequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SlashequalsContext getContext() {
		return (SlashequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slashequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SlashequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SlashequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}