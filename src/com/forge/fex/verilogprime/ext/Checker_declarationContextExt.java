package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Checker_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Checker_declarationContextExt extends AbstractBaseExt {

	public Checker_declarationContextExt(Checker_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Checker_declarationContext getContext() {
		return (Checker_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checker_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Checker_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Checker_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}