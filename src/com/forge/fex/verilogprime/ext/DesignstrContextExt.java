package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DesignstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DesignstrContextExt extends AbstractBaseExt {

	public DesignstrContextExt(DesignstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DesignstrContext getContext() {
		return (DesignstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).designstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DesignstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DesignstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}