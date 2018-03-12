package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OrContextExt extends AbstractBaseExt {

	public OrContextExt(OrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OrContext getContext() {
		return (OrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).or());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}