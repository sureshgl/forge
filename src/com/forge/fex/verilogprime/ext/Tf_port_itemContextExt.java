package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tf_port_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tf_port_itemContextExt extends AbstractBaseExt {

	public Tf_port_itemContextExt(Tf_port_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tf_port_itemContext getContext() {
		return (Tf_port_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tf_port_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tf_port_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tf_port_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}