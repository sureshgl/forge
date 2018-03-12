package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Genvar_initializationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Genvar_initializationContextExt extends AbstractBaseExt {

	public Genvar_initializationContextExt(Genvar_initializationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Genvar_initializationContext getContext() {
		return (Genvar_initializationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvar_initialization());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Genvar_initializationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Genvar_initializationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}