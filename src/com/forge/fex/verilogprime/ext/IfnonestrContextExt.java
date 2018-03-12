package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IfnonestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IfnonestrContextExt extends AbstractBaseExt {

	public IfnonestrContextExt(IfnonestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IfnonestrContext getContext() {
		return (IfnonestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ifnonestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IfnonestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IfnonestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}