package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StringContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StringContextExt extends AbstractBaseExt {

	public StringContextExt(StringContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StringContext getContext() {
		return (StringContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).string());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StringContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StringContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}