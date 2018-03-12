package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TypedefstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TypedefstrContextExt extends AbstractBaseExt {

	public TypedefstrContextExt(TypedefstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TypedefstrContext getContext() {
		return (TypedefstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).typedefstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TypedefstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TypedefstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}