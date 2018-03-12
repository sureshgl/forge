package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_port_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_port_itemContextExt extends AbstractBaseExt {

	public Sequence_port_itemContextExt(Sequence_port_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_port_itemContext getContext() {
		return (Sequence_port_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_port_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_port_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_port_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}