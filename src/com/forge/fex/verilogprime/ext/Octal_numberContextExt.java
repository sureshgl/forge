package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Octal_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Octal_numberContextExt extends AbstractBaseExt {

	public Octal_numberContextExt(Octal_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Octal_numberContext getContext() {
		return (Octal_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).octal_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Octal_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Octal_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}