package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Built_in_method_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Built_in_method_callContextExt extends AbstractBaseExt {

	public Built_in_method_callContextExt(Built_in_method_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Built_in_method_callContext getContext() {
		return (Built_in_method_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).built_in_method_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Built_in_method_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Built_in_method_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}