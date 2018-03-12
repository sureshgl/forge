package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_concatenationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_concatenationContextExt extends AbstractBaseExt {

	public Constant_concatenationContextExt(Constant_concatenationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_concatenationContext getContext() {
		return (Constant_concatenationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_concatenation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_concatenationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_concatenationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}