package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_port_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_port_listContextExt extends AbstractBaseExt {

	public Sequence_port_listContextExt(Sequence_port_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_port_listContext getContext() {
		return (Sequence_port_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_port_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_port_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_port_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}