package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_declarationContextExt extends AbstractBaseExt {

	public Constraint_declarationContextExt(Constraint_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_declarationContext getContext() {
		return (Constraint_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}