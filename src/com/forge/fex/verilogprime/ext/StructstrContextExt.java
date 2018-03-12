package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StructstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StructstrContextExt extends AbstractBaseExt {

	public StructstrContextExt(StructstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StructstrContext getContext() {
		return (StructstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).structstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StructstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StructstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}