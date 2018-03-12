package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Genvar_iterationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Genvar_iterationContextExt extends AbstractBaseExt {

	public Genvar_iterationContextExt(Genvar_iterationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Genvar_iterationContext getContext() {
		return (Genvar_iterationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvar_iteration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Genvar_iterationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Genvar_iterationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}