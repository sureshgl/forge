package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_declarationContextExt extends AbstractBaseExt {

	public Let_declarationContextExt(Let_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_declarationContext getContext() {
		return (Let_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Let_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}