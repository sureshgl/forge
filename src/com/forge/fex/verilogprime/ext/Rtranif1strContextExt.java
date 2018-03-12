package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rtranif1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rtranif1strContextExt extends AbstractBaseExt {

	public Rtranif1strContextExt(Rtranif1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rtranif1strContext getContext() {
		return (Rtranif1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rtranif1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rtranif1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rtranif1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}