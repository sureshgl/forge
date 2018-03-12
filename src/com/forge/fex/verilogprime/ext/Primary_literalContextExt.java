package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Primary_literalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Primary_literalContextExt extends AbstractBaseExt {

	public Primary_literalContextExt(Primary_literalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Primary_literalContext getContext() {
		return (Primary_literalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).primary_literal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Primary_literalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Primary_literalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}