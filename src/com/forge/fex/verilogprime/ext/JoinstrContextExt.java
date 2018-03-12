package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.JoinstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class JoinstrContextExt extends AbstractBaseExt {

	public JoinstrContextExt(JoinstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public JoinstrContext getContext() {
		return (JoinstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).joinstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof JoinstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + JoinstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}