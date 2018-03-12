package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Overload_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Overload_declarationContextExt extends AbstractBaseExt {

	public Overload_declarationContextExt(Overload_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Overload_declarationContext getContext() {
		return (Overload_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).overload_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Overload_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Overload_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}