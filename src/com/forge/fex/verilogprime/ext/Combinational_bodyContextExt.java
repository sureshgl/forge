package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Combinational_bodyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Combinational_bodyContextExt extends AbstractBaseExt {

	public Combinational_bodyContextExt(Combinational_bodyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Combinational_bodyContext getContext() {
		return (Combinational_bodyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).combinational_body());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Combinational_bodyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Combinational_bodyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}