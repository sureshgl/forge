package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Checker_port_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Checker_port_listContextExt extends AbstractBaseExt {

	public Checker_port_listContextExt(Checker_port_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Checker_port_listContext getContext() {
		return (Checker_port_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checker_port_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Checker_port_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Checker_port_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}