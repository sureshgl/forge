package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ImpliesContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ImpliesContextExt extends AbstractBaseExt {

	public ImpliesContextExt(ImpliesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ImpliesContext getContext() {
		return (ImpliesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).implies());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ImpliesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ImpliesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}