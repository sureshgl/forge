package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_formal_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_formal_typeContextExt extends AbstractBaseExt {

	public Let_formal_typeContextExt(Let_formal_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_formal_typeContext getContext() {
		return (Let_formal_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_formal_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_formal_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Let_formal_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}