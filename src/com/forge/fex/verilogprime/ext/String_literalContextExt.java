package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.String_literalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class String_literalContextExt extends AbstractBaseExt {

	public String_literalContextExt(String_literalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public String_literalContext getContext() {
		return (String_literalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).string_literal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof String_literalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ String_literalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}