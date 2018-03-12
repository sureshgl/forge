package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Modport_simple_portContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Modport_simple_portContextExt extends AbstractBaseExt {

	public Modport_simple_portContextExt(Modport_simple_portContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Modport_simple_portContext getContext() {
		return (Modport_simple_portContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).modport_simple_port());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Modport_simple_portContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Modport_simple_portContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}