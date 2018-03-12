package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AndequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AndequalsContextExt extends AbstractBaseExt {

	public AndequalsContextExt(AndequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AndequalsContext getContext() {
		return (AndequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).andequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AndequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AndequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}