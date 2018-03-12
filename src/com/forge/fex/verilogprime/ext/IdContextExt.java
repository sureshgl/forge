package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IdContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IdContextExt extends AbstractBaseExt {

	public IdContextExt(IdContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IdContext getContext() {
		return (IdContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).id());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IdContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IdContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}