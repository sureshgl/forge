package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_port_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_port_listContextExt extends AbstractBaseExt {

	public Let_port_listContextExt(Let_port_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_port_listContext getContext() {
		return (Let_port_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_port_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_port_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Let_port_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}