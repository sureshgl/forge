package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TypestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TypestrContextExt extends AbstractBaseExt {

	public TypestrContextExt(TypestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TypestrContext getContext() {
		return (TypestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).typestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TypestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TypestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}