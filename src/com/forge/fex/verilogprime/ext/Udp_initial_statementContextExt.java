package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_initial_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_initial_statementContextExt extends AbstractBaseExt {

	public Udp_initial_statementContextExt(Udp_initial_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_initial_statementContext getContext() {
		return (Udp_initial_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_initial_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_initial_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_initial_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}