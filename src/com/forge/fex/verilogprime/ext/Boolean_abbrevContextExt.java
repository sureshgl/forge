package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Boolean_abbrevContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Boolean_abbrevContextExt extends AbstractBaseExt {

	public Boolean_abbrevContextExt(Boolean_abbrevContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Boolean_abbrevContext getContext() {
		return (Boolean_abbrevContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).boolean_abbrev());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Boolean_abbrevContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Boolean_abbrevContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}