package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ProductionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ProductionContextExt extends AbstractBaseExt {

	public ProductionContextExt(ProductionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ProductionContext getContext() {
		return (ProductionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).production());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ProductionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ProductionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}