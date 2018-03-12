package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarholdstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarholdstrContextExt extends AbstractBaseExt {

	public DollarholdstrContextExt(DollarholdstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarholdstrContext getContext() {
		return (DollarholdstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarholdstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarholdstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarholdstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}