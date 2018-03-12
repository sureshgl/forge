package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_coverpointsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_coverpointsContextExt extends AbstractBaseExt {

	public List_of_coverpointsContextExt(List_of_coverpointsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_coverpointsContext getContext() {
		return (List_of_coverpointsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_coverpoints());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_coverpointsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_coverpointsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}