package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Scalar_constant0Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Scalar_constant0ContextExt extends AbstractBaseExt {

	public Scalar_constant0ContextExt(Scalar_constant0Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Scalar_constant0Context getContext() {
		return (Scalar_constant0Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).scalar_constant0());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Scalar_constant0Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Scalar_constant0Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}