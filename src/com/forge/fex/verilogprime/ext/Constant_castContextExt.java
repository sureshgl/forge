package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_castContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_castContextExt extends AbstractBaseExt {

	public Constant_castContextExt(Constant_castContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_castContext getContext() {
		return (Constant_castContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_cast());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_castContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Constant_castContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}