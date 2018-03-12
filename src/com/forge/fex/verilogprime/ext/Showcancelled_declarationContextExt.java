package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Showcancelled_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Showcancelled_declarationContextExt extends AbstractBaseExt {

	public Showcancelled_declarationContextExt(Showcancelled_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Showcancelled_declarationContext getContext() {
		return (Showcancelled_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).showcancelled_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Showcancelled_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Showcancelled_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}