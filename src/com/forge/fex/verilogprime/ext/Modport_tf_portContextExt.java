package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Modport_tf_portContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Modport_tf_portContextExt extends AbstractBaseExt {

	public Modport_tf_portContextExt(Modport_tf_portContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Modport_tf_portContext getContext() {
		return (Modport_tf_portContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).modport_tf_port());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Modport_tf_portContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Modport_tf_portContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}