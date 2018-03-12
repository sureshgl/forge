package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dynamic_array_newContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dynamic_array_newContextExt extends AbstractBaseExt {

	public Dynamic_array_newContextExt(Dynamic_array_newContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dynamic_array_newContext getContext() {
		return (Dynamic_array_newContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dynamic_array_new());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dynamic_array_newContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dynamic_array_newContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}