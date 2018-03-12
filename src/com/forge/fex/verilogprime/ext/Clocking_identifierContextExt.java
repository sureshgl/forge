package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_identifierContextExt extends AbstractBaseExt {

	public Clocking_identifierContextExt(Clocking_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_identifierContext getContext() {
		return (Clocking_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}