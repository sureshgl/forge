package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Scalar_constant1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Scalar_constant1ContextExt extends AbstractBaseExt {

	public Scalar_constant1ContextExt(Scalar_constant1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Scalar_constant1Context getContext() {
		return (Scalar_constant1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).scalar_constant1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Scalar_constant1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Scalar_constant1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}