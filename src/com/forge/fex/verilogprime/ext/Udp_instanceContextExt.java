package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_instanceContextExt extends AbstractBaseExt {

	public Udp_instanceContextExt(Udp_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_instanceContext getContext() {
		return (Udp_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Udp_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}