package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Array_manipulation_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Array_manipulation_callContextExt extends AbstractBaseExt {

	public Array_manipulation_callContextExt(Array_manipulation_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Array_manipulation_callContext getContext() {
		return (Array_manipulation_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).array_manipulation_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Array_manipulation_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Array_manipulation_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}