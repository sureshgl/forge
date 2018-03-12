package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Casting_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Casting_typeContextExt extends AbstractBaseExt {

	public Casting_typeContextExt(Casting_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Casting_typeContext getContext() {
		return (Casting_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).casting_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Casting_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Casting_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}