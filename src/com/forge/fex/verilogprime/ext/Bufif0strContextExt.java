package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bufif0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bufif0strContextExt extends AbstractBaseExt {

	public Bufif0strContextExt(Bufif0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bufif0strContext getContext() {
		return (Bufif0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bufif0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bufif0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Bufif0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}