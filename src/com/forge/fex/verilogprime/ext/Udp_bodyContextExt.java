package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_bodyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_bodyContextExt extends AbstractBaseExt {

	public Udp_bodyContextExt(Udp_bodyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_bodyContext getContext() {
		return (Udp_bodyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_body());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_bodyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Udp_bodyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}