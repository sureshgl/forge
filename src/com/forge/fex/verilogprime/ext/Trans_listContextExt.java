package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Trans_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Trans_listContextExt extends AbstractBaseExt {

	public Trans_listContextExt(Trans_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Trans_listContext getContext() {
		return (Trans_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trans_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Trans_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Trans_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}