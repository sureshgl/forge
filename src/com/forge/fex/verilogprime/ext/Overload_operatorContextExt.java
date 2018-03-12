package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Overload_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Overload_operatorContextExt extends AbstractBaseExt {

	public Overload_operatorContextExt(Overload_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Overload_operatorContext getContext() {
		return (Overload_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).overload_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Overload_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Overload_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}