package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pulsestyle_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pulsestyle_declarationContextExt extends AbstractBaseExt {

	public Pulsestyle_declarationContextExt(Pulsestyle_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pulsestyle_declarationContext getContext() {
		return (Pulsestyle_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulsestyle_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pulsestyle_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pulsestyle_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}