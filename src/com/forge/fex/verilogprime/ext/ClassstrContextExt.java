package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ClassstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ClassstrContextExt extends AbstractBaseExt {

	public ClassstrContextExt(ClassstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ClassstrContext getContext() {
		return (ClassstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).classstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ClassstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ClassstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}