package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bufif1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bufif1strContextExt extends AbstractBaseExt {

	public Bufif1strContextExt(Bufif1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bufif1strContext getContext() {
		return (Bufif1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bufif1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bufif1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Bufif1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}