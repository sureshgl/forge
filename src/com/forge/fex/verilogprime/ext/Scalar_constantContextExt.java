package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Scalar_constantContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Scalar_constantContextExt extends AbstractBaseExt {

	public Scalar_constantContextExt(Scalar_constantContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Scalar_constantContext getContext() {
		return (Scalar_constantContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).scalar_constant());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Scalar_constantContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Scalar_constantContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}