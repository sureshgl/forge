package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Timeunits_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Timeunits_declarationContextExt extends AbstractBaseExt {

	public Timeunits_declarationContextExt(Timeunits_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Timeunits_declarationContext getContext() {
		return (Timeunits_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timeunits_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Timeunits_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Timeunits_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}