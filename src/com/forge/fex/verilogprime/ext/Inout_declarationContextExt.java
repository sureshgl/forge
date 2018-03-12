package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inout_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inout_declarationContextExt extends AbstractBaseExt {

	public Inout_declarationContextExt(Inout_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inout_declarationContext getContext() {
		return (Inout_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inout_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inout_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Inout_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}