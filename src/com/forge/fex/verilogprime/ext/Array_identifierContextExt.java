package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Array_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Array_identifierContextExt extends AbstractBaseExt {

	public Array_identifierContextExt(Array_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Array_identifierContext getContext() {
		return (Array_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).array_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Array_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Array_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}