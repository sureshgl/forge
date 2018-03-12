package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_multiple_concatenationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_multiple_concatenationContextExt extends AbstractBaseExt {

	public Constant_multiple_concatenationContextExt(Constant_multiple_concatenationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_multiple_concatenationContext getContext() {
		return (Constant_multiple_concatenationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_multiple_concatenation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_multiple_concatenationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_multiple_concatenationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}