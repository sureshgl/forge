package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequential_bodyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequential_bodyContextExt extends AbstractBaseExt {

	public Sequential_bodyContextExt(Sequential_bodyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequential_bodyContext getContext() {
		return (Sequential_bodyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequential_body());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequential_bodyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequential_bodyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}