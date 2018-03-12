package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unbased_unsized_literalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unbased_unsized_literalContextExt extends AbstractBaseExt {

	public Unbased_unsized_literalContextExt(Unbased_unsized_literalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unbased_unsized_literalContext getContext() {
		return (Unbased_unsized_literalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unbased_unsized_literal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unbased_unsized_literalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unbased_unsized_literalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}