package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExtendsstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ExtendsstrContextExt extends AbstractBaseExt {

	public ExtendsstrContextExt(ExtendsstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ExtendsstrContext getContext() {
		return (ExtendsstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).extendsstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ExtendsstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ExtendsstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}