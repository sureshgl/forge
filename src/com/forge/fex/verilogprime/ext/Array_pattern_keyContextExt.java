package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Array_pattern_keyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Array_pattern_keyContextExt extends AbstractBaseExt {

	public Array_pattern_keyContextExt(Array_pattern_keyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Array_pattern_keyContext getContext() {
		return (Array_pattern_keyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).array_pattern_key());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Array_pattern_keyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Array_pattern_keyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}