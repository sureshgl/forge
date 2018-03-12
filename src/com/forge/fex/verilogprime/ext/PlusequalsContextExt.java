package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PlusequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PlusequalsContextExt extends AbstractBaseExt {

	public PlusequalsContextExt(PlusequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PlusequalsContext getContext() {
		return (PlusequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).plusequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PlusequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PlusequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}