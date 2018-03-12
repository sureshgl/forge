package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Const_identifierContextExt extends AbstractBaseExt {

	public Const_identifierContextExt(Const_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Const_identifierContext getContext() {
		return (Const_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).const_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Const_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Const_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}