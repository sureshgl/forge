package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Genvar_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Genvar_declarationContextExt extends AbstractBaseExt {

	public Genvar_declarationContextExt(Genvar_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Genvar_declarationContext getContext() {
		return (Genvar_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvar_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Genvar_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Genvar_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}