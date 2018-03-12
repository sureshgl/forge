package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ColoncolonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ColoncolonContextExt extends AbstractBaseExt {

	public ColoncolonContextExt(ColoncolonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ColoncolonContext getContext() {
		return (ColoncolonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coloncolon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ColoncolonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ColoncolonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}