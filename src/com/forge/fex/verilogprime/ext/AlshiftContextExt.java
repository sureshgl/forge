package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AlshiftContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AlshiftContextExt extends AbstractBaseExt {

	public AlshiftContextExt(AlshiftContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AlshiftContext getContext() {
		return (AlshiftContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).alshift());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AlshiftContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AlshiftContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}