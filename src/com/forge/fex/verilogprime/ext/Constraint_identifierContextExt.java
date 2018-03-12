package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_identifierContextExt extends AbstractBaseExt {

	public Constraint_identifierContextExt(Constraint_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_identifierContext getContext() {
		return (Constraint_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}