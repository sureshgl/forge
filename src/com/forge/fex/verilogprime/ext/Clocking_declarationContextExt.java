package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_declarationContextExt extends AbstractBaseExt {

	public Clocking_declarationContextExt(Clocking_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_declarationContext getContext() {
		return (Clocking_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}