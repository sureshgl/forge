package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Specparam_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Specparam_declarationContextExt extends AbstractBaseExt {

	public Specparam_declarationContextExt(Specparam_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Specparam_declarationContext getContext() {
		return (Specparam_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).specparam_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Specparam_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Specparam_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}