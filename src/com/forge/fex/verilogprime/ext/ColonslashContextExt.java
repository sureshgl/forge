package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ColonslashContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ColonslashContextExt extends AbstractBaseExt {

	public ColonslashContextExt(ColonslashContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ColonslashContext getContext() {
		return (ColonslashContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).colonslash());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ColonslashContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ColonslashContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}