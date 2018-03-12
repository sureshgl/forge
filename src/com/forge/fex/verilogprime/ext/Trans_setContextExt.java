package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Trans_setContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Trans_setContextExt extends AbstractBaseExt {

	public Trans_setContextExt(Trans_setContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Trans_setContext getContext() {
		return (Trans_setContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trans_set());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Trans_setContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Trans_setContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}