package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rtranif0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rtranif0strContextExt extends AbstractBaseExt {

	public Rtranif0strContextExt(Rtranif0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rtranif0strContext getContext() {
		return (Rtranif0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rtranif0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rtranif0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rtranif0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}