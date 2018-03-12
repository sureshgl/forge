package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assertion_item_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assertion_item_declarationContextExt extends AbstractBaseExt {

	public Assertion_item_declarationContextExt(Assertion_item_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assertion_item_declarationContext getContext() {
		return (Assertion_item_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assertion_item_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assertion_item_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assertion_item_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}